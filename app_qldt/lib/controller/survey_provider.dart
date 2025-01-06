import 'dart:io';

import 'package:app_qldt/model/entities/survey_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/error/error.dart';
import '../model/repositories/auth_repository.dart';

final listSurveyProvider =
AsyncNotifierProvider<AsynclistSurveyProviderProviderNotifier, List<SurveyModel>?>
  (AsynclistSurveyProviderProviderNotifier.new);
class AsynclistSurveyProviderProviderNotifier extends AsyncNotifier<List<SurveyModel>?> {

  @override
  Future<List<SurveyModel>?> build() async {
    return null;
  }

  void forward(AsyncValue<List<SurveyModel>?> value) => state = value;

  Future<List<SurveyModel>> getAllSurvey(String class_id) async {
    state = const AsyncValue.loading();
    try {
      var listSurvey = <SurveyModel>[];
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api.getListSurvey(class_id).then((value) async {
        for (int i = 0; i < (value["data"] as List<dynamic>).length; i++) {
          listSurvey.add(SurveyModel.fromJson((value["data"] as List<dynamic>)[i]));
        }
        return AsyncData(listSurvey);
      });
      return listSurvey;
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
      return [];
    }
  }

  Future<bool> createSurvey(File? file, String classId, String title, String deadline, String? description) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.createSurvey(file, classId, title, deadline, description).then((value) async {
        print(value);
      });
      return true;
    } on Map<String, dynamic> catch (map) {
      return false;
    }
  }

  Future<bool> editSurvey(File? file, String assignmentId, String deadline, String? description) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.updateSurvey(file, assignmentId, deadline, description).then((value) async {
        print(value);
      });
      return true;
    } on Map<String, dynamic> catch (map) {
      return false;
    }
  }

  Future<bool> deleteSurvey(String survey_id) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.deleteSurvey(survey_id)
          .then((value) async {
        print('delete survey: $value');
      });
      return true;
    } on Map<String, dynamic> catch (map) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getListAssignment(String? type, String class_id) async {
    try {
      Map<String, dynamic> res = {};
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.getListAssignment(type, class_id).then((value) async {
        res = value;
      });
      return res;
    } on Map<String, dynamic> catch (map) {
      return {};
    }
  }

  Future<bool> submit11(File? file, String assignmentId, String? textResponse) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.submit(file, assignmentId, textResponse)
          .then((value) async {
        print('submit survey: $value');
      });
      return true;
    } on Map<String, dynamic> catch (map) {
      return false;
    }
  }

}