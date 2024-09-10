
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';

import '../../../../data/repositories/cart_implements.dart';
import '../../../../riverpod/cart_provider.dart';
import '../../../../widgets/scaffold_messenger.dart';
import '../../data/models/cart_model/cart_model.dart';

// поле ввода количества !только для маленького экрана
Future cartQuatityFieldSmall(BuildContext mainContext, TextEditingController controller, CartModel currentProduct, WidgetRef ref){
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: mainContext, 
    builder: (context){
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Align(alignment: Alignment.center, child: Text(currentProduct.name, style: black54(16, FontWeight.bold),)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.transparent
                  ),
                  color: Colors.white,
                ),
                height: 45,
                width: 300,
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: controller,
                  style: black54(20),
                  minLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintStyle: grey(16),
                    hintText: 'укажите количество',
                    prefixIcon: Icon(MdiIcons.calculator, color: Colors.black,),
                    isCollapsed: true
                  ),
                ),
              ),
            ),
  
            const SizedBox(height: 20,),
  
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async { 
                  int exact;
                  final CartImplements cartBackend = CartImplements();
                  try {
                    exact = controller.text.isEmpty ? 0 : int.parse(controller.text);
                    if (exact < 0) {
                      GlobalScaffoldMessenger.instance.showSnackBar("Значение не может быть отрицательным!", 'error');
                    } else {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      final updateCart = await cartBackend.putExact(currentProduct.id, exact, ref);
                      ref.read(cartBadgesProvider.notifier).state = updateCart.length;
                      ref.read(cartProvider.notifier).state = updateCart;
                    }
                  } catch (_) {
                    GlobalScaffoldMessenger.instance.showSnackBar("Не верный формат количества!", 'error');
                  }
                  
                }, 
                child: Text('подтвердить', style: black54(16),)
              ),
            ),
      
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const SizedBox(height: 30),
            ),
          ],
        ),
      );
    }
  );
}