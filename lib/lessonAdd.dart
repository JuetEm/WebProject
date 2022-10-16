import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_project/userInfo.dart';

import 'auth_service.dart';
import 'baseTableCalendar.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';
import 'memberInfo.dart';
import 'lesson_service.dart';

GlobalFunction globalFunction = GlobalFunction();

String selectedDropdown = '기구';
List<String> dropdownList = [
  'REFORMER',
  'CADILLAC',
  'CHAIR',
  'LADDER BARREL',
  'SPRING BOARD',
  'SPINE CORRECTOR',
  'MAT'
];

class LessonAdd extends StatefulWidget {
  const LessonAdd({super.key});

  @override
  State<LessonAdd> createState() => _LessonAddState();
}

class _LessonAddState extends State<LessonAdd> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    // 이전 화면에서 보낸 변수 받기
    final userInfo = ModalRoute.of(context)!.settings.arguments as UserInfo;

    TextEditingController nameController =
        TextEditingController(text: userInfo.name);
    TextEditingController apratusNameController = TextEditingController();
    TextEditingController actionNameController = TextEditingController();
    TextEditingController lessonDateController = TextEditingController();
    TextEditingController gradeController = TextEditingController();
    TextEditingController totalNoteController = TextEditingController();
    return Consumer<LessonService>(
      builder: (context, lessonService, child) {
        return Scaffold(
          appBar: BaseAppBarMethod(context, "노트 추가"),
          body: SafeArea(
            child: Column(
              children: [
                /// 입력창
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// 기구 입력창
                        BasePopupMenuButton(
                          customController: apratusNameController,
                          hint: "기구",
                          showButton: true,
                          dropdownList: dropdownList,
                          customFunction: () {},
                        ),

                        /// 수업일 입력창
                        BaseTextField(
                          customController: lessonDateController,
                          hint: "수업일",
                          showArrow: true,
                          customFunction: () {
                            globalFunction.getDateFromCalendar(
                                context, lessonDateController);
                          },
                        ),

                        /// 전화번호 입력창
                        BaseTextField(
                          customController: actionNameController,
                          hint: "동작이름",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// 수행도 입력창
                        BaseTextField(
                          customController: gradeController,
                          hint: "수행도",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        Slider(
                            value: 50,
                            min: 0,
                            max: 100,
                            divisions: 6,
                            onChanged: (value) {
                              setState(() {
                                gradeController.text = "${value}";
                              });
                            }),

                        /// 메모 입력창
                        BaseTextField(
                          customController: totalNoteController,
                          hint: "메모",
                          showArrow: false,
                          customFunction: () {},
                        ),
                        Divider(height: 1),

                        /// 추가 버튼
                        ElevatedButton(
                          child: Text("저장하기", style: TextStyle(fontSize: 21)),
                          onPressed: () {
                            print("추가 버튼");
                            // create bucket
                            if (globalFunction.textNullCheck(
                                    context,
                                    apratusNameController,
                                    "apratusNameController") &&
                                globalFunction
                                    .textNullCheck(context, lessonDateController,
                                        "lessonDateController") &&
                                globalFunction.textNullCheck(
                                    context,
                                    actionNameController,
                                    "actionNameController") &&
                                globalFunction.textNullCheck(context,
                                    gradeController, "gradeController") &&
                                globalFunction.textNullCheck(
                                    context,
                                    totalNoteController,
                                    "totalNoteController")) {
                              String now = DateFormat("yyyy-MM-dd")
                                  .format(DateTime.now()); // 오늘 날짜 가져오기
                              lessonService.create(
                                  uid: user.uid,
                                  name: nameController.text,
                                  phoneNumber: userInfo
                                      .phoneNumber, // 회권 고유번호 => 전화번호로 회원 식별
                                  apratusName:
                                      apratusNameController.text, //기구이름
                                  actionName: actionNameController.text, //동작이름
                                  lessonDate: now, //수업날짜
                                  grade: gradeController.text, //수행도
                                  totalNote: totalNoteController.text, //수업총메모
                                  onSuccess: () {
                                    // 저장하기 성공
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("저장하기 성공"),
                                    ));
                                    // 저장하기 성공시 Home로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MemberInfo(),
                                        // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                        settings: RouteSettings(
                                          arguments: userInfo,
                                        ),
                                      ),
                                    );
                                  },
                                  onError: () {
                                    print("저장하기 ERROR");
                                  });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("항목을 모두 입력해주세요."),
                              ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }
}
