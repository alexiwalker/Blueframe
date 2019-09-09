import 'package:blueframe/Routes/RouteDelegator.dart';
import 'package:blueframe/blueframe.dart';
import 'api/ping.dart';


class Api {

	static const Map<String, Route Function(Request)> routeGetter = {
		"ping": Ping.getRoute
	};


	static Route getApi(Request request) {
		final List<String> segments = request.path.segments;

		if (!routeGetter.containsKey(segments[1]))
			return BadRoute(request);

		final Route Function(Request) routingFunction = routeGetter[segments[1]];
		final Route route = routingFunction(request);

		return route;
	}
}