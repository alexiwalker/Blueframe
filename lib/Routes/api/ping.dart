import 'package:blueframe/Routes/RouteDelegator.dart';
import 'package:blueframe/blueframe.dart';

class Ping implements Route {

	Ping(this.request);
	static Route init(Request request) => Ping(request);

	Request request;

	@override
	Future<Response> getResponse() async => Response.ok("ping");

}