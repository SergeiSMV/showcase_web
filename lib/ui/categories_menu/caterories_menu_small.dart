
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_web/constants/fonts.dart';
import 'package:showcase_web/data/models/category_model/category_model.dart';

import '../../constants/api_config.dart';
import '../../data/models/category_model/category_data.dart';
import '../../riverpod/categories_provider.dart';


// поле ввода количества !только для маленького экрана
Future categoriesMenuSmall(BuildContext mainContext, WidgetRef ref){
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: mainContext, 
    builder: (context){
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10,),   
            Expanded(
              child: Consumer(
                builder: (context, ref, child){
                  final categories = ref.watch(categoriesProvider);
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index){
                      CategoryModel category = CategoryModel(categories: categories[index]);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10), 
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.purple.shade50,
                          ),
                          child: InkWell(
                            onTap: (){
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: CachedNetworkImage(
                                        imageUrl: '$apiURL${category.thumbnail}',
                                        errorWidget: (context, url, error) => Image.asset(categoryImagePath['empty'], scale: 3),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Expanded(
                                  child: Text(category.name, style: black54(15)),
                                ),
                                if(category.children.isNotEmpty)
                                Icon(MdiIcons.chevronRight, size: 20, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  );
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const SizedBox(height: 10),
            ),
          ],
        ),
      );
    }
  );
}