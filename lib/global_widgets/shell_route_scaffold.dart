
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu.dart';



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
            final isSmallScreen = MediaQuery.of(context).size.width < 600;
            return Scaffold(
              key: _key,
              backgroundColor: Colors.white,
              appBar: isSmallScreen
                ? AppBar(
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
              body: Row(
                children: [
                  if (!isSmallScreen) const Menu(),
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