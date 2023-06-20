/// Represents an entry of the application.
class HintEntry {
  /// The name for this entry (website, application, ..).
  late String name;

  /// The hint for this entry (password indicator).
  late String hint;

  /// The optional identifier (username, email, ..).
  late String identifier;

  /// Default constructor.
  HintEntry(this.name, this.hint, this.identifier);

  /// Constructor from a JSON map.
  HintEntry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    hint = json['hint'];
    identifier = json['identifier'];
  }

  /// Converts this entry to a map convertible in JSON format.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['hint'] = hint;
    data['identifier'] = identifier;

    return data;
  }
}
