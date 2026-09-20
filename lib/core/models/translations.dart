class TranslationModel {
  final Map<String, String> data;

  const TranslationModel(this.data);

  TranslationModel.fromJson(Map<String, dynamic> json)
    : data = json.map((key, value) => MapEntry(key, value.toString()));

  String get(String key, {Map<String, Object> params = const {}}) {
    var value = data[key] ?? key;
    for (final entry in params.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value.toString());
    }
    return value;
  }
}
