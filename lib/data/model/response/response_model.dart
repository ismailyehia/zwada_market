class ResponseModel {
  final bool _isSuccess;
  final String? _message;
  final String? _role;
  ResponseModel(this._isSuccess, this._message, {String? role}) : _role = role;

  String? get message => _message;
  bool get isSuccess => _isSuccess;
  String? get role => _role;
  
  @override
  String toString() {
    return 'ResponseModel{ isSuccess: $_isSuccess, message: $_message, role: $_role }';
  }
}