// ignore_for_file: file_names

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:flutter/material.dart';

ThemeData getThemeDataLight() => ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(AppColorLight.primaryColor),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 110, vertical: 20),
            ))),
    textTheme: const TextTheme(
        headlineMedium: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColorLight.blackColor)));
