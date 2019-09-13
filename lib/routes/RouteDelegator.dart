import "package:blueframe/blueframe.dart";
import "package:blueframe/routes/api.dart";
import 'Route.dart';
import 'homeRoute.dart';
export "Route.dart";

class RouteDelegator {

	RouteDelegator(this.request);

	static const Map<String, Route Function(Request)> routeGetter = {
		"api": Api.get,
	};

	Route getRoute() {
		final List<String> routeString = request.path.segments;

		if (routeString.isEmpty)
			return HomeRoute(request);

		//eg. if url is .../api/something it will route to Api.getApi, which will handle it there - may return a bad response if seg 1+ are invalid
		if (routeGetter.containsKey(routeString[0]))
			return routeGetter[routeString[0]](request);

		return BadRoute(request);
	}

	Request request;

}

