import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../model/recipe.dart';

class RecipeForm extends StatefulWidget {
  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  List<String> _ingredients = [];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    if (_title!.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      String? email = "";
      if (user != null) {
        email = user.email;
      } else {
        Navigator.pushNamed(context, '/login');
      }
      String id = (new DateTime.now().millisecondsSinceEpoch).toString();
      Recipe recipe = Recipe(
          id: id,
          title: _title,
          description: _description,
          ingredients: [],
          email: email);
      final recipeItem =
          FirebaseFirestore.instance.collection('recipes').doc(id);

      final recipeJson = {
        'title': _title,
        'description': _description,
        'email': email,
        'ingredients': _ingredients
      };

      await recipeItem.set(recipeJson);
    } else {
      print('text is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter the recipe title',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a recipe title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter the recipe description',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a recipe description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              SizedBox(height: 16),
              Text('Ingredients'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _ingredients.length,
                itemBuilder: (BuildContext context, int index) {
                  return TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Ingredient ${index + 1}',
                      hintText: 'Enter the ingredient name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an ingredient';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _ingredients[index] = value!;
                    },
                  );
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
