
// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:showcase_web/data/repositories/hive_implements.dart';
import 'dart:html' as html;

import '../constants/fonts.dart';
import '../data/repositories/auth_implements.dart';
import '../riverpod/cart_provider.dart';
import '../riverpod/token_provider.dart';

class Auth extends ConsumerStatefulWidget {
  const Auth({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthState();
}

class _AuthState extends ConsumerState<Auth> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final HiveImplements hive = HiveImplements();
  final AuthImplements auth = AuthImplements();

  @override
  void initState(){
    super.initState();
    _loginController.text = 'client1';
    _passController.text = 'DerParol';
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedIndexProvider.notifier).state = 7;
    });
    */
  }

  @override
  void dispose(){
    _loginController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String token = ref.watch(tokenProvider);

    return token.isNotEmpty ? const Center(child: Text('Вы авторизованы'),) : ProgressHUD(
      barrierColor: Colors.white.withOpacity(0.7),
      padding: const EdgeInsets.all(20.0),
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('lib/images/logo_full.png', scale: 4),
                    Text('авторизация', style: green(16),),
                    const SizedBox(height: 20,),
                    Container(
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
                        controller: _loginController,
                        style: black54(18),
                        minLines: 1,
                        obscureText: false,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintStyle: grey(16),
                          hintText: 'id клиента',
                          prefixIcon: const Icon(Icons.person, color: Colors.black,),
                          isCollapsed: true
                        ),
                        onChanged: (_){ },
                        onSubmitted: (_) { },
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Container(
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
                        controller: _passController,
                        style: black54(18),
                        minLines: 1,
                        obscureText: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintStyle: grey(16),
                          hintText: 'пароль',
                          prefixIcon: const Icon(Icons.lock, color: Colors.black,),
                          isCollapsed: true
                        ),
                        onChanged: (_){ },
                        onSubmitted: (_) { },
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async { 
                            FocusScope.of(context).unfocus();
                            final progress = ProgressHUD.of(context);
                            progress?.showWithText('авторизуемся');
                            await auth.authorization(_loginController.text, _passController.text).then((token) async {
                              token.isNotEmpty ?
                              await hive.saveToken(token).then((_) {
                                ref.read(tokenProvider.notifier).state = token;
                                html.window.history.back();
                                return ref.refresh(baseCartsProvider);
                              }) : null;
                              progress?.dismiss();
                            });
                          }, 
                          child: Text('авторизоваться', style: whiteText(16),)
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        GoRouter.of(context).go('/auth/registration');
                      },
                      child: Text('Еще не зарегистрированы?\nПодайте заявку', style: blue(14), textAlign: TextAlign.center,),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}