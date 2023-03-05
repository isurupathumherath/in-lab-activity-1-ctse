import 'package:flutter/material.dart';
import 'package:lab_activity_recipes_app/model/recipe.dart';

class RecipeWidget extends StatelessWidget {
  final Recipe? recipe;

  const RecipeWidget({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/create');
        },
        child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            color: Colors.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe!.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe!.description!,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ingredients:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: recipe!.ingredients!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ingredient = recipe!.ingredients![index];
                    return Text('- $ingredient');
                  },
                ),
              ],
            )));
  }
}
