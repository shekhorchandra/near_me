import 'package:flutter/material.dart';

class PasswordRule extends StatelessWidget {
  final String title;
  final bool valid;

  const PasswordRule({
    super.key,
    required this.title,
    required this.valid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [

          Icon(
            valid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: valid ? Colors.green : Colors.grey,
            size: 18,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: valid ? Colors.green : Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

}