
import 'package:flutter/material.dart';
import 'package:showcase_web/constants/fonts.dart';

Future<bool?> confirmAddressDelete(BuildContext context, String address) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(address, style: black54(18),),
        content: Text('Вы действительно хотите удалить адрес?', style: black54(16),),
        actions: [
          TextButton(
            onPressed: () { Navigator.of(context).pop(false); },
            child: Text('нет', style: black(18),),
          ),
          TextButton(
            onPressed: () { Navigator.of(context).pop(true); },
            child: Text('да', style: black(18),),
          ),
        ],
      );
    },
  );
}