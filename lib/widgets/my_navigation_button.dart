import 'package:flutter/material.dart';

class MyNavigationButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  
  const MyNavigationButton({
    required this.text,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        width: screenWidth * 0.85,
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(33, 173, 252, 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
