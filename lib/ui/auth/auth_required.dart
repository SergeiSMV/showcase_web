
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/fonts.dart';

Widget authRequired(BuildContext context){
  return Center(
    // alignment: Alignment.bottomCenter,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('lib/images/logo_full.png', scale: 4),
        const SizedBox(height: 20,),
        SizedBox(
          width: 300,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B737),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () { 
              GoRouter.of(context).go('/auth');
            }, 
            child: Text('авторизоваться', style: whiteText(16),)
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const SizedBox(height: 20,),
        ),
        InkWell(
          onTap: (){
            GoRouter.of(context).go('/registration');
          },
          child: Text('Еще не зарегистрированы?\nПодайте заявку', style: blue(14), textAlign: TextAlign.center,),
        )
      ],
    ),
  );
}