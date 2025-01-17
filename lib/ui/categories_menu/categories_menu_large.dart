
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/api_config.dart';
import '../../constants/fonts.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/models/category_model/category_model.dart';
import '../../riverpod/categories_menu_provider.dart';
import '../../riverpod/categories_provider.dart';
import 'sub_category_menu_large.dart';

class CategoriesMenuLarge extends ConsumerStatefulWidget {
  const CategoriesMenuLarge({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoriesMenuState();
}

class _CategoriesMenuState extends ConsumerState<CategoriesMenuLarge> with TickerProviderStateMixin {


  void hasChildrenHandler(int categoryID){
    ref.read(subCategoryExpandedProvider.notifier).open();
    ref.read(selectedSubCategoryProvider.notifier).toggle(categoryID);
  }

  void notChildrenHandler(int categoryID) {
    ref.read(subCategoryExpandedProvider.notifier).close();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 900;
        return Consumer(
          builder: (context, ref, child) {
            bool catIsExpanded = ref.watch(categoryExpandedProvider);
            bool subCatIsExpanded = ref.watch(subCategoryExpandedProvider);
            return GestureDetector(
              onHorizontalDragEnd: (details) {
                if(isSmallScreen){
                  ref.read(categoryExpandedProvider.notifier).close();
                  ref.read(subCategoryExpandedProvider.notifier).close();
                }
              },
              child: Row(
                children: [
                  categoryMenu(catIsExpanded, subCatIsExpanded),
                  subCategoriesMenu(subCatIsExpanded)
                ],
              ),
            );
          },
        );
      }
    );
  }

  Widget subCategoriesMenu(bool subCatIsExpanded) {
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 900;
        return AnimatedContainer(
          width: subCatIsExpanded ? 
          isSmallScreen ? 150.0 : 200.0 
          : 0.0,
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
          child: !subCatIsExpanded ? null : const SubCategoryMenuLarge()
        );
      }
    );
  }

  Widget categoryMenu(bool catIsExpanded, bool subCatIsExpanded) {
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 900;
        return AnimatedContainer(
          width: catIsExpanded ? 
            isSmallScreen ? 150.0 : 250 
            : 0.0,
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
                loading: () => const SizedBox.shrink(),
                error: (error, _) => Center(child: Text(error.toString())),
                data: (_){
                  final allCategories = ref.watch(categoriesProvider);
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: (){
                                    GoRouter.of(context).go('/global');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      color: Colors.purple,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(MdiIcons.magnify, color: Colors.white),
                                        const SizedBox(width: 10,),
                                        Expanded(child: Text(isSmallScreen ? 'поиск' : 'глобальный поиск', style: whiteText(14), overflow: TextOverflow.clip,))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  final isSmallScreen = MediaQuery.of(context).size.width < 900;
                                  return isSmallScreen ? InkWell(
                                    onTap: (){
                                      ref.read(categoryExpandedProvider.notifier).toggle();
                                      ref.read(subCategoryExpandedProvider.notifier).close();
                                    },
                                    child: SizedBox(
                                      height: 35,
                                      width: 35,
                                      child: Icon(MdiIcons.chevronLeft, size: 35, color: Colors.purple),
                                    ),
                                  ) : const SizedBox.shrink();
                                }
                              ),
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.sizeOf(context).height - 120,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: allCategories.length,
                            itemBuilder: (context, index){
                              
                              CategoryModel category = CategoryModel(categories: allCategories[index]);
                              int selectedMainCategory = ref.watch(selectedMainCategoryProvider);
                              
                              // плашка основной категории
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: 3, 
                                  bottom: 3, 
                                  left:  category.id == selectedMainCategory && category.children.isNotEmpty && subCatIsExpanded ? 10 : 5,
                                  right: category.id == selectedMainCategory && category.children.isNotEmpty && subCatIsExpanded ? 0 : 5
                                ),
                                child: Container(
                                  padding: isSmallScreen ? const EdgeInsets.symmetric(horizontal: 5) : EdgeInsets.zero,
                                  height: isSmallScreen ? 50 : null,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(10), 
                                      bottomLeft: const Radius.circular(10),
                                      topRight: Radius.circular(category.id == selectedMainCategory && category.children.isNotEmpty && subCatIsExpanded ?  0 : 10),
                                      bottomRight: Radius.circular(category.id == selectedMainCategory && category.children.isNotEmpty && subCatIsExpanded ? 0 : 10),
                                    ),
                                    color: category.id == selectedMainCategory ? Colors.purple.shade200 : Colors.purple.shade50,
                                    boxShadow: [
                                      if(category.id == selectedMainCategory)
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
                                      category.children.isEmpty ? 
                                        notChildrenHandler(category.id) 
                                        : hasChildrenHandler(category.id);
                                      GoRouter.of(context).go('/products/${category.id}');
                                      ref.read(selectedMainCategoryProvider.notifier).toggle(category.id);
                                      ref.read(categoriesDirectoryProvider.notifier).addCategoryData({
                                        'id': category.id, 
                                        'name': category.name, 
                                        'motherCategory' : 0,
                                        'motherSubCategory': 0,
                                        'children': category.children.isEmpty ? false : true
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        isSmallScreen ? const SizedBox.shrink() :
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
                                        isSmallScreen ? const SizedBox.shrink() : const SizedBox(width: 8,),
                                        Expanded(
                                          child: Text(category.name, style: category.id == selectedMainCategory ? whiteText(15) : black54(15)),
                                        ),
                                        if(category.children.isNotEmpty)
                                        Icon(MdiIcons.chevronRight, size: 20, color: category.id == selectedMainCategory ? Colors.white : Colors.purple,),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  );
                },  
              );
            },
          )
        );
      }
    );
  }

}