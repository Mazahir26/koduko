import 'dart:convert';

class Payload {
  late String uId;
  late String title;
  late String des;
  late bool isDaily;

  Payload(
      {required this.uId,
      required this.title,
      required this.des,
      required this.isDaily});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'title': title,
      'des': des,
      'isDaily': isDaily,
    };
  }

  factory Payload.fromMap(Map<String, dynamic> map) {
    return Payload(
      uId: map['uId'] as String,
      title: map['title'] as String,
      des: map['des'] as String,
      isDaily: map['isDaily'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Payload.fromJson(String source) =>
      Payload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Payload(uId: $uId, title: $title, des: $des, isDaily: $isDaily)';
}
