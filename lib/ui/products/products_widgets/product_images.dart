
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/api_config.dart';
import '../../../data/models/category_model/category_data.dart';

Widget productImages(List pictures, PageController pageController) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10)
      ),
      color: Colors.white,
    ),
    child: pictures.isEmpty ? 
    Image.asset(
      categoryImagePath['empty'],
      scale: 2,
    )
    : 
    PageView.builder(
      controller: pageController,
      itemCount: pictures.length,
      itemBuilder: (context, index) {
        String picURL = '$apiURL${pictures[index]['picture_url']}';
        return CachedNetworkImage(
          imageUrl: picURL,
          errorWidget: (context, url, error) => Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                categoryImagePath['empty'],
                scale: 3
              )
            )
          ),
        );
      },
    ),
  );
}
