

class httpexception implements Exception
{
  final String message;

  httpexception(this.message);

@override
  String toString() {
    // TODO: implement toString
    return message;
  }
}