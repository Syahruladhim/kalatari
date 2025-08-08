import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  final List<Map<String, String>> policyList = [
    {
      'title': 'Informasi yang kami kumpulkan',
      'desc':
          'Kami mengumpulkan informasi yang Anda berikan secara langsung saat mendaftar, seperti nama, email, dan data profil. Selain itu, kami juga mengumpulkan data penggunaan aplikasi, log aktivitas, serta data perangkat untuk meningkatkan layanan.'
    },
    {
      'title': 'Penggunaan informasi',
      'desc':
          'Informasi yang dikumpulkan digunakan untuk:\n- Menyediakan dan meningkatkan layanan aplikasi\n- Personalisasi konten\n- Menghubungi Anda terkait update atau event\n- Menjaga keamanan dan mencegah penyalahgunaan'
    },
    {
      'title': 'Penyimpanan dan keamanan data',
      'desc':
          'Data Anda disimpan secara aman di server kami dan dilindungi dengan teknologi enkripsi. Kami membatasi akses data hanya untuk pihak yang berwenang dan menerapkan prosedur keamanan sesuai standar industri.'
    },
    {
      'title': 'Perubahan kebijakan privasi',
      'desc':
          'Kebijakan privasi dapat diperbarui sewaktu-waktu. Setiap perubahan akan diinformasikan melalui aplikasi atau email. Penggunaan aplikasi setelah perubahan berarti Anda menyetujui kebijakan terbaru.'
    },
    {
      'title': 'Kontak kami',
      'desc':
          'Jika Anda memiliki pertanyaan atau keluhan terkait privasi, silakan hubungi kami di support@kalatari.id.'
    },
  ];

  late List<bool> expanded;

  @override
  void initState() {
    super.initState();
    expanded = List.generate(policyList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Kebijakan & Privasi',
          style: TextStyle(
            color: Color(0xFF9D2708),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(policyList.length, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      expanded[i] = !expanded[i];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                policyList[i]['title']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              expanded[i]
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 22,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        if (expanded[i]) ...[
                          const SizedBox(height: 12),
                          Text(
                            policyList[i]['desc']!,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
