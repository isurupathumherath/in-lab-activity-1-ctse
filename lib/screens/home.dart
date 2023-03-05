import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_activity_recipes_app/widgets/itemWidget.dart';
import '../constants/colors.dart';
import '../model/recipe.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // readRecipes();
  }

  String newRecipeTitle = '';
  String newRecipeDescription = '';
  List<Recipe> recipeList = [
    Recipe(
        id: "1",
        title: "Sample 1",
        ingredients: ["Sample I 1", "Sample I 2", "Sample I 3"],
        description: "Sample 1 description",
        email: "email"),
    Recipe(
        id: "2",
        title: "Sample 2",
        ingredients: ["Sample I 1", "Sample I 2", "Sample I 3", "Sample I 4"],
        description: "Sample 2 description",
        email: "email"),
    Recipe(
        id: "3",
        title: "Sample 3",
        ingredients: ["Sample I 1", "Sample I 2"],
        description: "Sample 3 description",
        email: "email"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tdBGColor,
        // appBar: _buildAppBar(),

        body: Stack(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              // const ElevatedButton(
              //   style: ButtonStyle(),
              //   onPressed: () => _createItem(createItem()),
              //   child: Text(
              //     "Create an Account",
              //     style: TextStyle(
              //       fontSize: 15.0,
              //     ),
              //   ),
              // ),
              Expanded(
                  child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 20, left: 80),
                    child: const Text(
                      'Recipes',
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                  for (Recipe recipe in recipeList)
                    RecipeWidget(
                      recipe: recipe,
                    )
                ],
              )),
            ]),
          ),
        ]));
  }

  // Handles todo update
  void _handleTodoChange(Recipe recipe) {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('recipes').doc(recipe.id);
    docRef
        .update({
          'title': recipe.title!,
          'description': recipe.description!,
          'ingredients': recipe.ingredients
        })
        .then((value) => print('updated'))
        .catchError((error) => print("Failed to update value: $error"));
  }

  // Handles delete todos
  void _handleRecipeDelete(String id) async {
    await FirebaseFirestore.instance.collection('recipe').doc(id).delete();
    readRecipes();
  }

  // Reads todos from the currently logged in user
  void readRecipes() async {
    setState(() {
      recipeList.clear();
    });

    User? user = FirebaseAuth.instance.currentUser;
    String? email = "";
    if (user != null) {
      email = user.email;
    } else {
      Navigator.pushNamed(context, '/login');
    }
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('recipes');

    final QuerySnapshot querySnapshot =
        await collection.where('email', isEqualTo: email).get();

    for (final QueryDocumentSnapshot document in querySnapshot.docs) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String title = data['title'];
      final String description = data['description'];
      final List<String> ingredients = data['ingrediants'];
      final String id = document.id;

      final Recipe recipe = Recipe(
          id: id,
          title: title,
          description: description,
          email: email,
          ingredients: ingredients);

      setState(() {
        recipeList.add(recipe);
      });
    }
  }

  // login callback
  _createItem(Future<void> future) {
    future.then((_) {
      print('Successfully Created');
    });
  }

  //Handles sign in
  Future<void> createItem() async {}

  //Appbar widget
  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: tdBGColor,
        // 0 shadow
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.menu,
              size: 30,
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('/assests/profile/isuru.png')),
            ),
          ],
        ));
  }
}
