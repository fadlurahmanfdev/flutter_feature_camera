class FeatureCameraException {
  String code;
  String message;

  FeatureCameraException({required this.code, required this.message});

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}
