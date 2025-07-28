import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/services/database/module/module_service.dart';

final getUserUploadsProvider =
    FutureProvider((ref) => ModuleService.getModulesByUploader());

final getModulesProvider = FutureProvider((ref) => ModuleService.getModules());
