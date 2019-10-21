import 'package:aqueduct/aqueduct.dart';
import 'package:blueframe/blueframe.dart';

class Cookies {
	static Response setCookies(Response response, Map<String, String> cookies) {
		var headers = response.headers;

		List<String> cookieStrings = [];
		cookies.forEach((k, v) {
			try {
				final String cookie = "$k=$v";
				cookieStrings.add(cookie);
			} catch (e) {
				print(e.toString());
			}
		});

		headers.addAll({"Set-cookie": cookieStrings});
		response.headers = headers;
		return response;
	}
}

class Cookie {

	Cookie({this.name, this.value, this.maxAge, this.expires, this.httpOnly, this.secure, this.expiresTimeScale});

	String name;
	dynamic value;
	int expires;
	int expiresTimeScale;
	int maxAge;
	bool httpOnly = true;
	bool secure = true;
	int sameSite = SAMESITE_STRICT;

	static const int TIME_SECONDS = 0;
	static const int TIME_MICROSECONDS = 1000000;
	static const int TIME_MILLISECONDS = 1000;

	//Only if good reason
	static const int SAMESITE_LAX = 0;

	//prefer this
	static const int SAMESITE_STRICT = 1;

	//Do not use
	static const int SAMESITE_NONE = -1;

	@override
	String toString() {
		final StringBuffer sb = StringBuffer();
		sb.write("$name=${value.toString()}");

		if (maxAge != null)
			sb.write(" Max-Age=$maxAge;");

		if (expires != null) {
			final DateTime expiryDateTime = DateTime.fromMillisecondsSinceEpoch(expires * expiresTimeScale);
			sb.write(" Expires=${expiryDateTime.toUtc()};");
		}
		if (httpOnly)
			sb.write(" HttpOnly;");

		if (secure)
			sb.write(" Secure;");
	}

	void setExpired() => maxAge = -1;

	void setSecure(bool b) => secure = b;

	void setHttpOnly(bool b) => httpOnly = b;

	void setMaxAge(int a) => maxAge = a;

}
