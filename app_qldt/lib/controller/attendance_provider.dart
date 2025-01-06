import 'package:flutter_riverpod/flutter_riverpod.dart';

final listMaterialProvider =
AsyncNotifierProvider<AsynclistMaterialProviderNotifier, List<MaterialModel>?>
  (AsynclistMaterialProviderNotifier.new);
class AsynclistMaterialProviderNotifier extends AsyncNotifier<List<MaterialModel>?> {

  @override
  Future<List<MaterialModel>?> build() async {
    return null;
  }

  void forward(AsyncValue<List<MaterialModel>?> value) => state = value;

  Future<void> getListMaterial(String class_id) async {
    state = const AsyncValue.loading();
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api.getListMaterial(class_id).then((value) async {
        var listMaterial = <MaterialModel>[];
        for (int i = 0; i < (value["data"] as List<dynamic>).length; i++) {
          listMaterial.add(MaterialModel.fromJson((value["data"] as List<dynamic>)[i]));
        }
        return AsyncData(listMaterial);
      });
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }

}