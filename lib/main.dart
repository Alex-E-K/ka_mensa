import 'package:flutter/material.dart';
import 'package:ka_mensa/data/constants/languages.dart';
import 'package:ka_mensa/data/constants/supported_locales.dart';
import 'package:ka_mensa/data/themes/dark_theme.dart';
import 'package:ka_mensa/data/themes/light_theme.dart';
import 'package:ka_mensa/logic/provider/theme_provider.dart';
import 'package:ka_mensa/presentation/router/app_router.dart';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int selectedLanguageIndex = preferences.getInt('selectedLanguage') ?? 0;

  Locale selectedLocale = languages[selectedLanguageIndex].locale;

  runApp(
    KLocalizations.asChangeNotifier(
        locale: selectedLocale,
        defaultLocale: supportedLocales[0],
        supportedLocales: supportedLocales,
        localizationsAssetsPath: 'assets/translations',
        child: MyApp(
          appRouter: AppRouter(),
        )),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter;
  const MyApp({Key? key, required AppRouter appRouter})
      : _appRouter = appRouter,
        super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final KLocalizations localizations = KLocalizations.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      builder: (context, _) {
        final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'KA Mensa',
          themeMode: themeProvider.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          locale: localizations.locale,
          supportedLocales: localizations.supportedLocales,
          localizationsDelegates: [
            localizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          onGenerateRoute: _appRouter.onGenerateRoute,
        );
      },
    );
  }
}
