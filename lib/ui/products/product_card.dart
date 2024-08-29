
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/api_config.dart';
import '../../constants/fonts.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/models/product_model/product_model.dart';




class ProductCard extends StatefulWidget {
  final ProductModel product;
  final Consumer cartController;
  const ProductCard({super.key, required this.product, required this.cartController});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  final PageController pageController = PageController();

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          
              // изображение продукта
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 300,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  color: Colors.white,
                ),
                child: widget.product.pictures.isEmpty ? Image.asset(categoryImagePath['empty'], scale: 2,) : 
                PageView.builder(
                  controller: pageController,
                  itemCount: widget.product.pictures.length,
                  itemBuilder: (context, index) {
                    String picURL = '$apiURL${widget.product.pictures[index]['picture_url']}';
                    return CachedNetworkImage(
                      imageUrl: picURL,
                      errorWidget: (context, url, error) => Align(alignment: Alignment.center, child: Opacity(opacity: 0.3, child: Image.asset(categoryImagePath['empty'], scale: 3))),
                    );
                  },
                ),
              ),
          
              // индикатор изображений, если их больше 1
              widget.product.pictures.isEmpty || widget.product.pictures.length == 1 ? const SizedBox.shrink() : 
              SmoothPageIndicator(
                controller: pageController,
                count: widget.product.pictures.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  type: WormType.thin,
                  activeDotColor: Colors.green,
                  dotColor: Colors.grey.shade300
                ),
              ),
          
              // название продукта
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Align(alignment: Alignment.centerLeft, child: Text(widget.product.name, style: black54(18, FontWeight.bold),)),
              ),
          
              // описание продукта
              Align(alignment: Alignment.centerLeft, child: Text('Описание:', style: black54(18, FontWeight.bold),)),
              const SizedBox(height: 5,),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                  minHeight: 50
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft, 
                        child: Text(
                          widget.product.discription.isEmpty ? 'описание отсутствует...' : widget.product.discription, 
                          style: black54(15),
                          overflow: TextOverflow.fade,
                        )
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
          
              // информация о повышении цены
              widget.product.futureDate.isEmpty ? const SizedBox.shrink() :
              Row(
                children: [
                  Icon(MdiIcons.arrowTopRightBoldBox, color: Colors.red,),
                  Expanded(child: Text('${widget.product.futurePrice}₽ c ${widget.product.futureDate}', style: black54(16), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                ],
              ),
          
              // текущая цена
              Align(alignment: Alignment.centerLeft, child: getPrice(widget.product.basePrice, widget.product.clientPrice,)),
              const SizedBox(height: 10,),
          
              // кнопки работы с корзиной
              widget.cartController,
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPrice(double basePrice, double clientPrice){
    if (basePrice > clientPrice){
      return Row(
        children: [
          Icon(MdiIcons.bookmark),
          const SizedBox(width: 5,),
          Text('${clientPrice.toStringAsFixed(2)}₽', style: black54(24, FontWeight.normal), overflow: TextOverflow.fade,),
          const SizedBox(width: 10,),
          Text('${basePrice.toStringAsFixed(2)}₽', style: blackThroughPrice(20, FontWeight.normal)),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(MdiIcons.bookmark),
          const SizedBox(width: 5,),
          Text('${clientPrice.toStringAsFixed(2)}₽', style: black54(24, FontWeight.normal)),
        ],
      );
    }
  }
}