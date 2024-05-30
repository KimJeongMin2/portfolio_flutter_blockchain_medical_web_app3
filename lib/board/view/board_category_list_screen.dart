
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/board/view/board_list_screen.dart';

class BoardCategoryListScreen extends ConsumerWidget {
  const BoardCategoryListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    _navigateToBoardEntireScreen(context, 'ENTIRE');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blue.withOpacity(0.8),
                          width: 2.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.dashboard, color: Colors.blueAccent, size: 35),
                        SizedBox(width: 8),
                        Text(
                          '전체 게시판',
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    _navigateToBoardEntireScreen(context, 'ELDERS');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blue.withOpacity(0.8),
                          width: 2.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.elderly_rounded, color: Colors.blueAccent, size: 35),
                        SizedBox(width: 8),
                        Text(
                          '노년층 게시판',
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    _navigateToBoardEntireScreen(context, 'MATERNITY');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blue.withOpacity(0.8),
                          width: 2.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.pregnant_woman, color: Colors.blueAccent, size: 35),
                        SizedBox(width: 8),
                        Text(
                          '임산부 게시판',
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToBoardEntireScreen(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BoardListScreen(category: category)),
    );
  }
}