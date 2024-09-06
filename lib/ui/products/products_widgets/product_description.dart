

import 'package:flutter/material.dart';

import '../../../constants/fonts.dart';
import '../../../data/models/product_model/product_model.dart';

Widget productDescription(ProductModel product) {
  return Align(
    alignment: Alignment.centerLeft,
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Описание:',
              style: black54(18, FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              product.discription.isEmpty ? 'описание отсутствует...' : product.discription,
              style: black54(15),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    )
  );
}