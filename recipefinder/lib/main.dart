import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'card.dart';
import 'dart:convert';

import 'recipt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Finder',

      home: MainPage(), // Set MainPage as the home page
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text('Main Page'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 4, 38, 40),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: const ImageIcon(
          AssetImage("assets/Chef.png"),
          color: Colors.white,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar:
          const BottomNavBar(), // Include bottom navigation bar
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _recipes = [];

  final String _apiKey = '5547a69ec3e443d89733f65aa93c46e5';

  Future<void> _searchRecipes(String query) async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?ingredients=$query&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _recipes = json.decode(response.body);
      });
    } else {
      print('Failed to load recipes: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        centerTitle: true,
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: "Sofia",
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search ingredients',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 151, 162, 176)),
                prefixIcon: const ImageIcon(
                  AssetImage("assets/Discover.png"),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 230, 235, 242),
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              onSubmitted: _searchRecipes,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _recipes.isEmpty
                  ? const Center(child: Text('No recipes found'))
                  : ListView.builder(
                      itemCount: _recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _recipes[index];
                        return RecipeCard(
                          title: recipe['title'],
                          imageUrl: recipe['image'] ?? '',
                          authorName: 'Author Name',
                          authorImageUrl: 'https://example.com/avatar.png',
                          onIconButtonPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailPage(recipeId: recipe['id']),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 4, 38, 40),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: const ImageIcon(
          AssetImage("assets/Chef.png"),
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 20,
            blurRadius: 20,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Transform.scale(
              scale: 1,
              child: IconButton(
                
                icon: const ImageIcon(
                  AssetImage("assets/Home.png"),
                  //color: Color.fromARGB(255, 112, 185, 190)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                },
              ),
            ),
            Transform.scale(
              scale: 1,
              child: IconButton(
                icon: const ImageIcon(
                  AssetImage("assets/Discover.png"),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
              ),
            ),
            Transform.scale(
              scale: 1,
              child: IconButton(
                icon: const ImageIcon(
                  AssetImage("assets/Leaderboard.png"),
                ),
                onPressed: () {},
              ),
            ),
            Transform.scale(
              scale: 1,
              child: IconButton(
                icon: const ImageIcon(
                  AssetImage("assets/Profile.png"),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
