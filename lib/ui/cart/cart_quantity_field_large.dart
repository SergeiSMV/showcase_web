

import 'package:flutter/material.dart';

import '../../../../constants/fonts.dart';

Widget cartQuatityFieldLarge(FocusNode focusNode, TextEditingController controller){
  return Container(
    height: 33,
    padding: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.transparent
      ),
      color: Colors.white,
    ),
    child: Center(
      child: TextField(
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        style: black(18),
        minLines: 1,
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          isCollapsed: true,
        ),
      ),
    ),
  );
}