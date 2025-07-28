import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/services/shared_preferences/shared_pref_helper.dart';
import 'package:read_quest/routing/app_router.dart';
import 'package:read_quest/routing/route_names.dart';

import '../core/services/shared_preferences/shared_pref_enum.dart';
import '../core/utils/user_role.dart';

final routerProvider = Provider((ref) {
  return routeConfig(
    redirect: (context, state) async {
      final isAuthenticated =
          await SharedPrefHelper.get(SharedPrefKey.session) != null;

      final isHasInstitution =
          await SharedPrefHelper.get(SharedPrefKey.institutionKey) != null;

      final userRole = await SharedPrefHelper.get(SharedPrefKey.userRole);
      log('isAuthenticated $isAuthenticated');
      log('userRole $userRole');
      log('isHasInstitution $isHasInstitution');
      print('Current Route ${state.matchedLocation}');
      // final authState = ref.read(currentUserProvider);
      // if (authState.isLoading || authState.hasError) return null;

      if (state.matchedLocation == RouteNames.root.path) {
        if (isAuthenticated) {
          if (userRole == null) return RouteNames.membership.path;

          if (userRole == UserRole.admin.name.toString() ||
              userRole == UserRole.teacher.name.toString()) {
            return RouteNames.dashboard.path;
          } else {
            return RouteNames.home.path;
          }
        }
      }

      if (state.matchedLocation == RouteNames.membership.path) {
        if (!isAuthenticated) {
          return RouteNames.login.path;
        }
        if (!isHasInstitution) return RouteNames.membership.path;
        if (userRole == UserRole.teacher.name) return RouteNames.dashboard.path;
        if (userRole == UserRole.admin.name) return RouteNames.dashboard.path;
        if (userRole == UserRole.student.name) return RouteNames.home.path;
      }

      return null;
    },
  );
});
