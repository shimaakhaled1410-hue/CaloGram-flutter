import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/scanned_food_model.dart';

abstract class FoodScannerRemoteDataSource {
  Future<ScannedFoodModel> analyzeFoodImage(File imageFile);
}

class FoodScannerRemoteDataSourceImpl implements FoodScannerRemoteDataSource {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static String get _endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey';
  
  @override
  Future<ScannedFoodModel> analyzeFoodImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final prompt = '''
Analyze this meal image and return ONLY a valid JSON object without markdown fences (no ```json):
{
  "foodName": "string",
  "calories": int,
  "protein": int,
  "carbs": int,
  "fats": int,
  "confidenceScore": "string percentage e.g. 95%",
  "detectedIngredients": ["ingredient 1", "ingredient 2"]
}
''';

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
                {
                  "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": base64Image,
                  },
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final String rawText =
            decoded['candidates'][0]['content']['parts'][0]['text'];
        final cleanJsonText = rawText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        final Map<String, dynamic> foodJson = jsonDecode(cleanJsonText);

        return ScannedFoodModel.fromJson(foodJson);
      } else {
        throw ServerException('Failed to analyze image from AI engine');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is NetworkException || e is ServerException) rethrow;
      throw ServerException('Failed to parse AI response');
    }
  }
}
