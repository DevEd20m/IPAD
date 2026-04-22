abstract class Failure {
  final String message;
  const Failure(this.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class DocumentFailure extends Failure {
  const DocumentFailure(super.message);
}

class AudioFailure extends Failure {
  const AudioFailure(super.message);
}

class DrawingFailure extends Failure {
  const DrawingFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

class FileFailure extends Failure {
  const FileFailure(super.message);
}
