import 'evaluation_context.dart';
import 'features.dart';
import 'hook.dart';
import 'metadata.dart';

/// Interface used to resolve flags of varying types.
abstract class Client extends Features {
  Metadata get metadata;

  EvaluationContext? get evaluationContext;

  set evaluationContext(EvaluationContext? evaluationContext);

  // Dart does not have varargs
  void addHook(Hook hook);

  List<Hook> get hooks;
}
