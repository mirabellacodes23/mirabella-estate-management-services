import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/tokens.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  Future<void> _openCdaLetter() async {
    await launchUrlString(
      '/docs/cda_possession_letter.jpg',
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 64,
        vertical: isMobile ? 48 : 72,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'OFFICIAL NEWS & CDA UPDATE',
                  style: TextStyle(
                    color: AppColors.blue600,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'CDA Possession Update & Verified Estate Management Services',
                style: TextStyle(
                  fontSize: isMobile ? 30 : 44,
                  height: 1.12,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Mirabella Estate Management Services is committed to keeping its valued clients informed with the latest, verified, and authentic information regarding property developments and official updates.',
                style: TextStyle(
                  fontSize: isMobile ? 15.5 : 17,
                  height: 1.65,
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'As per the recent letter issued by the Capital Development Authority regarding the handing over of possession of plots in various sectors, including E-12, C-14, and I-12, MEMS will be sharing and explaining these developments through its official website and social media platforms. Our objective is to provide clients and the general public with accurate, transparent, and reliable information based on official documentation.',
                style: TextStyle(
                  fontSize: isMobile ? 15.5 : 17,
                  height: 1.65,
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'MEMS is not operating as a local property dealer. We are a professional estate management organization committed to transparency, authenticity, and a lawful process. Our team works with relevant authorities, stakeholders, and clients to facilitate genuine property-related opportunities, including guidance, support, documentation assistance, and updates regarding plot possession and related matters.',
                style: TextStyle(
                  fontSize: isMobile ? 15.5 : 17,
                  height: 1.65,
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 28),

              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  ElevatedButton.icon(
                    onPressed: _openCdaLetter,
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: const Text('View CDA Possession Letter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => launchUrlString(
                      'https://wa.me/923300492037',
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.chat_rounded),
                    label: const Text('Contact Management Team'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.blue600,
                      side: const BorderSide(color: AppColors.blue600),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
