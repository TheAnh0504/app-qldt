import 'dart:io';

import 'package:app_qldt/model/entities/material_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/error/error.dart';
import '../model/repositories/auth_repository.dart';

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

final infoMaterialProvider =
AsyncNotifierProvider<AsyncInfoMaterialProviderNotifier, MaterialModel?>
  (AsyncInfoMaterialProviderNotifier.new);
class AsyncInfoMaterialProviderNotifier extends AsyncNotifier<MaterialModel?> {

  @override
  Future<MaterialModel?> build() async {
    return null;
  }

  void forward(AsyncValue<MaterialModel?> value) => state = value;

  Future<bool> uploadMaterial(File file, String classId, String title, String description, String materialType) async {
    state = const AsyncValue.loading();
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api.uploadMaterial(file, classId, title, description, materialType)
          .then((value) async {
        return AsyncData(MaterialModel.fromJson(value['data']));
      });
      return true;
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
      return false;
    }
  }

  Future<bool> editMaterial(File file, String materialId, String title, String description, String materialType) async {
    state = const AsyncValue.loading();
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api.editMaterial(file, materialId, title, description, materialType)
          .then((value) async {
        return AsyncData(MaterialModel.fromJson(value['data']));
      });
      return true;
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteMaterial(String material_id) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.deleteMaterial(material_id)
          .then((value) async {
        print('delete material: $value');
      });
      return true;
    } on Map<String, dynamic> catch (map) {
      return false;
    }
  }

  Future<void> getInfoMaterial(String material_id) async {
    state = const AsyncValue.loading();
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api.getInfoMaterial(material_id)
          .then((value) async {
        return AsyncData(MaterialModel.fromJson(value['data']));
      });
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }

}