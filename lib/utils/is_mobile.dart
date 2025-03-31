import 'package:flutter/material.dart';

bool IsMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 800;
}
