
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/fonts.dart';
import '../../global_widgets/scaffold_messenger.dart';

class Registration extends ConsumerStatefulWidget {
  const Registration({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegistrationState();
}

class _RegistrationState extends ConsumerState<Registration> {

  TextEditingController innController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  // final BackendImplements backend = BackendImplements();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    innController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        barrierColor: Colors.white.withOpacity(0.7),
        padding: const EdgeInsets.all(20.0),
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('lib/images/logo_full.png', scale: 4),
                    Text('заявка на регистрацию', style: green(16),),
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
                        keyboardType: TextInputType.number,
                        controller: innController,
                        style: black(18),
                        minLines: 1,
                        obscureText: false,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintStyle: grey(16),
                          hintText: 'ИНН организации',
                          prefixIcon: Icon(MdiIcons.passportBiometric, color: Colors.black,),
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
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        style: black(18),
                        minLines: 1,
                        obscureText: false,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintStyle: grey(16),
                          hintText: 'телефон',
                          prefixIcon: SizedBox(width: 30, height: 30, child: Center(child: Text('+7', style: black(18),))),
                          isCollapsed: true
                        ),
                        onChanged: (_){ },
                        onSubmitted: (_) { },
                      ),
                    ),
                    const SizedBox(height: 30,),
                    SizedBox(
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
                          if(innController.text.isEmpty || phoneController.text.isEmpty){
                            GlobalScaffoldMessenger.instance.showSnackBar("Заполнены не все поля!", 'error');
                          } else {
                            FocusScope.of(context).unfocus();
                            final progress = ProgressHUD.of(context);
                            progress?.showWithText('отправляем');
                            // await BackendImplements().register(innController.text, phoneController.text).then((_){
                            //   progress?.dismiss();
                            //   GoRouter.of(context).pop();
                            // });
                          }
                        }, 
                        child: Text('подать заявку', style: whiteText(16),)
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      );
  }
}