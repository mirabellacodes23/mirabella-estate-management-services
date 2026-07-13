import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MemsAdSection extends StatefulWidget {
  const MemsAdSection({super.key});

  @override
  State<MemsAdSection> createState() => _MemsAdSectionState();
}

class _MemsAdSectionState extends State<MemsAdSection> {
  late final VideoPlayerController _controller;

  bool _ready = false;
  bool _muted = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/mems_ad.mp4');

    _controller
        .initialize()
        .then((_) async {
          await _controller.setLooping(false);
          await _controller.setVolume(0);
          await _controller.play();

          if (mounted) {
            setState(() => _ready = true);
          }
        })
        .catchError((_) {
          if (mounted) {
            setState(() => _hasError = true);
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_ready) return;

    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        if (_controller.value.position >= _controller.value.duration) {
          _controller.seekTo(Duration.zero);
        }
        _controller.play();
      }
    });
  }

  void _toggleSound() {
    if (!_ready) return;

    setState(() {
      _muted = !_muted;
      _controller.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 700;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 42,
        vertical: isMobile ? 40 : 54,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF050505), Color(0xFF11100D), Color(0xFF050505)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFD6A84B)),
                ),
                child: const Text(
                  'MEMS IN ACTION',
                  style: TextStyle(
                    color: Color(0xFFD6A84B),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.8,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'From Vision to Value',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 28 : 42,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Experience the MEMS approach to professional estate management, development and client support.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFB8B8B8),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7A5010),
                      Color(0xFFFFD978),
                      Color(0xFF7A5010),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x55000000),
                      blurRadius: 28,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Container(
                            color: const Color(0xFF111111),
                            child: _hasError
                                ? const Center(
                                    child: Text(
                                      'Advertisement video could not be loaded.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : !_ready
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFD6A84B),
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _controller.value.size.width,
                                      height: _controller.value.size.height,
                                      child: VideoPlayer(_controller),
                                    ),
                                  ),
                          ),
                        ),

                        if (_ready)
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(onTap: _togglePlay),
                            ),
                          ),

                        if (_ready && !_controller.value.isPlaying)
                          GestureDetector(
                            onTap: _togglePlay,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.70),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFD6A84B),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Color(0xFFD6A84B),
                                size: 44,
                              ),
                            ),
                          ),

                        if (_ready)
                          Positioned(
                            right: 16,
                            bottom: 16,
                            child: IconButton(
                              onPressed: _toggleSound,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.72),
                                foregroundColor: const Color(0xFFD6A84B),
                              ),
                              icon: Icon(
                                _muted
                                    ? Icons.volume_off_rounded
                                    : Icons.volume_up_rounded,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
