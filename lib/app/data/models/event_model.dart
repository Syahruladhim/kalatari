class Event {
  final String id;
  final String namaEvent;
  final String deskripsi;
  final String gambarUrl;
  final double harga;
  final bool isActive;
  final int kuota;
  final String lokasi;
  final DateTime tanggal;

  Event({
    required this.id,
    required this.namaEvent,
    required this.deskripsi,
    required this.gambarUrl,
    required this.harga,
    required this.isActive,
    required this.kuota,
    required this.lokasi,
    required this.tanggal,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      namaEvent: json['nama_event'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gambarUrl: json['gambar_url'] ?? '',
      harga: (json['harga'] as num).toDouble(),
      isActive: json['is_active'] ?? false,
      kuota: json['kuota'] ?? 0,
      lokasi: json['lokasi'] ?? '',
      tanggal: DateTime.parse(json['tanggal']),
    );
  }
}
