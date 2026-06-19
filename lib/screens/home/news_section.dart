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
                  'OFFICIAL INFORMATION & VERIFIED NOTICES',
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
                'Professional Estate Management & Verified Property Solutions',
                style: TextStyle(
                  fontSize: isMobile ? 30 : 44,
                  height: 1.12,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Mirabella Estate Management Services is a professional estate management company providing transparent, verified, and lawful property solutions across multiple residential, commercial, and mixed-use projects.',
                style: TextStyle(
                  fontSize: isMobile ? 15.5 : 17,
                  height: 1.65,
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Through our official website and social media platforms, we share authentic project information, official notices, possession-related guidance, documentation support, and estate management developments for the awareness and convenience of our valued clients.',

                style: TextStyle(
                  fontSize: isMobile ? 15.5 : 17,
                  height: 1.65,
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'MEMS is not operating as a local property dealer. We are a professional estate management organization committed to transparency, authenticity, documentation, and lawful processes. The recent CDA possession letter is being shared only as one verified official notice for public awareness, while our wider services include project guidance, possession support, documentation assistance, client facilitation, and complete estate management solutions.',
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
