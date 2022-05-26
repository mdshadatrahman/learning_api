// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rest_api/auth/http_service.dart';
import '../auth/post_model.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () async {
              await httpService.deletePost(widget.post.id);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: const Text("Title"),
                      subtitle: Text(widget.post.title),
                    ),
                    ListTile(
                      title: const Text("ID"),
                      subtitle: Text("${widget.post.id}"),
                    ),
                    ListTile(
                      title: const Text("Body"),
                      subtitle: Text(widget.post.body),
                    ),
                    ListTile(
                      title: const Text("User ID"),
                      subtitle: Text("${widget.post.userId}"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
