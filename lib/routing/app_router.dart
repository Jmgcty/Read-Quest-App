import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:read_quest/features/auth/signup/views/signup_screen.dart';
import 'package:read_quest/features/home/membership/views/membership_screen.dart';
import 'package:read_quest/features/home/officials/views/add_module_screen.dart';
import 'package:read_quest/features/home/officials/views/dashboard_screen.dart';
import 'package:read_quest/features/home/officials/views/reading_modules_screen.dart';
import 'package:read_quest/features/home/student/views/home_screen.dart';
import 'package:read_quest/features/profile/views/profile_screen.dart';
import 'package:read_quest/features/shell/views/shell_screen.dart';
import '../features/auth/login/views/login_screen.dart';
import '../features/books/views/book_screen.dart';
import '../features/books/views/read_book.dart';
import '../features/home/officials/views/view_reading_module.dart';
import '../features/start/views/get_started_screen.dart';
import 'route_names.dart';

typedef GoRouterRedirect = FutureOr<String?> Function(
    BuildContext context, GoRouterState state);

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _shellANavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellBNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellCNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');

GoRouter routeConfig({GoRouterRedirect? redirect}) => GoRouter(
      debugLogDiagnostics: true,
      initialLocation: RouteNames.root.path,
      navigatorKey: _rootNavigatorKey,
      redirect: redirect,
      routes: [
        GoRoute(
          path: RouteNames.root.path,
          name: RouteNames.root.name,
          builder: (context, state) => const GetStartedScreen(),
        ),
        GoRoute(
          path: RouteNames.login.path,
          name: RouteNames.login.name,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RouteNames.signup.path,
          name: RouteNames.signup.name,
          builder: (context, state) => const SignupScreen(),
        ),
        //
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              ShellScaffoldWithNavBar(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              initialLocation: RouteNames.membership.path,
              navigatorKey: _shellANavigatorKey,
              routes: [
                GoRoute(
                  path: RouteNames.membership.path,
                  name: RouteNames.membership.name,
                  builder: (context, state) => const MembershipScreen(),
                ),
                GoRoute(
                  path: RouteNames.dashboard.path,
                  name: RouteNames.dashboard.name,
                  builder: (context, state) => const DashboardScreen(),
                ),
                GoRoute(
                  path: RouteNames.home.path,
                  name: RouteNames.home.name,
                  builder: (context, state) => const HomeScreen(),
                ),
                GoRoute(
                  path: RouteNames.modules.path,
                  name: RouteNames.modules.name,
                  builder: (context, state) => const ReadingModulesScreen(),
                  routes: [
                    GoRoute(
                      path: RouteNames.addModule.path,
                      name: RouteNames.addModule.name,
                      builder: (context, state) => const AddModuleScreen(),
                    ),
                    GoRoute(
                      path: RouteNames.readModule.path,
                      name: RouteNames.readModule.name,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final file =
                            Uri.decodeComponent(state.pathParameters['file']!);
                        final title =
                            Uri.decodeComponent(state.pathParameters['title']!);
                        return PDFViewerScreen(title: title, pdfUrl: file);
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              initialLocation: RouteNames.book.path,
              navigatorKey: _shellBNavigatorKey,
              routes: [
                GoRoute(
                  path: RouteNames.book.path,
                  name: RouteNames.book.name,
                  builder: (context, state) => const BookScreen(),
                  routes: [
                    GoRoute(
                      path: RouteNames.readBook.path,
                      name: RouteNames.readBook.name,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final file =
                            Uri.decodeComponent(state.pathParameters['file']!);
                        final title =
                            Uri.decodeComponent(state.pathParameters['title']!);
                        return BookViewerScreen(title: title, pdfUrl: file);
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              initialLocation: RouteNames.profile.path,
              navigatorKey: _shellCNavigatorKey,
              routes: [
                GoRoute(
                  path: RouteNames.profile.path,
                  name: RouteNames.profile.name,
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
