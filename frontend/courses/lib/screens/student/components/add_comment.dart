import 'package:flutter/material.dart';

class AddComment extends StatefulWidget {
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  List<String> comments = [];
  bool showTextField = false;

  TextEditingController commentController = TextEditingController();

  void addComment() {
    String comment = commentController.text;
    setState(() {
      comments.add(comment);
      commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(comments[index]),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: showTextField ? TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ) : Container(),
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    setState(() {
                      showTextField = !showTextField;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
