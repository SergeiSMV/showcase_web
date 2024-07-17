
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget searchAnimation(){
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: DotLottieLoader.fromAsset('lib/images/lottie/search.lottie',
          frameBuilder: (ctx, dotlottie) {
            return dotlottie != null ? Lottie.memory(dotlottie.animations.values.single) : Container();
        }),
      ),
    );
  }