
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/fonts.dart';
import '../../data/models/category_model/category_model.dart';
import '../../data/models/product_model/product_model.dart';
import '../../data/repositories/search_products_implements.dart';
import '../../global_widgets/loading.dart';
import '../../global_widgets/search_animation.dart';
import '../../riverpod/categories_provider.dart';
import '../../riverpod/navigator_provider.dart';
import '../../riverpod/products_provider.dart';
import '../products/products_views.dart';
import 'subcategories_views_small.dart';

class SubCategoriesScreen extends ConsumerStatefulWidget {
  final int categoryID;
  const SubCategoriesScreen({super.key, required this.categoryID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewSubcategoriesScreenState();
}

class _NewSubcategoriesScreenState extends ConsumerState<SubCategoriesScreen> {

  TextEditingController searchController = TextEditingController();
  String searchHint = '';
  Timer? _debounce;
  Widget content = Container();

  @override
  void initState(){
    super.initState();
  }


  @override
  void dispose(){
    _debounce?.cancel();
    searchController.clear();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final selectedCategoryProvider = ref.read(selectedSubCategoryProvider);
    int selectedCategory = selectedCategoryProvider == -1 ? widget.categoryID : selectedCategoryProvider;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      searchController.text.isEmpty ? 
        setState(() { content = Container(); }) 
        : 
        {
          setState(() { content = searchAnimation(); }),
          await SearchProductsImplements().searchProductByCategory(selectedCategory, searchController.text, ref).then((value){
            value.isEmpty ? setState(() { content = Center(child: Text('товар не найден', style: black(18),),); }) : setState(() { content = productGrid(value); }) ;
          }),
        };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child){
        return ref.watch(baseCategoryProvider(widget.categoryID)).when(
          loading: () => const Loading(),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (_){
            final getCategory = ref.watch(categoryProvider);
            CategoryModel category = CategoryModel(categories: getCategory);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  titleSpacing: 0,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  automaticallyImplyLeading: false,
                  title: Text(category.name, style: black(26, FontWeight.bold), overflow: TextOverflow.clip,),
                ),
                body: Builder(
                  builder: (context) {
                    final isSmallScreen = MediaQuery.of(context).size.width < 600;
                    return isSmallScreen ? subCategoriesViewsSmall(category.children, ref) : subCategoriesViewsLarge(category.children);
                  }
                ),
              ),
            );
          },  
        );
      },
    );
  }

  Widget subCategoriesViewsLarge(List subCategories){
    return Consumer(
      builder: (context, ref, child) {
        final selectedCategory = ref.watch(selectedSubCategoryProvider);
        final asyncValue = ref.watch(baseProductsProvider(selectedCategory == -1 ? widget.categoryID : selectedCategory));
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            subCategoryMenu(context, selectedCategory, ref, subCategories),
            const SizedBox(width: 10,),
            Expanded(
              child: asyncValue.when( 
                loading: () => const Loading(),
                error: (error, _) => Center(child: Text(error.toString())),
                data: (_){
                  final allProducts = ref.watch(productsProvider);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: allProducts!.isEmpty ? Center(child: Text('нет товаров в данном разделе', style: black(20),)) 
                      : 
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                              child: searchField(),
                            ),
                            searchController.text.isEmpty ? productGrid(allProducts) : content,
                          ],
                        ),
                      ),
                  );
                }, 
              ),
            )
          ],
        );
      }
    );
  }

  Widget productGrid(List<dynamic> allProducts) {
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
        

        return GridView.builder(
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
        );
      }
    );
  }

  Padding subCategoryMenu(BuildContext context, int selectedCategory, WidgetRef ref, List<dynamic> subCategories) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: 200,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: selectedCategory == -1 ? Colors.green.shade100 : Colors.amber.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(5),
                  child: InkWell(
                    onTap: (){ 
                      setState(() {
                        searchHint = '';
                        searchController.clear();
                      });
                      ref.read(selectedSubCategoryProvider.notifier).state = -1;
                    },
                    child: Align(alignment: Alignment.centerLeft, child: Text('Все товары', style: black(16),))
                  )
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: subCategories.length,
                itemBuilder: (context, index){
                  CategoryModel category = CategoryModel(categories: subCategories[index]);
                  return category.children.isEmpty ? 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: category.id == selectedCategory ? Colors.green.shade100 : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(5),
                      child: InkWell(
                        onTap: (){ 
                          setState(() {
                            searchHint = category.name;
                            searchController.clear();
                          });
                          ref.read(selectedSubCategoryProvider.notifier).state =  category.id;
                        },
                        child: Text(category.name, style: black(16),)
                      )
                    ),
                  ) : 
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: category.id == selectedCategory ? Colors.green.shade100 : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          child: InkWell(
                            onTap: (){ 
                              setState(() {
                                searchHint = category.name;
                                searchController.clear();
                              });
                              ref.read(selectedSubCategoryProvider.notifier).state =  category.id;
                            },
                            child: Text(category.name, style: black(16),)
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 15),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: category.children.length,
                          itemBuilder: (context, index){
                            CategoryModel childCategory = CategoryModel(categories: category.children[index]);
                            return  Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: category.children[index]['category_id'] == selectedCategory ? Colors.green.shade100 : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(5),
                                child: InkWell(
                                  onTap: (){ 
                                    setState(() {
                                      searchController.clear();
                                      searchHint = '${category.name} ${category.children[index]['name']}';
                                    });
                                    ref.read(selectedSubCategoryProvider.notifier).state = category.children[index]['category_id'];
                                  },
                                  child: Text(category.children[index]['name'], style: childCategory.children.isEmpty ? black(16) : red(16))
                                )
                              ),
                            );
                          }
                        ),
                      )
                    ],
                  );
                }
              ),
            ],
          ),
        ),
      ),
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
          color: Colors.amber,
        ),
        height: 40,
        child: TextField(
          autofocus: false,
          controller: searchController,
          style: whiteText(20),
          cursorColor: Colors.white,
          minLines: 1,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: whiteText(20),
            hintText: 'поиск товара по категории $searchHint',
            prefixIcon: Icon(MdiIcons.magnify, color: Colors.white,),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: (){
                  setState(() {
                    searchController.clear();
                    content = Container();
                  });
                },
                child: Icon(MdiIcons.close, color: Colors.white,)
              ),
            ),
            isCollapsed: true
          ),
          onChanged: (text) => _onSearchChanged(),
        ),
      ),
    );
  }

}