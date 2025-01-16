
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/fonts.dart';
import '../riverpod/menu_index_provider.dart';



class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(categoryExpandedProvider.notifier).close();
      // ref.read(subCategoryExpandedProvider.notifier).close();
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String token = ref.watch(tokenProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Добро пожаловать в Prod62', style: black(18),),
                  const SizedBox(height: 10,),
                  // Text(token.isEmpty ? 'не авторизован' : 'авторизован', style: black54(14),),
                  Text('пожалуйста ознакомьтесь с краткой инструкцией', style: black54(14),),
                  Text('по работе с приложением', style: black54(14),),
                  
                  
                  const SizedBox(height: 30,),
                  Image.asset('lib/images/faq/login.png', scale: 5),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Авторизация и регистрация', style: black(18),),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: 'Для начала работы нажмите ',
                      style: black(14, FontWeight.normal, 1.1), // Основной стиль текста
                      children: <TextSpan>[
                        TextSpan(
                          text: 'войти', // Кликабельное слово
                          style: blue(14),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              GoRouter.of(context).push('/auth');
                              ref.read(menuIndexProvider.notifier).state = 4;
                            },
                        ),
                        TextSpan(
                          text: '. Если нет учетной записи - ',
                          style: black(14, FontWeight.normal, 1.1), // Продолжение основного текста
                        ),
                        TextSpan(
                          text: 'подайте заявку ', // Кликабельное слово
                          style: blue(14),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              GoRouter.of(context).go('/auth/registration');
                              ref.read(menuIndexProvider.notifier).state = 4;
                            },
                        ),
                        TextSpan(
                          text: 'на регистрацию: в форме "Регистрация", указав ИНН организации и контактный номер телефона. C Вами свяжется наш оператор, подтвердит регистрацию и предоставит учётные данные для входа.',
                          style: black(14, FontWeight.normal, 1.1), // Продолжение основного текста
                        ),
                      ],
                    ),
                  ),
          
                  const SizedBox(height: 30,),
                  Image.asset('lib/images/faq/catalog.png', scale: 5),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Каталог товаров', style: black(18),),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: 'Просматривайте товары по категориям или используйте "ПОИСК". Нажатие (клик, тап) на товарную позицию открывает подробную информацию. Выбрав необходимое количество товара, нажмите на иконку "в корзину".',
                      style: black(14, FontWeight.normal, 1.1), // Основной стиль текста
                      children: const <TextSpan>[
                        // TextSpan(
                        //   text: 'каталог', // Кликабельное слово
                        //   style: blue(14),
                        //   recognizer: TapGestureRecognizer()
                        //     ..onTap = () {
                        //       ref.read(menuIndexProvider.notifier).state = 1;
                        //       List allCategories = ref.read(categoriesProvider);
                        //       CategoryModel category = CategoryModel(categories: allCategories[0]);
                        //       ref.read(selectedMainCategoryProvider.notifier).toggle(category.id);
                        //       GoRouter.of(context).go('/products/${category.id}');
                        //     },
                        // ),
                        // TextSpan(
                        //   text: '. Просматривайте товары по категориям или используйте поиск для быстрого нахождения нужного товара. Чтобы выбрать товар, нажмите на него для просмотра подробной информации. Вы можете выбрать количество и добавить товар в корзину, нажав кнопку «в корзину».',
                        //   style: black(14, FontWeight.normal, 1.1), // Продолжение основного текста
                        // ),
                      ],
                    ),
                  ),
          
          
          
                  const SizedBox(height: 30,),
                  Image.asset('lib/images/faq/cart.png', scale: 5),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Корзина', style: black(18),),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: 'Корзина содержит список всех добавленных товаров. Количество товара меняют кнопки «+» или «-» рядом с каждым позицией в корзине. Для удаления товара из корзины, нажмите на значок корзины рядом с ним.',
                      style: black(14, FontWeight.normal, 1.1), // Основной стиль текста
                      children: const <TextSpan>[
                        // TextSpan(
                        //   text: 'корзина', // Кликабельное слово
                        //   style: blue(14),
                        //   recognizer: TapGestureRecognizer()
                        //     ..onTap = () {
                        //       GoRouter.of(context).go('/cart');
                        //       ref.read(menuIndexProvider.notifier).state = 2;
                        //     },
                        // ),
                        // TextSpan(
                        //   text: '. В корзине вы увидите список всех добавленных товаров. Для изменения количества товара используйте кнопки «+» или «-» рядом с каждым товаром. Чтобы удалить товар, нажмите на значок корзины рядом с ним.',
                        //   style: black(14, FontWeight.normal, 1.1), // Продолжение основного текста
                        // ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 30,),
                  Image.asset('lib/images/faq/order.png', scale: 5),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Оформление заказа', style: black(18),),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: 'Нажмите "заказать". Выберите адрес доставки из вашего списка или добавьте новый адрес. При необходимости оставьте комментарий к заказу и нажмите "подтвердить и отправить". После оформления заявка отразится в личном кабинете в разделе "мои заказы".',
                      style: black(14, FontWeight.normal, 1.1), // Основной стиль текста
                    ),
                  ),
          
                  const SizedBox(height: 30,),
                  Image.asset('lib/images/faq/cabinet.png', scale: 5),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Кабинет', style: black(18),),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: 'Контроль заявок и отгрузок ведется в кабинете. Содержание кабинета: "мои отгрузки", "мои заказы" и "адреса".',
                      style: black(14, FontWeight.normal, 1.1), // Основной стиль текста
                      children: const <TextSpan>[
                        // TextSpan(
                        //   text: 'кабинет', // Кликабельное слово
                        //   style: blue(14),
                        //   recognizer: TapGestureRecognizer()
                        //     ..onTap = () {
                        //       GoRouter.of(context).go('/account');
                        //       ref.read(menuIndexProvider.notifier).state = 3;
                        //     },
                        // ),
                        // TextSpan(
                        //   text: '. Здесь вы увидите разделы "мои отгрузки", "мои заказы" и "адреса".',
                        //   style: black(14, FontWeight.normal, 1.1), // Продолжение основного текста
                        // ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 30,),
                  Image.asset('lib/images/faq/delivery.png', scale: 5),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Мои отгрузки', style: black(18),),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: '«Мои отгрузки» содержит информацию обо всех заказах, которые были уже обработаны и отгружены.',
                      style: black(14, FontWeight.normal, 1.1), // Основной стиль текста
                    ),
                  ),


                  const SizedBox(height: 30,),
                  Image.asset('lib/images/faq/orders.png', scale: 5),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Мои заказы', style: black(18),),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: '"Мои заказы" содержит информацию обо всех заказах, которые в обработке, но еще НЕ отгружены. Здесь отображаются детали текущих заказов и отслеживаются их статус.',
                      style: black(14, FontWeight.normal, 1.1), // Основной стиль текста
                    ),
                  ),

                  const SizedBox(height: 30,),
                  Image.asset('lib/images/faq/adresses.png', scale: 5),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Адреса доставки', style: black(18),),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: 'В раздел «адреса» можно добавить новый адрес: кнопку «+», Удалить адрес: кнопку «-», Рядом главным с адресом «по умолчанию» стоит галочка « ».',
                      style: black(14, FontWeight.normal, 1.1), // Основной стиль текста
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}