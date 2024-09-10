
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';

import '../../../data/models/request_model/request_model.dart';
import '../../../riverpod/requests_provider.dart';
import '../../../widgets/loading.dart';


class RequestsView extends ConsumerStatefulWidget {
  const RequestsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RequestsViewState();
}

class _RequestsViewState extends ConsumerState<RequestsView> with SingleTickerProviderStateMixin {

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
                Icon(MdiIcons.clipboardText, size: 20, color: Colors.white,),
                const SizedBox(width: 5,),
                Text('мои заказы', style: whiteText(16),),
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
          child: requestsViews()
        ),
      ],
    );
  }

  Widget requestsViews() {
    return Consumer(
      builder: (context, ref, child){
        return ref.watch(baseRequestsProvider).when(
          loading: () => const Loading(),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (_){
            var allRequests = ref.watch(requestsProvider);
            allRequests.isEmpty ? null : allRequests = allRequests.reversed.toList();
            return allRequests.isEmpty ? Container() :
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: allRequests.length,
                itemBuilder: (BuildContext context, int index){
                  RequestModel request = RequestModel(request: allRequests[index]);
                  return InkWell(
                    onTap: (){
                      // requestDetail(context, request);
                      GoRouter.of(context).push(
                        '/request_detail',
                        extra: {
                          'request': request,
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
                                Icon(MdiIcons.clipboardText, size: 18, color: Colors.grey,),
                                const SizedBox(width: 5),
                                Expanded(child: Text('${request.id} от ${request.created}', style: black54(18, FontWeight.normal), overflow: TextOverflow.clip,)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(MdiIcons.truckFast, size: 18, color: Colors.grey,),
                                const SizedBox(width: 5),
                                Text(request.shipAddress, style: black54(16, FontWeight.normal), overflow: TextOverflow.clip,),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Text('товаров: ${request.products}', style: black54(16, FontWeight.normal), overflow: TextOverflow.clip,),
                            Text('сумма: ${request.total}₽', style: black54(16, FontWeight.w500), overflow: TextOverflow.clip,),
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