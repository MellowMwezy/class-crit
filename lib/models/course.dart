class Course {
  // final String? id;
  final String name;
  final String code;

  Course({
    required this.name,
    required this.code,
  });

  Course.fromJSON(Map<String, dynamic> json)
      : this.code = json['code'],
        this.name = json['name'];
}
