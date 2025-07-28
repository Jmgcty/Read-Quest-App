import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading_provider.g.dart';

@riverpod
class Loading extends _$Loading {
  @override
  bool build() => false;

  void setLoading(bool value) => state = value;
}
