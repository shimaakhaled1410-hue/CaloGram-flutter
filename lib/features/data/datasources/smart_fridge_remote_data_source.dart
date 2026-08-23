import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../models/recipe_model.dart';

abstract class SmartFridgeRemoteDataSource {
  Future<List<RecipeModel>> generateRecipes(List<String> ingredients);
}

class SmartFridgeRemoteDataSourceImpl implements SmartFridgeRemoteDataSource {
  static String get _groqApiKey => dotenv.env['GROQ_FRIDGE_API_KEY'] ?? '';

  @override
  Future<List<RecipeModel>> generateRecipes(List<String> ingredients) async {
    try {
      if (_groqApiKey.isEmpty) {
        throw ServerException('Groq API Key is missing in .env');
      }

      final uri = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

      const systemPrompt = '''
You are a professional chef and sports nutritionist.
Given a list of available ingredients, suggest 2 to 3 healthy recipes.
Output ONLY a raw valid JSON array without markdown formatting or backticks.
Format:
[
  {
    "title": "Meal Title",
    "description": "Brief description",
    "calories": 350,
    "protein": 30,
    "carbs": 25,
    "fats": 10,
    "cookingTimeMinutes": 20,
    "usedIngredients": ["egg", "spinach"],
    "missingIngredients": ["olive oil"],
    "instructions": ["Step 1", "Step 2"]
  }
]
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
            {"role": "user", "content": "Ingredients available: ${ingredients.join(', ')}"}
          ],
          "temperature": 0.3,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        String rawContent = decoded['choices'][0]['message']['content'] as String;
        
        rawContent = rawContent.replaceAll('```json', '').replaceAll('```', '').trim();

        final List<dynamic> jsonList = jsonDecode(rawContent);
        return jsonList.map((item) => RecipeModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw ServerException('Groq API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to generate recipes: ${e.toString()}');
    }
  }
}