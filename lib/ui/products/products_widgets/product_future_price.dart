
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../constants/fonts.dart';
import '../../../data/models/product_model/product_model.dart';

Widget productFuturePrice(ProductModel product){
  if (product.futureDate.isEmpty) {
    return const SizedBox.shrink();
  } else {
    return Row(
      children: [
        Icon(MdiIcons.arrowTopRightBoldBox, color: Colors.red,),
        Expanded(
          child: Text(
            '${product.futurePrice}₽ c ${product.futureDate}',
            style: black54(16), 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
          )
        ),
      ],
    );
  }
}