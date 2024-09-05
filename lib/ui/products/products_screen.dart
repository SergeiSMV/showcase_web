

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/riverpod/categories_provider.dart';

import '../../constants/fonts.dart';
import '../../data/models/product_model/product_model.dart';
import '../../data/repositories/search_products_implements.dart';
import '../../widgets/loading.dart';
import '../../widgets/search_animation.dart';
import '../../riverpod/products_provider.dart';
import 'products_views/products_views.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  final int categoryID;
  const ProductsScreen({super.key, required this.categoryID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  Widget content = Container();
  String searchCategoryHint = '';
  Map categoryData = {};

  @override
  void initState(){
    super.initState();    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List allCategories = ref.read(categoriesProvider);
      if(allCategories.isEmpty){
        ref.refresh(baseCategoriesProvider.future).then((result){
          allCategories = ref.read(categoriesProvider);
          if(allCategories.isNotEmpty){
            Map<String, dynamic>? foundCategory = findCategoryById(allCategories, widget.categoryID);
            if (foundCategory != null) {
              setState(() {
                searchCategoryHint = foundCategory['name'];
              });
            } else {
              log('Категория с таким ID не найдена.', name: 'ProductsScreen, foundCategory');
            }
          }
        });
      } else {
        Map<String, dynamic>? foundCategory = findCategoryById(allCategories, widget.categoryID);
        if (foundCategory != null) {
          setState(() {
            searchCategoryHint = foundCategory['name'];
          });
        } else {
          log('Категория с таким ID не найдена.', name: 'ProductsScreen, foundCategory');
        }
      }
      /*
      categoryData = ref.read(categoriesDirectoryProvider.notifier).selectedCategoryData(widget.categoryID);
      if (categoryData.isNotEmpty){
        searchCategoryHint = categoryData['name'];
        // настройка индекса материнской категории
        if(categoryData['motherCategory'] == 0){
          ref.read(selectedMainCategoryProvider.notifier).toggle(categoryData['id']);
        } else {
          ref.read(selectedMainCategoryProvider.notifier).toggle(categoryData['motherCategory']);
        }
        // настройка индекса подкатегории
        // [ProductsScreen Log] {id: 73, name: Творожный, motherCategory: 43, motherSubCategory: 70, children: false}
        // [ProductsScreen] {id: 70, name: Сыр, motherCategory: 43, motherSubCategory: 0, children: true}
        if(categoryData['children']){
          ref.read(selectedSubCategoryProvider.notifier).toggle(categoryData['id']);
        } else {
          if (categoryData['motherSubCategory'] == 0) {
            ref.read(selectedSubCategoryProvider.notifier).toggle(categoryData['motherCategory']);
          } else {
            ref.read(selectedSubCategoryProvider.notifier).toggle(categoryData['motherSubCategory']);
          }
        }
        // настройка Expanded у subCategoryMenu
        if(categoryData['children'] || categoryData['motherCategory'] != 0){
          ref.read(subCategoryExpandedProvider.notifier).open();
        } else {
          ref.read(subCategoryExpandedProvider.notifier).close();
        }
      }
      */
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
          await SearchProductsImplements().searchProductByCategory(widget.categoryID, _searchController.text, ref).then((value){
            value.isEmpty ? setState(() { content = Center(child: Text('товар не найден', style: black54(14),),); }) : setState(() { content = products(value); }) ;
          }),
        };
    });
  }

  Map<String, dynamic>? findCategoryById(List categories, int categoryId) {
    for (var category in categories) {
      if (category['category_id'] == categoryId) {
        return category;
      }
      if (category.containsKey('children')) {
        var found = findCategoryById(category['children'], categoryId);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Consumer(
        builder: (context, ref, child) {      
          return ref.watch(baseProductsProvider(widget.categoryID)).when( 
            loading: () => const Loading(),
            error: (error, _) => Center(child: Text(error.toString())),
            data: (_){
              final allProducts = ref.watch(productsProvider);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: allProducts.isEmpty ? Center(child: Text('нет товаров в данном разделе', style: black54(14),)) 
                  : 
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
                          child: searchField(),
                        ),

                        // _searchController.text.isEmpty ? products(allProducts): content,

                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.sizeOf(context).height - 155,
                            ),
                            child: _searchController.text.isEmpty ? products(allProducts): content,
                          ),
                        ),
                      ],
                    ),
                  ),

              );
            }, 
          );
        }
      ),
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
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 25),
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
              hintText: 'поиск товаров по категории ${searchCategoryHint.toLowerCase()}',
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
        );
      }
    );
  }

}
















