/// Dynamic ambient backdrop glow and fluid animated mesh gradients from image artwork with OKLab color blending for Flutter.
///
/// Provides GPU-accelerated [CustomPainter] and drop-in widgets for Spotify / Apple Music-style ambient backdrops,
/// sub-4ms color extraction, and perceptual OKLab color transitions.
///
/// Implementation by Govind Tank.
library ambient_backdrop_glow;

export 'src/models/ambient_glow_config.dart';
export 'src/color/oklab_interpolation.dart';
export 'src/color/color_extractor.dart';
export 'src/painters/mesh_glow_painter.dart';
export 'src/painters/radial_glow_painter.dart';
export 'src/widgets/ambient_backdrop_glow.dart';
