import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart'; // Import the html parser
import 'dart:convert';
import 'dart:ui';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId; // Pass the recipe ID to fetch its details

  const RecipeDetailPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  Map<String, dynamic>? _recipeDetails;
  Map<String, dynamic>? _nutritionDetails;
  bool _isLoading = true;
  bool _isTitleExpanded = false;
  bool _showIngredients = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipeDetails();
  }

  // Function to fetch recipe details from Spoonacular API
  Future<void> _fetchRecipeDetails() async {
    const apiKey = '5547a69ec3e443d89733f65aa93c46e5';
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/${widget.recipeId}/information?apiKey=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _recipeDetails = jsonDecode(response.body);
        _isLoading = false;
      });

      await _fetchNutritionDetails();
    } else {
      print('Failed to load recipe details');
    }
  }

  // Function to fetch nutrition details from Spoonacular API
  Future<void> _fetchNutritionDetails() async {
    const apiKey = '5547a69ec3e443d89733f65aa93c46e5';
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/${widget.recipeId}/nutritionWidget.json?apiKey=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _nutritionDetails = jsonDecode(response.body);
      });
    } else {
      print('Failed to load nutrition details');
    }
  }

  String _convertHtmlToPlainText(String htmlString) {
    final document = parse(htmlString); // Parse the HTML
    final body = document.body; // Extract body element
    final text = body?.text ??
        'No summary available'; // Get text or default to an empty string
    return text.isNotEmpty
        ? text
        : 'No summary available'; // Return text or a default message
  }

  @override
  Widget build(BuildContext context) {
    final summary = _recipeDetails?['summary'] ?? 'No summary available';
    final plainTextSummary = _convertHtmlToPlainText(summary);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(0),
            fixedSize: const Size(50, 50),
          ),
          child: const ImageIcon(
            AssetImage("assets/Cancel.png"),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(0),
              fixedSize: const Size(50, 60),
            ),
            child: const ImageIcon(
              AssetImage("assets/Love.png"),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recipeDetails != null
              ? Stack(
                  children: [
                    Positioned(
                      child: Image.network(
                        _recipeDetails!['image']??"assets/Group.png",//check if image is null
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: 300,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 250), 
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                          topRight: Radius.circular(35.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isTitleExpanded = !_isTitleExpanded;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _recipeDetails!['title']??"Unknow",//if null set to unknow
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                        maxLines: _isTitleExpanded ? null : 1,
                                        overflow: _isTitleExpanded
                                            ? TextOverflow.visible
                                            : TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const ImageIcon(
                                      AssetImage("assets/Time Circle.png"),
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                        '${_recipeDetails!['readyInMinutes']} Min'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ExpandableText(
                                plainTextSummary,
                                expandText: 'show more',
                                collapseText: 'show less',
                                maxLines: 2,
                                linkColor: const Color.fromARGB(255, 4, 38, 40),
                                animation: true,
                                collapseOnTextTap: true,
                                style:
                                    const TextStyle(color: Color(0xFF748189)),
                              ),
                              _buildNutritionalInfo(),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[100],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildToggleButton(
                                      label: 'Ingredients',
                                      isSelected: _showIngredients,
                                      onPressed: () {
                                        setState(() {
                                          _showIngredients = true;
                                        });
                                      },
                                    ),
                                    _buildToggleButton(
                                      label: 'Instructions',
                                      isSelected: !_showIngredients,
                                      onPressed: () {
                                        setState(() {
                                          _showIngredients = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (_showIngredients)
                                ..._recipeDetails!['extendedIngredients']
                                    .map<Widget>((ingredient) => Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 5,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          color: Colors.white,
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(8.0),
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  'https://spoonacular.com/cdn/ingredients_100x100/${ingredient['image']}'),
                                            ),
                                            title: Text(ingredient['name']),
                                            trailing: Text(
                                                '${ingredient['amount']} ${ingredient['unit']}'),
                                          ),
                                        ))
                                    .toList()
                              else
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: HtmlWidget(
                                    _recipeDetails!['instructions'] ??
                                        'No instructions available',
                                    textStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 116, 129, 137)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(child: Text('Failed to load recipe details')),
    );
  }

  Widget _buildNutritionalInfo() {
    if (_nutritionDetails == null) {
      return const Center(
        child: Text(
          'Nutritional information not available',
          style: TextStyle(
            color: Color.fromARGB(255, 116, 129, 137),
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutrientCard(
                'assets/Carbs.png',
                '${_nutritionDetails!['carbs'] ?? 'N/A'}g carbs',
              ),
              _buildNutrientCard(
                'assets/Proteins.png',
                '${_nutritionDetails!['protein'] ?? 'N/A'}g proteins',
              ),
            ],
          ),
          const SizedBox(
              height: 16), // Adjust this value to control vertical spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutrientCard(
                'assets/Calories.png',
                '${_nutritionDetails!['calories'] ?? 'N/A'} Kcal',
              ),
              _buildNutrientCard(
                'assets/Fats.png',
                '${_nutritionDetails!['fat'] ?? 'N/A'}g fats',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(String iconPath, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        margin: const EdgeInsets.symmetric(
            horizontal: 8), // Ensure spacing between cards
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            const SizedBox(width: 8), // Space between icon and text
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF042628),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: isSelected
                ? const Color.fromARGB(255, 4, 38, 40)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                color: Colors.transparent,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 4, 38, 40),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
