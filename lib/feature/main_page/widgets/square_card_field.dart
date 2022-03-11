import 'package:flutter/material.dart';

typedef OnClick = Function(int i);

class SquareCardField extends StatelessWidget {
  const SquareCardField({
    Key? key,
    required this.index,
    required this.dimension,
    this.isSelected = false,
    required this.onClick,
  }) : super(key: key);
  final int index;
  final double dimension;
  final bool isSelected;
  final OnClick onClick;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => onClick(index),
        child: Center(
          child: Container(
            width: dimension,
            height: dimension,
            decoration: BoxDecoration(
              color: isSelected ? Colors.yellow : Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(index.toString())),
          ),
        ),
      ),
    );
  }
}
