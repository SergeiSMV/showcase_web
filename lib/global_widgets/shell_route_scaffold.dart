
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidebarx/sidebarx.dart';



class ShellRouteScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const ShellRouteScaffold({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShellRouteScaffoldState();
}

class _ShellRouteScaffoldState extends ConsumerState<ShellRouteScaffold> with SingleTickerProviderStateMixin {

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
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
            final isSmallScreen = MediaQuery.of(context).size.width < 600;
            return Scaffold(
              key: _key,
              backgroundColor: Colors.white,
              appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: Colors.white,
                    // title: Text(_getTitleByIndex(_controller.selectedIndex)),
                    leading: IconButton(
                      onPressed: () {
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu, color: Colors.green,),
                    ),
                  )
                : null,
              drawer: ExampleSidebarX(controller: _controller),
              body: Row(
                children: [
                  if (!isSmallScreen) ExampleSidebarX(controller: _controller),
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

/*
String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Search';
    case 2:
      return 'People';
    case 3:
      return 'Favorites';
    case 4:
      return 'Custom iconWidget';
    case 5:
      return 'Profile';
    case 6:
      return 'Settings';
    default:
      return 'Not found page';
  }
}
*/

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({super.key, required SidebarXController controller,}) : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        width: 60,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 2),
            ),
            // BoxShadow(
            //   color: Colors.black.withOpacity(0.5),
            //   blurRadius: 3,
            // )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.5),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),

      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.green,
        ),
      ),

      footerDivider: divider,

      headerBuilder: (context, extended) {
        return const SizedBox(
          height: 20,
          // child: Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Image.asset('assets/images/avatar.png'),
          // ),
        );
      },

      items: [
        SidebarXItem(
          icon: MdiIcons.home,
          label: 'главная',
          onTap: (){},
        ),
        SidebarXItem(
          icon: MdiIcons.clipboardText,
          label: 'товары',
          onTap: (){},
        ),
        SidebarXItem(
          icon: Icons.search,
          label: 'поиск',
          onTap: (){},
        ),
        SidebarXItem(
          icon: MdiIcons.cart,
          label: 'корзина',
          onTap: (){},
        ),
        SidebarXItem(
          icon: MdiIcons.truckFast,
          label: 'отгрузки',
          onTap: (){},
        ),
        SidebarXItem(
          icon: MdiIcons.packageVariantClosed,
          label: 'заказы',
          onTap: (){},
        ),
      ],
    );
  }
}