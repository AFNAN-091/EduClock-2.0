
class Task{
  String? id;
  String? courseName;
  String? courseCode;
  String? roomNo;
  String? date;
  String? startTime;
  String? endTime;
  String? description;
  String? type;
  int? remind;
  int? color;

  Task({
    this.id,
    this.courseName,
    this.courseCode,
    this.roomNo,
    this.date,
    this.startTime,
    this.endTime,
    this.description,
    this.type,
    this.remind,
    this.color,
  });


  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      courseName: json['courseName'],
      courseCode: json['courseCode'],
      roomNo: json['roomNo'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      description: json['description'],
      type: json['type'],
      remind: json['remind'],
      color: json['color'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'courseCode': courseCode,
      'roomNo': roomNo,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
      'type': type,
      'remind': remind,
      'color': color,
    };
  }

}