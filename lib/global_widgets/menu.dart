import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';
import 'package:showcase_web/data/repositories/usecase_implements.dart';

import '../riverpod/navigator_provider.dart';
import '../riverpod/token_provider.dart';

class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> with TickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _fadeController;
  late AnimationController _iconController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: -0.5).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void toggleContainer() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _fadeController.forward();
        });
        _iconController.forward();
      } else {
        _fadeController.reverse();
        _iconController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final String token = ref.watch(tokenProvider);

    return AnimatedContainer(
      margin: EdgeInsets.all(isExpanded ? 0 : 8),
      width: isExpanded ? 200.0 : 70.0,
      height: double.infinity,
      alignment: isExpanded ? Alignment.center : AlignmentDirectional.topCenter,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(isExpanded ? 0 : 20),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                  child: Image.asset('lib/images/name.png', scale: 3),
                ),
                Expanded(
                  child: Column(
                    children: [
                      menuElements('главная', 0, MdiIcons.home),
                      menuElements('товары', 1, MdiIcons.clipboardText),
                      menuElements('поиск', 2, Icons.search),
                      token.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 30,),
                      token.isEmpty ? const SizedBox.shrink() : Divider(
                        color: Colors.white.withOpacity(0.3),
                        height: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                      token.isEmpty ? const SizedBox.shrink() : menuElements('корзина', 3, MdiIcons.cart),
                      token.isEmpty ? const SizedBox.shrink() : menuElements('отгрузки', 4, MdiIcons.truckFast),
                      token.isEmpty ? const SizedBox.shrink() : menuElements('заказы', 5, MdiIcons.packageVariantClosed),
                      token.isEmpty ? const SizedBox.shrink() : menuElements('адреса', 6, MdiIcons.mapMarker),

                      const SizedBox(height: 30,),
                      Divider(
                        color: Colors.white.withOpacity(0.3),
                        height: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                      token.isEmpty ? menuElements('авторизация', 7, MdiIcons.cardAccountDetails) : menuElements('выход', 8, MdiIcons.exitToApp),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white.withOpacity(0.3),
                  height: 1,
                  indent: 5,
                  endIndent: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: toggleContainer,
                    child: RotationTransition(
                      turns: _iconTurns,
                      child: Icon(
                        MdiIcons.chevronRight,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuElements(String title, int elementIndex, IconData icon) {
    return Consumer(
      builder: (context, ref, child) {
        
        final int selectedIndex = ref.watch(selectedIndexProvider);

        return InkWell(
          onTap: (){ 
            UseCaseImplements().menuElementCases(elementIndex, ref, context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: selectedIndex == elementIndex ? Colors.purple.shade700 : Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: selectedIndex == elementIndex ? Colors.black.withOpacity(0.3) : Colors.transparent,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  isExpanded ? const SizedBox(width: 10,) : const SizedBox.shrink(),
                  Icon(icon, color: selectedIndex == elementIndex ? Colors.white : Colors.white.withOpacity(0.8),),
                  isExpanded ? const SizedBox(width: 15,) : const SizedBox.shrink(),
                  if (isExpanded)
                  Flexible(
                    fit: FlexFit.loose,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(title, style: whiteText(16),),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  // menuElementCases(int element) {
  //   switch (element) {
  //     case 0: // главная страница
  //       ref.read(lastIndexProvider.notifier).state = ref.read(menuIndexProvider);
  //       ref.read(menuIndexProvider.notifier).state = element; 
  //       GoRouter.of(context).push('/home');
  //       break;
  //     case 1: // товары
  //       ref.read(lastIndexProvider.notifier).state = ref.read(menuIndexProvider);
  //       ref.read(menuIndexProvider.notifier).state = element; 
  //       // GoRouter.of(context).push('/home');
  //       break;
  //     case 7: // авторизация
  //       ref.read(lastIndexProvider.notifier).state = ref.read(menuIndexProvider);
  //       ref.read(menuIndexProvider.notifier).state = element;
  //       GoRouter.of(context).pushReplacement('/auth');
  //       break;
  //     case 8: // выход
  //       UseCaseImplements().exitApp(ref);
  //       break;
  //   }
  // }

}
