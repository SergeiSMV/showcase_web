
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';

import '../../../data/repositories/address_implements.dart';
import '../../../riverpod/address_provider.dart';
import '../../../widgets/loading.dart';
import 'address_add.dart';
import 'confirm_address_delete.dart';

class Addresses extends ConsumerStatefulWidget {
  const Addresses({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShipsViewState();
}

class _ShipsViewState extends ConsumerState<Addresses> with SingleTickerProviderStateMixin {

  final AddressImplements address = AddressImplements();
  int selectedIndex = 0;
  TextEditingController newAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    newAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: 600,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10,),
                  header(),
                  const SizedBox(height: 20,),
                  Expanded(child: addressView())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget header(){
    return Align(
      alignment: Alignment.centerLeft, 
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          children: [
            Expanded(child: Text('Адреса', style: black54(30, FontWeight.bold), overflow: TextOverflow.clip,)),
            InkWell(
              onTap: () async {
                await addressAdd(context, newAddressController).then((result) async {
                  if (result == null || result == false) {
                    null;
                  } else {
                    await address.addClientAddress(newAddressController.text, ref).then((update){
                      ref.read(addressProvider.notifier).state = update.toList();
                      newAddressController.clear();
                    });
                  }
                });
              },
              child: Icon(MdiIcons.plus, size: 30,),
            ),
            const SizedBox(width: 8,),
          ],
        ),
      )
    );
  }


  Widget addressView(){
    return Consumer(
      builder: (context, ref, child){
        return ref.watch(getAddressProvider).when(
          loading: () => const Loading(),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (_){
            var allAddresses = ref.watch(addressProvider);
            return allAddresses.isEmpty ? SizedBox(height: 50, child: Center(child: Text('нет доступных адресов', style: black54(14),)),) :
            ListView.builder(
              shrinkWrap: true,
              itemCount: allAddresses.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      Checkbox(
                        value: selectedIndex == index,
                        onChanged: (bool? value) async {
                          await address.patchClientAddress(allAddresses[index]['ship_to_id'], false, true, ref).then((update){
                            ref.read(addressProvider.notifier).state = update.toList();
                          });
                        },
                        activeColor: Colors.green.withOpacity(0.5), // Цвет заливки, когда выбрано
                        checkColor: Colors.black, // Цвет галочки
                        side: WidgetStateBorderSide.resolveWith(
                          (state) {
                            if (state.contains(WidgetState.selected)) {
                              return const BorderSide(width: 1.0, color: Colors.transparent);
                            } else {
                              return const BorderSide(width: 2.0, color: Colors.grey);
                            }
                          }
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${allAddresses[index]['address']}', 
                          style: allAddresses[index]['is_default'] ? black54(16, FontWeight.w600) : black54(16), 
                          overflow: TextOverflow.clip,
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: IconButton(
                          onPressed: () async {
                            bool? confirmDelete = await confirmAddressDelete(context, allAddresses[index]['address']);
                            !confirmDelete! ? null :
                            await address.patchClientAddress(allAddresses[index]['ship_to_id'], true, false, ref).then((update){
                              ref.read(addressProvider.notifier).state = update.toList();
                            });
                          },
                          icon: Icon(MdiIcons.minusCircle, color: Colors.red, size: 20,)
                        ),
                      )
                    ],
                  ),
                );
              }
            );
          }
        );
      }
    );
  }

}