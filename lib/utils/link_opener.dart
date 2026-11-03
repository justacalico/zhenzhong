import 'package:url_launcher/url_launcher.dart';

typedef UrlOpener = Future<bool> Function(Uri uri);

Future<bool> _launch(Uri uri) async {
  // coverage:ignore-start
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
  // coverage:ignore-end
}

class LinkOpener {
  final UrlOpener open;

  LinkOpener({UrlOpener? opener}) : open = opener ?? _launch;
}
