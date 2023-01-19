class HintEntry {
  late String name;
  late String hint;
  late String identifier;

  HintEntry(this.name, this.hint, this.identifier);

  HintEntry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    hint = json['hint'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['hint'] = hint;
    data['identifier'] = identifier;

    return data;
  }
}
