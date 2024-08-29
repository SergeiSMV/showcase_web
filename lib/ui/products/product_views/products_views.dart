
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constants/api_config.dart';
import '../../../constants/fonts.dart';
import '../../../data/models/category_model/category_data.dart';
import '../../../data/models/product_model/product_model.dart';
import '../../../data/repositories/cart_implements.dart';
import '../../../widgets/image_filteres.dart';
import '../../../widgets/scaffold_messenger.dart';
import '../../../riverpod/cart_provider.dart';
import '../../../riverpod/token_provider.dart';
import 'product_quatity_field_large.dart';
import '../product_card.dart';

class ProductsViews extends ConsumerStatefulWidget {
  final ProductModel currentProduct;
  const ProductsViews({super.key, required this.currentProduct});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsViewsState();
}

class _ProductsViewsState extends ConsumerState<ProductsViews> {

  final TextEditingController _quantityController = TextEditingController();
  final PageController pageController = PageController();
  final CartImplements cartBackend = CartImplements();
  late FocusNode _focusNode;
  bool loading = false;

  @override
  void initState(){
    super.initState();
    _focusNode = FocusNode();
    focusListener(_focusNode);
    initQuantity();
  }

  @override
  void dispose(){
    _focusNode.dispose();
    _quantityController.dispose();
    pageController.dispose();
    super.dispose();
  }

  // работа с API при завершении ввода
  void focusListener(FocusNode focus) async {
    focus.addListener(() {
      if (!focus.hasFocus) {
        int exact;
        try {
          exact = _quantityController.text.isEmpty ? 0 : int.parse(_quantityController.text);
          exact < 0 ? GlobalScaffoldMessenger.instance.showSnackBar("Значение не может быть отрицательным!", 'error') :
          cartBackend.putExact(widget.currentProduct.id, exact, ref).then(
            (updateCart) { 
              ref.read(cartBadgesProvider.notifier).state = updateCart.length;
              ref.read(cartProvider.notifier).state = updateCart;
            }
          );
        } catch (_) {
          GlobalScaffoldMessenger.instance.showSnackBar("Не верный формат количества!", 'error');
        }
      }
    });
  }

