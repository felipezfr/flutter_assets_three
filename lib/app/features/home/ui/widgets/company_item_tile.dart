import 'package:flutter/material.dart';

class CompanyItemTile extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const CompanyItemTile({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: const Color(0xFF2188FF),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Row(
            children: [
              const Image(image: AssetImage('assets/icons/home.png')),
              const SizedBox(
                width: 10,
              ),
              Text(
                '$name Unit',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
