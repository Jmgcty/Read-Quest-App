import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/services/database/institution/institution_service.dart';

final getUserInstitutionProvider =
    FutureProvider.family((ref, int userID) async {
  return await InstitutionService.checkUserInstitution(userID);
});
