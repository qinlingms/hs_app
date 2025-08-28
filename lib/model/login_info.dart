class LoginInfo{
  String sessionId;
  String authToken;
  int ttl;
  LoginInfo(this.sessionId, this.authToken, this.ttl);
  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(json['sessionId'], json['authToken'], json['ttl']);
  }
}