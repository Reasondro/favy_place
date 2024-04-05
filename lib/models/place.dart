import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class Place {
  Place({required this.title}) : id = uuid.v4();

  final String id;
  final String title;
}
