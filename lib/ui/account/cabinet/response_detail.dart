
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';
import 'package:showcase_web/data/repositories/cart_implements.dart';

import '../../../constants/other.dart';
import '../../../data/models/response_model/response_model.dart';
import '../../../data/models/response_product_model/response_product_model.dart';
import '../../../riverpod/cart_provider.dart';
import '../../../widgets/scaffold_messenger.dart';



class ResponseDetail extends ConsumerStatefulWidget {
  final ResponseModel response;
  const ResponseDetail({super.key, required this.response});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResponseDetailsState();
}

class _ResponseDetailsState extends ConsumerState<ResponseDetail> {

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      barrierColor: Colors.white.withOpacity(0.7),
      padding: const EdgeInsets.all(20.0),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  width: 600,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              height: 70,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.withOpacity(0.5),
                                    Colors.white
                                  ]
                                )
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('отгрузка ${widget.response.responseID} от ${widget.response.updated}', style: black54(18, FontWeight.normal),),
                                  const SizedBox(height: 3,),
                                  Text('к заявке: ${widget.response.requestID} от ${widget.response.created}', style: black54(14, FontWeight.normal), overflow: TextOverflow.clip,),
                                  const SizedBox(height: 3,),
                                  Text('доставка: ${widget.response.shipAddress}', style: black54(14, FontWeight.normal), overflow: TextOverflow.clip,),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height:  
                              MediaQuery.sizeOf(context).height - 70 - 90 - appBarHeight < 0 ? 0 : 
                              MediaQuery.sizeOf(context).height - 70 - 90 - appBarHeight,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.response.productsDetails.length,
                              itemBuilder: (BuildContext context, int index){
                                ResponseProductModel product = ResponseProductModel(product: widget.response.productsDetails[index]);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      product.comment == null && product.replaceName == null && product.replaceQuantity == null ? 
                                        const SizedBox.shrink() :
                                        InkWell(
                                          onTap: (){
                                            changeDetails(context, widget.response, product);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(
                                                width: 3,
                                                color: Colors.transparent,
                                              ),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Colors.amber,
                                                  Colors.white
                                                ]
                                              )
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(MdiIcons.commentAlert, size: 18, color: Colors.black,),
                                                const SizedBox(width: 10,),
                                                Text('доп. информация', style: black54(16, FontWeight.w500), overflow: TextOverflow.clip,),
                                              ],
                                            ),
                                          ),
                                        ),
                                      product.comment == null && product.replaceName == null && product.replaceQuantity == null ? 
                                        const SizedBox.shrink() : const SizedBox(height: 5,),
                                      Text(product.name, style: black54(16, FontWeight.w500), overflow: TextOverflow.clip,),
                                      const SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Icon(MdiIcons.bookmark, size: 18, color: Colors.grey,),
                                          const SizedBox(width: 10,),
                                          Text('${product.price}₽', style: black(16)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(MdiIcons.packageVariantClosed, size: 18, color: Colors.grey,),
                                          const SizedBox(width: 10,),
                                          Text('${product.quantity}', style: black(16)),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Text('итого: ${product.total}₽', style: black(16, FontWeight.w500), overflow: TextOverflow.clip,),
                                      const Divider(),
                                    ],
                                  ),
                                );
                              }
                            ),
                          ),


                          Center(
                            child: SizedBox(
                              width: 600,
                              height: 90, // Жестко заданная высота
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    totalPrice(widget.response.productsDetails),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () async { 
                                            Map data;
                                            final cart = ref.read(cartProvider);
                                            final progress = ProgressHUD.of(context);
                                            progress?.showWithText('повторяем');
                                            if (cart.isEmpty){
                                              data = {
                                                "clean_cart": false,
                                                "response_id": widget.response.responseID.toString()
                                              };
                                              await CartImplements().repeatOrder(data, ref).then((_){
                                                progress?.dismiss();
                                              });
                                            } else {
                                              await combine(context).then((result) async {
                                                result == null ? 
                                                {
                                                  progress?.dismiss(),
                                                  GlobalScaffoldMessenger.instance.showSnackBar("Товары не были добавлены в корзину!", 'error')
                                                } :
                                                {
                                                  data = {
                                                    "clean_cart": result,
                                                    "response_id": widget.response.responseID.toString()
                                                  },
                                                  await CartImplements().repeatOrder(data, ref).then((_){
                                                    progress?.dismiss();
                                                  })
                                                };
                                              });
                                            }
                                          }, 
                                          child: Text('повторить заказ', style: whiteText(16),)
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          
                        ],
                      ),
                    ),
                  ),
                ),
              ), 
            ),
          );
        }
      ),
    );
  }


  Widget totalPrice(List ordersProduct){
    int sum = 0;
    for (var product in ordersProduct) {
      int productTotal = (product['total'] * 100).round();
      sum += productTotal;
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text('итого: ${sum / 100} ₽', style: black54(24, FontWeight.w500),),
      ),
    );
  }


  Future changeDetails(BuildContext context, ResponseModel response, ResponseProductModel product) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          actionsPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('доп. информация к отгрузке ${response.responseID} от ${response.updated}', style: black54(18),),
              const SizedBox(height: 3,),
              Text('позиция: ${product.name}', style: black54(16),),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              product.replaceName == null ? const SizedBox.shrink() :
              Row(
                children: [
                  Icon(MdiIcons.arrowURightBottom, size: 30, color: Colors.green,),
                  Expanded(
                    child: Column(
                      children: [
                        Text(product.replaceName!, style: grey(16), overflow: TextOverflow.clip,),
                        const SizedBox(height: 3,),
                        Text(product.name, style: black54(16), overflow: TextOverflow.clip,),
                      ],
                    ),
                  )
                ],
              ),
              product.replaceQuantity == null ? const SizedBox.shrink() :
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Icon(MdiIcons.arrowURightBottom, size: 30, color: Colors.green,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${product.replaceQuantity!.toString()} шт.', style: grey(16), overflow: TextOverflow.clip,),
                          const SizedBox(height: 3,),
                          Text('${product.quantity.toString()} шт.', style: black54(16), overflow: TextOverflow.clip,),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              product.comment == null ? const SizedBox.shrink() :
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(alignment: Alignment.centerLeft, child: Text('комментарий:\n${product.comment!}', maxLines: 5, style: black54(16), overflow: TextOverflow.clip,)),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () { Navigator.of(context).pop(); },
              child: Text('понятно', style: black(18),),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> combine(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          actionsPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          title: Text('В корзине есть товары!', style: black54(18),),
          content: Text('Вы хотите очистить корзину или добавить к имеющимся товарам?', style: black(16),),
          actions: [
            TextButton(
              onPressed: () { Navigator.of(context).pop(true); },
              child: Text('очистить', style: black(18),),
            ),
            TextButton(
              onPressed: () { Navigator.of(context).pop(false); },
              child: Text('добавить', style: black(18),),
            ),
          ],
        );
      },
    );
  }

}