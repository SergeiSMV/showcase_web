/*
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/riverpod/navigator_provider.dart';
import 'package:universal_html/html.dart' as html;

import '../../constants/api_config.dart';
import '../../constants/fonts.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/models/category_model/category_model.dart';
import '../../riverpod/products_provider.dart';

class SubCategoriesScreen extends ConsumerStatefulWidget {
  final List subCategories;
  final String mainCategory;
  final int mainCategoryID;
  const SubCategoriesScreen({super.key, required this.subCategories, required this.mainCategory, required this.mainCategoryID});

  @override
  ConsumerState<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends ConsumerState<SubCategoriesScreen> {

  @override
  void initState() {
    super.initState();
    // Обработка нажатия кнопки "Назад" в браузере
    // html.window.onPopState.listen((_) {
    //   if (mounted) {
    //     final notifier = ref.read(subCategoryDataProvider.notifier);
    //     if (notifier.mounted) {
    //       notifier.removeItem();
    //     }
    //   }
    // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        title: SizedBox(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Text(widget.mainCategory, style: black(26, FontWeight.bold), overflow: TextOverflow.clip,),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                    GoRouter.of(context).go('/categories');
                  },
                  child: Row(
                    children: [
                      Icon(MdiIcons.chevronLeft, size: 25,),
                      const SizedBox(width:0,),
                      Text('Категории товаров', style: black(14),),
                    ],
                  )
                ),
                const SizedBox(height: 10,),
                categoryMenu(context),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: subCategoriesViews(widget.subCategories)
      ),
    );
  }

  Widget subCategoriesViews(List subCategories) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: subCategories.length,
      itemBuilder: (BuildContext context, int index){
        CategoryModel category = CategoryModel(categories: subCategories[index]);
        return InkWell(
          onTap: (){ 
            category.children.isEmpty ?
            {
              ref.read(productsProvider.notifier).state = null,
              GoRouter.of(context).go(
                '/categories/${category.id}/products',
                extra: {
                  'mainCategory': category.name,
                  'categoryID': category.id
                },
              )
            } :
            {
              GoRouter.of(context).go(
                Uri(
                  path: '/categories/${category.id}',
                  queryParameters: {
                    'name': category.name,
                    'categoryID': category.id.toString(),
                    'subCategories': jsonEncode(category.children),
                  },
                ).toString(),
              )
            };
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 3,
                  color: Colors.transparent,
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  
                  Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: category.thumbnail == categoryImagePath['empty'] ? Image.asset(categoryImagePath['empty'], scale: 3) :
                        CachedNetworkImage(
                          imageUrl: '$apiURL${category.thumbnail}',
                          errorWidget: (context, url, error) => SizedBox(
                            width: 120,
                            height: 120,
                            child: Align(
                              alignment: Alignment.center, 
                              child: Image.asset(categoryImagePath['empty'], scale: 3)
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Text(category.name, style: black(20, FontWeight.w500), overflow: TextOverflow.clip,)
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  
  Widget categoryMenu(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: (){
            GoRouter.of(context).push(
              '/categories/${widget.mainCategoryID}/products',
              extra: {
                'mainCategory': widget.mainCategory,
                'categoryID': widget.mainCategoryID
              },
            );
          },
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 5),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   border: Border.all(
            //     width: 3,
            //     color: Colors.transparent,
            //   ),
            //   color: Colors.green.shade100,
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.4),
            //       spreadRadius: 1,
            //       blurRadius: 0.3,
            //       offset: const Offset(1, 2),
            //     ),
            //   ],
            // ),
            child: Row(
              children: [
                const SizedBox(width: 5,),
                Image.asset('lib/images/get_all.png', scale: 7, color: Colors.green.shade200,),
                const SizedBox(width: 10,),
                Expanded(
                  child: Text('товары в категории', style: black(14, FontWeight.w500), overflow: TextOverflow.clip,)
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 5,),
        InkWell(
          onTap: (){
            GoRouter.of(context).push(
              '/search_by_id',
              extra: {
                'mainCategory': widget.mainCategory,
                'categoryID': widget.mainCategoryID
              },
            );
          },
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 5),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   border: Border.all(
            //     width: 3,
            //     color: Colors.transparent,
            //   ),
            //   color: Colors.green.shade100,
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.4),
            //       spreadRadius: 1,
            //       blurRadius: 0.3,
            //       offset: const Offset(1, 2),
            //     ),
            //   ],
            // ),
            child: Row(
              children: [
                Image.asset('lib/images/glass.png', scale: 6, color: Colors.green.shade200,),
                const SizedBox(width: 5,),
                Expanded(
                  child: Text('поиск по категории', style: black(14, FontWeight.w500), overflow: TextOverflow.clip,)
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
*/