import 'package:flutter/material.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/custom_text_field.dart';

class ReplyDialogView extends StatelessWidget {
  const ReplyDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController replyController = TextEditingController();

    return AlertDialog(
      title: const Text("Write your Review Comment"),
      content: CustomTextField(
        controller: replyController,
        maxLines: 3,
        hint: "Type your reply...",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel", style: TextStyle(color: Colors.black),),
        ),
        AppButton(
          width: 100,
          height: 50,
          onPressed: () {
            String reply = replyController.text;

            if (reply.isNotEmpty) {
              // send reply to backend or controller
              print("Reply: $reply");
            }

            Navigator.pop(context);
          },
          text: 'Send',
        ),
      ],
    );
  }
}