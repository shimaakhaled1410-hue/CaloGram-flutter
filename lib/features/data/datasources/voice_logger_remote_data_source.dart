import 'dart:convert';
import 'package:calogram_flutter/features/data/models/scanned_food_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';

abstract class VoiceLoggerRemoteDataSource {
  Future<ScannedFoodModel> analyzeVoiceLog(String transcribedText);
}

class VoiceLoggerRemoteDataSourceImpl implements VoiceLoggerRemoteDataSource {
  static String get _groqApiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  @override
  Future<ScannedFoodModel> analyzeVoiceLog(String transcribedText) async {
    try {
      if (_groqApiKey.isEmpty) {
        throw ServerException('Groq API Key is missing in .env');
      }

      final uri = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

      const systemPrompt = '''
You are an expert AI nutritionist. The user will give you a transcribed voice text of what they ate (often in Egyptian Arabic or English).
Analyze the meal and estimate the nutritional values.
Output ONLY a raw valid JSON object without markdown fences (no ```json).
Format:
{
  "foodName": "Meal Name in English",
  "calories": 400,
  "protein": 25,
  "carbs": 45,
  "fats": 12,
  "confidenceScore": "90%",
  "detectedIngredients": ["item 1", "item 2"]
}
''';

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_groqApiKey',
        },
        body: jsonEncode({
          "model": "openai/gpt-oss-20b",
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": transcribedText}
          ],
          "temperature": 0.3,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        
        String rawText = decoded['choices'][0]['message']['content'] as String;
        
        rawText = rawText.replaceAll('```json', '').replaceAll('```', '').trim();

        final Map<String, dynamic> foodJson = jsonDecode(rawText);
        return ScannedFoodModel.fromJson(foodJson);
      } else {
        throw ServerException('AI Server error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to analyze voice log: ${e.toString()}');
    }
  }
}