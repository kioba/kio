library kio;

import 'package:kio/kio.dart';

extension FiberKio<E extends Object, A> on Kio<E, A> {
  Kio<E, Fiber<E, A>>? fork() {}
}
