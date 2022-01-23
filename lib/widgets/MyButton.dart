import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final double width;
  final Widget child;
  MyButton({
    required this.child,
    required this.width,
    required this.onPressed,
    this.color = Colors.redAccent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: width,
      height: 50.0,
      duration: Duration(seconds: 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: ElevatedButton(
          style: TextButton.styleFrom(elevation: 0.0, backgroundColor: color),
          child: child,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
