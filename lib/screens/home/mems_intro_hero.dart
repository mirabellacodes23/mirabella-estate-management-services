import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MemsIntroHero extends StatefulWidget {
  final void Function(String id)? onNavTap;

  const MemsIntroHero({super.key, this.onNavTap});

  @override
  State<MemsIntroHero> createState() => _MemsIntroHeroState();
}

class _MemsIntroHeroState extends State<MemsIntroHero> {
  late final VideoPlayerController _controller;
  bool _ready = false;

  static const gold = Color(0xFFD6A84F);
  static const darkGold = Color(0xFF8F6B25);

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/mems_home_intro.mp4')
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            if (!mounted) return;
            setState(() => _ready = true);
            _controller.play();
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height + 110,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_ready)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            Container(color: Colors.black),

          Container(color: Colors.black.withOpacity(0.55)),

          Column(
            children: [
              const _TopContactBar(),
              _NavBar(onNavTap: widget.onNavTap),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.apartment_rounded, color: gold, size: 86),
                        SizedBox(height: 20),
                        _GoldTitle(),
                        SizedBox(height: 18),
                        Text(
                          'Your Estate. Managed Right.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Islamabad based residential, commercial, industrial and institutional real estate services — Sale, Purchase, Marketing & Development.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 26),
                        _TrustBadges(),
                        SizedBox(height: 32),
                        _ScrollHint(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopContactBar extends StatelessWidget {
  const _TopContactBar();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return Container(
      height: 46,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 34),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.72),
        border: const Border(bottom: BorderSide(color: Color(0x44D6A84F))),
      ),
      child: isMobile
          ? const Row(
              children: [
                Icon(Icons.phone, color: Color(0xFFD6A84F), size: 16),
                SizedBox(width: 6),
                Text(
                  '+92 333 00492037',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                Spacer(),
                Icon(Icons.email_outlined, color: Color(0xFFD6A84F), size: 16),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'info@mirabellaestatemanagementservices.com',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            )
          : const Row(
              children: [
                Icon(Icons.phone, color: Color(0xFFD6A84F), size: 18),
                SizedBox(width: 8),
                Text('+92 333 00492037', style: TextStyle(color: Colors.white)),
                SizedBox(width: 24),
                Icon(Icons.email_outlined, color: Color(0xFFD6A84F), size: 18),
                SizedBox(width: 8),
                Text(
                  'info@mirabellaestatemanagementservices.com',
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Icon(Icons.facebook, color: Color(0xFFD6A84F), size: 18),
                SizedBox(width: 18),
                Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFFD6A84F),
                  size: 18,
                ),
                SizedBox(width: 18),
                Icon(
                  Icons.video_library_outlined,
                  color: Color(0xFFD6A84F),
                  size: 18,
                ),
              ],
            ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final void Function(String id)? onNavTap;

  const _NavBar({this.onNavTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;

    return Container(
      height: isMobile ? 70 : 82,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 18),
      color: Colors.black.withOpacity(0.42),
      child: isMobile
          ? Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'MEMS\nMIRABELLA ESTATE MANAGEMENT SERVICES',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFFD6A84F),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      height: 1.15,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Color(0xFFD6A84F),
                    size: 30,
                  ),
                  color: const Color(0xFF171717),
                  onSelected: (value) => onNavTap?.call(value),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'home', child: _MobileNavText('HOME')),
                    PopupMenuItem(
                      value: 'services',
                      child: _MobileNavText('SERVICES'),
                    ),
                    PopupMenuItem(
                      value: 'why',
                      child: _MobileNavText('WHY CHOOSE US'),
                    ),
                    PopupMenuItem(
                      value: 'process',
                      child: _MobileNavText('PROCESS'),
                    ),
                    PopupMenuItem(value: 'news', child: _MobileNavText('NEWS')),
                    PopupMenuItem(
                      value: 'about',
                      child: _MobileNavText('ABOUT MEMS'),
                    ),
                    PopupMenuItem(
                      value: 'contact',
                      child: _MobileNavText('CONTACT US'),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 48,
                  width: 48,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                const Text(
                  'MEMS\nMIRABELLA ESTATE MANAGEMENT SERVICES',
                  style: TextStyle(
                    color: Color(0xFFD6A84F),
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                const _NavItem('HOME', active: true),
                _NavItem('SERVICES', onTap: () => onNavTap?.call('services')),
                _NavItem('WHY CHOOSE US', onTap: () => onNavTap?.call('why')),
                _NavItem('PROCESS', onTap: () => onNavTap?.call('process')),
                _NavItem('INVESTMENT', onTap: () => onNavTap?.call('pricing')),
                _NavItem('NEWS', onTap: () => onNavTap?.call('news')),
                _NavItem('ABOUT MEMS', onTap: () => onNavTap?.call('about')),
                _NavItem('CONTACT US', onTap: () => onNavTap?.call('contact')),
                const SizedBox(width: 18),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_rounded),
                  label: const Text('BOOK A SITE VISIT'),
                  style: OutlinedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    foregroundColor: const Color(0xFFD6A84F),
                    side: const BorderSide(color: Color(0xFFD6A84F)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _MobileNavText extends StatelessWidget {
  final String text;

  const _MobileNavText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem(this.text, {this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
        child: Text(
          text,
          style: TextStyle(
            color: active ? const Color(0xFFD6A84F) : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _GoldTitle extends StatelessWidget {
  const _GoldTitle();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final double mainSize = width < 600
        ? 68
        : width < 1000
        ? 96
        : 126;

    final double subSize = width < 600
        ? 16
        : width < 1000
        ? 22
        : 28;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(5, 6),
              child: Text(
                'MEMS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: mainSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 5,
                  color: const Color(0xFF4A3005),
                ),
              ),
            ),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFFFFF0B8),
                    Color(0xFFD6A84F),
                    Color(0xFF8F641A),
                    Color(0xFFFFDE7A),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              },
              child: Text(
                'MEMS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: mainSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 5,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                      color: Color(0xAA000000),
                      blurRadius: 14,
                      offset: Offset(4, 5),
                    ),
                    Shadow(color: Color(0x88D6A84F), blurRadius: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'MIRABELLA ESTATE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFFFD978),
            fontSize: subSize,
            fontWeight: FontWeight.w700,
            letterSpacing: width < 600 ? 2 : 5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'MANAGEMENT SERVICES',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFFFD978),
            fontSize: subSize,
            fontWeight: FontWeight.w700,
            letterSpacing: width < 600 ? 1.5 : 4,
          ),
        ),
      ],
    );
  }
}

class _TrustBadges extends StatelessWidget {
  const _TrustBadges();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 760),
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.42),
        border: Border.all(color: const Color(0x88D6A84F)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _Badge(Icons.shield_outlined, 'SECP\nREGISTERED'),
          _DividerGold(),
          _Badge(Icons.verified_outlined, 'RDA / IBMS\nAPPROVED'),
          _DividerGold(),
          _Badge(Icons.groups_rounded, '3S NETWORK\nPARTNERS'),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Badge(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFD6A84F), size: 34),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _DividerGold extends StatelessWidget {
  const _DividerGold();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 42, color: const Color(0x66D6A84F));
  }
}

class _ScrollHint extends StatelessWidget {
  const _ScrollHint();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'SCROLL TO EXPLORE',
          style: TextStyle(
            color: Color(0xFFD6A84F),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 10),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFFD6A84F),
          size: 34,
        ),
      ],
    );
  }
}
