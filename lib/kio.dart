/// # Darty data structure
///
/// - [Kio]...
///
/// ## Usage example
///
/// ```dart
/// const t = const Kio.succeedNow(10);
///
/// t.run((p0) { print(p0); }); // prints 'a'
/// ```
library kio;

import 'package:tuple/tuple.dart';

/// TODO:
/// Stack safety

/// program runtime base class
abstract class Kio<A> {
  static Kio<A> async<A>(Function(Function(A)) register) => _Async(register);

  /// successful program
  static Kio<A> succeedNow<A>(A value) => _Succeed(value);

  /// successful delayed program
  static Kio<A> succeed<A>(A Function() value) =>
      succeedNow(Object()).map((_) => value());

  /// zip two program
  static Kio<Tuple2<A, B>> zip<A, B>(Kio<A> first, Kio<B> second) =>
      first.flatMap((p0) => second.map((p1) => Tuple2(p0, p1)));

  Kio<B> map<B>(B Function(A) f) => flatMap((p0) => succeedNow(f(p0)));

  Kio<B> flatMap<B>(Kio<B> Function(A) f) => _FlatMap(this, f);

  Kio<Tuple2<A, B>> zipWith<B>(Kio<B> that) => zip(this, that);

  Kio<B> as<B>(B Function() f) => map((_) => f());

  void run(void Function(A) callback);
}

class _Async<A> extends Kio<A> {
  final Function(Function(A)) register;

  _Async(this.register);

  @override
  void run(void Function(A p1) callback) {
    register(callback);
  }
}

class Fiber<A> {}

class _FlatMap<A, B> extends Kio<B> {
  final Kio<A> rope;
  final Kio<B> Function(A) f;

  _FlatMap(this.rope, this.f);

  @override
  void run(void Function(B p1) callback) {
    rope.run((p0) {
      f(p0).run(callback);
    });
  }
}

class _Succeed<A> extends Kio<A> {
  final A value;

  _Succeed(this.value);

  @override
  void run(void Function(A) callback) {
    callback(value);
  }
}
