import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_id_provider.g.dart';

@riverpod
class UserID extends _$UserID {
  @override
  int build() => 0;

  void setUserID(int userID) => state = userID;
}
