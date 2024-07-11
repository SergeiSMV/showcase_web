
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onPopInvoked: (result){
      //   int lastIndex = ref.read(lastIndexProvider);
      //   int currenIndex = ref.read(menuIndexProvider);
      //   result ?
      //   lastIndex == currenIndex ? null : ref.read(menuIndexProvider.notifier).state = lastIndex : null;
      // },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Home Screen', style: black(18),)
        ),
      ),
    );
  }
}