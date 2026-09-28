import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../color/color_extractor.dart';
import '../color/oklab_interpolation.dart';
import '../models/ambient_glow_config.dart';
import '../painters/mesh_glow_painter.dart';
import '../painters/radial_glow_painter.dart';

/// A dynamic ambient backdrop glow widget that generates fluid mesh gradients and ambient lighting
/// derived automatically from image artwork or custom color palettes.
class AmbientBackdropGlow extends StatefulWidget {
  /// The image artwork source to extract ambient colors from.
  final ImageProvider? image;

  /// Optional direct color palette. Overrides [image] if provided.
  final List<Color>? colors;

  /// Optional pre-configured [AmbientColorPalette].
  final AmbientColorPalette? palette;

  /// The glow rendering style (mesh, radial, aurora, spotlight).
  final AmbientGlowMode mode;

  /// Visual styling configuration (blur, intensity, spread, speed).
  final AmbientGlowStyle style;

  /// Duration for smooth color cross-fades when artwork changes.
  final Duration crossFadeDuration;

  /// Optional foreground content rendered over the ambient backdrop.
  final Widget? child;

  /// Optional overlay widget (e.g. glassmorphism filter, gradient scrim).
  final Widget? overlay;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Creates an [AmbientBackdropGlow] widget.
  const AmbientBackdropGlow({
    super.key,
    this.image,
    this.colors,
    this.palette,
    this.mode = AmbientGlowMode.mesh,
    this.style = const AmbientGlowStyle(),
    this.crossFadeDuration = const Duration(milliseconds: 800),
    this.child,
    this.overlay,
    this.width,
    this.height,
  });

  @override
  State<AmbientBackdropGlow> createState() => _AmbientBackdropGlowState();
}

class _AmbientBackdropGlowState extends State<AmbientBackdropGlow>
    with TickerProviderStateMixin {
  late AnimationController _motionController;
  late AnimationController _crossFadeController;

  AmbientColorPalette _currentPalette = AmbientColorPalette.fallback();
  AmbientColorPalette _targetPalette = AmbientColorPalette.fallback();
  AmbientColorPalette _previousPalette = AmbientColorPalette.fallback();

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    );

    if (widget.style.speed > 0) {
      _motionController.repeat();
    }

    _crossFadeController = AnimationController(
      vsync: this,
      duration: widget.crossFadeDuration,
    )..addListener(() {
        setState(() {
          final double t = _crossFadeController.value;
          _currentPalette = _lerpPalette(_previousPalette, _targetPalette, t);
        });
      });

    _resolveInitialPalette();
  }

  void _resolveInitialPalette() {
    if (widget.palette != null) {
      _setTargetPalette(widget.palette!);
    } else if (widget.colors != null && widget.colors!.isNotEmpty) {
      _setTargetPalette(AmbientColorPalette.fromColors(widget.colors!));
    } else if (widget.image != null) {
      _extractFromImage(widget.image!);
    } else {
      _setTargetPalette(AmbientColorPalette.fallback());
    }
  }

  @override
  void didUpdateWidget(AmbientBackdropGlow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.palette != oldWidget.palette && widget.palette != null) {
      _animateToPalette(widget.palette!);
    } else if (widget.colors != oldWidget.colors && widget.colors != null) {
      _animateToPalette(AmbientColorPalette.fromColors(widget.colors!));
    } else if (widget.image != oldWidget.image && widget.image != null) {
      _extractFromImage(widget.image!);
    }

    if (widget.style.speed != oldWidget.style.speed) {
      if (widget.style.speed > 0 && !_motionController.isAnimating) {
        _motionController.repeat();
      } else if (widget.style.speed == 0 && _motionController.isAnimating) {
        _motionController.stop();
      }
    }
  }

  void _extractFromImage(ImageProvider imageProvider) async {
    final palette =
        await AmbientColorExtractor.extractFromProvider(imageProvider);
    if (mounted) {
      _animateToPalette(palette);
    }
  }

  void _setTargetPalette(AmbientColorPalette palette) {
    _currentPalette = palette;
    _targetPalette = palette;
    _previousPalette = palette;
  }

  void _animateToPalette(AmbientColorPalette newPalette) {
    _previousPalette = _currentPalette;
    _targetPalette = newPalette;
    _crossFadeController.forward(from: 0.0);
  }

  AmbientColorPalette _lerpPalette(
      AmbientColorPalette a, AmbientColorPalette b, double t) {
    return AmbientColorPalette(
      primary: OkLab.lerp(a.primary, b.primary, t),
      secondary: OkLab.lerp(a.secondary, b.secondary, t),
      accent: OkLab.lerp(a.accent, b.accent, t),
      background: OkLab.lerp(a.background, b.background, t),
      isDark: b.isDark,
    );
  }

  @override
  void dispose() {
    _motionController.dispose();
    _crossFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Ambient Glow Backdrop Layer
          AnimatedBuilder(
            animation: _motionController,
            builder: (context, child) {
              final double phase =
                  _motionController.value * 2 * math.pi * widget.style.speed;
              final CustomPainter painter = widget.mode == AmbientGlowMode.mesh
                  ? MeshGlowPainter(
                      palette: _currentPalette,
                      style: widget.style,
                      phase: phase,
                    )
                  : RadialGlowPainter(
                      palette: _currentPalette,
                      style: widget.style,
                      mode: widget.mode,
                      phase: phase,
                    );

              Widget canvas = CustomPaint(painter: painter);

              if (widget.style.blurSigma > 0) {
                canvas = ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: widget.style.blurSigma,
                    sigmaY: widget.style.blurSigma,
                    tileMode: TileMode.clamp,
                  ),
                  child: canvas,
                );
              }

              return canvas;
            },
          ),

          // 2. Optional Scrim / Overlay Layer
          if (widget.overlay != null) widget.overlay!,

          // 3. Foreground Child Content
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}
