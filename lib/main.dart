import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'data/constants/languages.dart';
import 'data/constants/supported_locales.dart';
import 'data/themes/dark_theme.dart';
import 'data/themes/light_theme.dart';
import 'logic/provider/theme_provider.dart';
import 'presentation/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Main method and starting point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Load the saved language
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int selectedLanguageIndex = preferences.getInt('selectedLanguage') ?? 0;

  Locale selectedLocale = languages[selectedLanguageIndex].locale;

  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: supportedLocales[0],
      child: MyApp(
        appRouter: AppRouter(),
      ),
    ),
  );

  // Run the app with the selected language
  // runApp(
  //   KLocalizations.asChangeNotifier(
  //       locale: selectedLocale,
  //       defaultLocale: supportedLocales[0],
  //       supportedLocales: supportedLocales,
  //       localizationsAssetsPath: 'assets/translations',
  //       child: MyApp(
  //         appRouter: AppRouter(),
  //       )),
  // );
}

/// Class that represents the entry point of the app. Here will the theme, the
/// language and other different things used initially.
class MyApp extends StatelessWidget {
  final AppRouter _appRouter;

  /// Constructor which takes an [appRouter] to set for generated routes.
  const MyApp({Key? key, required AppRouter appRouter})
      : _appRouter = appRouter,
        super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Needed for localizing the UI.
    //final KLocalizations localizations = KLocalizations.of(context);

    return MultiProvider(
      providers: [
        // Provides to react to theme changes on the fly
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
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          onGenerateRoute: _appRouter.onGenerateRoute,
        );
      },
    );
  }
}
