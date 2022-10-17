import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:web_project/globalWidget.dart';

import 'auth_service.dart';
import 'color.dart';
import 'lessonAdd.dart';
import 'lesson_service.dart';
import 'memberList.dart';
import 'member_service.dart';
import 'userInfo.dart';
import 'lessonInfo.dart';

class MemberInfo extends StatefulWidget {
  const MemberInfo({super.key});

  @override
  State<MemberInfo> createState() => _MemberInfoState();
}

class _MemberInfoState extends State<MemberInfo> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    // 이전 화면에서 보낸 변수 받기
    final userInfo = ModalRoute.of(context)!.settings.arguments as UserInfo;
    return Consumer<LessonService>(builder: (context, lessonService, child) {
      // lessonService
      // ignore: dead_code
      return Scaffold(
        appBar: BaseAppBarMethod(context, "회원 관리", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberList(),
              // setting에서 arguments로 다음 화면에 회원 정보 넘기기
              settings: RouteSettings(
                arguments: userInfo,
              ),
            ),
          );
        }),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BaseContainer(
                        name: userInfo.name,
                        registerDate: userInfo.registerDate,
                        goal: userInfo.goal,
                        info: userInfo.info,
                        note: userInfo.note,
                        phoneNumber: userInfo.phoneNumber,
                        isActive: userInfo.isActive,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '회원정보',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '목표',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                userInfo.goal,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                '신체특이사항/체형분석',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                userInfo.info,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                '메모',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                userInfo.note,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '동작',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Expanded(
                        child: FutureBuilder<QuerySnapshot>(
                          future: lessonService.read(
                            user.uid,
                            userInfo.phoneNumber,
                          ),
                          builder: (context, snapshot) {
                            final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                            if (docs.isEmpty) {
                              return Center(child: Text("동작 목록을 준비 중입니다."));
                            }
                            return GroupedListView(
                              elements: docs,
                              groupBy: (element) => element['actionName'],
                              groupSeparatorBuilder: (String value) =>
                                  GroupActionContainer(actionName: value),
                              itemBuilder:
                                  (BuildContext context, dynamic docs) =>
                                      ActionContainer(
                                          apratusName: docs['apratusName'],
                                          actionName: docs['actionName'],
                                          lessonDate: docs['lessonDate'],
                                          grade: docs['grade'],
                                          totalNote: docs['totalNote']),
                              order: GroupedListOrder.ASC,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// 추가 버튼
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      color: Palette.buttonOrange,
                    ),
                    height: 60,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "노트추가",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    print("노트추가");
                    // LessonAdd로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonAdd(),
                        // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                        settings: RouteSettings(
                          arguments: userInfo,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // Figma 확인 해보면 '회원정보' 탭에는 BottomAppBar 없는데, '동작' 탬에는 있음
        // 같은 화면인데 '회원정보' 탭에는 누락 된 듯하여 추가 BottomAppBar 함
        bottomNavigationBar: BaseBottomAppBar(),
      );
    });
  }
}
