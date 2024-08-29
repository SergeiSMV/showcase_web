
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';

// поле ввода количества !только для маленького экрана
productQuatityFieldLarge(BuildContext mainContext, TextEditingController controller, String name){
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
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Align(alignment: Alignment.centerLeft, child: Text(name, style: black54(18, FontWeight.bold),)),
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
                  Navigator.pop(context);
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