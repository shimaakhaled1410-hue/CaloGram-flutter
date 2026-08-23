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
        throw ServerException('Fridge Groq API Key is missing in .env');
      }

      final uri = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

      final prompt =
          '''
Role: Nutritionist Chef.
Available: ${ingredients.join(', ')}

Rules:
1. Suggest exactly 2 realistic healthy meals.
2. Exclude soft drinks/sodas from cooking.
3. Return ONLY valid JSON matching this schema:
{
  "recipes": [
    {
      "title": "Title",
      "description": "Short description",
      "calories": 300,
      "protein": 20,
      "carbs": 25,
      "fats": 10,
      "cookingTimeMinutes": 15,
      "usedIngredients": ["item1"],
      "missingIngredients": ["item2"],
      "instructions": ["Step 1", "Step 2"]
    }
  ]
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
            {"role": "user", "content": prompt},
          ],
          "temperature": 0.2,
          "reasoning_effort": "low",
          "max_completion_tokens": 1000,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        String rawContent =
            decoded['choices'][0]['message']['content'] as String;

        rawContent = rawContent
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        final int startIndex = rawContent.indexOf('{');
        final int endIndex = rawContent.lastIndexOf('}');
        if (startIndex != -1 && endIndex != -1 && endIndex >= startIndex) {
          rawContent = rawContent.substring(startIndex, endIndex + 1);
        }

        final Map<String, dynamic> jsonResponse = jsonDecode(rawContent);
        final List<dynamic> recipesList = jsonResponse['recipes'] ?? [];

        return recipesList
            .map((item) => RecipeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Groq API error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to generate recipes: ${e.toString()}');
    }
  }
}
