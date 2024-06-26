import 'package:flutter/widgets.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/board/model/question.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/board/repository/board_repository.dart';
import 'package:state_notifier/state_notifier.dart';

class QuestionViewModel extends ChangeNotifier {

  final QuestionRepository _repository;
  List<Question> _questions = [];

  QuestionViewModel(this._repository);

  List<Question> get questions => _questions;

  Future<void> fetchQuestions({String? category}) async {
    try {
      print("실행?");
      _questions = await _repository.fetchQuestions(category: category);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching questions: $e');
    }
  }

  Future<void> deleteQuestion(Question question) async {
    try {
      await _repository.deleteQuestion(question.id);
      _questions.remove(question);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error deleting question: $e');
    }
  }

  Future<void> myBoardQuestion( {String? userId}) async {
    try {
      _questions = await _repository.myBoardList(userId: userId);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error deleting question: $e');
    }
  }

  Future<void> updateQuestion(
      int questionId,
      String title,
      String symptom,
      String content,
      ) async {
    try {
      print(questionId);
      print(title);
      print(symptom);
      print(content);
      await _repository.updateQuestion(
        questionId,
        title,
        symptom,
        content,
      );
      // 질문 목록 업데이트
      await fetchQuestions();
    } catch (e) {
      // Handle error
      print('Error updating question: $e');
    }
  }



  // final QuestionRepository _repository;
  // List<Question> _questions = [];
  //
  // QuestionViewModel(this._repository);
  //
  // List<Question> get questions => _questions;
  //
  // Future<void> fetchQuestions({String? category}) async {
  //   try {
  //     print("실행?");
  //     _questions = await _repository.fetchQuestions(category: category);
  //     notifyListeners();
  //   } catch (e) {
  //     // Handle error
  //     print('Error fetching questions: $e');
  //   }
  // }
  //



  // Future<void> fetchQuestions({String? category, String? userId}) async {
  //   try {
  //     print("실행?");
  //     _questions = await _repository.fetchQuestions(category: category, userId: userId);
  //     notifyListeners();
  //   } catch (e) {
  //     // Handle error
  //     print('Error fetching questions: $e');
  //   }
  // }

  // Future<void> fetchQuestions() async {
  //   try {
  //     print("실행?");
  //     _questions = await _repository.fetchQuestions();
  //     notifyListeners();
  //   } catch (e) {
  //     // Handle error
  //   }
  // }

}
