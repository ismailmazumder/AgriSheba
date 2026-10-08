import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const AgriGuideApp());

// ───────────────────────── Theme & helpers ─────────────────────────

class AppColors {
  static const bg = Color(0xFF0B0813);
  static const surface = Color(0xFF15111F);
  static const iconCircle = Color(0xFF1F1830);
  static const border = Color(0xFF2A2340);
  static const primary = Color(0xFF7C3AED);
  static const primaryLight = Color(0xFF9F6BFF);
  static const textSecondary = Color(0xFFA29BB5);
  static const amber = Color(0xFFF5B83D);
}

const int kTotalSteps = 6;

void go(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

class AgriGuideApp extends StatelessWidget {
  const AgriGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriGuide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

// ───────────────────────── Shared widgets ─────────────────────────

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.highlight = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Material(
      color: AppColors.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: highlight ? AppColors.primaryLight : AppColors.border,
              width: highlight ? 1.5 : 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class CircleBadge extends StatelessWidget {
  const CircleBadge({super.key, required this.child, this.size = 44});

  factory CircleBadge.icon(IconData icon, {double size = 44}) => CircleBadge(
    size: size,
    child: Icon(icon, color: AppColors.primaryLight, size: size * 0.5),
  );

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.iconCircle,
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: child,
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.height = 56,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(height / 2);
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: r,
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF6D28D9)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: r,
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 10),
                Icon(icon, color: Colors.white, size: 22),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class OutlinePillButton extends StatelessWidget {
  const OutlinePillButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconAfter = false,
    this.height = 52,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool iconAfter;
  final double height;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(height / 2);
    final text = Text(label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
    final ic = Icon(icon, size: 20);
    return Material(
      color: AppColors.bg,
      borderRadius: r,
      child: InkWell(
        borderRadius: r,
        onTap: onTap,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: r,
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: iconAfter
                ? [text, const SizedBox(width: 8), ic]
                : [ic, const SizedBox(width: 8), text],
          ),
        ),
      ),
    );
  }
}

class BackNextRow extends StatelessWidget {
  const BackNextRow({
    super.key,
    required this.onNext,
    this.nextLabel = 'Next',
    this.nextIcon = Icons.arrow_forward,
  });

  final VoidCallback onNext;
  final String nextLabel;
  final IconData nextIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: OutlinePillButton(
            label: 'Back',
            icon: Icons.arrow_back,
            onTap: () => Navigator.maybePop(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: GradientButton(
            label: nextLabel,
            icon: nextIcon,
            height: 52,
            onTap: onNext,
          ),
        ),
      ],
    );
  }
}

class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.step, this.subtitle = 'NASA-Powered'});

  final int step;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          CircleBadge.icon(Icons.eco, size: 40),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('AgriGuide',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Text('$step of $kTotalSteps',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: step / kTotalSteps,
          minHeight: 5,
          backgroundColor: AppColors.surface,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.items, required this.index});

  final List<(IconData, String)> items;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: i == index
                        ? BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(20),
                    )
                        : null,
                    child: Icon(
                      items[i].$1,
                      color: i == index
                          ? AppColors.primaryLight
                          : AppColors.textSecondary,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      items[i].$2,
                      style: TextStyle(
                        fontSize: 11,
                        color: i == index
                            ? AppColors.primaryLight
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Common layout for steps 2–6: header, progress bar, title, body, footer, nav.
class StepShell extends StatelessWidget {
  const StepShell({
    super.key,
    required this.step,
    required this.title,
    required this.body,
    this.subtitle,
    this.trailing,
    this.footer,
    this.nav,
    this.headerSubtitle = 'NASA-Powered',
  });

  final int step;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget body;
  final Widget? footer;
  final Widget? nav;
  final String headerSubtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StepHeader(step: step, subtitle: headerSubtitle),
            StepProgress(step: step),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title,
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800)),
                              if (subtitle != null) ...[
                                const SizedBox(height: 8),
                                Text(subtitle!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.35,
                                        color: AppColors.textSecondary)),
                              ],
                            ],
                          ),
                        ),
                        if (trailing != null) ...[
                          const SizedBox(width: 8),
                          trailing!,
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    body,
                  ],
                ),
              ),
            ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: footer,
              ),
            if (nav != null) nav!,
          ],
        ),
      ),
    );
  }
}

