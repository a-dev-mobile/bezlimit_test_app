import 'package:flutter/material.dart';

class LongCardField extends StatelessWidget {
  const LongCardField({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RepaintBoundary(
      child: SizedBox(
        height: size.width * 0.13,
        width: width,
        child: const Card(
          color: Colors.white,
          shape: StadiumBorder(),
          elevation: 8,
        ),
      ),
    );
  }
}
