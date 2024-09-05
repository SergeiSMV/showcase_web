
import 'package:flutter/material.dart';

import '../../../constants/fonts.dart';

Widget productName(String name){
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      name,
      style: black54(18, FontWeight.bold),
    )
  );
}