import 'package:happy_dog_house/src/feature/rituals/model/dog.dart';

import 'package:happy_dog_house/src/feature/rituals/presentation/create_screen.dart';
import 'package:happy_dog_house/src/feature/rituals/presentation/detailed_screen.dart';
import 'package:happy_dog_house/src/feature/rituals/presentation/gallery_screen.dart';
import 'package:happy_dog_house/src/feature/rituals/presentation/history_screen.dart';
import 'package:happy_dog_house/src/feature/rituals/presentation/home_screen.dart';
import 'package:happy_dog_house/src/feature/rituals/presentation/tasks_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:happy_dog_house/src/feature/rituals/presentation/vactination_screen.dart';

import '../src/feature/splash/presentation/screens/splash_screen.dart';
import 'root_navigation_screen.dart';
import 'route_value.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildGoRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteValue.splash.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) {
        return NoTransitionPage(
          child: RootNavigationScreen(
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: RouteValue.home.path,
              builder: (context, state) => HomeScreen(key: UniqueKey()),
              routes: [
                GoRoute(
                  path: RouteValue.detailed.path,
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: DetailedScreen(
                      key: UniqueKey(),
                      dog: state.extra! as Dog,
                    ),
                  ),
                  routes: [
                    GoRoute(
                        path: RouteValue.task.path,
                        pageBuilder: (context, state) => NoTransitionPage(
                              child: TasksScreen(
                                dog: state.extra as Dog,
                                key: UniqueKey(),
                              ),
                            ),
                        routes: [
                          GoRoute(
                            path: RouteValue.history.path,
                            pageBuilder: (context, state) => NoTransitionPage(
                              child: HistoryScreen(
                                dog: state.extra as Dog,
                                key: UniqueKey(),
                              ),
                            ),
                          ),
                        ]),
                    GoRoute(
                      path: RouteValue.create.path,
                      pageBuilder: (context, state) => NoTransitionPage(
                        child: CreateScreen(
                          key: UniqueKey(),
                          dog: state.extra! as Dog,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: RouteValue.vactination.path,
                      pageBuilder: (context, state) => NoTransitionPage(
                        child: VactinationScreen(
                          key: UniqueKey(),
                          dog: state.extra! as Dog,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: RouteValue.gallery.path,
                      pageBuilder: (context, state) => NoTransitionPage(
                        child: GalleryScreen(
                          key: UniqueKey(),
                          dog: state.extra! as Dog,
                        ),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: RouteValue.create.path,
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: CreateScreen(
                      key: UniqueKey(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.black,
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteValue.splash.path,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),
      ],
    ),
  ],
);
