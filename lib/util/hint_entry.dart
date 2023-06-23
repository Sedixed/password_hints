/// Represents an entry of the application.
class HintEntry {
  /// The name for this entry (website, application, ..).
  late String _name;

  /// The hint for this entry (password indicator).
  late String _hint;

  /// The optional identifier (username, email, ..).
  late String _identifier;

  /// Default constructor.
  HintEntry(this._name, this._hint, this._identifier);

  /// Constructor from a JSON map.
  HintEntry.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _hint = json['hint'];
    _identifier = json['identifier'];
  }

  /// Converts this entry to a map convertible in JSON format.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = _name;
    data['hint'] = _hint;
    data['identifier'] = _identifier;
    return data;
  }

  String get name => _name;
  String get hint => _hint;
  String get identifier => _identifier;
  set name(String name) => _name = name;
  set hint(String hint) => _hint = hint;
  set identifier(String identifier) => _identifier = identifier;
}
