sealed class Either<L, R> {
  const Either();

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  T fold<T>(T Function(L failure) onLeft, T Function(R value) onRight) {
    final value = this;
    if (value is Left<L, R>) {
      return onLeft(value.value);
    }
    return onRight((value as Right<L, R>).value);
  }
}

final class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);
}

final class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);
}
