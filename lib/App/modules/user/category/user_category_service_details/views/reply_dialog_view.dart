import 'package:flutter/material.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/custom_text_field.dart';

class ReplyDialogView extends StatefulWidget {
  const ReplyDialogView({super.key});

  @override
  State<ReplyDialogView> createState() => _ReplyDialogViewState();
}

class _ReplyDialogViewState extends State<ReplyDialogView> {
  final TextEditingController replyController = TextEditingController();
  int rating = 0;

  Widget buildStar(int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          rating = index + 1;
        });
      },
      icon: Icon(index < rating ? Icons.star : Icons.star_border, color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Write your Review Comment",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => buildStar(index)),
          ),

          const SizedBox(height: 10),

          /// Comment Field
          CustomTextField(controller: replyController, maxLines: 3, hint: "Write a Review..."),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel", style: TextStyle(color: Colors.black)),
        ),
        AppButton(
          width: 100,
          height: 40,
          onPressed: () {
            String reply = replyController.text;

            if (reply.isNotEmpty) {
              print("Rating: $rating");
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
