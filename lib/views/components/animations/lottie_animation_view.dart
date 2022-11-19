import 'package:flutter/material.dart';
import 'package:instantgram/views/components/animations/models/lottie_animation.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationView extends StatelessWidget {
  const LottieAnimationView({
    super.key,
    required this.animation,
    this.repeat = true,
    this.reverse = false,
  });

  final LottieAnimation animation;
  final bool repeat;
  final bool reverse;

  @override
  Widget build(BuildContext context) => Lottie.asset(animation.fullPath);
}

extension GetFullPath on LottieAnimation {
  String get fullPath => 'assets/animations/$name.json';
}
