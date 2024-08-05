
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/fonts.dart';
import '../../data/models/product_model/product_model.dart';
import '../../global_widgets/loading.dart';
import '../../riverpod/products_provider.dart';
import 'products_views.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  final int categoryID;
  const ProductsScreen({super.key, required this.categoryID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {

        final asyncValue = ref.watch(baseProductsProvider(widget.categoryID));

        return asyncValue.when( 
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
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      //   child: searchField(),
                      // ),
                      // searchController.text.isEmpty ? productGrid(allProducts) : content,


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

                    ],
                  ),
                ),
            );
          }, 
        );
      }
    );
  }
}