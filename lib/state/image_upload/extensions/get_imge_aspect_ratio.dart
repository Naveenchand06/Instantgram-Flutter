import 'dart:async';

import 'package:flutter/material.dart';

extension GetImageAspectRatio on Image {
  Future<double> getAspectRatio() async {
    final completer = Completer<double>();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (imageInfo, syncronousCall) {
          final aspectRatio = imageInfo.image.width / imageInfo.image.height;
          imageInfo.image.dispose();
          completer.complete(aspectRatio);
        },
      ),
    );
    return completer.future;
  }
}