class SmallIconBox extends StatelessWidget {
  const SmallIconBox(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.35),
            AppColors.surface,
          ],
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, size: 40, color: AppColors.primaryLight),
    );
  }
}

// ───────────────────────── Step 1: Farm setup ─────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _locations = [
    'Cumilla Bangladesh',
    'Dhaka Bangladesh',
    'Chattogram Bangladesh',
    'Rajshahi Bangladesh',
    'Khulna Bangladesh',
    'Sylhet Bangladesh',
    'Barishal Bangladesh',
    'Rangpur Bangladesh',
    'Mymensingh Bangladesh',
  ];
  static const _sizes = [
    '1 acre',
    '2 acres',
    '3 acres',
    '5 acres',
    '10 acres',
    '20+ acres',
  ];

  String _location = _locations.first;
  String _size = _sizes[1];

  Future<void> _pick({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onSelected,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final o in options)
                    ListTile(
                      title: Text(o),
                      trailing: o == current
                          ? const Icon(Icons.check,
                          color: AppColors.primaryLight)
                          : null,
                      onTap: () => Navigator.pop(ctx, o),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (result != null) onSelected(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.eco, color: AppColors.primary, size: 32),
                  const SizedBox(width: 12),
                  const Text('AgriGuide',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    width: 48,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.more_vert,
                        color: AppColors.primaryLight, size: 20),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Row(
                children: [
                  const Text('1 of 6',
                      style: TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 1 / kTotalSteps,
                        minHeight: 5,
                        backgroundColor: AppColors.surface,
                        valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildHero(),
                    const SizedBox(height: 8),
                    _SelectorTile(
                      icon: Icons.location_on,
                      label: 'Farm location',
                      value: _location,
                      onTap: () => _pick(
                        title: 'Farm location',
                        options: _locations,
                        current: _location,
                        onSelected: (v) => setState(() => _location = v),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SelectorTile(
                      icon: Icons.grass,
                      label: 'Farm size',
                      value: _size,
                      onTap: () => _pick(
                        title: 'Farm size',
                        options: _sizes,
                        current: _size,
                        onSelected: (v) => setState(() => _size = v),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: GradientButton(
                label: 'Continue',
                // Goes to Step 2: Soil Details
                onTap: () => go(context, const SoilScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return SizedBox(
      height: 330,
      child: Stack(
        children: [
          // To use your own artwork instead of the drawn illustration:
          // Positioned.fill(child: Image.asset('assets/hero.png', fit: BoxFit.cover))
          const Positioned.fill(child: _HeroIllustration()),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 260,
                  child: Text(
                    'NASA-powered crop rotation decision support',
                    style: TextStyle(
                        fontSize: 25, height: 1.2, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 14),
                const SizedBox(
                  width: 220,
                  child: Text(
                    "Let's set up your farm to get personalized recommendations.",
                    style: TextStyle(
                        fontSize: 15,
                        height: 1.35,
                        color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectorTile extends StatelessWidget {
  const _SelectorTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.iconCircle,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryLight, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryLight),
        ],
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final sat = Offset(c.maxWidth * 0.72, c.maxHeight * 0.14);
      return Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _FieldPainter())),
          Positioned(
            left: sat.dx - 22,
            top: sat.dy - 22,
            child: Transform.rotate(
              angle: 0.6,
              child: const Icon(Icons.satellite_alt,
                  size: 44, color: Color(0xFFD9C8FF)),
            ),
          ),
        ],
      );
    });
  }
}

class _FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final tl = Offset(w * 0.34, h * 0.60);
    final tr = Offset(w * 0.97, h * 0.52);
    final br = Offset(w * 1.00, h * 0.92);
    final bl = Offset(w * 0.22, h * 0.97);

    Offset pt(double u, double v) {
      final top = Offset.lerp(tl, tr, u)!;
      final bottom = Offset.lerp(bl, br, u)!;
      return Offset.lerp(top, bottom, v)!;
    }

    final sat = Offset(w * 0.72, h * 0.14);
    final beam = Path()
      ..moveTo(sat.dx, sat.dy)
      ..lineTo(pt(0.1, 0.1).dx, pt(0.1, 0.1).dy)
      ..lineTo(pt(0.85, 0.35).dx, pt(0.85, 0.35).dy)
      ..close();
    canvas.drawPath(
      beam,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryLight.withValues(alpha: 0.55),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    const cols = 4, rows = 3;
    final fill = Paint()..color = const Color(0xFF1B1430).withValues(alpha: 0.9);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.primary.withValues(alpha: 0.7);

    for (var r = 0; r < rows; r++) {
      for (var cI = 0; cI < cols; cI++) {
        final a = pt(cI / cols, r / rows);
        final b = pt((cI + 1) / cols, r / rows);
        final c = pt((cI + 1) / cols, (r + 1) / rows);
        final d = pt(cI / cols, (r + 1) / rows);
        final p = Path()
          ..moveTo(a.dx, a.dy)
          ..lineTo(b.dx, b.dy)
          ..lineTo(c.dx, c.dy)
          ..lineTo(d.dx, d.dy)
          ..close();
        canvas.drawPath(p, fill);
        canvas.drawPath(p, stroke);
      }
    }

    final outline = Path()
      ..moveTo(tl.dx, tl.dy)
      ..lineTo(tr.dx, tr.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();
    canvas.drawPath(
      outline,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AppColors.primaryLight
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ───────────────────────── Step 2: Soil details ─────────────────────────

class SoilScreen extends StatefulWidget {
  const SoilScreen({super.key});

  @override
  State<SoilScreen> createState() => _SoilScreenState();
}

class _SoilScreenState extends State<SoilScreen> {
  static const _levelNames = ['Low', 'Medium', 'High'];
  static const _levelIcons = [
    Icons.eco_outlined,
    Icons.signal_cellular_alt_2_bar,
    Icons.signal_cellular_alt,
  ];

  double _ph = 5.8;

  // name, badge letter (null = use icon), level index (0 low, 1 medium, 2 high)
  final List<({String name, String? letter, int level})> _nutrients = [
    (name: 'Nitrogen', letter: 'N', level: 0),
    (name: 'Phosphorus', letter: 'P', level: 1),
    (name: 'Potassium', letter: 'K', level: 1),
    (name: 'Organic Matter', letter: null, level: 0),
  ];

  Future<void> _editPh() async {
    var temp = _ph;
    final v = await showDialog<double>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Soil pH'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(temp.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w800)),
              Slider(
                value: temp,
                min: 4,
                max: 9,
                divisions: 50,
                onChanged: (x) => setS(() => temp = x),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(ctx, temp),
                child: const Text('Save')),
          ],
        ),
      ),
    );
    if (v != null) setState(() => _ph = v);
  }

  @override
  Widget build(BuildContext context) {
    return StepShell(
      step: 2,
      title: 'Soil Details',
      subtitle:
      'Your soil inputs complement NASA Earth Observation data for precise recommendations.',
      trailing: const SmallIconBox(Icons.eco),
      body: Column(
        children: [
          AppCard(
            onTap: _editPh,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                CircleBadge.icon(Icons.water_drop_outlined, size: 40),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text('pH',
                      style:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                ),
                Text(_ph.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
              ],
            ),
          ),
          for (var i = 0; i < _nutrients.length; i++) ...[
            const SizedBox(height: 10),
            AppCard(
              onTap: () => setState(() {
                final n = _nutrients[i];
                _nutrients[i] =
                (name: n.name, letter: n.letter, level: (n.level + 1) % 3);
              }),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  CircleBadge(
                    size: 40,
                    child: _nutrients[i].letter != null
                        ? Text(_nutrients[i].letter!,
                        style: const TextStyle(
                            color: AppColors.primaryLight,
                            fontSize: 18,
                            fontWeight: FontWeight.w700))
                        : const Icon(Icons.spa,
                        color: AppColors.primaryLight, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(_nutrients[i].name,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    width: 130,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.iconCircle,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_levelIcons[_nutrients[i].level],
                            color: AppColors.primaryLight, size: 20),
                        const SizedBox(width: 8),
                        Text(_levelNames[_nutrients[i].level],
                            style: const TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      footer: GradientButton(
        label: 'Analyze Farm',
        icon: Icons.arrow_forward,
        onTap: () => go(context, const ObservationsScreen()),
      ),
      nav: const BottomNav(
        index: 1,
        items: [
          (Icons.home_outlined, 'Home'),
          (Icons.science_outlined, 'Analyze'),
          (Icons.bar_chart, 'Insights'),
          (Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }
}

// ───────────────────────── Step 3: NASA Earth Observation ─────────────────────────

List<double> _wave(double seed) => List.generate(
  24,
      (i) => (0.5 + 0.28 * sin(i * 0.6 + seed) + 0.12 * sin(i * 2.3 + seed * 2))
      .clamp(0.0, 1.0)
      .toDouble(),
);

class _SparkPainter extends CustomPainter {
  _SparkPainter(this.data);

  final List<double> data;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    Offset? last;
    for (var i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * size.width;
      final y = size.height - (data[i] * size.height * 0.8) - size.height * 0.1;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      last = Offset(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.primaryLight,
    );
    if (last != null) {
      canvas.drawCircle(last, 3, Paint()..color = AppColors.primaryLight);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkPainter old) => old.data != data;
}

class ObservationsScreen extends StatelessWidget {
  const ObservationsScreen({super.key});

  Widget _metric(IconData icon, String label, String value, double seed) {
    return AppCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleBadge.icon(icon, size: 34),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value,
                style:
                const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          ),
          const Spacer(),
          SizedBox(
            height: 24,
            width: double.infinity,
            child: CustomPaint(painter: _SparkPainter(_wave(seed))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StepShell(
      step: 3,
      title: 'NASA Earth Observation',
      subtitle:
      'Satellite-derived indicators provide context about your farm environment and conditions.',
      body: Column(
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.74,
            children: [
              _metric(Icons.thermostat, 'Temperature', '29.5°C', 1),
              _metric(Icons.cloud_outlined, 'Rainfall', '850 mm', 2),
              _metric(Icons.water_drop_outlined, 'Soil Moisture', '18%', 3),
              _metric(Icons.eco_outlined, 'NDVI', '0.42', 4),
              AppCard(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleBadge.icon(Icons.shield_outlined, size: 34),
                    const SizedBox(height: 6),
                    const Text('Drought Risk',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('Moderate',
                            style: TextStyle(
                                color: AppColors.amber,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              AppCard(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleBadge.icon(Icons.satellite_alt, size: 34),
                    const SizedBox(height: 10),
                    const Text('NASA Earth Observation data',
                        style: TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: AppColors.primaryLight),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'These satellite observations are part of your farm context. Use them with field data and recommendations for better decisions.',
                    style: TextStyle(fontSize: 13, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      footer: GradientButton(
        label: 'Next: AI Analysis',
        icon: Icons.arrow_forward,
        onTap: () => go(context, const CropResultsScreen()),
      ),
      nav: const BottomNav(
        index: 2,
        items: [
          (Icons.home_outlined, 'Home'),
          (Icons.grass, 'Fields'),
          (Icons.satellite_alt, 'Observations'),
          (Icons.recommend_outlined, 'Recommendations'),
          (Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }
}

// ───────────────────────── Step 4: Crop suitability ─────────────────────────

class _Crop {
  const _Crop(this.name, this.emoji, this.water, this.soil, this.climate,
      this.desc, this.score);

  final String name;
  final String emoji; // replace with an image asset when you have photos
  final String water;
  final String soil;
  final String climate;
  final String desc;
  final int score;
}

const _crops = [
  _Crop('Mung Bean', '🌱', 'Low', 'High', 'High',
      'Thrives in low water conditions, enriches soil with nitrogen, and performs well in warm, dry climates.', 87),
  _Crop('Lentil', '🌿', 'Low', 'High', 'Medium',
      'Well-suited to cool, dry conditions; improves soil structure and supports sustainable yields.', 82),
  _Crop('Maize', '🌽', 'Medium', 'Medium', 'Medium',
      'Reliable yield under moderate inputs; adapts well to seasonal rainfall and varied soil types.', 71),
  _Crop('Rice', '🌾', 'High', 'Low', 'Medium',
      'Requires more water and nutrient input; suitable with assured irrigation and fertile soils.', 58),
];

class CropResultsScreen extends StatelessWidget {
  const CropResultsScreen({super.key});

  Widget _attr(IconData icon, String label, String value) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: AppColors.primaryLight),
      const SizedBox(width: 3),
      Text('$label $value',
          style: const TextStyle(fontSize: 10, height: 1.2)),
    ],
  );

  Widget _cropCard(int i, _Crop c) {
    return AppCard(
      highlight: i == 0,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1F3D2B), Color(0xFF14241B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(c.emoji, style: const TextStyle(fontSize: 36)),
              ),
              Positioned(
                left: 4,
                top: 4,
                child: Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child: Text('${i + 1}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  children: [
                    _attr(Icons.water_drop_outlined, 'Water', c.water),
                    _attr(Icons.eco_outlined, 'Soil', c.soil),
                    _attr(Icons.shield_outlined, 'Climate', c.climate),
                  ],
                ),
                const SizedBox(height: 4),
                Text(c.desc,
                    style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.3,
                        color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 68,
            height: 68,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: c.score / 100,
                  strokeWidth: 6,
                  backgroundColor: AppColors.border,
                  valueColor:
                  const AlwaysStoppedAnimation(AppColors.primaryLight),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${c.score}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800)),
                      const Text('/100',
                          style: TextStyle(
                              fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void next() => go(context, const RotationScreen());
    return StepShell(
      step: 4,
      title: 'Crop Suitability Results',
      subtitle:
      'Ranked crops for your field based on NASA satellite data, soil and climate analysis.',
      body: Column(
        children: [
          for (var i = 0; i < _crops.length; i++) ...[
            _cropCard(i, _crops[i]),
            const SizedBox(height: 10),
          ],
        ],
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GradientButton(
            label: 'Continue to Rotation Recommendation',
            icon: Icons.arrow_forward,
            height: 50,
            onTap: next,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 110,
                child: OutlinePillButton(
                  label: 'Back',
                  icon: Icons.arrow_back,
                  height: 44,
                  onTap: () => Navigator.maybePop(context),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < kTotalSteps; i++)
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == 3 ? AppColors.primary : AppColors.border,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 110,
                child: OutlinePillButton(
                  label: 'Next',
                  icon: Icons.arrow_forward,
                  iconAfter: true,
                  height: 44,
                  onTap: next,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Step 5: Recommended rotation ─────────────────────────

class RotationScreen extends StatelessWidget {
  const RotationScreen({super.key});

  static const _seasons = [
    ('Season 1', 'Kharif', 'Mung Bean', '🌱'),
    ('Season 2', 'Rabi', 'Rice', '🌾'),
    ('Season 3', 'Summer', 'Lentil', '🫘'),
  ];

  Widget _infoRow(IconData icon, String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleBadge.icon(icon, size: 54),
            const SizedBox(width: 12),
            Container(width: 1, height: 52, color: AppColors.border),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(text,
                      style: const TextStyle(
                          fontSize: 12,
                          height: 1.3,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primaryLight),
          ],
        ),
      ),
    );
  }

  Widget _arrowCircle() => Container(
    width: 28,
    height: 28,
    decoration: const BoxDecoration(
        color: AppColors.primary, shape: BoxShape.circle),
    child: const Icon(Icons.arrow_forward, size: 16),
  );

  @override
  Widget build(BuildContext context) {
    return StepShell(
      step: 5,
      title: 'Recommended Rotation',
      subtitle: 'NASA-powered guidance for your field',
      body: Column(
        children: [
          AppCard(
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(builder: (context, cons) {
              const gap = 36.0;
              final e = (cons.maxWidth - 2 * gap) / 3;
              return Column(
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < 3; i++) ...[
                        SizedBox(
                          width: e,
                          child: Text(
                            '${_seasons[i].$1}\n${_seasons[i].$2}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                        if (i < 2) const SizedBox(width: gap),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 14,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: e / 2,
                          right: e / 2,
                          child: Container(
                              height: 2,
                              color: AppColors.primary.withValues(alpha: 0.6)),
                        ),
                        Row(
                          children: [
                            for (var i = 0; i < 3; i++) ...[
                              SizedBox(
                                width: e,
                                child: Center(
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                              ),
                              if (i < 2) const SizedBox(width: gap),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 3; i++) ...[
                        Container(
                          width: e,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.iconCircle,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: i == 0
                                  ? AppColors.primaryLight
                                  : AppColors.border,
                              width: i == 0 ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(_seasons[i].$4,
                                  style: const TextStyle(fontSize: 34)),
                              const SizedBox(height: 6),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(_seasons[i].$3,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ),
                        if (i < 2)
                          SizedBox(
                              width: gap, child: Center(child: _arrowCircle())),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Mung Bean  →  Rice  →  Lentil',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.spa, 'Soil Health',
              'Mung bean fixes nitrogen and adds organic matter, rice sustains soil structure, and lentil reduces disease buildup for a healthier soil.'),
          _infoRow(Icons.water_drop_outlined, 'Water Efficiency',
              'This rotation optimizes water use across seasons, reducing stress on water resources while maintaining productivity.'),
          _infoRow(Icons.thermostat, 'Climate Adaptation',
              'Diverse crops improve resilience to weather variability and support stable yields under changing climate conditions.'),
        ],
      ),
      footer: BackNextRow(onNext: () => go(context, const WhyScreen())),
    );
  }
}

// ───────────────────────── Step 6: Why this recommendation ─────────────────────────

class WhyScreen extends StatelessWidget {
  const WhyScreen({super.key});

  static const _factors = [
    (Icons.satellite_alt, 'NASA climate/vegetation indicators',
    'We use NASA satellite data for rainfall, temperature trends, soil moisture and vegetation health.'),
    (Icons.spa, 'Local soil inputs',
    'Your soil type, organic matter, pH and nutrients shape how well crops will perform.'),
    (Icons.biotech, 'Crop traits',
    'We consider crop growth duration, water needs, nitrogen fixation and resilience to stress.'),
    (Icons.person_outline, 'Farmer priorities',
    'Your goals for yield, income, soil health and risk guide the final scoring and ranking.'),
  ];

  @override
  Widget build(BuildContext context) {
    return StepShell(
      step: 6,
      title: 'Why This Recommendation',
      subtitle:
      'Your rotation score combines four key factors to find the best fit for your field and goals.',
      headerSubtitle: 'NASA-powered',
      body: Column(
        children: [
          Stack(
            children: [
              Positioned(
                left: 15,
                top: 20,
                bottom: 20,
                child: Container(width: 2, color: AppColors.primary),
              ),
              Column(
                children: [
                  for (var i = 0; i < _factors.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.bg,
                              border: Border.all(
                                  color: AppColors.primaryLight, width: 2),
                            ),
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppCard(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  CircleBadge.icon(_factors[i].$1, size: 52),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(_factors[i].$2,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 2),
                                        Text(_factors[i].$3,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                height: 1.3,
                                                color:
                                                AppColors.textSecondary)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          AppCard(
            highlight: true,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const SmallIconBox(Icons.spa),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RESULTING RECOMMENDATION',
                          style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 0.6,
                              color: AppColors.textSecondary)),
                      SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Mung Bean → Rice → Lentil',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800)),
                      ),
                      SizedBox(height: 4),
                      Text(
                          'This rotation best balances productivity, resilience and your field conditions.',
                          style: TextStyle(fontSize: 12.5, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: AppColors.primaryLight),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                      'Demo scores are illustrative, not validated agronomic predictions.',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ],
      ),
      footer: BackNextRow(
        nextLabel: 'Done',
        nextIcon: Icons.check,
        onNext: () => go(context, const ChatScreen()),
      ),
      nav: const BottomNav(
        index: 2,
        items: [
          (Icons.home_outlined, 'Home'),
          (Icons.grass, 'Fields'),
          (Icons.eco_outlined, 'Recommendations'),
          (Icons.bar_chart, 'Insights'),
          (Icons.menu, 'More'),
        ],
      ),
    );
  }
}

// ───────────────────────── Chat: Agri-aichat ─────────────────────────

class _Msg {
  const _Msg(this.farmer, this.sender, this.text);

  final bool farmer;
  final String sender;
  final String text;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const _farmer = '🧑‍🌾 Farmer:';
  static const _ai = '🤖 AgriGuide AI:';

  final _controller = TextEditingController();
  final _scroll = ScrollController();

  final List<_Msg> _msgs = [
    const _Msg(true, _farmer, 'আমার crop আরও ভালোভাবে grow করানোর জন্য কী করতে পারি?'),
    const _Msg(false, _ai,
        '🌱 Soil: Nitrogen কম → organic inputs ব্যবহার করুন।\n💧 Water: Soil moisture কম → unnecessary irrigation এড়ান।\n⚠️ Weather: Heavy rainfall risk detected.'),
    const _Msg(true, _farmer, 'আজকে কি কোনো warning আছে?'),
    const _Msg(false, _ai,
        '⚠️ Weather Notice — heavy rainfall-এর সম্ভাবনা। drainage পরীক্ষা করুন, পানি জমা কমান, প্রয়োজন ছাড়া irrigation বন্ধ রাখুন।\n🚨 Government Agriculture Notice — এলাকার সরকারি কৃষি notice/পরামর্শ দেখানো হবে।\n☎️ Agriculture Hotline: 16123'),
    const _Msg(true, _farmer, 'নতুন কৃষি গবেষণা নিয়ে তথ্য দাও'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() {
    final t = _controller.text.trim();
    if (t.isEmpty) return;
    setState(() => _msgs.add(_Msg(true, _farmer, t)));
    _controller.clear();
    _scrollDown();

    // TODO: replace this canned reply with a real AI/backend call.
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _msgs.add(const _Msg(false, _ai,
          'আপনার প্রশ্নটি পেয়েছি। শীঘ্রই বিস্তারিত পরামর্শ দেখানো হবে।')));
      _scrollDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width * 0.78;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const StepHeader(step: 6, subtitle: 'NASA-powered'),
            const StepProgress(step: 6),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Agri-aichat',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _msgs.length,
                itemBuilder: (context, i) {
                  final m = _msgs[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Align(
                      alignment:
                      m.farmer ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxW),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: m.farmer
                                ? const Color(0xFF3B2A6B)
                                : const Color(0xFF2A2050),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.sender,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(m.text,
                                  style: const TextStyle(
                                      fontSize: 13.5, height: 1.4)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _send(),
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Ask AgriGuide… / প্রশ্ন লিখুন…',
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide:
                          const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide:
                          const BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _send,
                    style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
            const BottomNav(
              index: 3,
              items: [
                (Icons.home_outlined, 'Home'),
                (Icons.grass, 'Fields'),
                (Icons.eco_outlined, 'Recommendations'),
                (Icons.chat_bubble_outline, 'Chat'),
                (Icons.menu, 'More'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}