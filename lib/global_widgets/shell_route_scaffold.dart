
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';

import '../riverpod/categories_menu_provider.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Builder(
          builder: (context) {
            // ignore: unused_local_variable
            final isSmallScreen = MediaQuery.of(context).size.width < 600;
            final String token = ref.watch(tokenProvider);
            bool isExpanded = ref.watch(categoriesMenuProvider);
            return Scaffold(
              key: _key,
              backgroundColor: Colors.white,

              appBar: AppBar(
                toolbarHeight: 80,
                backgroundColor: Colors.green,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Image.asset('lib/images/name.png', scale: 4, color: Colors.white,),
                    const SizedBox(width: 20,),
                    InkWell(
                      onTap: (){
                        ref.read(categoriesMenuProvider.notifier).toggle();
                        ref.read(subCategoryMenuProvider.notifier).close();
                        ref.read(selectedIndexCategoryProvider.notifier).toggle(-1);
                        ref.read(categoryPathProvider.notifier).clear();
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
                          onTap: (){},
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
                          onTap: (){},
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
              /*
              appBar: isSmallScreen
                ? AppBar(
                    surfaceTintColor: Colors.white,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: () {
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu, color: Colors.green,),
                    ),
                  )
                : null,
              drawer: const Menu(),
              */
              body: 
              
              /*
              Stack(
                children: [
                  widget.child,
                  // if(isExpanded)
                  //   Container(
                  //     width: double.infinity,
                  //     height: double.infinity,
                  //     color: Colors.black26,
                  //   ),
                  const CategoriesMenu(),
                ],
              )
              */

              Row(
                children: [
                  const CategoriesMenu(),
                  Expanded(child: widget.child)
                ],
              ),
            );
          }
        );
      }
    );
  }


  


}