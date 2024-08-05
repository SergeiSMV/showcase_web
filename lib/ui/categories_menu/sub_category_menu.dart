
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/fonts.dart';
import '../../data/models/category_model/category_model.dart';
import '../../riverpod/categories_menu_provider.dart';
import '../../riverpod/categories_provider.dart';

class SubCategoryMenu extends ConsumerStatefulWidget {
  const SubCategoryMenu({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SubCategoryMenuState();
}

class _SubCategoryMenuState extends ConsumerState<SubCategoryMenu> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {

        List categoryPath = ref.watch(categoryPathProvider);
        int selectedCategory = ref.watch(selectedCategoryProvider);

        return ref.watch(baseCategoryProvider(selectedCategory)).when(
          loading: () => const Center(
            child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)),
          ),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (data){
            CategoryModel category = CategoryModel(categories: ref.watch(categoryProvider));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          categoryPath.length == 1 ? const Spacer() :
                          
                          // кнопка назад в субменю
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                ref.read(selectedCategoryProvider.notifier).toggle(categoryPath[categoryPath.length - 2]);
                                ref.read(categoryPathProvider.notifier).removeLastPath();
                              },
                              child: Align(alignment: Alignment.centerLeft, child: Icon(MdiIcons.chevronLeft, size: 20, color: Colors.white))
                            ),
                          ),

                          // кнопка закрытия субменю
                          InkWell(
                            onTap: (){
                              ref.read(subCategoryMenuProvider.notifier).close();
                              ref.read(selectedIndexCategoryProvider.notifier).toggle(-1);
                              ref.read(categoryPathProvider.notifier).clear();
                            },
                            child: Icon(MdiIcons.close, color: Colors.white, size: 18,),
                          ),
                        ],
                      ),
                    ),
        
                    // кнопка показа всех товаров в категории
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(
                        onTap: (){
                          GoRouter.of(context).go('/products/${categoryPath[categoryPath.length - 1]}');
                        },
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white
                          ),
                          child: Align(alignment: Alignment.centerLeft, child: Text('Все товары в категории', style: black(15),)),
                        ),
                      ),
                    ),

                    const Divider(color: Colors.white, thickness: 0.5, indent: 5, endIndent: 5, height: 25,),
        
                    // список субкатегорий
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: category.children.length,
                      itemBuilder: (context, index){
                        CategoryModel subCategory = CategoryModel(categories: category.children[index]);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: InkWell(
                            onTap: (){ 
                              if(subCategory.children.isNotEmpty) {
                                ref.read(selectedCategoryProvider.notifier).toggle(subCategory.id);
                                ref.read(categoryPathProvider.notifier).addPath(subCategory.id);
                              } else {
                                GoRouter.of(context).go('/products/${subCategory.id}');
                              }
                              
                            },
                            child: Container(
                              height: 35,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Colors.white
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: Text(subCategory.name, style: black(15),)),
                                  if(subCategory.children.isNotEmpty)
                                  Icon(MdiIcons.chevronRight, size: 20, color: Colors.black),
                                ],
                              ),
                            )
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}