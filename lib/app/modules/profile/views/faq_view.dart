import 'package:flutter/material.dart';

class FaqView extends StatefulWidget {
  const FaqView({Key? key}) : super(key: key);

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  final List<Map<String, String>> faqList = [
    {
      'q': 'Apa itu aplikasi "Kalatari"?',
      'a':
          'Kalatari adalah aplikasi edukasi dan informasi seputar seni tari tradisional Jawa Tengah. Aplikasi ini menyediakan fitur deteksi jenis tari, artikel budaya, info event, serta visualisasi tari untuk memperkenalkan dan melestarikan budaya Indonesia.'
    },
    {
      'q': 'Apa saja fitur utama aplikasi ini?',
      'a':
          'Fitur utama Kalatari meliputi:\n- Deteksi jenis tari melalui video\n- Daftar dan detail event tari\n- Artikel dan berita seputar seni tari\n- Visualisasi gerakan tari\n- FAQ dan Kebijakan Privasi\n- Profil pengguna'
    },
    {
      'q': 'Apakah aplikasi ini gratis?',
      'a':
          'Ya, seluruh fitur utama aplikasi Kalatari dapat digunakan secara gratis. Namun, beberapa event atau konten premium mungkin memerlukan pembayaran tertentu.'
    },
    {
      'q': 'Lapor bug atau saran ke mana?',
      'a':
          'Anda dapat melaporkan bug atau memberikan saran melalui menu "Hubungi Kami" di halaman profil, atau mengirim email ke support@kalatari.id.'
    },
    {
      'q': 'Apakah data pribadi saya aman?',
      'a':
          'Kami berkomitmen menjaga keamanan data Anda. Data pribadi hanya digunakan untuk keperluan aplikasi dan tidak dibagikan ke pihak ketiga tanpa izin. Lihat detail di halaman Kebijakan Privasi.'
    },
    {
      'q': 'Bagaimana cara menghubungi tim pengembang?',
      'a':
          'Anda dapat menghubungi tim pengembang melalui email support@kalatari.id atau melalui media sosial resmi Kalatari.'
    },
  ];

  late List<bool> expanded;

  @override
  void initState() {
    super.initState();
    expanded = List.generate(faqList.length, (index) => false);
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
          'FAQ',
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
            children: List.generate(faqList.length, (i) {
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
                                faqList[i]['q']!,
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
                            faqList[i]['a']!,
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
