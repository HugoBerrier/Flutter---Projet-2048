import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final int value;
  final String palette;

  const Tile({super.key, required this.value, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getTileColor(value),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          value == 0 ? '' : '$value',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _getTextColor(value),
          ),
        ),
      ),
    );
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return Colors.grey[300]!;
      case 4:
        return Colors.grey[400]!;
      case 8:
        return Colors.orange[300]!;
      case 16:
        return Colors.orange[500]!;
      case 32:
        return Colors.deepOrange[400]!;
      case 64:
        return Colors.red[400]!;
      case 128:
        return Colors.purple[300]!;
      case 256:
        return Colors.purple[500]!;
      case 512:
        return Colors.blue[400]!;
      case 1024:
        return Colors.teal[400]!;
      case 2048:
        return Colors.green[500]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Color _getTextColor(int value) {
    return value <= 4 ? Colors.black87 : Colors.white;
  }
}
