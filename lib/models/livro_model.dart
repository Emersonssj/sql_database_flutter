class Livro {
  final int? id;
  final String livroName;
  final String autorName;
  final int? exemplares;

  Livro({this.id, required this.livroName, required this.autorName, required this.exemplares});

  factory Livro.fromMap(Map<String, dynamic> json) => new Livro(
    id: json['id'],
    livroName: json['livroName'],
    autorName: json['autorName'],
    exemplares: json['exemplares']
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'livroName': livroName,
      'autorName': autorName,
      'exemplares': exemplares
    };
  }
}