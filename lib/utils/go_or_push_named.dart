// lib/navigation/nav.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

typedef StrMap = Map<String, String>;

void navNamed(
  BuildContext c,
  String name, {
  StrMap path = const {},
  StrMap query = const {},
  Object? extra,
}) =>
    kIsWeb
        ? GoRouter.of(c).goNamed(
          name,
          pathParameters: path,
          queryParameters: query,
          extra: extra,
        )
        : GoRouter.of(c).pushNamed(
          name,
          pathParameters: path,
          queryParameters: query,
          extra: extra,
        );
