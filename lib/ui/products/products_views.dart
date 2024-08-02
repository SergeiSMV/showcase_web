
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/api_config.dart';
import '../../constants/fonts.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/models/product_model/product_model.dart';
import '../../global_widgets/image_filteres.dart';
import '../../riverpod/cart_provider.dart';
import '../../riverpod/token_provider.dart';

class ProductsViews extends ConsumerStatefulWidget {
  final ProductModel currentProduct;
  const ProductsViews({super.key, required this.currentProduct});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsViewsState();
}

class _ProductsViewsState extends ConsumerState<ProductsViews> {

  final TextEditingController _quantityController = TextEditingController();
  final PageController pageController = PageController();
  // final BackendImplements backend = BackendImplements();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    _quantityController.dispose();
    pageController.dispose();
    super.dispose();
  }


  bool currentProductsInCart(List cart){
    bool inCart = false;
    for (var product in cart) {
      if (product['product_id'] == widget.currentProduct.id) {
        inCart = true;
        break;
      }
    }
    return inCart;
  }

  Map currentProductCartData(List cart){
    Map data = {};
    for (var product in cart) {
      if (product['product_id'] == widget.currentProduct.id) {
        data = product;
        break;
      }
    }
    return data;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        // onTap: () => showProductCard(context),
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
          child: Builder(
            builder: (context) {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    productImages(widget.currentProduct.quantity),
                    const SizedBox(height: 5,),
                    widget.currentProduct.pictures.isEmpty || widget.currentProduct.pictures.length == 1 ? const SizedBox(height: 8,) : imageIndicator(),
                    const SizedBox(height: 5,),
                    SizedBox(height: 40, child: Align(alignment: Alignment.topLeft, child: Text(widget.currentProduct.shortName, style: black(14), maxLines: 3, overflow: TextOverflow.ellipsis,))),
                    widget.currentProduct.futureDate.isEmpty ? const SizedBox(height: 30,) :
                    SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Icon(MdiIcons.arrowTopRightBoldBox, color: Colors.red, size: 18,),
                          Expanded(child: Text('${widget.currentProduct.futurePrice}₽ c ${widget.currentProduct.futureDate}', style: black(14), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                        ],
                      ),
                    ),
                    Align(alignment: Alignment.centerLeft, child: getPrice(widget.currentProduct.basePrice, widget.currentProduct.clientPrice,)),
                    const SizedBox(height: 5,),
                    cartController(),
                    // const SizedBox(height: 5,),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  Consumer cartController() {
    return Consumer(
      builder: (context, ref, child) {
        final cart = ref.watch(cartProvider);
        return SizedBox(
          width: double.infinity,
          child: 
          currentProductsInCart(cart) ? 
          Row(
            children: [
              quantityControlButton('minus', cart),
              Expanded(
                child: InkWell(
                  // onTap: () => indicateQuantity(context, _quantityController, widget.currentProduct.name).then((_) async {
                  //   await backend.putExact(widget.currentProduct.id, int.parse(_quantityController.text), ref).then(
                  //     (updateCart) { 
                  //       ref.read(cartBadgesProvider.notifier).state = updateCart.length;
                  //       ref.read(cartProvider.notifier).state = updateCart;
                  //     }
                  //   );
                  // }),
                  child: Center(
                    child: Text('${currentProductCartData(cart)['quantity']}', style: black(20, FontWeight.w500),)
                  ),
                )
              ),
              quantityControlButton('plus')
            ],
          )
          : toCartButton(widget.currentProduct.quantity),
        );
      }
    );
  }

  SizedBox quantityControlButton(String operation, [List<dynamic> cart = const []]) {
    return SizedBox(
      width: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: operation == 'plus' ? const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)) :
              const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
        ),
        onPressed: () async { 
          // operation == 'plus' ? 
          // await backend.putIncrement(widget.currentProduct.id, ref).then(
          //   (updateCart) { 
          //     ref.read(cartBadgesProvider.notifier).state = updateCart.length;
          //     ref.read(cartProvider.notifier).state = updateCart;
          //   }
          // )
          // : 
          // await backend.putDecrement(widget.currentProduct.id, currentProductCartData(cart)['quantity'], ref).then(
          //   (updateCart) { 
          //     ref.read(cartBadgesProvider.notifier).state = updateCart.length;
          //     ref.read(cartProvider.notifier).state = updateCart;
          //   }
          // );
        }, 
        child: Center(
          child: operation == 'plus' ? Icon(MdiIcons.plus, color: Colors.black, size: 20,) : 
            Icon(MdiIcons.minus, color: Colors.black, size: 20,)
        )
      ),
    );
  }

  Widget toCartButton(int quantity) {
    return Consumer(
      builder: (context, ref, child) {
        // ignore: unused_local_variable
        String token = ref.watch(tokenProvider);
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: quantity == 0 ? Colors.grey : const Color(0xFF00B737),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            // quantity == 0 ? null :
            // token.isNotEmpty ? 
            // await backend.putIncrement(widget.currentProduct.id, ref).then(
            //   (updateCart) { 
            //     ref.read(cartBadgesProvider.notifier).state = updateCart.length;
            //     ref.read(cartProvider.notifier).state = updateCart;
            //   }
            // )
            // : GlobalScaffoldMessenger.instance.showSnackBar('Вы не авторизованы!', 'error');
          }, 
          child: Text('в корзину', style: whiteText(16),)
        );
      }
    );
  }

  Container productImages(int quantity) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: widget.currentProduct.pictures.isEmpty ? Image.asset(categoryImagePath['empty'], scale: 3,) : 
      PageView.builder(
        controller: pageController,
        itemCount: widget.currentProduct.pictures.length,
        itemBuilder: (context, index) {
          String picURL = '$apiURL${widget.currentProduct.pictures[index]['picture_url']}';
          return ColorFiltered(
            colorFilter: quantity == 0 ? greyFilter : opacityFilter,
            child: CachedNetworkImage(
              imageUrl: picURL,
              errorWidget: (context, url, error) => Align(alignment: Alignment.center, child: Opacity(opacity: 0.3, child: Image.asset(categoryImagePath['empty'], scale: 3))),
            ),
          );
        },
      ),
    );
  }

  SmoothPageIndicator imageIndicator() {
    return SmoothPageIndicator(
      controller: pageController,
      count: widget.currentProduct.pictures.length,
      effect: WormEffect(
        dotHeight: 8,
        dotWidth: 8,
        type: WormType.thin,
        activeDotColor: Colors.green,
        dotColor: Colors.grey.shade300
      ),
    );
  }

  Widget getPrice(double basePrice, double clientPrice){
    if (basePrice > clientPrice){
      return Row(
        children: [
          Text('$clientPrice₽', style: black(18, FontWeight.normal), overflow: TextOverflow.fade,),
          const SizedBox(width: 10,),
          Text('$basePrice₽', style: blackThroughPrice(16, FontWeight.normal)),
        ],
      );
    } else {
      return Text('$clientPrice₽', style: black(18, FontWeight.normal));
    }
  }


  /*
  void showProductCard(BuildContext mainContext) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: mainContext,
      builder: (context) {
        return ProductCard(
          product: widget.currentProduct,
          cartController: cartController(),
        );
      },
    );
  }
  */


}