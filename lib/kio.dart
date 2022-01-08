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
abstract class Kio<E, A> {
  static Kio<E, A> async<E, A>(Function(Function(A)) register) =>
      _Async(register);

  /// successful program
  static Kio<E, A> succeedNow<E, A>(A value) => _Succeed(value);

  /// successful delayed program
  static Kio<E, A> succeed<E, A>(A Function() value) =>
      succeedNow<E, Object>(Object()).map((p0) => value());

  /// zip two program
  static Kio<E, Tuple2<A, B>> zip<E, A, B>(
    Kio<E, A> first,
    Kio<E, B> second,
  ) =>
      first.flatMap((p0) => second.map((p1) => Tuple2(p0, p1)));

  Kio<E, B> map<B>(B Function(A) f) => flatMap((p0) => succeedNow(f(p0)));

  Kio<E, B> flatMap<B>(Kio<E, B> Function(A) f) => _FlatMap(this, f);

  Kio<E, Tuple2<A, B>> zipWith<B>(Kio<E, B> that) => zip(this, that);

  Kio<E, B> as<B>(B Function() f) => map((_) => f());

  void run(void Function(A) callback);
}

class _Async<E, A> extends Kio<E, A> {
  final Function(Function(A)) register;

  _Async(this.register);

  @override
  void run(void Function(A p1) callback) {
    register(callback);
  }
}

class Fiber<E, A> {}

class _FlatMap<E, A, B> extends Kio<E, B> {
  final Kio<E, A> kio;
  final Kio<E, B> Function(A) f;

  _FlatMap(this.kio, this.f);

  @override
  void run(void Function(B p1) callback) {
    kio.run((p0) {
      f(p0).run(callback);
    });
  }
}

class _Succeed<E, A> extends Kio<E, A> {
  final A value;

  _Succeed(this.value);

  @override
  void run(void Function(A) callback) {
    callback(value);
  }
}
