import '../models/tag_model.dart';

class TagService {
  // Örnek tag listesi
  final List<TagModel> _tags = [
    TagModel(id: 5, name: "Yazılım"),
    TagModel(id: 6, name: "Mobil"),
    TagModel(id: 7, name: "Web"),
    TagModel(id: 8, name: "Siber Güvenlik"),
    TagModel(id: 9, name: "Php"),
    TagModel(id: 10, name: "Java"),
    TagModel(id: 11, name: "Python"),
    TagModel(id: 12, name: "Flutter"),
    TagModel(id: 13, name: "Dart"),
    TagModel(id: 14, name: "JavaScript"),
    TagModel(id: 15, name: "C#"),
    TagModel(id: 16, name: "C++"),
    TagModel(id: 17, name: "Ruby"),
    TagModel(id: 18, name: "Swift"),
    TagModel(id: 19, name: "Kotlin"),
    TagModel(id: 20, name: "Go"),
    TagModel(id: 21, name: "Rust"),
    TagModel(id: 22, name: "TypeScript"),
    TagModel(id: 23, name: "HTML"),
    TagModel(id: 24, name: "CSS"),
  ];

  Future<List<TagModel>> getTags() async {
    await Future.delayed(const Duration(milliseconds: 300)); // simüle async
    return _tags;
  }

  TagModel? getTagById(int id) {
    try {
      return _tags.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
