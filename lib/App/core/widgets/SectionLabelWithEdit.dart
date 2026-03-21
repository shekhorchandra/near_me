import 'package:flutter/material.dart';

class SectionLabelWithEdit extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit;

  const SectionLabelWithEdit({
    super.key,
    required this.title,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: const Icon(
            Icons.edit,
            size: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}