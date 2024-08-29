import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String authorName;
  final String authorImageUrl;
  final VoidCallback onIconButtonPressed; // Add this line

  const RecipeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.authorName,
    required this.authorImageUrl,
    required this.onIconButtonPressed, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(authorImageUrl),
                      ),
                      const SizedBox(width: 8),
                      Text(authorName),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onIconButtonPressed, // Use the callback
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              color: const Color.fromARGB(255, 4, 38, 40),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 4, 38, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
