import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'; // Import the flutter_widget_from_html package
import '../models/post.dart'; // Adjust the import according to your project structure

class PostDetailScreen extends StatelessWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the post thumbnail
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    post.thumbnail.isNotEmpty
                        ? post.thumbnail
                        : 'https://via.placeholder.com/200',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Display post title
            Text(
              post.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Display post description
            Text(
              post.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Display post content using flutter_widget_from_html
            Expanded(
              child: SingleChildScrollView(
                child: HtmlWidget(
                  post.content, // This will render the HTML content
                  textStyle: TextStyle(
                      fontSize: 16), // Set the font size for the content
                  // Add any additional options like custom styling
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
