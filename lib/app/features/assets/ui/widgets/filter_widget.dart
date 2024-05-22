import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onTap;

  const FilterWidget({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: const Color(0xFFD8DFE6),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Image.asset(assetPath),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF77818C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
