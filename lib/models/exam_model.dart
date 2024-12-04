class Exam {
  final String courseName;
  final String courseCode;
  final String examType;
  final String date;
  final String errorDate;
  final String syllabus;
  final String roomNo;
  final String startTime;
  final String examHour;
  final String type;
  final int color;

  Exam({
    required this.courseName,
    required this.courseCode,
    required this.examType,
    required this.date,
    required this.errorDate,
    required this.syllabus,
    required this.roomNo,
    required this.startTime,
    required this.examHour,
    required this.type,
    required this.color,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      courseName: json['courseName'],
      courseCode: json['courseCode'],
      examType: json['examType'],
      date: json['date'],
      errorDate: json['errorDate'],
      syllabus: json['syllabus'],
      roomNo: json['roomNo'],
      startTime: json['startTime'],
      examHour: json['examHour'],
      type: json['type'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseName': courseName,
      'courseCode': courseCode,
      'examType': examType,
      'date': date,
      'errorDate': errorDate,
      'syllabus': syllabus,
      'roomNo': roomNo,
      'startTime': startTime,
      'examHour': examHour,
      'type': type,
      'color': color,
    };
  }


}