import 'package:flutter/material.dart';
import 'package:flutter_rte/flutter_rte.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/post_controller.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? thumbnailUrl; // To store the URL of the selected image
  final HtmlEditorController contentController = HtmlEditorController();

  Future<void> chooseImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        final postController =
            Provider.of<PostController>(context, listen: false);
        try {
          thumbnailUrl = await postController
              .uploadImage(imageFile); // Upload image and get URL
          setState(() {}); // Refresh UI
        } catch (e) {
          _showMessage(context, 'Failed to upload image: ${e.toString()}',
              isSuccess: false);
        }
      } else {
        _showMessage(context, 'No image selected.', isSuccess: false);
      }
    } catch (e) {
      _showMessage(context, 'Error picking image: ${e.toString()}',
          isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postController = Provider.of<PostController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            GestureDetector(
              onTap: chooseImage,
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  children: [
                    if (thumbnailUrl != null)
                      Image.network(thumbnailUrl!,
                          height: 100) // Display selected image
                    else
                      Text('Choose Thumbnail Image'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: HtmlEditor(
                controller: contentController,
                height: 300,
                hint: "Type your content here...",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Center(child: CircularProgressIndicator());
                  },
                );

                final title = titleController.text;
                final description = descriptionController.text;
                final content = await contentController.getText();
                final slug = title.toLowerCase().replaceAll(' ', '-');

                try {
                  await postController.createPost(
                      title, description, thumbnailUrl ?? '', content, slug);
                  Navigator.of(context).pop(); // Close loading dialog
                  Navigator.of(context).pop(); // Close the create post screen
                  _showMessage(context, 'Post created successfully!',
                      isSuccess: true);
                } catch (e) {
                  Navigator.of(context).pop(); // Close loading dialog
                  _showMessage(
                      context, 'Failed to create post: ${e.toString()}',
                      isSuccess: false);
                }
              },
              child: Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message,
      {bool isSuccess = true}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
