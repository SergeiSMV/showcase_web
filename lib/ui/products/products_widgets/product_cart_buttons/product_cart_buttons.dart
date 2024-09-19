
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../constants/fonts.dart';
import '../../../../data/models/product_model/product_model.dart';
import '../../../../data/repositories/cart_implements.dart';
import '../../../../riverpod/cart_provider.dart';
import '../../../../riverpod/token_provider.dart';
import '../../../../widgets/scaffold_messenger.dart';
import 'product_quantity_field_large.dart';
import 'product_quantity_field_small.dart';



class ProductCartButtons extends ConsumerStatefulWidget {
  final ProductModel product;
  const ProductCartButtons({super.key, required this.product});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductCartButtonsState();
}

class _ProductCartButtonsState extends ConsumerState<ProductCartButtons> {
  final CartImplements cartBackend = CartImplements();
  final ValueNotifier<bool> loadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<int> cartQuantity = ValueNotifier<int>(0);
  final TextEditingController _quantityController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState(){
    super.initState();
    _focusNode = FocusNode();
    focusListener(_focusNode);
  }

  @override
  void dispose(){
    _quantityController.dispose();
    _focusNode.dispose();
    loadingNotifier.dispose();
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
          cartBackend.putExact(widget.product.id, exact, ref).then(
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

  // получаем количество продукта в корзине
  bool checkProductInCart(List cart, int productID){
    bool inCart = false;
    for (var product in cart) {
      if (product['product_id'] == productID) {
        inCart = true;
        break;
      }
    }
    return inCart;
  }

  // получаем информацию о продукте в корзине
  int productQuantityInCart(List cart){
    int quantity = 0;
    for (var product in cart) {
      if (product['product_id'] == widget.product.id) {
        quantity = product['quantity'];
        break;
      }
    }
    return quantity;
  }

  // обновляем _quantityController
  void updateController(List cart){
    for (var product in cart) {
      if (product['product_id'] == widget.product.id && !_focusNode.hasFocus) {
        if(cartQuantity.value != product['quantity']){
          cartQuantity.value = product['quantity'];
          _quantityController.text = cartQuantity.value.toString();
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Consumer(
          builder: (context, ref, child) {
            String token = ref.watch(tokenProvider);
            final cart = ref.watch(cartProvider);
            updateController(cart);
            bool productInCart = checkProductInCart(cart, widget.product.id);
            return ValueListenableBuilder<bool>(
              valueListenable: loadingNotifier,
              builder: (context, loading, child) {
                return Stack(
                  children: [
                    productInCart ?
                    // управление количеством в корзине
                    cartManager(loading, cart, isSmallScreen) :
                    // кнопка "в козину"
                    addInCartButton(loading, token),
                    // загрузка
                    Center(child: loadingCurtain(loading))         
                  ],
                );
              }
            );
          }
        );
      }
    );
  }

  // управление количеством в корзине
  Widget cartManager(bool loading, List<dynamic> cart, bool isSmallScreen) {
    return Center(
      child: SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            quantityControlButton('minus', loading, cart),
            Expanded(
              child: InkWell(
                onTap: () => isSmallScreen ? 
                  productQuatityFieldSmall(context, _quantityController, widget.product, ref) : null,
                child: SizedBox(
                  height: 30,
                  child: Center(
                    child: isSmallScreen ? 
                      ValueListenableBuilder<int>(
                        valueListenable: cartQuantity,
                        builder: (context, quantity, child) {
                          return Text(
                            loading ? '' : quantity.toString(), 
                            style: black(18),
                          );
                        }
                      ) 
                      : 
                      loading ? const Text('') : productQuatityFieldLarge(_focusNode, _quantityController),
                  ),
                ),
              )
            ),
            quantityControlButton('plus', loading)
          ],
        ),
      ),
    );
  }

  // загрузка
  Widget loadingCurtain(bool loading) {
    if (loading) {
      return Container(
      height: 30,
      width: double.infinity,
      color: Colors.white60,
      child: Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.green.shade900, 
            strokeWidth: 2,
          ),
        ),
      ),
    );
    } else {
      return const SizedBox.shrink();
    }
  }

  // кнопка "в козину"
  SizedBox addInCartButton(bool loading, String token) {
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.product.quantity == 0 || loading ? 
            Colors.grey 
            : 
            const Color(0xFF00B737),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          if (widget.product.quantity != 0) {
            loadingNotifier.value = !loadingNotifier.value;
            if (token.isNotEmpty) {
              await cartBackend.putIncrement(widget.product.id, ref).then(
                (updateCart) { 
                  ref.read(cartBadgesProvider.notifier).state = updateCart.length;
                  ref.read(cartProvider.notifier).state = updateCart;
                  loadingNotifier.value = !loadingNotifier.value;
                  // initQuantity();
                }
              );
            } else {
              GlobalScaffoldMessenger.instance.showSnackBar('Вы не авторизованы!', 'error',);
              loadingNotifier.value = !loadingNotifier.value;
            }
          } else {
            null;
          }
        }, 
        child: Text(
          loading ? '' : 'в корзину', 
          style: whiteText(16),
        )
      ),
    );
  }

  // кнопки + и -
  Widget quantityControlButton(String operation, bool loading, [List<dynamic> cart = const []]) {
    return SizedBox(
      width: 40,
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 3.0, 
            vertical: 3.0
          ),
          backgroundColor: loading ? Colors.grey : Colors.amber,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: operation == 'plus' ? 
              const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)) 
              :
              const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
        ),
        onPressed: () async { 
          loadingNotifier.value = !loadingNotifier.value;
          operation == 'plus' ? 
          await cartBackend.putIncrement(widget.product.id, ref).then(
            (updateCart) { 
              ref.read(cartBadgesProvider.notifier).state = updateCart.length;
              ref.read(cartProvider.notifier).state = updateCart;
              loadingNotifier.value = !loadingNotifier.value;
              // initQuantity();
            }
          )
          : 
          await cartBackend.putDecrement(widget.product.id, productQuantityInCart(cart), ref).then(
            (updateCart) { 
              ref.read(cartBadgesProvider.notifier).state = updateCart.length;
              ref.read(cartProvider.notifier).state = updateCart;
              loadingNotifier.value = !loadingNotifier.value;
              // initQuantity();
            }
          );
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

}