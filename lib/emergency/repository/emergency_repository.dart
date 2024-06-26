import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/board/model/question.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/emergency/model/emergency.dart';


class EmergencyRepository {
  String? baseUrl = dotenv.env['BASE_URL'];


  Future<Emergency> fetchEmergency(String? userId) async {
    final uri = Uri.parse('$baseUrl/patient/get-my-urgent-data');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': userId,
      }),
    );

    print(uri);
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final emergency = Emergency.myUrgentContentFromJson(data);
      return emergency;
    } else {
      throw Exception('Failed to fetch emergency data');
    }
  }

  Future<void> deleteMyEmergencyData(String userId) async {
    final uri = Uri.parse('$baseUrl/patient/urgent-data/$userId');
    final response = await http.delete(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete question');
    }
  }

  Future<List<Emergency>> fetchEmergencyViewHistory(String? userId) async {
    final uri = Uri.parse('$baseUrl/patient/$userId/urgent-data-view-history')
        .replace(queryParameters: {
      'patientId': userId,
    });

    print(uri);
    final response = await http.get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final history = (data['history'] as List)
          .map((history) => Emergency.myEmergencyDataHistoryFromJson(history))
          .toList();
      return history;
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

//
  // Future<void> deleteQuestion(int questionId) async {
  //   final uri = Uri.parse('$baseUrl/api/test-0/question/$questionId');
  //   final response = await http.delete(uri);
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to delete question');
  //   }
  // }
  //
  // Future<List<Question>> myBoardList({String? userId}) async {
  //   final uri = Uri.parse('$baseUrl/api/v1/question')
  //       .replace(queryParameters: {
  //     'userId': userId,
  //   });
  //
  //   print(uri);
  //   final response = await http.get(uri);
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     final data = json.decode(utf8.decode(response.bodyBytes));
  //     final questions = (data['questions'] as List)
  //         .map((question) => Question.fromJson(question))
  //         .toList();
  //     return questions;
  //   } else {
  //     throw Exception('Failed to fetch questions');
  //   }
  // }
  //
  //
  // Future<void> updateQuestion(
  //     int questionId,
  //     String title,
  //     String symptom,
  //     String content,
  //     ) async {
  //   print("여기");
  //   print(questionId);
  //   print(title);
  //   print(symptom);
  //   print(content);
  //   final uri = Uri.parse('$baseUrl/api/test-0/question');
  //   final body = jsonEncode({
  //     'questionId': questionId,
  //     'title': title,
  //     'symptom': symptom,
  //     'content': content,
  //   });
  //   final response = await http.patch(
  //     uri,
  //     headers: {'Content-Type': 'application/json'},
  //     body: body,
  //   );
  //   print(body);
  //   print(uri);
  //   print(response.body);
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to update question');
  //   }
  // }
}

