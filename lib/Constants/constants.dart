import 'dart:ui';
import 'package:flutter/material.dart';

final class Constants {
  static const List<String> priorityLevels = [
    'Düşük',
    'Orta',
    'Yüksek',
    'Acil'
  ];
  static const padding = 8.0;
  static const Map<String, Color> priorityColors = {
    'Düşük': Colors.green,
    'Orta': Colors.blue,
    'Yüksek': Colors.orange,
    'Acil': Colors.red,
  };

  static const List<String> categories = [
    'Varsayılan',
    'İş',
    'Kişisel',
    'Eğitim',
    'Sağlık',
    'Finans'
  ];
}
