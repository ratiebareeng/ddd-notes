import 'package:auto_route/auto_route.dart';
import 'package:ddd_notes/presentation/notes/notes_overview/notes_overview_page.dart';
import 'package:ddd_notes/presentation/sign_in/sign_in_page.dart';
import 'package:ddd_notes/presentation/splash/splash_page.dart';
import 'package:flutter/widgets.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName:
      'Page,Route', // Shorten auto-generated route names from e.g. BookListPageRoute to BookListRoute
  routes: [
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: SignInPage),
    AutoRoute(page: NotesOverviewPage),
    //MaterialRoute(page: SignInPage),
  ],
)
class AppRouter extends _$AppRouter {}
