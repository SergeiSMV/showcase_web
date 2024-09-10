
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../constants/fonts.dart';
import '../../../widgets/scaffold_messenger.dart';

Future<bool?> addressAdd(BuildContext context, TextEditingController controller) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        width: 600,
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.white,
          content: SizedBox(
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40,),
                Align(
                  alignment: Alignment.center, 
                  child: Text('введите новый адрес', style: black54(18, FontWeight.bold),)
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.transparent
                      ),
                      color: Colors.white,
                    ),
                    height: 45,
                    width: 400,
                    child: TextField(
                      autofocus: true,
                      controller: controller,
                      style: black54(18),
                      minLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black54, width: 2.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintStyle: grey(18),
                        hintText: 'новый адрес',
                        prefixIcon: Icon(MdiIcons.map, color: Colors.grey,),
                        isCollapsed: true
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () { Navigator.of(context).pop(false); },
              child: Text('отмена', style: black54(18),),
            ),
            TextButton(
              onPressed: () { 
                if (controller.text.isEmpty) {
                  GlobalScaffoldMessenger.instance.showSnackBar("Вы не указали новый адрес!", 'error');
                } else {
                  Navigator.of(context).pop(true);
                }
              },
              child: Text('добавить', style: black54(18),),
            ),
          ],
        ),
      );
    },
  );
}