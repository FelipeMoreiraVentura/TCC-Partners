import "package:flutter/material.dart";

class AppColors {
  static const Color background = Color.fromRGBO(240, 239, 239, 1);
  static const Color menu = Color.fromARGB(255, 255, 255, 255);
  static const Color blue = Color.fromRGBO(2, 78, 180, 1.0);
  static const Color menuBackground = Color.fromARGB(255, 179, 178, 178);
}

class AppText {
  static const TextStyle titleLarge = TextStyle(
    color: AppColors.blue,
    fontSize: 50,
    fontWeight: FontWeight.bold,
    fontFamily: "Mayak_Extended",
  );
  static const TextStyle titleMedium = TextStyle(
    color: AppColors.blue,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontFamily: "Mayak_Extended",
  );
  static const TextStyle titleTiny = TextStyle(
    color: AppColors.blue,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: "Mayak_Extended",
  );
  static const TextStyle titleInfoLarge = TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle titleInfoMedium = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle titleInfoTiny = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle xs = TextStyle(fontSize: 10);
  static const TextStyle sm = TextStyle(fontSize: 14);
  static const TextStyle base = TextStyle(fontSize: 16);
  static const TextStyle md = TextStyle(fontSize: 20);
  static const TextStyle lg = TextStyle(fontSize: 24);
  static const TextStyle xl = TextStyle(fontSize: 30);

  static const TextStyle description = TextStyle(color: Colors.black87);
}
