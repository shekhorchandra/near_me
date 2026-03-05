import 'package:flutter/material.dart';

class ReplyDialogView extends StatelessWidget {
  const ReplyDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController replyController = TextEditingController();

    return AlertDialog(
      title: const Text("Write a Reply"),
      content: TextField(
        controller: replyController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: "Type your reply...",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            String reply = replyController.text;

            if (reply.isNotEmpty) {
              // send reply to backend or controller
              print("Reply: $reply");
            }

            Navigator.pop(context);
          },
          child: const Text("Send"),
        ),
      ],
    );
  }
}