


import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget productImagesIndicator(List pictures, PageController pageController){
  if (pictures.isEmpty || pictures.length == 1) {
    return const SizedBox(height: 8,);
  } else {
    return SmoothPageIndicator(
      controller: pageController,
      count: pictures.length,
      effect: WormEffect(
          dotHeight: 8,
          dotWidth: 8,
          type: WormType.thin,
          activeDotColor: Colors.green,
          dotColor: Colors.grey.shade300),
    );
  }
}