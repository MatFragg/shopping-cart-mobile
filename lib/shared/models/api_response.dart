class ApiResponse<T>{
  final bool success;
  final String message;
  final T? data;
  final DateTime timestamp;
  ApiResponse({required this.success, required this.message, this.data, required this.timestamp});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic> itemJson) itemFromJson,) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? itemFromJson(json['data'] as Map<String, dynamic>) : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}