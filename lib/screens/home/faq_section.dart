import 'package:flutter/material.dart';

import '../../data/data.dart';

class FAQSection extends StatefulWidget {
  final VoidCallback? onContact;

  const FAQSection({super.key, this.onContact});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  int? _openIndex;

  void _toggleQuestion(int index) {
    setState(() {
      _openIndex = _openIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 850;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 48 : 64,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF050505), Color(0xFF12110E), Color(0xFF050505)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 850;

              final accordion = ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: faqsData.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = faqsData[index];

                  return _FaqTile(
                    number: index + 1,
                    question: item.question,
                    answer: item.answer,
                    isOpen: _openIndex == index,
                    onTap: () => _toggleQuestion(index),
                  );
                },
              );

              final intro = _FaqIntroPanel(onContact: widget.onContact);

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 350, child: intro),
                    const SizedBox(width: 48),
                    Expanded(child: accordion),
                  ],
                );
              }

              return Column(
                children: [intro, const SizedBox(height: 40), accordion],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FaqIntroPanel extends StatelessWidget {
  final VoidCallback? onContact;

  const _FaqIntroPanel({this.onContact});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 850;

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFD6A84B), width: 1.2),
          ),
          child: const Text(
            'FAQ',
            style: TextStyle(
              color: Color(0xFFD6A84B),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text.rich(
          const TextSpan(
            children: [
              TextSpan(
                text: 'Answers You\n',
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: 'Can Trust',
                style: TextStyle(color: Color(0xFFD6A84B)),
              ),
            ],
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 34 : 46,
            fontWeight: FontWeight.w900,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Clear answers about MEMS property management, tenant services, maintenance, reporting and owner support.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            color: Color(0xFFB8B8B8),
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          width: isMobile ? 120 : 150,
          height: isMobile ? 120 : 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF151515),
            border: Border.all(color: const Color(0xFF8F6B25), width: 1.5),
            boxShadow: const [
              BoxShadow(color: Color(0x33D6A84B), blurRadius: 28),
            ],
          ),
          child: Text(
            '?',
            style: TextStyle(
              color: const Color(0xFFD6A84B),
              fontSize: isMobile ? 70 : 92,
              fontWeight: FontWeight.w300,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 28),
        OutlinedButton.icon(
          onPressed:
              onContact ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening contact section...')),
                );
              },
          icon: const Icon(Icons.chat_bubble_outline_rounded),
          label: const Text('STILL HAVE QUESTIONS?'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD6A84B),
            side: const BorderSide(color: Color(0xFFD6A84B), width: 1.4),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqTile extends StatelessWidget {
  final int number;
  final String question;
  final String answer;
  final bool isOpen;
  final VoidCallback onTap;

  const _FaqTile({
    required this.number,
    required this.question,
    required this.answer,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOpen
              ? const [Color(0xFF242018), Color(0xFF151515)]
              : const [Color(0xFF1A1A1A), Color(0xFF101010)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOpen ? const Color(0xFFD6A84B) : const Color(0xFF6E511B),
          width: isOpen ? 1.6 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x77000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 34,
                      child: Text(
                        number.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          color: Color(0xFFD6A84B),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        question,
                        textScaler: scaler,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 250),
                      turns: isOpen ? 0.125 : 0,
                      child: Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOpen
                              ? const Color(0xFFD6A84B)
                              : const Color(0xFF242424),
                          border: Border.all(color: const Color(0xFFD6A84B)),
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: isOpen
                              ? const Color(0xFF111111)
                              : const Color(0xFFD6A84B),
                          size: 21,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: isOpen
                  ? Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Divider(color: Color(0xFF8F6B25), height: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(62, 16, 20, 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              answer,
                              textScaler: scaler,
                              softWrap: true,
                              style: const TextStyle(
                                color: Color(0xFFB8B8B8),
                                fontSize: 14.5,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
