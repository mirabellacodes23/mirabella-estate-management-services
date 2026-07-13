import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color _gold = Color(0xFFD6A84B);
const Color _charcoal = Color(0xFF151515);
const Color _cream = Color(0xFFF1E9D8);

class NewsletterStrip extends StatefulWidget {
  const NewsletterStrip({super.key});

  @override
  State<NewsletterStrip> createState() => _NewsletterStripState();
}

class _NewsletterStripState extends State<NewsletterStrip> {
  final _email = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _subscribe() async {
    final email = _email.text.trim();
    final isValid = RegExp(r'^\S+@\S+\.\S+$').hasMatch(email);

    if (!isValid) {
      _showResultOverlay(false, 'Invalid email address');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _firestore.collection('newsletter_subscribers').add({
        'email': email,
        'subscribedAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      _email.clear();

      _showResultOverlay(true, 'Successfully subscribed!');
    } catch (error) {
      debugPrint('Error saving email: $error');

      _showResultOverlay(false, 'Failed to subscribe. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showResultOverlay(bool success, String message) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => _ResultOverlay(success: success, message: message),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Widget _emailField() {
    return SizedBox(
      height: 54,
      child: TextField(
        controller: _email,
        enabled: !_isLoading,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _subscribe(),
        autofillHints: const [AutofillHints.email],
        cursorColor: _gold,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Enter your email address',
          hintStyle: const TextStyle(color: Color(0xFFBDB5A7)),
          filled: true,
          fillColor: _charcoal,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.65),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.45),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final bottomInset = mediaQuery.viewInsets.bottom;

    final clampedMediaQuery = mediaQuery.copyWith(
      textScaler: mediaQuery.textScaler.clamp(maxScaleFactor: 1.2),
    );

    final titleSize = width > 900
        ? 32.0
        : width > 600
        ? 30.0
        : 26.0;

    final copySize = width > 600 ? 16.0 : 15.0;

    return MediaQuery(
      data: clampedMediaQuery,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6E4B13),
                Color(0xFFD6A84F),
                Color(0xFFFFD978),
                Color(0xFF8F641A),
              ],
              stops: [0.0, 0.32, 0.68, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Stay Updated',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Subscribe to our newsletter for property management tips, market insights, and exclusive offers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.78),
                        fontSize: copySize,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final useRow = constraints.maxWidth >= 640;

                      final subscribeButton = SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: _gold,
                            disabledBackgroundColor: Colors.black.withOpacity(
                              0.65,
                            ),
                            disabledForegroundColor: _gold.withOpacity(0.65),
                            elevation: 8,
                            shadowColor: Colors.black.withOpacity(0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                          ),
                          onPressed: _isLoading ? null : _subscribe,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _gold,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Subscribe Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                        ),
                      );

                      if (useRow) {
                        return Row(
                          children: [
                            Expanded(child: _emailField()),
                            const SizedBox(width: 12),
                            subscribeButton,
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _emailField(),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: subscribeButton,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Join 5,000+ property owners receiving our insights',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.76),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultOverlay extends StatefulWidget {
  final bool success;
  final String message;

  const _ResultOverlay({required this.success, required this.message});

  @override
  State<_ResultOverlay> createState() => _ResultOverlayState();
}

class _ResultOverlayState extends State<_ResultOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

  late final Animation<double> _fadeAnimation = Tween<double>(begin: 0, end: 1)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0, 0.5, curve: Curves.easeOut),
        ),
      );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _charcoal,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _gold.withOpacity(0.65)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: widget.success
                              ? _gold
                              : const Color(0xFFEF5350),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.success ? Icons.check : Icons.close,
                          color: widget.success ? Colors.black : Colors.white,
                          size: 36,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _cream,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
