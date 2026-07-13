import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class OfficeLocationSection extends StatelessWidget {
  const OfficeLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 850;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 64,
        vertical: isMobile ? 48 : 8,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6E4B13),
            Color(0xFFD6A84F),
            Color(0xFFFFD978),
            Color(0xFF8F641A),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? const Column(
                  children: [
                    _OfficeInformation(),
                    SizedBox(height: 36),
                    _OfficeVisuals(),
                  ],
                )
              : const Row(
                  children: [
                    Expanded(flex: 4, child: _OfficeInformation()),
                    const SizedBox(width: 30),
                    Expanded(flex: 6, child: _OfficeVisuals()),
                  ],
                ),
        ),
      ),
    );
  }
}

class _OfficeInformation extends StatelessWidget {
  const _OfficeInformation();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 850;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'VISIT MEMS',
            style: TextStyle(
              color: Color(0xFFD6A84F),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Our Islamabad Office',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 34 : 48,
            height: 1.08,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Visit our office for a personalized consultation. Meet the MEMS team, discuss your property requirements, and let us guide you towards the right opportunity.',
          style: TextStyle(color: Color(0xFFF2E8D3), fontSize: 16, height: 1.6),
        ),
        const SizedBox(height: 26),

        const _OfficeDetailRow(
          icon: Icons.location_on_rounded,
          title: 'MEMS — Mirabella Estate Management Services',
          detail: 'Mirabella Complex, Gulshan-e-Sahat, E-18, Islamabad',
        ),
        const SizedBox(height: 16),

        const _OfficeDetailRow(
          icon: Icons.phone_rounded,
          title: '+92 333 00492037',
          detail: 'Contact the MEMS team',
        ),
        const SizedBox(height: 16),

        const _OfficeDetailRow(
          icon: Icons.chat_rounded,
          title: 'WhatsApp Assistance',
          detail: 'Discuss your property requirements with us',
        ),
        const SizedBox(height: 28),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                final mapUrl = Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=33.03176698521955,71.14989708093592',
                );
                await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
              },
              icon: const Icon(Icons.location_on_rounded),
              label: const Text('OPEN IN GOOGLE MAPS'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF111111), width: 1.5),
                backgroundColor: const Color(0xFF111111),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_month_rounded),
              label: const Text('BOOK A SITE VISIT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD978),
                foregroundColor: const Color(0xFF111111),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OfficeDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const _OfficeDetailRow({
    required this.icon,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFF111111),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFD6A84F), size: 23),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                style: const TextStyle(
                  color: Color(0xFFF2E8D3),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OfficeVisuals extends StatelessWidget {
  const _OfficeVisuals();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 850;
    final circleSize = isMobile ? 245.0 : 325.0;

    if (isMobile) {
      return Column(
        children: [
          _OfficeVisualCircle(
            size: circleSize,
            icon: Icons.map_rounded,
            label: 'OUR LOCATION',
            placeholder: 'Google Map',
          ),
          const SizedBox(height: 28),
          _OfficeVisualCircle(
            size: circleSize,
            icon: Icons.business_rounded,
            label: 'OUR OFFICE',
            placeholder: 'Office Image',
          ),
        ],
      );
    }

    const overlap = 42.0;
    final totalWidth = (circleSize * 2) - overlap;

    return SizedBox(
      height: circleSize + 60,
      child: Center(
        child: SizedBox(
          width: totalWidth,
          height: circleSize + 60,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: _OfficeVisualCircle(
                  size: circleSize,
                  icon: Icons.map_rounded,
                  label: 'OUR LOCATION',
                  placeholder: 'Google Map',
                ),
              ),
              Positioned(
                left: circleSize - overlap,
                top: 0,
                child: _OfficeVisualCircle(
                  size: circleSize,
                  icon: Icons.business_rounded,
                  label: 'OUR OFFICE',
                  placeholder: 'Office Image',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfficeVisualCircle extends StatelessWidget {
  final double size;
  final IconData icon;
  final String label;
  final String placeholder;

  const _OfficeVisualCircle({
    required this.size,
    required this.icon,
    required this.label,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFE7A3), Color(0xFFD6A84F), Color(0xFF7A5010)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),

          child: ClipOval(
            child: placeholder == 'Office Image'
                ? Image.asset(
                    'assets/mirabella_office.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : placeholder == 'Google Map'
                ? const _GoogleMapEmbed()
                : Container(
                    color: const Color(0xFF171717),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: const Color(0xFFD6A84F), size: 54),
                        const SizedBox(height: 12),
                        Text(
                          placeholder,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Image will be added',
                          style: TextStyle(
                            color: Color(0xFFB8B8B8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD6A84F),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

class _GoogleMapEmbed extends StatefulWidget {
  const _GoogleMapEmbed();

  @override
  State<_GoogleMapEmbed> createState() => _GoogleMapEmbedState();
}

class _GoogleMapEmbedState extends State<_GoogleMapEmbed> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();

    _viewType = 'mems-google-map-${identityHashCode(this)}';

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src =
            'https://www.google.com/maps?q=33.03176698521955,71.14989708093592&z=16&output=embed'
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;

      iframe.setAttribute('loading', 'lazy');
      iframe.setAttribute('referrerpolicy', 'strict-origin-when-cross-origin');

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
