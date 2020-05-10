import 'package:kczwifilocation/api/exceptions/api_exception.dart';

class InternalServerErrorAPIException extends APIException {
  InternalServerErrorAPIException(String message) : super(message, 500);
}
