import 'structure.dart';

/// The EvaluationContext is a container for arbitrary contextual data that can be used as a basis for dynamic evaluation.
abstract class EvaluationContext extends Structure {
  String getTargetingKey();

  EvaluationContext merge(EvaluationContext? overridingContext);
}
