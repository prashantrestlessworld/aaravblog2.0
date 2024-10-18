// screens/create_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import '../controllers/post_controller.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? thumbnailUrl;

  // Instantiate the QuillController
  quill.QuillController contentController = quill.QuillController.basic();
  bool _isLoading = false;

  // File for image picker
  File? _pickedImage;
  Uint8List? _webImage;

  Future<void> chooseImage() async {
    final picker = ImagePicker();
    try {
      if (kIsWeb) {
        // Web specific image picking
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
          });
          final postController =
              Provider.of<PostController>(context, listen: false);
          try {
            thumbnailUrl = await postController.uploadImageWeb(bytes);
            setState(() {});
          } catch (e) {
            _showMessage(
                context, 'Failed to upload image on web: ${e.toString()}',
                isSuccess: false);
          }
        } else {
          _showMessage(context, 'No image selected on web.', isSuccess: false);
        }
      } else {
        // Mobile/desktop specific image picking
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          setState(() {
            _pickedImage = imageFile;
          });
          final postController =
              Provider.of<PostController>(context, listen: false);
          try {
            thumbnailUrl = await postController.uploadImage(imageFile);
            setState(() {});
          } catch (e) {
            _showMessage(context, 'Failed to upload image: ${e.toString()}',
                isSuccess: false);
          }
        } else {
          _showMessage(context, 'No image selected.', isSuccess: false);
        }
      }
    } catch (e) {
      _showMessage(context, 'Error picking image: ${e.toString()}',
          isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title input field
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),

            // Description input field
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),

            // Image picker section
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
                      kIsWeb
                          ? Image.memory(_webImage!, height: 100)
                          : Image.file(_pickedImage!, height: 100)
                    else
                      Text('Choose Thumbnail Image'),
                  ],
                ),
              ),
            ),

            // Quill editor and toolbar
            QuillSimpleToolbar(
              controller: contentController,
              configurations: const quill.QuillSimpleToolbarConfigurations(),
            ),
            Expanded(
              child: quill.QuillEditor.basic(
                controller: contentController,
                configurations: const quill.QuillEditorConfigurations(),
              ),
            ),

            // Create Post Button
            ElevatedButton(
              onPressed: _isLoading ? null : _createPost,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createPost() async {
    setState(() {
      _isLoading = true;
    });

    final title = titleController.text;
    final description = descriptionController.text;
    final content = contentController.document
        .toPlainText(); // Get plain text content from Quill editor
    final slug = title
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '-'); // Generate slug from title

    try {
      final postController =
          Provider.of<PostController>(context, listen: false);
      await postController.createPost(
        title,
        description,
        thumbnailUrl ?? '',
        content,
        slug,
      );

      Navigator.of(context).pop();
      _showMessage(context, 'Post created successfully!', isSuccess: true);
    } catch (e) {
      _showMessage(context, 'Failed to create post: ${e.toString()}',
          isSuccess: false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(BuildContext context, String message,
      {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the QuillController to free up resources
    contentController.dispose();
    super.dispose();
  }
}
