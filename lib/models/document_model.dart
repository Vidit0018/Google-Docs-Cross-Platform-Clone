import 'dart:convert';

class DocumentModel {
  final String title;
  final String uid;
  final List content;
  final DateTime createdAt;
  final String id;

  DocumentModel(
      {required this.title,
      required this.uid,
      required this.content,
      required this.createdAt,
      required this.id});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'title': title});
    result.addAll({'uid': uid});
    result.addAll({'content': content});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'id': id});
  
    return result;
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      title: map['title'] ?? '',
      uid:map['uid'] ?? '',
      content :List.from(map['content']),
      createdAt:  DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      id:map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) => DocumentModel.fromMap(json.decode(source));
}
