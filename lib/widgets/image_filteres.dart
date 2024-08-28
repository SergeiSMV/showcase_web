
import 'package:flutter/material.dart';

ColorFilter greyFilter = const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0,  // красный
              0.2126, 0.7152, 0.0722, 0, 0,  // зеленый
              0.2126, 0.7152, 0.0722, 0, 0,  // синий
              0, 0, 0, 1, 0,               // альфа
            ]);


ColorFilter opacityFilter = const ColorFilter.matrix(<double>[
            1, 0, 0, 0, 0,  // красный
            0, 1, 0, 0, 0,  // зеленый
            0, 0, 1, 0, 0,  // синий
            0, 0, 0, 1, 0,  // альфа
          ]);