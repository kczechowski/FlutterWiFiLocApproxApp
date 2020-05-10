import 'package:kczwifilocation/api/exceptions/api_exception.dart';

class BadRequestAPIException extends APIException {
  BadRequestAPIException(String message) : super(message, 400);
}