/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/fonts.dart';
import '../../data/models/product_model/product_model.dart';
import '../../data/repositories/search_products_implements.dart';
import '../../widgets/loading.dart';
import '../../widgets/search_animation.dart';
import '../../riverpod/categories_menu_provider.dart';
import '../../riverpod/products_provider.dart';
import 'products_views.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  final int categoryID;
  const ProductsScreen({super.key, required this.categoryID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  Widget content = Container();
  String searchCategoryHint = '';
  Map categoryData = {};

  @override
  void initState(){
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {

      
      
      categoryData = ref.read(categoriesDirectoryProvider.notifier).selectedCategoryData(widget.categoryID);

      if (categoryData.isNotEmpty){

        searchCategoryHint = categoryData['name'];
        
        // настройка индекса материнской категории
        if(categoryData['motherCategory'] == 0){
          ref.read(selectedMainCategoryProvider.notifier).toggle(categoryData['id']);
        } else {
          ref.read(selectedMainCategoryProvider.notifier).toggle(categoryData['motherCategory']);
        }

        // настройка индекса подкатегории
        // [ProductsScreen Log] {id: 73, name: Творожный, motherCategory: 43, motherSubCategory: 70, children: false}
        // [ProductsScreen] {id: 70, name: Сыр, motherCategory: 43, motherSubCategory: 0, children: true}
        if(categoryData['children']){
          ref.read(selectedSubCategoryProvider.notifier).toggle(categoryData['id']);
        } else {
          if (categoryData['motherSubCategory'] == 0) {
            ref.read(selectedSubCategoryProvider.notifier).toggle(categoryData['motherCategory']);
          } else {
            ref.read(selectedSubCategoryProvider.notifier).toggle(categoryData['motherSubCategory']);
          }
        }

        // настройка Expanded у subCategoryMenu
        if(categoryData['children'] || categoryData['motherCategory'] != 0){
          ref.read(subCategoryExpandedProvider.notifier).open();
        } else {
          ref.read(subCategoryExpandedProvider.notifier).close();
        }
      }
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
          await SearchProductsImplements().searchProductByCategory(widget.categoryID, _searchController.text, ref).then((value){
            value.isEmpty ? setState(() { content = Center(child: Text('товар не найден', style: black54(14),),); }) : setState(() { content = products(value); }) ;
          }),
        };
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer(
        builder: (context, ref, child) {      
          return ref.watch(baseProductsProvider(widget.categoryID)).when( 
            loading: () => const Loading(),
            error: (error, _) => Center(child: Text(error.toString())),
            data: (_){
              final allProducts = ref.watch(productsProvider);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: allProducts.isEmpty ? Center(child: Text('нет товаров в данном разделе', style: black54(14),)) 
                  : 
                  SingleChildScrollView(
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
                          child: _searchController.text.isEmpty ? products(allProducts): content,
                        ),

                        // searchController.text.isEmpty ? products(allProducts): content,

                        /*
                        LayoutBuilder(
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
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                        )
                        */
                      ],
                    ),
                  ),

              );
            }, 
          );
        }
      ),
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
            hintText: 'поиск товаров по категории ${searchCategoryHint.toLowerCase()}',
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
*/