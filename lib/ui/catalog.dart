
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/categories_menu_provider.dart';
import 'categories_menu/categories_menu_large.dart';
import 'products/products_screen.dart';

class Catalog extends ConsumerStatefulWidget {
  final int categoryID;
  const Catalog({super.key, required this.categoryID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CatalogState();
}

class _CatalogState extends ConsumerState<Catalog> {

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 900;
        // Отложенное изменение состояния, если это не маленький экран
        if (!isSmallScreen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(categoryExpandedProvider.notifier).open();
          });
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSmallScreen ? const SizedBox.shrink() : const CategoriesMenuLarge(),
            Expanded(
              child: Stack(
                children: [
                  ProductsScreen(key: ValueKey(widget.categoryID), categoryID: widget.categoryID,),
                  isSmallScreen ? const CategoriesMenuLarge() : const SizedBox.shrink(),
                ],
              )
            )
          ],
        );
      }
    );
  }
}