
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcase_web/widgets/loading.dart';

import '../../../constants/fonts.dart';
import '../../../data/models/product_model/product_model.dart';
import '../../../data/repositories/goods_implements.dart';
import '../../../riverpod/menu_index_provider.dart';
import '../products_widgets/product_cart_buttons/product_cart_buttons.dart';
import '../products_widgets/product_description.dart';
import '../products_widgets/product_future_price.dart';
import '../products_widgets/product_images.dart';
import '../products_widgets/product_images_indicator.dart';
import '../products_widgets/product_name.dart';
import '../products_widgets/product_price.dart';

class ProductCard extends ConsumerStatefulWidget {
  final int productID;
  const ProductCard({super.key, required this.productID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  GoodsImplements goods = GoodsImplements();
  final PageController pageController = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int menuIndex = ref.read(menuIndexProvider);
      if (menuIndex != 1) {
        ref.read(menuIndexProvider.notifier).state = 1;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<Map> _productData() async {
    Map productData;
    productData = await goods.backendProduct(widget.productID, ref);
    return productData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _productData(),
      builder: (context, snapshot) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Пока данные загружаются
          return const Loading();
        } else if (snapshot.hasError) {
          // Если произошла ошибка
          return Center(
            child: Text(
              'Ошибка: ${snapshot.error}',
              style: black54(14),
            )
          );
        } else {
          // Когда данные загружены
          ProductModel product = ProductModel(product: snapshot.data as Map<String, dynamic>);
          return cardView(product, isSmallScreen);
        }
      }
    );
  }

  Widget cardView(ProductModel product, bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // изображение продукта
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: isSmallScreen ? 300 : 400,
                    maxWidth: isSmallScreen ? 300 : 400
                  ),
                  child: productImages(product.pictures, pageController)
                ),
                      
                // индикатор изображений, если их больше 1
                productImagesIndicator(product.pictures, pageController),
                      
                // название продукта
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15, 
                    horizontal: isSmallScreen ? 20 : 10
                  ),
                  child: productName(product.name),
                ),
                      
                // описание продукта
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5, 
                    horizontal: isSmallScreen ? 20 : 10
                  ),
                  child: productDescription(product),
                ),
                
                // информация о повышении цены
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20 : 10,
                    vertical: 10
                  ),
                  child: productFuturePrice(product),
                ),

                // текущая цена
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 15 : 5, 
                    vertical: 10
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft, 
                    child: productPrice(product.basePrice, product.clientPrice,)
                  ),
                ),
                const SizedBox(height: 10,),

                // управление корзиной
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20 : 10,
                    vertical: 20
                  ),
                  child: ProductCartButtons(product: product,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}