
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../constants/fonts.dart';

Widget productPrice(double basePrice, double clientPrice){
  if (basePrice > clientPrice){
    return Row(
      children: [
        Icon(MdiIcons.bookmark),
        const SizedBox(width: 5,),
        Text('${clientPrice.toStringAsFixed(2)}₽', style: black54(24, FontWeight.normal), overflow: TextOverflow.fade,),
        const SizedBox(width: 10,),
        Text('${basePrice.toStringAsFixed(2)}₽', style: blackThroughPrice(20, FontWeight.normal)),
      ],
    );
  } else {
    return Row(
      children: [
        Icon(MdiIcons.bookmark),
        const SizedBox(width: 5,),
        Text('${clientPrice.toStringAsFixed(2)}₽', style: black54(24, FontWeight.normal)),
      ],
    );
  }
}