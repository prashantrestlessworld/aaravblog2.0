import 'package:aaravblog/models/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/post_controller.dart';
import 'create_post_screen.dart';
import 'post_detail_screen.dart'; // Import the PostDetailScreen

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postController = Provider.of<PostController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: FutureBuilder<List<Post>>(
        future: postController.fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading skeleton while posts are being fetched
            return ListView.builder(
              itemCount: 5, // Display 5 skeletons
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300], // Skeleton color
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 16,
                              width: double.infinity,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 16,
                              width: double.infinity,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available.'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                // Make the post clickable
                onTap: () {
                  // Navigate to the PostDetailScreen with the selected post
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post: posts[index]),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      // Display the post thumbnail or a fallback image
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              posts[index].thumbnail.isNotEmpty
                                  ? posts[index].thumbnail
                                  : 'https://via.placeholder.com/100', // Fallback image
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              posts[index].title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              posts[index].description,
                              maxLines: 2,
                              overflow: TextOverflow
                                  .ellipsis, // Shorten the description
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreatePostScreen(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
