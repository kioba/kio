abstract class Either<E, A> {
  static Either<E, Never> left<E>(E value) => _Left(value: value);
  static Either<Never, A> right<A>(A value) => _Right(value: value);

  B fold<B>(
    B Function(E) onLeft,
    B Function(A) onRight,
  ) {
    if (this is _Left<E>) {
      return onLeft((this as _Left<E>).value);
    } else {
      return onRight((this as _Right<A>).value);
    }
  }

  Either<E, B> map<B>(
    B Function(A) af,
  ) {
    if (this is _Left<E>) {
      return this as _Left<E>;
    } else {
      A value = (this as _Right<A>).value;
      B mapped = af(value);
      return right<B>(mapped);
    }
  }

  void tap(
    void Function(E) onLeft,
    void Function(A) onRight,
  ) {
    if (this is _Left<E>) {
      onLeft((this as _Left<E>).value);
    } else {
      onRight((this as _Right<A>).value);
    }
  }
}

class _Left<E> extends Either<E, Never> {
  E value;
  _Left({
    required this.value,
  });
}

class _Right<A> extends Either<Never, A> {
  A value;
  _Right({
    required this.value,
  });
}
