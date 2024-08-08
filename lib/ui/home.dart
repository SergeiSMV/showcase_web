
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/fonts.dart';
import '../riverpod/token_provider.dart';



class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(categoryExpandedProvider.notifier).close();
      // ref.read(subCategoryExpandedProvider.notifier).close();
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String token = ref.watch(tokenProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: InkWell(
          onTap: (){
            GoRouter.of(context).push('/auth');
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Home Screen', style: black(18),),
                const SizedBox(height: 10,),
                Text(token.isEmpty ? 'не авторизован' : 'авторизован', style: black(14),),
              ],
            ),
          )
        )
      ),
    );
  }
}