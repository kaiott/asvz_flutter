class Lesson {
  final DateTime enrollmentFrom;
  final DateTime enrollmentUntil;
  final DateTime cancelationUntil;
  final DateTime starts;
  final DateTime ends;
  final int participantsMax;
  final int participantCount;
  final List<String> instructors;
  final String facility;
  final String room;
  final int id;
  final String number;
  final String sportName;

  Lesson({
    required this.enrollmentFrom,
    required this.enrollmentUntil,
    required this.cancelationUntil,
    required this.starts,
    required this.ends,
    required this.participantsMax,
    required this.participantCount,
    required this.instructors,
    required this.facility,
    required this.room,
    required this.id,
    required this.number,
    required this.sportName,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      enrollmentFrom: DateTime.parse(json["enrollmentFrom"]),
      enrollmentUntil: DateTime.parse(json["enrollmentUntil"]),
      cancelationUntil: DateTime.parse(json["cancelationUntil"]),
      starts: DateTime.parse(json["starts"]),
      ends: DateTime.parse(json["ends"]),
      participantsMax: json["participantsMax"],
      participantCount: json["participantCount"],
      instructors: List<String>.from((json["instructors"] as List).map((x) => x["name"] as String)),
      facility: json["facilities"][0]["name"],
      room: json["rooms"][0],
      id: json["id"],
      number: json["number"],
      sportName: json["sportName"],
    );
  }
}

final Map<String, dynamic> testJson = {
  "eventId":645896,
  "type":5,
  "enrollmentEnabled":true,
  "enrollmentFrom":"2025-07-17T10:00:00+02:00",
  "lotteryEnrollmentFrom":null,
  "lotteryEnrollmentTo":null,
  "lotteryParticipantsCount":null,
  "enrollmentUntil":"2025-07-18T10:00:00+02:00",
  "cancelationUntil":"2025-07-18T09:00:00+02:00",
  "starts":"2025-07-18T10:00:00+02:00",
  "ends":"2025-07-18T10:55:00+02:00",
  "cancellationDate":null,
  "cancellationReason":null,
  "participantsMin":null,
  "participantsMax":55,
  "participantCount":0,
  "instructors":[
    {"asvzId":81647,"name":"Alice Mylaeus"},
    {"asvzId":79533,"name":"Mina Monsef"}],
  "facilities":[
    {"facilityId":203,"nameShort":"SC IR","name":"Sport Center Irchel","url":"https://asvz.ch/anlage/45577-sport-center-irchel"}],
  "rooms":["Y30 Kleinsporthalle"],
  "requiredSkills":[],
  "subLessons":[],
  "isLiveStream":false,
  "id":663653,
  "baseType":3,
  "status":2,
  "number":"2025-L-663653",
  "sportId":119,
  "sportName":"Muscle Pump",
  "sportUrl":"https://asvz.ch/MusclePump",
  "title":"Training",
  "location":null,
  "webRegistrationType":6,
  "meetingPointInfo":null,
  "meetingPointCoordinates":null,
  "tlCommentActive":false,
  "tlCommentActiveInfo":false,
  "tlComment":null,
  "language":{"id":"117b1004-2137-4b60-8c63-34db3c5c61d6","code":"de","name":"German"},
  "languageInfo":"Deutsch",
  "levelId":16,
  "levelInfo":"Alle",
  "levelE":true,
  "levelM":false,
  "levelF":false,
};

final Map<String, dynamic> testJson1 = {
  "eventId":645896,
  "type":5,
  "enrollmentEnabled":true,
  "enrollmentFrom":"2025-07-17T10:00:00+02:00",
  "lotteryEnrollmentFrom":null,
  "lotteryEnrollmentTo":null,
  "lotteryParticipantsCount":null,
  "enrollmentUntil":"2025-07-18T10:00:00+02:00",
  "cancelationUntil":"2025-07-18T09:00:00+02:00",
  "starts":"2025-07-18T10:00:00+02:00",
  "ends":"2025-07-18T10:55:00+02:00",
  "cancellationDate":null,
  "cancellationReason":null,
  "participantsMin":null,
  "participantsMax":55,
  "participantCount":0,
  "instructors":[
    {"asvzId":81647,"name":"Alice Mylaeus"},
    {"asvzId":79533,"name":"Mina Monsef"}],
  "facilities":[
    {"facilityId":203,"nameShort":"SC IR","name":"Sport Center Irchel","url":"https://asvz.ch/anlage/45577-sport-center-irchel"}],
  "rooms":["Y30 Kleinsporthalle"],
  "requiredSkills":[],
  "subLessons":[],
  "isLiveStream":false,
  "id":663652,
  "baseType":3,
  "status":2,
  "number":"2025-L-663653",
  "sportId":119,
  "sportName":"Salsa",
  "sportUrl":"https://asvz.ch/MusclePump",
  "title":"Training",
  "location":null,
  "webRegistrationType":6,
  "meetingPointInfo":null,
  "meetingPointCoordinates":null,
  "tlCommentActive":false,
  "tlCommentActiveInfo":false,
  "tlComment":null,
  "language":{"id":"117b1004-2137-4b60-8c63-34db3c5c61d6","code":"de","name":"German"},
  "languageInfo":"Deutsch",
  "levelId":16,
  "levelInfo":"Alle",
  "levelE":true,
  "levelM":false,
  "levelF":false,
};

final Map<String, dynamic> testJson2 = {
  "eventId":645896,
  "type":5,
  "enrollmentEnabled":true,
  "enrollmentFrom":"2025-07-17T10:00:00+02:00",
  "lotteryEnrollmentFrom":null,
  "lotteryEnrollmentTo":null,
  "lotteryParticipantsCount":null,
  "enrollmentUntil":"2025-07-18T10:00:00+02:00",
  "cancelationUntil":"2025-07-18T09:00:00+02:00",
  "starts":"2025-07-18T10:00:00+02:00",
  "ends":"2025-07-18T10:55:00+02:00",
  "cancellationDate":null,
  "cancellationReason":null,
  "participantsMin":null,
  "participantsMax":55,
  "participantCount":0,
  "instructors":[
    {"asvzId":81647,"name":"Alice Mylaeus"},
    {"asvzId":79533,"name":"Mina Monsef"}],
  "facilities":[
    {"facilityId":203,"nameShort":"SC IR","name":"Sport Center Irchel","url":"https://asvz.ch/anlage/45577-sport-center-irchel"}],
  "rooms":["Y30 Kleinsporthalle"],
  "requiredSkills":[],
  "subLessons":[],
  "isLiveStream":false,
  "id":663654,
  "baseType":3,
  "status":2,
  "number":"2025-L-663653",
  "sportId":119,
  "sportName":"Body Combat",
  "sportUrl":"https://asvz.ch/MusclePump",
  "title":"Training",
  "location":null,
  "webRegistrationType":6,
  "meetingPointInfo":null,
  "meetingPointCoordinates":null,
  "tlCommentActive":false,
  "tlCommentActiveInfo":false,
  "tlComment":null,
  "language":{"id":"117b1004-2137-4b60-8c63-34db3c5c61d6","code":"de","name":"German"},
  "languageInfo":"Deutsch",
  "levelId":16,
  "levelInfo":"Alle",
  "levelE":true,
  "levelM":false,
  "levelF":false,
};

final List<Lesson> testLessons = [Lesson.fromJson(testJson), Lesson.fromJson(testJson1), Lesson.fromJson(testJson2)];

