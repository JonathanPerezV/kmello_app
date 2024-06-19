class PortalInfo {
  final String name;
  final List<String> domains;
  final List<Object> noOfArtcles;

  PortalInfo(
      {required this.name, required this.domains, required this.noOfArtcles});

  factory PortalInfo.fromJson(Map<String, dynamic> parsedJson) {
    return PortalInfo(
        name: parsedJson['name'],
        domains: parsedJson['domains'],
        noOfArtcles: parsedJson['noOfArticles']);
  }
}

Map<String, dynamic> portaInfoMap = {
  "name": "Vitalflux.com",
  "domains": ["Data Science", "Mobile", "Web"],
  "noOfArticles": [
    {"type": "data science", "count": 50},
    {"type": "web", "count": 75}
  ]
};
