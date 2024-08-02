
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/api_config.dart';
import '../../constants/fonts.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/models/category_model/category_model.dart';
import '../../riverpod/products_provider.dart';

Widget subCategoriesViewsSmall(List subCategories, WidgetRef ref) {
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
          GoRouter.of(context).go('/categories/${category.id}');
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