  // обновляем _quantityController
  void updateController(){
    log('updateController updated');
    final cart = ref.read(cartProvider);
    for (var product in cart) {
      if (product['product_id'] == widget.currentProduct.id && !_focusNode.hasFocus) {
        if (_quantityController.text != product['quantity'].toString()){
          if(mounted){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _quantityController.text = product['quantity'].toString();
              });
            });
          }
        }
        break;
      }
    }
  }

  // инициализируем _quantityController
  void initQuantity(){
    final startCart = ref.read(cartProvider);
    for (var product in startCart) {
      if (product['product_id'] == widget.currentProduct.id) {
        setState(() {
          _quantityController.text = product['quantity'].toString();
        });
      }
    }
  }

  // проверяем есть ли в корзине данный продукт
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

  // получаем информацию о продукте в корзине
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
    return Builder(
      builder: (context) {

        final isSmallScreen = MediaQuery.of(context).size.width < 600;

        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Stack(
            children: [
              // product views
              Container(
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
                    productImages(widget.currentProduct.quantity),
                    // индикаторы изображений продукта
                    imageIndicator(),
                    // наименование продукта
                    productName(),
                    // будущая цена (подорожание) продукта
                    futurePrice(),
                    // текущая цена продукта
                    currentPrice(widget.currentProduct.basePrice, widget.currentProduct.clientPrice,),
                    // заполнитель
                    const Expanded(child: SizedBox(height: 5,)),
                    // виджет контроля корзины
                    cartController(isSmallScreen),
                  ],
                ),
              ),
              // занавес загрузки
              loadingCurtain()
            ],
          ),
        );
      }
    );
  }

  // изображения продукта
  Widget productImages(int quantity) {
    return InkWell(
      onTap: () => showProductCard(context),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: widget.currentProduct.pictures.isEmpty ? 
          Image.asset(
            categoryImagePath['empty'], 
            scale: 3,
          ) 
          : 
          PageView.builder(
            controller: pageController,
            itemCount: widget.currentProduct.pictures.length,
            itemBuilder: (context, index) {
              String picURL = '$apiURL${widget.currentProduct.pictures[index]['picture_url']}';
              return ColorFiltered(
                colorFilter: quantity == 0 ? 
                  greyFilter 
                  : 
                  opacityFilter,
                child: CachedNetworkImage(
                  imageUrl: picURL,
                  errorWidget: (context, url, error) => Align(
                    alignment: Alignment.center, 
                    child: Opacity(
                      opacity: 0.3, 
                      child: Image.asset(
                        categoryImagePath['empty'], 
                        scale: 3
                      )
                    )
                  ),
                ),
              );
            },
          ),
      ),
    );
  }

  // индикаторы изображений продукта
  Widget imageIndicator() {
    if (widget.currentProduct.pictures.isEmpty || widget.currentProduct.pictures.length == 1) {
      return const SizedBox(height: 8,);
    } else {
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
  }

  // наименование продукта
  Widget productName() {
    return SizedBox(
      height: 40, 
      child: Align(
        alignment: Alignment.topLeft, 
        child: Text(
          widget.currentProduct.shortName, 
          style: black54(14), 
          maxLines: 3, 
          overflow: TextOverflow.ellipsis,
        )
      )
    );
  }

  // будущая цена (подорожание) продукта
  Widget futurePrice() {
    if (widget.currentProduct.futureDate.isEmpty) {
      return  const SizedBox(
        height: 25,
      );
    } else {
      return SizedBox(
        height: 25,
        child: Row(
          children: [
            Icon(
              MdiIcons.arrowTopRightBoldBox, 
              color: Colors.red, 
              size: 18,
            ),
            Expanded(
              child: Text(
                '${widget.currentProduct.futurePrice}₽ c ${widget.currentProduct.futureDate}', 
                style: black54(14), 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis,
              )
            ),
          ],
        ),
      );
    }
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

  // виджет контроля корзины
  Widget cartController(bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Consumer(
        builder: (context, ref, child) {
          final cart = ref.watch(cartProvider);
          updateController();
          return SizedBox(
            width: double.infinity,
            child: 
            currentProductsInCart(cart) ? 
            Row(
              children: [
                quantityControlButton('minus', cart),
                Expanded(
                  child: Center(
                    child: isSmallScreen ? 
                      InkWell(
                        onTap: () => productQuatityFieldLarge(context, _quantityController, widget.currentProduct.name),
                        child: Text(
                          _quantityController.text, 
                          style: black(18),
                        ),
                      ) 
                      : 
                      productQuatityFieldSmall(),
                  )
                ),
                quantityControlButton('plus')
              ],
            )
            : toCartButton(widget.currentProduct.quantity),
          );
        }
      ),
    );
  }

  // кнопки + и - в виджете контроля корзины
  Widget quantityControlButton(String operation, [List<dynamic> cart = const []]) {
    return SizedBox(
      width: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 3.0, 
            vertical: 3.0
          ),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: operation == 'plus' ? 
              const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)) 
              :
              const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
        ),
        onPressed: () async { 
          setState(() {
            loading = true;
          });
          operation == 'plus' ? 
          await cartBackend.putIncrement(widget.currentProduct.id, ref).then(
            (updateCart) { 
              ref.read(cartBadgesProvider.notifier).state = updateCart.length;
              ref.read(cartProvider.notifier).state = updateCart;
            }
          )
          : 
          await cartBackend.putDecrement(widget.currentProduct.id, currentProductCartData(cart)['quantity'], ref).then(
            (updateCart) { 
              ref.read(cartBadgesProvider.notifier).state = updateCart.length;
              ref.read(cartProvider.notifier).state = updateCart;
            }
          );
          setState(() {
            loading = false;
          });
        }, 
        child: Center(
          child: Icon(
            operation == 'plus' ? 
              MdiIcons.plus 
              : 
              MdiIcons.minus, 
            color: Colors.black, 
            size: 20,
          )
        )
      ),
    );
  }

  // кнопка 'в корзину' в виджете контроля корзины
  Widget toCartButton(int quantity) {
    return Consumer(
      builder: (context, ref, child) {
        // ignore: unused_local_variable
        String token = ref.watch(tokenProvider);
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: quantity == 0 ? 
              Colors.grey 
              : 
              const Color(0xFF00B737),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            quantity == 0 ? null :
            token.isNotEmpty ? 
              await cartBackend.putIncrement(widget.currentProduct.id, ref).then(
                (updateCart) { 
                  ref.read(cartBadgesProvider.notifier).state = updateCart.length;
                  ref.read(cartProvider.notifier).state = updateCart;
                }
              )
              : 
              GlobalScaffoldMessenger.instance.showSnackBar(
                'Вы не авторизованы!', 
                'error',
              );
            setState(() {
              loading = false;
            });
          }, 
          child: Text(
            'в корзину', 
            style: whiteText(16),
          )
        );
      }
    );
  }

  // поле ввода количества !только для большого экрана
  Widget productQuatityFieldSmall(){
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
          focusNode: _focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: _quantityController,
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

  // карточка продукта
  Future showProductCard(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return AlertDialog(
          shape: isSmallScreen ? const 
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ) 
            : 
            null,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(0),
          actionsPadding: const EdgeInsets.symmetric(
            vertical: 5, 
            horizontal: 0
          ),
          content: ProductCard(
            product: widget.currentProduct, 
            cartController: cartController(isSmallScreen),
          ),
        );
      },
    );
  }

  // занавес загрузки
  Widget loadingCurtain() {
    if (!loading) {
      return const SizedBox.shrink();
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 3,
            color: Colors.transparent,
          ),
          color: Colors.white70,
        ),
        child: Center(
          child: SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              color: Colors.green.shade900, 
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
  }

}