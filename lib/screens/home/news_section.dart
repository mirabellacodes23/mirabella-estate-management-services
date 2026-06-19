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

  Future<void> _openWhatsApp() async {
    await launchUrlString(
      'https://wa.me/923300492037',
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      width: double.infinity,
      color: const Color(0xFF062F35),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 64,
        vertical: isMobile ? 56 : 86,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = isMobile
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 24) / 2;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionIdentity(isMobile),
                            const SizedBox(height: 28),
                            _companyIntro(isMobile),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: _sectionIdentity(isMobile),
                            ),
                            const SizedBox(width: 56),
                            Expanded(flex: 6, child: _companyIntro(isMobile)),
                          ],
                        ),
                  SizedBox(height: isMobile ? 38 : 58),
                  Text(
                    'WHAT WE DO',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.72),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      _serviceCard(
                        width: cardWidth,
                        icon: Icons.apartment_rounded,
                        title: 'Estate & Project Management',
                        description:
                            'Structured management support for residential, commercial, and mixed-use real estate projects, with organized coordination between clients, stakeholders, and service teams.',
                      ),
                      _serviceCard(
                        width: cardWidth,
                        icon: Icons.verified_user_rounded,
                        title: 'Documentation & Compliance',
                        description:
                            'Professional assistance for property documentation, record keeping, regulatory coordination, official notices, and lawful process management.',
                      ),
                      _serviceCard(
                        width: cardWidth,
                        icon: Icons.handshake_rounded,
                        title: 'Possession & Handover Support',
                        description:
                            'Guidance and facilitation for possession matters, handover coordination, authority-issued information, and client awareness regarding project developments.',
                      ),
                      _serviceCard(
                        width: cardWidth,
                        icon: Icons.support_agent_rounded,
                        title: 'Client Advisory & Updates',
                        description:
                            'Transparent communication, verified project information, client facilitation, and timely estate management updates through official channels.',
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 34 : 46),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 20 : 26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _officialNoticeText(isMobile),
                              const SizedBox(height: 18),
                              _noticeButtons(),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: _officialNoticeText(isMobile)),
                              const SizedBox(width: 24),
                              _noticeButtons(),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionIdentity(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
          ),
          child: const Text(
            'ESTATE MANAGEMENT & PROJECT SOLUTIONS',
            style: TextStyle(
              color: Color(0xFFB7F7E5),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.9,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Integrated Estate Management for Modern Real Estate Projects',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 34 : 52,
            height: 1.05,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
          ),
        ),
      ],
    );
  }

  Widget _companyIntro(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mirabella Estate Management Services is a professional estate management company providing structured property administration, project coordination, documentation support, and client facilitation across multiple real estate developments.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.88),
            fontSize: isMobile ? 16 : 18,
            height: 1.7,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Our approach is built on transparency, verified information, lawful documentation, stakeholder communication, and reliable management support for residential, commercial, and mixed-use projects.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.74),
            fontSize: isMobile ? 15.5 : 17,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _serviceCard({
    required double width,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFB7F7E5), size: 30),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 15.5,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }

  Widget _officialNoticeText(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Official Notices & Verified Information',
          style: TextStyle(
            color: const Color(0xFF111827),
            fontSize: isMobile ? 22 : 26,
            height: 1.2,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Authority-issued letters and official updates are shared as part of MEMS’ wider commitment to transparency, client awareness, and verified communication.',
          style: TextStyle(color: Color(0xFF4B5563), fontSize: 16, height: 1.6),
        ),
      ],
    );
  }

  Widget _noticeButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: _openCdaLetter,
          icon: const Icon(Icons.picture_as_pdf_rounded),
          label: const Text('View Official Notice'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          onPressed: _openWhatsApp,
          icon: const Icon(Icons.chat_rounded),
          label: const Text('Discuss Services'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.blue600,
            side: const BorderSide(color: AppColors.blue600),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
    );
  }
}
