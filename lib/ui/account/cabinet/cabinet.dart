
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../constants/fonts.dart';
import 'requests_view.dart';
import 'responses_view.dart';

class Cabinet extends ConsumerStatefulWidget {
  const Cabinet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CabinetState();
}

class _CabinetState extends ConsumerState<Cabinet> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 600,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const SizedBox(height: 10,),
                header(),
                const SizedBox(height: 15,),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: const [
                      ResponsesView(),
                      SizedBox(height: 5,),
                      RequestsView(),
                      SizedBox(height: 5,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header(){
    return Align(
      alignment: Alignment.centerLeft, 
      child: Row(
        children: [
          Expanded(child: Text('Клиент', style: black54(30, FontWeight.bold), overflow: TextOverflow.clip,)),
          InkWell(
            onTap: (){
              GoRouter.of(context).push('/addresses');
            },
            child: Column(
              children: [
                Icon(MdiIcons.mapMarker, size: 25, color: Colors.black54,),
                Align(alignment: Alignment.bottomCenter, child: Text('адреса', style: black54(12),))
              ],
            ),
          ),
          const SizedBox(width: 10,),
        ],
      )
    );
  }


}