


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/fonts.dart';
import '../../data/models/product_model/product_model.dart';
import '../../data/repositories/search_products_implements.dart';
import '../../global_widgets/search_animation.dart';
import '../../riverpod/products_provider.dart';
import 'products_views.dart';

class ProductGlobalSearch extends ConsumerStatefulWidget {
  const ProductGlobalSearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductGlobalSearch> {

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  Widget content = Container();
  String searchCategoryHint = '';

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchCategoryHint = ref.read(productSearchHintProvider).toLowerCase();
    });
  }


  @override
  void dispose(){
    _debounce?.cancel();
    _searchController.clear();
    _searchController.dispose();
    super.dispose();
  }



  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      _searchController.text.isEmpty ? 
        setState(() { content = Container(); }) 
        : 
        {
          setState(() { content = searchAnimation(); }),
          await SearchProductsImplements().searchProduct(_searchController.text, ref).then((value){
            value.isEmpty ? setState(() { content = Center(child: Text('товар не найден', style: black(14),),); }) : setState(() { content = products(value); }) ;
          }),
        };
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
                  child: searchField(),
                ),

                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height - 155,
                  ),
                  child: _searchController.text.isEmpty ? Center(child: Text('воспользуйтесь строкой поиска', style: black(14),),): content,
                ),
              ],
            ),
          ),

      )
    );
  }

  Widget products(List<dynamic> allProducts) {
    return LayoutBuilder(
      builder: (context, constraints) {
    
        // Задаем минимальное и максимальное количество столбцов
        int minCrossAxisCount = 3;
        int maxCrossAxisCount = 9;
    
        // Задаем ширину элемента в пикселях
        double itemWidth = 200.0;
        double itemHeight = 280.0;
    
        // Вычисляем количество столбцов в зависимости от ширины контейнера
        int crossAxisCount = (constraints.maxWidth / itemWidth).floor();
    
        // Ограничиваем количество столбцов заданными пределами
        crossAxisCount = crossAxisCount.clamp(minCrossAxisCount, maxCrossAxisCount);
        
    
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: allProducts.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: itemWidth,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: itemHeight,
            ),
            itemBuilder: (BuildContext context, int index) {
              ProductModel currentGoods = ProductModel(product: allProducts[index]);
              return ProductsViews(currentProduct: currentGoods,);
            },
          ),
        );
      }
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
          color: Colors.amber.shade700,
        ),
        height: 35,
        child: TextField(
          autofocus: false,
          controller: _searchController,
          style: whiteText(18),
          minLines: 1,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            isCollapsed: true,
            hintStyle: whiteText(16),
            hintText: 'поиск товаров по всем категориям',
            prefixIcon: Icon(MdiIcons.magnify, color: Colors.white,),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: (){
                  setState(() {
                    _searchController.clear();
                    content = Container();
                  });
                },
                child: Icon(MdiIcons.close, color: Colors.white,)
              ),
            ),
          ),
          onChanged: (text) => _onSearchChanged(),
        ),
      ),
    );
  }

}

