library kio;

import 'package:kio/kio.dart';

extension FiberKio<A> on Kio<A> {
  Kio<Fiber<A>>? fork() {}
}
