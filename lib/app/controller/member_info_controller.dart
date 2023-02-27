import 'dart:developer';

import 'package:web_project/app/data/model/lessonInfo.dart';
import 'package:web_project/app/data/model/lessonNoteInfo.dart';
import 'package:web_project/app/data/repository/lesson_repository.dart';

class MemberInfoController {
  MemberInfoController();

  LessonRepository lessonRepository = LessonRepository();

  Future<List> getLessonDayAndActionNoteData(
      String uid, String memberId) async {
    List lessonNoteInfoList = [];
    LessonNoteInfo lessonNoteInfo;
    List resultLessonNoteData = [];

    List lessonDayNoteList = await lessonRepository.getLessonDaynNote(uid);
    List lessonActionNoteList =
        await lessonRepository.getLessonActionNote(uid, memberId);

    lessonDayNoteList.forEach((lNelement) {
      lessonActionNoteList.forEach((aNelement) {
        lessonNoteInfo = LessonNoteInfo(
          uid,
          memberId,
          lNelement['name'],
          lNelement['phoneNumber'],
          lNelement['lessonDate'],
          aNelement['actionName'],
          aNelement['grade'],
          aNelement['pos'],
          aNelement['totalNote'],
          aNelement['apratusName'],
          aNelement['timestamp'],
          lNelement['todayNote'],
          lNelement['timestamp'],
          aNelement['totalNote'].toString().isNotEmpty ? true : false,
          aNelement['id'],
          lNelement['id'],
        );
        print("C'MON ALBERT - uid : ${uid}, memberId : ${memberId}, lNelement['name'] : ${lNelement['name']}, lNelement['phoneNumber'] : ${lNelement['phoneNumber']}, lNelement['lessonDate'] : ${lNelement['lessonDate']}, aNelement['actionName'] : ${aNelement['actionName']}, aNelement['grade'] : ${aNelement['grade']}, aNelement['pos'] : ${aNelement['pos']}, aNelement['totalNote'] : ${aNelement['totalNote']}, aNelement['apratusName'] : ${aNelement['apratusName']}, aNelement['timestamp'] : ${aNelement['timestamp']}, lNelement['todayNote'] : ${lNelement['todayNote']}, lNelement['timestamp'] : ${lNelement['timestamp']}, false, aNelement['id'] : ${aNelement['id']}, lNelement['id'] : ${lNelement['id']}");
        // print("lessonNoteInfo : ${lessonNoteInfo}");
        // inspect(lessonNoteInfoList);
        lessonNoteInfoList.add(lessonNoteInfo);
      });
    });

    return resultLessonNoteData;
  }
}