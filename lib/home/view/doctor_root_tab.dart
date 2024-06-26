import 'package:flutter/material.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/board/view/board_category_list_screen.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/home/view/custom_app_bar.dart';
import '../../colors.dart';
import '../../mypage/doctor_profile_screen.dart';
import '../layout/default_layout.dart';
import 'doctor_home_screen.dart';
import 'home_screen.dart';

class DoctorRootTab extends StatefulWidget {
  static String get routeName => 'doctorHome';

  const DoctorRootTab({Key? key}) : super(key: key);

  @override
  State<DoctorRootTab> createState() => _DoctorRootTabState();
}

class _DoctorRootTabState extends State<DoctorRootTab>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  int index = 0;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 3, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener(){
    setState((){
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar:CustomAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '마이 페이지',
          ),

        ],
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          DoctorHomeScreen(),
          BoardCategoryListScreen(),
          DoctorProfileScreen(),
        ],
      ),
    );
  }
}