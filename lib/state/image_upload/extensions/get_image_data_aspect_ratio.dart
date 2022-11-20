import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instantgram/state/image_upload/extensions/get_imge_aspect_ratio.dart';

extension GetimageDataAspectratio on Uint8List {
  Future<double> getAspectratio() {
    final image = Image.memory(this);
    return image.getAspectRatio();
  }
}
