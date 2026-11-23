import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/game_entities.dart';

/// Resumen del resultado VALIDADO por el backend.
///
/// Usa los colores del tema (ColorScheme) para que el texto contraste bien
/// tanto en modo claro como en modo oscuro.
class ResultSummary extends StatelessWidget {
  const ResultSummary({
    super.key,
    required this.result,
    required this.onPlayNext,
    required this.onBack,
  });

  final GameResult result;
  final VoidCallback onPlayNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final onCard = scheme.onSurface;
    final muted = scheme.onSurfaceVariant;
    final b = result.breakdown;
    final changeText = switch (result.difficultyChange) {
      'increase' => '¡Subes de dificultad! Próximo reto: ${difficultyLabel(result.recommendedDifficulty)}',
      'decrease' => 'Bajamos la dificultad a ${difficultyLabel(result.recommendedDifficulty)}',
      _ => 'Dificultad recomendada: ${difficultyLabel(result.recommendedDifficulty)}',
    };

    return Card(
      key: const Key('result_summary'),
      color: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.primary, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: onCard),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.emoji_events, size: 48, color: Colors.amber),
            Text('¡Puzzle resuelto!', style: text.headlineSmall?.copyWith(color: onCard)),
            const SizedBox(height: 8),
            Text('${result.points} puntos',
                key: const Key('result_points'),
                style: text.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                )),
            const SizedBox(height: 12),
            _row('Tiempo', formatDuration(result.durationSeconds)),
            _row('Errores', '${result.mistakes}'),
            _row('Pistas', '${result.hintsUsed}'),
            Divider(color: scheme.outlineVariant),
            _row('Base', '+${b['base'] ?? 0}'),
            _row('Bonus de tiempo', '+${b['time_bonus'] ?? 0}', color: scheme.tertiary),
            _row('Penalización tiempo', '-${b['time_penalty'] ?? 0}', color: scheme.error),
            _row('Penalización errores', '-${b['mistake_penalty'] ?? 0}', color: scheme.error),
            _row('Penalización pistas', '-${b['hint_penalty'] ?? 0}', color: scheme.error),
            Divider(color: scheme.outlineVariant),
            Text(changeText, textAlign: TextAlign.center, style: TextStyle(color: muted)),
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 8, alignment: WrapAlignment.center, children: [
              OutlinedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.list),
                label: const Text('Niveles'),
              ),
              FilledButton.icon(
                key: const Key('play_next'),
                onPressed: onPlayNext,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Siguiente reto'),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Expanded(child: Text(label)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ]),
      );
}