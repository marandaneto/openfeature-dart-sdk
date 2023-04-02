import 'evaluation_context.dart';
import 'features.dart';
import 'hook.dart';
import 'metadata.dart';

/// Interface used to resolve flags of varying types.
abstract class Client extends Features {
  Metadata getMetadata();

  EvaluationContext? getEvaluationContext();

  void setEvaluationContext(EvaluationContext ctx);

  // Dart does not have varargs
  void addHook(Hook hook);

  // remove hooks?

  List<Hook> getHooks();
}
