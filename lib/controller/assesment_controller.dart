import 'package:get/get.dart';

class AssessmentController extends GetxController {
  final RxInt totalScore = 0.obs;
  final RxString category = ''.obs;

  void setResult(int score, String resultCategory) {
    totalScore.value = score;
    category.value = resultCategory;
  }
}