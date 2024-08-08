
// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';
import 'dart:html' as html;

import '../data/repositories/hive_implements.dart';
import '../riverpod/cart_provider.dart';
import '../riverpod/categories_menu_provider.dart';
import '../riverpod/screen_width_provider.dart';
import '../riverpod/token_provider.dart';
import '../ui/categories_menu/categories_menu.dart';



class ShellRouteScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const ShellRouteScaffold({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShellRouteScaffoldState();
}

class _ShellRouteScaffoldState extends ConsumerState<ShellRouteScaffold> with SingleTickerProviderStateMixin {

  final _key = GlobalKey<ScaffoldState>();
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getScreenSize();
    });
  }

  @override
  void dispose(){
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  void getScreenSize() {
    final width = html.window.innerWidth;
    // ignore: unused_local_variable
    final height = html.window.innerHeight;
    ref.read(screenWidthProvider.notifier).setWidth(width!.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: Colors.purple,
      radius: const Radius.circular(20),
      thickness: 8,
      controller: _horizontalController,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _horizontalController,
        child: RawScrollbar(
          thumbColor: Colors.purple,
          radius: const Radius.circular(20),
          thickness: 8,
          controller: _verticalController,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: _verticalController,
            child: Consumer(
              builder: (context, ref, child) {
                // ignore: unused_local_variable
                final isSmallScreen = MediaQuery.of(context).size.width < 600;
                final String token = ref.watch(tokenProvider);
                bool isExpanded = ref.watch(categoryExpandedProvider);
                double screenWidth = ref.watch(screenWidthProvider);
        
                return Container(
                  color: Colors.blue.shade100,
                  width: screenWidth,
                  height: MediaQuery.sizeOf(context).height,
                  child:                
                  
                  
                  Scaffold(
                    key: _key,
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      toolbarHeight: 80,
                      backgroundColor: Colors.green,
                      automaticallyImplyLeading: false,
                      title: Row(
                        children: [
                          InkWell(
                            onTap: (){ GoRouter.of(context).go('/'); },
                            child: Image.asset('lib/images/name.png', scale: 4, color: Colors.white,)
                          ),
                          const SizedBox(width: 20,),
                          InkWell(
                            onTap: (){
                              ref.read(categoryExpandedProvider.notifier).toggle();
                              ref.read(subCategoryExpandedProvider.notifier).close();
                              // ref.read(selectedMainCategoryProvider.notifier).toggle(-1);
                              // ref.read(categoriesIdPathProvider.notifier).clear();
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return RotationTransition(
                                        turns: child.key == const ValueKey('menu') ? Tween<double>(begin: 0.5, end: 0).animate(animation) : Tween<double>(begin: 0.5, end: 1).animate(animation),
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: isExpanded
                                        ? const Icon(Icons.close, key: ValueKey('close'), color: Colors.white,)
                                        : const Icon(Icons.menu, key: ValueKey('menu'), color: Colors.white,),
                                  ),
                                  const SizedBox(width: 10,),
                                  Text('каталог', style: whiteText(16),)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      actions: [
                        
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: SizedBox(
                            child: token.isEmpty ? 
                              InkWell(
                                onTap: (){
                                  GoRouter.of(context).go('/auth');
                                },
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(MdiIcons.cardAccountDetails, color: Colors.white,),
                                      Text('вход', style: whiteText(14),)
                                    ],
                                  ),
                                ),
                              ) :
                              InkWell(
                                onTap: () async {
                                  ref.read(tokenProvider.notifier).state = '';
                                  ref.read(cartBadgesProvider.notifier).state = 0;
                                  ref.read(cartProvider.notifier).state = [];
                                  await HiveImplements().saveToken('');
                                },
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(MdiIcons.exitToApp, color: Colors.white,),
                                      Text('выход', style: whiteText(14),)
                                    ],
                                  ),
                                ),
                              ),
                          ),
                        )
                        
                      ],
                    ),
                    body: Row(
                      children: [
                        const CategoriesMenu(),
                        Expanded(child: widget.child)
                      ],
                    ),
                  ),
                  
                );
              }
            ),
          ),
        ),
      ),
    );
  }


  


}