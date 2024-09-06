
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/fonts.dart';
import '../../data/models/product_model/product_model.dart';
import 'products_widgets/product_cart_buttons/product_cart_buttons.dart';
import 'products_widgets/product_future_price.dart';
import 'products_widgets/product_images.dart';
import 'products_widgets/product_images_indicator.dart';
import 'products_widgets/product_name.dart';

class ProductsViews extends ConsumerStatefulWidget {
  final ProductModel currentProduct;
  const ProductsViews({super.key, required this.currentProduct});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsViewsState();
}

class _ProductsViewsState extends ConsumerState<ProductsViews> {

  final PageController pageController = PageController();

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {

        // ignore: unused_local_variable
        final isSmallScreen = MediaQuery.of(context).size.width < 600;

        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 3,
                color: Colors.transparent,
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(1, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // изображения продукта
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: InkWell(
                    onTap: (){
                      GoRouter.of(context).go('/product/${widget.currentProduct.id}');
                    },
                    child: productImages(widget.currentProduct.pictures, pageController)
                  )
                ),

                // индикаторы изображений продукта
                // imageIndicator(),
                productImagesIndicator(widget.currentProduct.pictures, pageController),

                // наименование продукта
                SizedBox(
                  height: 45,
                  child: productName(widget.currentProduct.name, black54(14))
                ),
                
                // будущая цена (подорожание) продукта
                productFuturePrice(widget.currentProduct),

                // текущая цена продукта
                currentPrice(widget.currentProduct.basePrice, widget.currentProduct.clientPrice,),
                
                // заполнитель
                const Expanded(child: SizedBox(height: 5,)),
                
                // виджет контроля корзины
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: ProductCartButtons(product: widget.currentProduct),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  // текущая цена продукта
  Widget currentPrice(double basePrice, double clientPrice){
    if (basePrice > clientPrice){
      return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              '${clientPrice.toStringAsFixed(2)}₽', 
              style: black54(18, FontWeight.w700), 
              overflow: TextOverflow.fade,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              '${basePrice.toStringAsFixed(2)}₽', 
              style: blackThroughPrice(16, FontWeight.w700),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${clientPrice.toStringAsFixed(2)}₽', 
          style: black54(18, FontWeight.w700),
          overflow: TextOverflow.fade,
        ),
      );
    }
  }

}