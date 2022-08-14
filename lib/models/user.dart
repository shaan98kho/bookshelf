class User {
  final String uId;
  final String uName;
  final String uEmail;

  User({
    required this.uId,
    required this.uName,
    required this.uEmail,
  });

  Map<String, dynamic> toJson() => {
        'id': uId,
        'name': uName,
        'email': uEmail,
      };
}
