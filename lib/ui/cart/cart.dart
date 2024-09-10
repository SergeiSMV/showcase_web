
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';
import 'package:showcase_web/constants/other.dart';
import 'package:showcase_web/data/repositories/cart_implements.dart';
import 'package:showcase_web/ui/products/products_widgets/product_images_indicator.dart';

import '../../data/models/cart_model/cart_model.dart';
import '../../riverpod/cart_provider.dart';
import '../../riverpod/requests_provider.dart';
import '../../riverpod/token_provider.dart';
import '../auth/auth_required.dart';
import '../products/products_widgets/product_images.dart';
import 'cart_buttons.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {

  double footerHeight = 100;
  PageController pageController = PageController();
  CartImplements cartBackend = CartImplements();

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Consumer(
            builder: (context, ref, child) {

              final String token = ref.watch(tokenProvider);
              final cartItems = ref.watch(cartProvider);

              return token.isEmpty ? authRequired(context) :
              
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height:  
                        MediaQuery.sizeOf(context).height - footerHeight - appBarHeight < 0 ? 
                        0 : 
                        MediaQuery.sizeOf(context).height - footerHeight - appBarHeight,
                      width: 600,
                      
                      child: cartItems.isEmpty ?

                      Center(
                        child: emptyCart()
                      ) :
                      
                      
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          CartModel cartProduct = CartModel(cart: cartItems[index]);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            child: Container(
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
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      // изображения продукта
                                      SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: productImages(cartProduct.pictures, pageController)
                                      ),
                                      // индикатор изображений
                                      productImagesIndicator(cartProduct.pictures, pageController),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5, bottom: 5),
                                          child: Text(cartProduct.name, style: black54(16, FontWeight.w500), overflow: TextOverflow.clip,),
                                        ),
                                        currentPrice(cartProduct.basePrice, cartProduct.price),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Text('итого: ${cartProduct.totalPrice.toStringAsFixed(2)}₽', style: black54(20, FontWeight.w500), overflow: TextOverflow.clip,),
                                        ),
                                        const SizedBox(height: 20,),

                                        Row(
                                          children: [
                                            CartButtons(product: cartProduct,),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () async { 
                                                await cartBackend.putDelete(cartProduct.id, ref).then(
                                                  (updateCart) { 
                                                    ref.read(cartBadgesProvider.notifier).state = updateCart.length;
                                                    ref.read(cartProvider.notifier).state = updateCart;
                                                  }
                                                );
                                              }, 
                                              icon: Icon(MdiIcons.delete, color: Colors.red, size: 25,)
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              
                    // Нижний фиксированный элемент
                    Center(
                      child: Container(
                        height: footerHeight,  // Жестко заданная высота
                        color: Colors.white,
                        child: SizedBox(
                          width: 600,
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                const Divider(indent: 10, endIndent: 10,),
                                totalPrice(cartItems),
                                cartItems.isEmpty ? const SizedBox.shrink() :
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF00B737),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await GoRouter.of(context).push('/additinal_info',).then((_){
                                          return {
                                            ref.refresh(baseCartsProvider),
                                            ref.refresh(baseRequestsProvider)
                                          };
                                        });
                                      }, 
                                      child: Text('заказать', style: whiteText(18),)
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      )
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
              style: black54(16, FontWeight.w700), 
              overflow: TextOverflow.fade,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              '${basePrice.toStringAsFixed(2)}₽', 
              style: blackThroughPrice(14, FontWeight.w700),
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
          style: black54(16, FontWeight.w700),
          overflow: TextOverflow.fade,
        ),
      );
    }
  }

  Widget totalPrice(List ordersProduct){
    int sum = 0;
    for (var product in ordersProduct) {
      int productTotal = (product['total'] * 100).round();
      sum += productTotal;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text('итого:', style: black54(18),),
          const SizedBox(width: 8,),
          InkWell(
            onTap: () {
              final Map data = {
                "clean_cart": true,
              };
              cartBackend.repeatOrder(data, ref);
            },
            child: Text('${(sum / 100).toStringAsFixed(2)}₽', style: black54(24, FontWeight.bold),)
          ),
        ],
      ),
    );
  }

  Widget emptyCart(){
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(opacity: 0.7, child: Image.asset('lib/images/empty_cart.png', scale: 5)),
          const SizedBox(height: 10,),
          Text('в корзине пока\nпусто', style: black(14), textAlign: TextAlign.center,),
        ],
      ),
    );
  }

}
