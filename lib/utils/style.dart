import "package:flutter/material.dart";

class AppColors {
  static const Color background = Color.fromARGB(255, 216, 216, 216);
  static const Color blue = Color.fromRGBO(2, 78, 180, 1.0);
  static const Color grey = Colors.grey;
  static const Color grey_100 = Color.fromARGB(255, 216, 216, 216);
}

class AppText {
  static const TextStyle titleLarge = TextStyle(
    color: AppColors.blue,
    fontSize: 50,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle titleMedium = TextStyle(
    color: AppColors.blue,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle titleTiny = TextStyle(
    color: AppColors.blue,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle tiny = TextStyle(fontSize: 20);
  static const TextStyle medium = TextStyle(fontSize: 30);
}
