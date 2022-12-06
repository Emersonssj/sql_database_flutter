class GroupBy {
  final String autorName;
  final int totalLivros;

  GroupBy({required this.autorName, required this.totalLivros});

  factory GroupBy.fromMap(Map<String, dynamic> json) => new GroupBy(
      autorName: json['autorName'], totalLivros: json['totalLivros']);

  Map<String, dynamic> toMap() {
    return {'autorName': autorName, 'totalLivros': totalLivros};
  }
}
