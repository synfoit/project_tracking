class Token {
  String token;
  String ssoNumber;
  String orderType;

  Token(this.token, this.ssoNumber, this.orderType);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'token': token,
      'ssonumber': ssoNumber,
      'orderType': orderType
    };
    return map;
  }

  factory Token.fromMap(Map data) {
    return Token(data["token"] as String, data["ssonumber"] as String,
        data["orderType"] as String);
  }
}
