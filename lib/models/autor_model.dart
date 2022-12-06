class Autor {
  final int? id;
  final String autorName;

  Autor({this.id, required this.autorName});

  factory Autor.fromMap(Map<String, dynamic> json) => new Autor(
    id: json['id'],
    autorName: json['autorName'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'autorName': autorName,
    };
  }
}