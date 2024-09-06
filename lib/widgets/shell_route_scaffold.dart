// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showcase_web/constants/fonts.dart';
import 'package:showcase_web/riverpod/menu_index_provider.dart';
// ignore: unused_import
import 'dart:html' as html;

import '../constants/menu_list.dart';
import '../data/models/category_model/category_model.dart';
import '../data/repositories/hive_implements.dart';
import '../riverpod/cart_provider.dart';
import '../riverpod/categories_menu_provider.dart';
import '../riverpod/categories_provider.dart';
import '../riverpod/token_provider.dart';
import 'go_router.dart';



class ShellRouteScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const ShellRouteScaffold({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShellRouteScaffoldState();
}

class _ShellRouteScaffoldState extends ConsumerState<ShellRouteScaffold> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    indexUpdate();
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Consumer(
          builder: (context, ref, child) {
            
            final String token = ref.watch(tokenProvider);
            final menuIndex = ref.watch(menuIndexProvider);
          
            return Container(
              color: Colors.green.shade100,
              height: MediaQuery.sizeOf(context).height,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: shellAppBar(isSmallScreen, menuIndex, token),
                drawer: shellDrawer(menuIndex, token),
                body: widget.child,
              ),
            );
          }
        );
      }
    );
  }

  AppBar shellAppBar(bool isSmallScreen, int menuIndex, String token) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.green.shade300,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          !isSmallScreen ? const SizedBox.shrink() :
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, size: 30, color: Colors.white,),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }
          ),
          InkWell(
            onTap: (){},
            child: Image.asset('lib/images/name.png', scale: 4, color: Colors.white,)
          ),
          isSmallScreen ? Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(menuList[menuIndex], style: whiteText(18, FontWeight.w300),),
          ) : const SizedBox.shrink(),
          const SizedBox(width: 30,),
          isSmallScreen ? const SizedBox.shrink() :
          Expanded(
            child: SizedBox(
              height: 25,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: menuList.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: menuIndex == index ? Colors.purple : Colors.transparent,
                    ),
                      width: 90,
                      child: Center(
                        child: InkWell(
                        onTap: (){
                          switchNavigate(index, token);
                        },
                        child: Text(
                          menuList[index].isEmpty? 
                            token.isEmpty ? 'войти' : 'выйти' 
                            :
                            menuList[index], 
                          style: whiteText(16, FontWeight.w300),
                        )
                      ),
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer shellDrawer(int menuIndex, String token) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Image.asset('lib/images/name.png', scale: 4, color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: menuList.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: menuIndex == index ? Colors.green.shade300 : Colors.transparent,
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: (){
                                switchNavigate(index, token);
                                Navigator.pop(context);
                              },
                              child: Text(
                                menuList[index].isEmpty? 
                                  token.isEmpty ? 'войти' : 'выйти' 
                                  :
                                  menuList[index], 
                                style: menuIndex == index ? whiteText(16) : black54(16),
                              )
                            )
                          )
                        )
                      )
                    ),
                  );
                }
              ),
            ),
          ],
      )
    );
  }

  void switchNavigate(int index, String token){
    switch (index) {
      case 0:
        ref.read(menuIndexProvider.notifier).state = index;
        GoRouter.of(context).go('/');
        break;
      case 1:
        ref.read(menuIndexProvider.notifier).state = index;
        List allCategories = ref.read(categoriesProvider);
        CategoryModel category = CategoryModel(categories: allCategories[0]);
        ref.read(selectedMainCategoryProvider.notifier).toggle(category.id);
        GoRouter.of(context).go('/products/${category.id}');
        break;
      case 2:
        ref.read(menuIndexProvider.notifier).state = index;
        GoRouter.of(context).go('/cart');
        break;
      case 3:
        ref.read(menuIndexProvider.notifier).state = index;
        GoRouter.of(context).go('/account');
        break;
      case 4:
        if(token.isEmpty){
          ref.read(menuIndexProvider.notifier).state = index;
          GoRouter.of(context).go('/auth');
        } else {
          exitApp();
        }
        break;
    }
  }

  void exitApp() async {
    ref.read(tokenProvider.notifier).state = '';
    ref.read(cartBadgesProvider.notifier).state = 0;
    ref.read(cartProvider.notifier).state = [];
    await HiveImplements().saveToken('');
  }

  void indexUpdate(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = router.routerDelegate.currentConfiguration.last.route.path;
      switch (route) {
        case '/':
          ref.read(menuIndexProvider.notifier).state = 0;
          break;
        case '/products/:categoryId':
          ref.read(menuIndexProvider.notifier).state = 1;
          break;
        case '/cart':
          ref.read(menuIndexProvider.notifier).state = 2;
          break;
        case '/account':
          ref.read(menuIndexProvider.notifier).state = 3;
          break;
      }
    });
  }

}















// _old

/*
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
                                      Text('вход', style: whiteText(16),)
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
                                      Text('выход', style: whiteText(16),)
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
*/