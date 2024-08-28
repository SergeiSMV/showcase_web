
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: DotLottieLoader.fromAsset('lib/images/lottie/truck_loading.lottie',
          frameBuilder: (ctx, dotlottie) {
            return dotlottie != null ? Lottie.memory(dotlottie.animations.values.single) : Container();
        }),
      ),
    );
  }
}