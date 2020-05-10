import 'package:kczwifilocation/api/exceptions/api_exception.dart';

class BadRequestAPIException extends APIException {
  BadRequestAPIException({message}) : super(message, 400);
}
