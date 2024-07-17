
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/api_config.dart';
import '../../constants/fonts.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/models/category_model/category_model.dart';
import '../../global_widgets/loading.dart';
import '../../riverpod/categories_provider.dart';
import '../../riverpod/products_provider.dart';

Widget categoryViews() {
  return Consumer(
    builder: (context, ref, child){
      return ref.watch(baseCategoriesProvider).when(
        loading: () => const Loading(),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (_){
          final allCategories = ref.watch(categoriesProvider);
          return allCategories.isEmpty ? update(ref) : categories(ref, allCategories);
        },  
      );
    },
  );
}


Widget categories(WidgetRef ref, List<dynamic> mainCategories) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: LayoutBuilder(
      builder: (context, constraints) {
    
        // Задаем минимальное и максимальное количество столбцов
        int minCrossAxisCount = 3;
        int maxCrossAxisCount = 9;
    
        // Задаем ширину элемента в пикселях
        double itemWidth = 170.0;
    
        // Вычисляем количество столбцов в зависимости от ширины контейнера
        int crossAxisCount = (constraints.maxWidth / itemWidth).floor();
    
        // Ограничиваем количество столбцов заданными пределами
        crossAxisCount = crossAxisCount.clamp(minCrossAxisCount, maxCrossAxisCount);
    
        return GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: mainCategories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 5,
            crossAxisSpacing: 10
          ),
          itemBuilder: (BuildContext context, int index) {
            CategoryModel category = CategoryModel(categories: mainCategories[index]);
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: (){ 
                  category.children.isEmpty ?
                  {
                    ref.read(productsProvider.notifier).state = null,
                    GoRouter.of(context).push(
                      '/categories/${category.id}/products',
                      extra: {
                        'mainCategory': category.name,
                        'categoryID': category.id
                      },
                    )
                  } : 
                  GoRouter.of(context).push(
                    '/categories/${category.id}',
                    extra: {
                      'mainCategory': category.name,
                      'subCategories': category.children,
                      'mainCategoryID': category.id
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(1, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        FittedBox(
                          fit: BoxFit.cover,
                          child: category.thumbnail == categoryImagePath['empty'] ? SizedBox(width: 180, height: 180, child: Image.asset(categoryImagePath['empty'], scale: 3)) :
                          CachedNetworkImage(
                            imageUrl: '$apiURL${category.thumbnail}',
                            errorWidget: (context, url, error) => SizedBox(
                              width: 180,
                              height: 180,
                              child: Align(
                                alignment: Alignment.bottomCenter, 
                                child: Opacity(
                                  opacity: 0.3, child: 
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Image.asset(categoryImagePath['empty'], scale: 3),
                                  )
                                )
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                            // color: Colors.white60,
                            gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent, ], // Градиент от красного к зеленому
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Text(category.name, style: whiteText(18, FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    ),
  );
}


Column update(WidgetRef ref) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset('lib/images/no_data.png', scale: 3),
      Text('что-то пошло не так...', style: black(14),),
      const SizedBox(height: 10,),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00B737),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async { 
          Future.delayed(const Duration(seconds: 1), () {
            return ref.refresh(baseCategoriesProvider);
          });
        }, 
        child: Text('обновить', style: whiteText(16),)
      ),
    ],
  );
}