import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_project/color.dart';
import 'package:web_project/memberList_admin.dart';

// BBZKGmz56W-GOXCUlzkRuupvFLEOZcvJpt3NCmst0ZibT8SFS-5Q4X3jxUEac3D726CV_i4mW6kCE0ldyBUykHM

var fcmToken = null;

late FocusNode pageFocusNode;
late SingleValueDropDownController reportPageController;

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool pageOffstage = true;

  TextEditingController pageName = TextEditingController();
  TextEditingController errorContents = TextEditingController();

  /* 회원목록/회원목록/노트보기/회원정보 수정/
회원등록/노트추가/동작선택/동작추가 */
  final pages = [
    DropDownValueModel(
        name: "OTHERS", value: 'others', toolTipMsg: "등록하려는 자세가 없는 경우 선택해주세요."),
    DropDownValueModel(name: "회원목록", value: '회원목록', toolTipMsg: "회원목록"),
    DropDownValueModel(name: "회원목록", value: '회원목록', toolTipMsg: "회원목록"),
    DropDownValueModel(name: "노트보기", value: '노트보기', toolTipMsg: "노트보기"),
    DropDownValueModel(
        name: "회원정보 수정", value: '회원정보 수정', toolTipMsg: "회원정보 수정"),
    DropDownValueModel(name: "회원등록", value: '회원등록', toolTipMsg: "회원등록"),
    DropDownValueModel(name: "노트추가", value: '노트추가', toolTipMsg: "노트추가"),
    DropDownValueModel(name: "동작선택", value: '동작선택', toolTipMsg: "동작선택"),
    DropDownValueModel(name: "동작추가", value: '동작추가', toolTipMsg: "동작추가"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reportPageController = SingleValueDropDownController();

    pageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    reportPageController.dispose();

    pageFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            print('back');
            // 로그인 페이지로 이동
            Navigator.pop(context);
          },
          color: Palette.gray33,
          // icon: Icon(Icons.account_circle),
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 0,
        backgroundColor: Palette.mainBackground,
        title: Text(
          "오류 및 개선요청",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Palette.gray00,
              ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Palette.secondaryBackground,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Text('문제 페이지',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Palette.gray00,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: DropDownTextField(
                    controller: reportPageController,
                    isEnabled: true,
                    clearOption: false,
                    enableSearch: true,
                    // textFieldFocusNode: textFieldFocusNode,
                    // searchFocusNode: searchFocusNode,
                    clearIconProperty:
                        IconProperty(color: Palette.buttonOrange),
                    textFieldDecoration: InputDecoration(
                      hintText: "페이지를 선택하세요.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                      fillColor: Colors.white,
                    ),
                    searchDecoration: InputDecoration(
                      hintText: "검색하고 싶은 페이지를 입력하세요",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      print("position validator value : ${value}");
                      if (value == null) {
                        return "required field";
                      } else {
                        return null;
                      }
                    },
                    dropDownItemCount: pages.length,
                    dropDownList: pages,
                    onChanged: (val) {
                      print("position onChange val : ${val}");
                      print(
                          "positionController.dropDownValue : ${reportPageController.dropDownValue!.value}");
                      setState(() {
                        if (reportPageController.dropDownValue!.name ==
                            "OTHERS") {
                          pageOffstage = false;
                          pageFocusNode.requestFocus();
                        } else {
                          pageOffstage = true;
                        }
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Text('오류 및 개선요청 내용',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Palette.gray00,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.mainBackground,
                ),
                height: 300,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                  child: TextFormField(
                    maxLines: null,
                    controller: errorContents,
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: '오류가 발생한 내용 또는 개선이 필요한 부분을 알려주세요.',
                      hintStyle: TextStyle(color: Palette.gray99),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                    ),
                    style: TextStyle(color: Palette.gray00),
                    /* validator:
                          _model.textControllerValidator.asValidator(context), */
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: AlignmentDirectional(0, -0.05),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          height: 50,
                          child: Text("취소",
                              style: TextStyle(
                                  color: Palette.textRed, fontSize: 16)),
                        )),
                    TextButton(
                        onPressed: () {},
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          height: 50,
                          child: Text("제출",
                              style: TextStyle(
                                  color: Palette.textBlue, fontSize: 16)),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}