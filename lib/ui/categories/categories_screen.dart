
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/data/repositories/search_products_implements.dart';
import 'package:showcase_web/riverpod/navigator_provider.dart';

import '../../constants/fonts.dart';
import '../../data/models/product_model/product_model.dart';
import '../products/products_views.dart';
import 'category_search.dart';
import 'category_views.dart';




class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<CategoriesScreen> {

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  Widget content = Container();


  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedIndexProvider.notifier).state = 1;
    });
  }

  @override
  void dispose(){
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      searchController.text.isEmpty ? 
        setState(() { content = Container(); }) 
        : 
        {
          setState(() { content = searchAnimation(); }),
          await SearchProductsImplements().searchProduct(searchController.text, ref).then((value){
            value.isEmpty ? setState(() { content = Center(child: Text('товар не найден', style: black(18),),); }) : setState(() { content = products(value); }) ;
          }),
        };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 10),
                child: Text(searchController.text.isEmpty ? 'Категории товаров' : 'Поиск по всем категориям', style: black(30, FontWeight.bold),),
              ),
              const SizedBox(height: 10,),
              searchField(),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // header(),
            if (searchController.text.isEmpty) Expanded(child: categoryViews()) else Expanded(child: content),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text('Категории товаров', style: black(30, FontWeight.bold), overflow: TextOverflow.clip,),
        ),
        const Expanded(child: SizedBox(width: 10,)),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: (){ 
              GoRouter.of(context).push('/search',);
            }, 
            icon: Icon(MdiIcons.magnify, size: 30,)),
        )
      ],
    );
  }

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.transparent
          ),
          color: Colors.white,
        ),
        height: 40,
        child: TextField(
          autofocus: true,
          controller: searchController,
          style: black(20),
          minLines: 1,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            focusedBorder:OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            hintStyle: grey(18),
            hintText: 'поиск товара по всем категориям',
            prefixIcon: Icon(MdiIcons.magnify, color: Colors.grey,),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: (){
                  setState(() {
                    searchController.clear();
                    content = Container();
                  });
                },
                child: Icon(MdiIcons.close, color: Colors.grey,)
              ),
            ),
            isCollapsed: true
          ),
          onChanged: (text) => _onSearchChanged(),
        ),
      ),
    );
  }

  Widget products(List<dynamic> allProducts) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: allProducts.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 170,
            mainAxisSpacing: 5,
            crossAxisSpacing: 10,
            childAspectRatio: 0.56
          ),
          itemBuilder: (BuildContext context, int index) {
            ProductModel currentGoods = ProductModel(product: allProducts[index]);
            return ProductsViews(currentProduct: currentGoods,);
          },
        );
      }
    );
  }

}