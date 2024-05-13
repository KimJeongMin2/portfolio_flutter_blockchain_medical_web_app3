import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../notification.dart';

class DeliverScreen extends StatefulWidget {
  @override
  _DeliverScreenState createState() => _DeliverScreenState();
}

class _DeliverScreenState extends State<DeliverScreen> {
  final Stream<QuerySnapshot> _messagesStream = FirebaseFirestore.instance.collection('first').snapshots();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();

  // 싱글톤 인스턴스
  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  // 싱글톤 패턴의 팩토리 생성자
  static FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin {
    _flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
    return _flutterLocalNotificationsPlugin!;
  }

  void getMyDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print("내 디바이스 토큰: $token");
  }

  @override
  void initState(){
    super.initState();
    getMyDeviceToken();
    _initializeNotifications();
    FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true,
    );

    _messagesStream.listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          FlutterLocalNotification.showNotification(data);
        }
      });
    });
  }
  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메시지 전송'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: '내용'),
            ),
            TextField(
              controller: _senderController,
              decoration: InputDecoration(labelText: '보낸 사람'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Firestore에 데이터 추가
                await FirebaseFirestore.instance.collection('first').add({
                  'title': _titleController.text,
                  'body': _bodyController.text,
                  'sender': _senderController.text,
                });
                // 데이터 추가 후, 필드 초기화
                _titleController.clear();
                _bodyController.clear();
                _senderController.clear();
                // 선택적으로 성공 메시지 표시나 다른 화면으로의 이동 로직 추가
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _senderController.dispose();
    super.dispose();
  }
}