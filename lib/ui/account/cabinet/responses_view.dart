
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';

import '../../../data/models/response_model/response_model.dart';
import '../../../riverpod/response_provider.dart';
import '../../../widgets/loading.dart';


class ResponsesView extends ConsumerStatefulWidget {
  const ResponsesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RequestsViewState();
}

class _RequestsViewState extends ConsumerState<ResponsesView> with SingleTickerProviderStateMixin {

  late AnimationController _requestController;
  late Animation<double> _requestIconTurns;
  late Animation<double> _requestsHeightFactor;
  bool _requestsIsExpanded = false;

  @override
  void initState() {
    super.initState();
    _requestController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _requestIconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_requestController);
    _requestsHeightFactor = _requestController.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }

  void requestsHandleTap() {
    setState(() {
      _requestsIsExpanded = !_requestsIsExpanded;
      if (_requestsIsExpanded) {
        _requestController.forward();
      } else {
        _requestController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: requestsHandleTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.5),
                  Colors.white
                ]
              )
            ),
            child: Row(
              children: [
                Icon(MdiIcons.packageVariantClosed, size: 20, color: Colors.white,),
                const SizedBox(width: 5,),
                Text('мои отгрузки', style: whiteText(16),),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: RotationTransition(
                    turns: _requestIconTurns,
                    child: const Icon(Icons.expand_more, size: 30,),
                  ),
                )
              ],
            )
          ),
        ),
        AnimatedBuilder(
          animation: _requestController, 
          builder: (BuildContext context, Widget? child) {
            return ClipRect(
              child: Align(
                heightFactor: _requestsHeightFactor.value,
                child: child,
              ),
            );
          },
          child: responsesViews()
        ),
      ],
    );
  }

  Widget responsesViews() {
    return Consumer(
      builder: (context, ref, child){
        return ref.watch(baseResponsesProvider).when(
          loading: () => const Loading(),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (_){
            var allResponses = ref.watch(responsesProvider);
            allResponses.isEmpty ? null : allResponses = allResponses.reversed.toList();
            return allResponses.isEmpty ? Container() :
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: allResponses.length,
                itemBuilder: (BuildContext context, int index){
                  ResponseModel response = ResponseModel(response: allResponses[index]);
                  return InkWell(
                    onTap: (){
                      GoRouter.of(context).push(
                        '/response_detail',
                        extra: {
                          'response': response,
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 3,
                            color: Colors.transparent,
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(MdiIcons.packageVariantClosed, size: 18, color: Colors.grey,),
                                const SizedBox(width: 5),
                                Expanded(child: Text('${response.responseID} от ${response.updated}', style: black54(18, FontWeight.normal), overflow: TextOverflow.clip,)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(MdiIcons.clipboardText, size: 18, color: Colors.grey,),
                                const SizedBox(width: 5),
                                Expanded(child: Text('${response.requestID} от ${response.created}', style: black54(14, FontWeight.normal), overflow: TextOverflow.clip,)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(MdiIcons.truckFast, size: 18, color: Colors.grey,),
                                const SizedBox(width: 5),
                                Text(response.shipAddress, style: black54(16, FontWeight.normal), overflow: TextOverflow.clip,),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Text('товаров: ${response.products}', style: black54(16, FontWeight.normal), overflow: TextOverflow.clip,),
                            Text('сумма: ${response.total}₽', style: black54(16, FontWeight.w500), overflow: TextOverflow.clip,),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              ),
            );
          },  
        );
      },
    );
  }
}