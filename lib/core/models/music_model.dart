class MusicModel {
  final int id;
  final String path;
  final String title;
  final String artist;
  final String? album;
  final int? duration;
  final int? size;

  MusicModel({
    required this.id,
    required this.path,
    required this.title,
    required this.artist,
    this.album,
    this.duration,
    this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'title': title,
      'artist': artist,
      'album': album,
      'duration': duration,
      'size': size,
    };
  }

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
      id: map['id'] ?? map['songId'] ?? 0,
      path: map['path'] ?? map['songPath'] ?? '',
      title: map['title'] ?? map['songTitle'] ?? 'Unknown',
      artist: map['artist'] ?? map['songArtist'] ?? 'Unknown',
      album: map['album'] ?? map['songAlbum'],
      duration: map['duration'] ?? map['songDuration'],
      size: map['size'] ?? map['songSize'],
    );
  }
}
