sealed class Failure {
  final String messageKey;

  const Failure(this.messageKey);
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure() : super('generic_error');
}

final class CacheFailure extends Failure {
  const CacheFailure() : super('generic_error');
}

final class AudioFailure extends Failure {
  const AudioFailure() : super('generic_error');
}

final class PermissionFailure extends Failure {
  const PermissionFailure() : super('permission_denied');
}

final class PaletteFailure extends Failure {
  const PaletteFailure() : super('generic_error');
}
