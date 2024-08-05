
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/api_config.dart';
import '../../constants/fonts.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/models/category_model/category_model.dart';
import '../../global_widgets/loading.dart';
import '../../riverpod/categories_menu_provider.dart';
import '../../riverpod/categories_provider.dart';
import 'sub_category_menu.dart';

class CategoriesMenu extends ConsumerStatefulWidget {
  const CategoriesMenu({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoriesMenuState();
}

class _CategoriesMenuState extends ConsumerState<CategoriesMenu> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        bool catIsExpanded = ref.watch(categoriesMenuProvider);
        bool subCatIsExpanded = ref.watch(subCategoryMenuProvider);
        return Row(
          children: [
            categoryMenu(catIsExpanded),
            subCategoriesMenu(subCatIsExpanded)
          ],
        );
      },
    );
  }

  Widget subCategoriesMenu(bool subCatIsExpanded) {
    return AnimatedContainer(
      width: subCatIsExpanded ? 200.0 : 0.0,
      height: double.infinity,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.purple.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: !subCatIsExpanded ? null : const SubCategoryMenu()
    );
  }

  AnimatedContainer categoryMenu(bool catIsExpanded) {
    return AnimatedContainer(
      width: catIsExpanded ? 250.0 : 0.0,
      height: double.infinity,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          if(catIsExpanded)
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: 
      !catIsExpanded ? null :
      Consumer(
        builder: (context, ref, child){
          return ref.watch(baseCategoriesProvider).when(
            loading: () => const Loading(),
            error: (error, _) => Center(child: Text(error.toString())),
            data: (_){
              final allCategories = ref.watch(categoriesProvider);
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: allCategories.length,
                itemBuilder: (context, index){
                  
                  CategoryModel category = CategoryModel(categories: allCategories[index]);
                  int selectedIndex = ref.watch(selectedIndexCategoryProvider);
      
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 3, 
                      bottom: 3, 
                      left:  index == selectedIndex && category.children.isNotEmpty ? 10 : 5,
                      right: index == selectedIndex && category.children.isNotEmpty ? 0 : 5
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10), 
                          bottomLeft: const Radius.circular(10),
                          topRight: Radius.circular(index == selectedIndex && category.children.isNotEmpty ?  0 : 10),
                          bottomRight: Radius.circular(index == selectedIndex && category.children.isNotEmpty ? 0 : 10),
                        ),
                        color: index == selectedIndex ? Colors.purple.shade200 : Colors.purple.shade50,
                        boxShadow: [
                          if(index == selectedIndex)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: (){
                          category.children.isEmpty ? {
                            ref.read(subCategoryMenuProvider.notifier).close(),
                            GoRouter.of(context).go('/products/${category.id}')
                          } :
                            {
                              ref.read(categoryPathProvider.notifier).clear(),
                              ref.read(subCategoryMenuProvider.notifier).open(),
                              ref.read(selectedCategoryProvider.notifier).toggle(category.id),
                              ref.read(categoryPathProvider.notifier).addPath(category.id)
                            };
                          ref.read(selectedIndexCategoryProvider.notifier).toggle(index);
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
                              child: Text(category.name, style: index == selectedIndex ? whiteText(15) : black(15)),
                            ),
                            if(category.children.isNotEmpty)
                            Icon(MdiIcons.chevronRight, size: 20, color: index == selectedIndex ? Colors.white : Colors.purple,),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
            },  
          );
        },
      )
    );
  }
}