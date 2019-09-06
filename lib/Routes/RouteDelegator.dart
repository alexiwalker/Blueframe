import "package:blueframe/blueframe.dart";
import "package:blueframe/Routes/api.dart";

import 'Route.dart';

import 'homeRoute.dart';

export "Route.dart";

class RouteDelegator {

  RouteDelegator(this.request);

  static const Map<String,Route Function(Request)> routeGetter = {
    "api":Api.getApi,
  };

  Route getRoute() {

    List<String> routeString = request.path.segments;

    if(routeString.isEmpty)
      return HomeRoute(request);

    if(routeGetter.containsKey(routeString[0]))
      return routeGetter[routeString[0]](request);

    return badRoute(request);
  }

  Request request;

}

