class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    this.image,
    this.cuisine,
    this.difficulty,
    this.rating,
    this.servings,
    this.prepMinutes,
    this.cookMinutes,
    this.mealTypes = const [],
    this.ingredients = const [],
    this.instructions = const [],
  });

  final int id;
  final String name;
  final String? image;
  final String? cuisine;
  final String? difficulty;
  final double? rating;
  final int? servings;
  final int? prepMinutes;
  final int? cookMinutes;
  final List<String> mealTypes;
  final List<String> ingredients;
  final List<String> instructions;

  static Recipe? tryParse(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    if (id is! num) return null;
    final name = _text(json['name']);
    final servings = _int(json['servings']);

    return Recipe(
      id: id.toInt(),
      name: name ?? 'Receita sem nome',
      image: _text(json['image']),
      cuisine: _text(json['cuisine']),
      difficulty: _difficulty(_text(json['difficulty'])),
      rating: json['rating'] is num ? (json['rating'] as num).toDouble() : null,
      servings: servings != null && servings > 0 ? servings : null,
      prepMinutes: _int(json['prepTimeMinutes']),
      cookMinutes: _int(json['cookTimeMinutes']),
      mealTypes: _list(json['mealType']),
      ingredients: _list(json['ingredients']),
      instructions: _list(json['instructions']),
    );
  }

  ({String valor, String legenda})? get tempo {
    final p = prepMinutes;
    final c = cookMinutes;
    if (p != null && c != null) {
      return (valor: '${p + c} min', legenda: 'tempo total');
    }
    if (p != null) return (valor: '$p min', legenda: 'preparo');
    if (c != null) return (valor: '$c min', legenda: 'cozimento');
    return null;
  }

  String? get tempoCurto {
    final t = tempo;
    if (t == null) return null;
    return prepMinutes != null && cookMinutes != null
        ? t.valor
        : '${t.valor} de ${t.legenda}';
  }

  String? get nota {
    final r = rating;
    if (r == null) return null;
    return '${r.toStringAsFixed(1).replaceAll('.', ',')} / 5';
  }

  static String? _text(Object? v) {
    if (v is! String) return null;
    final t = v.trim();
    return t.isEmpty ? null : t;
  }

  static int? _int(Object? v) => v is num ? v.toInt() : null;

  static List<String> _list(Object? v) {
    if (v is String) return _text(v) == null ? const [] : [v.trim()];
    if (v is! List) return const [];
    return v.map(_text).whereType<String>().toList();
  }

  static String? _difficulty(String? v) {
    switch (v?.toLowerCase()) {
      case 'easy':
        return 'Fácil';
      case 'medium':
        return 'Médio';
      case 'hard':
        return 'Difícil';
      default:
        return v;
    }
  }
}
