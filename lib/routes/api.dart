import 'package:blueframe/blueframe.dart';
import 'package:blueframe/routes/RouteDelegator.dart';

import 'api/ping.dart';


class Api implements RouteBase {

	Api(this.request);

	Request request;

	static const Map<String, Route Function(Request)> routeGetter = {
		"ping": Ping.init
	};

	@override
	Route getRoute() {
		final List<String> segments = request.path.segments;

		if (!routeGetter.containsKey(segments[1]))
			return BadRoute(request);

		final routingFunction = routeGetter[segments[1]];
		final Route route = routingFunction(request);

		return route;
	}

	static Route get(Request request) => Api(request).getRoute();
}

abstract class RouteBase {
	Route getRoute();
}