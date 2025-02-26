import 'package:happy_dog_house/src/feature/rituals/bloc/user_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../../routes/go_router_config.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontFamily: 'Bur',
      fontSize: 35,
      fontWeight: FontWeight.w700,
      color: Color.fromRGBO(255, 255, 255, 1),
    );
    return BlocProvider(
      create: (context) => UserBloc()..add(UserLoadData()),
      child: CupertinoApp.router(
        routerConfig: buildGoRouter,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: const CupertinoThemeData(
          brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(textStyle: textStyle),
        ),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              textTheme: const TextTheme(bodyLarge: textStyle),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
