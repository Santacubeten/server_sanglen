class KROUTES {
  static const String root = '/';
  static const transport = ExpampleRoutes();
}

class ExpampleRoutes {
  const ExpampleRoutes();
  final example = '/examplr';

  final exampleDetails = '/example/<id>';
}
