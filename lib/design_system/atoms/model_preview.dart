import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../theme.dart';

/// Small wrapper that attempts to load an asset before embedding
/// it into `ModelViewer`. If the asset can't be loaded, it shows
/// a fallback icon instead of crashing or leaving a blank area.
class ModelPreview extends StatefulWidget {
  final String src;
  final String alt;
  final Color? backgroundColor;
  final bool ar;
  final bool autoRotate;
  final bool cameraControls;

  const ModelPreview({
    super.key,
    required this.src,
    required this.alt,
    this.backgroundColor,
    this.ar = true,
    this.autoRotate = true,
    this.cameraControls = true,
  });

  @override
  State<ModelPreview> createState() => _ModelPreviewState();
}

class _ModelPreviewState extends State<ModelPreview> {
  bool _exists = false;
  bool _checked = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAsset();
  }

  Future<void> _checkAsset() async {
    try {
      // Try to load the asset from the asset bundle. This confirms
      // the file is present in the packaged assets and accessible.
      await rootBundle.load(widget.src);

      // If it's a .gltf (JSON-based), also verify that any external
      // resource URIs it references (images, .bin) exist alongside it.
      if (widget.src.toLowerCase().endsWith('.gltf')) {
        try {
          final jsonText = await rootBundle.loadString(widget.src);
          final Map<String, dynamic> doc = jsonDecode(jsonText);
          final missing = <String>[];

          // collect referenced URIs from 'images' and anywhere with 'uri'
          void checkUris(dynamic node) {
            if (node is Map<String, dynamic>) {
              node.forEach((k, v) {
                if (k == 'uri' && v is String) {
                  final baseDir = widget.src.contains('/')
                      ? widget.src.substring(0, widget.src.lastIndexOf('/') + 1)
                      : '';
                  final candidate = baseDir + v;
                  try {
                    rootBundle.load(candidate);
                  } catch (e) {
                    missing.add(v);
                  }
                } else {
                  checkUris(v);
                }
              });
            } else if (node is List) {
              for (final item in node) { checkUris(item); }
            }
          }

          checkUris(doc);

          if (missing.isNotEmpty) {
            _errorMessage = 'Recursos faltantes: ${missing.join(', ')}';
            if (mounted) setState(() { _exists = false; _checked = true; });
            return;
          }
        } catch (e) {
          // If parsing fails, mark as not existing to avoid crashes.
          _errorMessage = 'No se pudo parsear el glTF: ${e.toString()}';
          if (mounted) setState(() { _exists = false; _checked = true; });
          return;
        }
      }

      if (mounted) setState(() { _exists = true; _checked = true; });
    } catch (e) {
      if (mounted) setState(() { _exists = false; _checked = true; _errorMessage = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(height: 16),
            Text(
              'Preparando modelo 3D...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (!_exists) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.broken_image, size: 40),
            const SizedBox(height: 8),
            Text('Modelo no disponible', style: Theme.of(context).textTheme.bodySmall),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(_errorMessage!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error)),
            ],
          ],
        ),
      );
    }

    // Show model viewer directly without overlay
    return RepaintBoundary(
      child: ModelViewer(
        src: widget.src,
        alt: widget.alt,
        ar: widget.ar,
        autoRotate: widget.autoRotate,
        cameraControls: widget.cameraControls,
        backgroundColor: widget.backgroundColor ?? AppColors.transparent,
      ),
    );
  }
}
