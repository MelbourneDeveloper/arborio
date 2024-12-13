import 'dart:async';

import 'package:flutter/material.dart';

/// Factory for generating images
typedef ImageBuilder = Widget Function(
  String path, {
  required double width,
  required double height,
  BoxFit? fit,
});

/// Returns an image asset
Widget imageAsset(
  String path, {
  required double width,
  required double height,
  BoxFit? fit,
}) =>
    switch (Zone.current[#imageBuilder]) {
      (final ImageBuilder builder) =>
        builder(path, width: width, height: height, fit: fit),
      (_) => Image.asset(
          path,
          width: width,
          height: height,
          fit: fit,
        ),
    };
