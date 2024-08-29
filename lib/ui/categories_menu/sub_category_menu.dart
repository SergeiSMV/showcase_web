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

  void closeSubMenu() {
    ref.read(subCategoryExpandedProvider.notifier).close();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {

        int selectedSubCategory = ref.watch(selectedSubCategoryProvider);
        int motherCategory = ref.watch(selectedMainCategoryProvider);

        return ref.watch(baseCategoryProvider(selectedSubCategory)).when(
          loading: () => const Center(
            child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)),
          ),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (data){
            CategoryModel category = CategoryModel(categories: ref.watch(categoryProvider));
            Map subCategoryData = ref.read(categoriesDirectoryProvider.notifier).selectedCategoryData(selectedSubCategory);
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
                          
                          // кнопка назад в субменю
                          subCategoryData['motherCategory'] == 0 ? const Spacer() :
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                subCategoryData['motherSubCategory'] == 0 ?
                                ref.read(selectedSubCategoryProvider.notifier).toggle(subCategoryData['motherCategory']) :
                                ref.read(selectedSubCategoryProvider.notifier).toggle(subCategoryData['motherSubCategory']);
                              },
                              child: Row(
                                children: [
                                  Align(alignment: Alignment.centerLeft, child: Icon(MdiIcons.chevronLeft, size: 22, color: Colors.white)),
                                  Text('назад', style: whiteText(15),)
                                ],
                              )
                            ),
                          ),

                          // кнопка закрытия субменю
                          InkWell(
                            onTap: closeSubMenu,
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
                          GoRouter.of(context).go('/products/${subCategoryData['id']}');
                        },
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white
                          ),
                          child: Align(alignment: Alignment.centerLeft, child: Text('Все товары в категории', style: black54(15),)),
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
                              ref.read(categoriesDirectoryProvider.notifier).addCategoryData({
                                'id': subCategory.id, 
                                'name': subCategory.name,
                                'motherCategory' : motherCategory,
                                'motherSubCategory': motherCategory == category.id ? 0 : category.id,
                                'children': subCategory.children.isEmpty ? false : true
                              });
                              GoRouter.of(context).go('/products/${subCategory.id}');
                              if(subCategory.children.isNotEmpty) {
                                ref.read(selectedSubCategoryProvider.notifier).toggle(subCategory.id);
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
                                  Expanded(child: Text(subCategory.name, style: black54(15),)),
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