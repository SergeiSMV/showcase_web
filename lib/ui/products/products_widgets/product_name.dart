
import 'package:flutter/material.dart';


Widget productName(String name, TextStyle style){
  return Align(
    alignment: Alignment.topLeft,
    child: Text(
      name,
      style: style,
      maxLines: 3,
    )
  );
}