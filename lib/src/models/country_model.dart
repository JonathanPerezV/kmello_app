class Country {
  String name;
  String flag;
  String code;
  String dialCode;
  int minLength;
  int maxLength;

  Country({
    required this.code,
    required this.dialCode,
    required this.flag,
    required this.maxLength,
    required this.minLength,
    required this.name,
  });
}
