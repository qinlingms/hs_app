class ApiResponse<T> {
  final int code;
  final String msg;
  final int serverTime;
  final T? data;

  ApiResponse({
    required this.code,
    required this.msg,
    required this.serverTime,
    this.data,
  });

  // 从JSON创建对象
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, 
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] as int,
      msg: json['msg'] as String,
      serverTime: json['serverTime'] as int,
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'] as T?,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'serverTime': serverTime,
      'data': data,
    };
  }

  // 判断请求是否成功（通常code为0表示成功，你可以根据实际情况调整）
  bool get isSuccess => code == 200;

  // 判断请求是否失败
  bool get isFailure => !isSuccess;

  @override
  String toString() {
    return 'ApiResponse{code: $code, msg: $msg, serverTime: $serverTime, data: $data}';
  }
}

// 便捷的工厂方法
class ApiResponseHelper {
  // 解析简单的响应（data为Map类型）
  static ApiResponse<Map<String, dynamic>> fromJsonMap(Map<String, dynamic> json) {
    return ApiResponse.fromJson(json, (data) => data as Map<String, dynamic>);
  }

  // 解析列表响应（data为List类型）
  static ApiResponse<List<dynamic>> fromJsonList(Map<String, dynamic> json) {
    return ApiResponse.fromJson(json, (data) => data as List<dynamic>);
  }

  // 解析字符串响应（data为String类型）
  static ApiResponse<String> fromJsonString(Map<String, dynamic> json) {
    return ApiResponse.fromJson(json, (data) => data.toString());
  }
}