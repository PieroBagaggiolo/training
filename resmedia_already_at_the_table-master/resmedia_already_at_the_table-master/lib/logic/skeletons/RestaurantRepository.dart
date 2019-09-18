import 'package:easy_blocs/easy_blocs.dart';
import 'package:rxdart/rxdart.dart';

abstract class BoneValue<M> extends Bone {
  Stream<M> get outValue;
  M get value;
}


abstract class SkeletonValue<M> extends BlocBase implements BoneValue<M> {
  SkeletonValue(M initialValue)
      : _valueController = BehaviorSubject.seeded(initialValue) {
    _pocket = TinyPocket(_valueController);
  }

  TinyPocket _pocket;
  TinyPocket get pocket => _pocket;

  final BehaviorSubject<M> _valueController;
  Stream<M> get outValue => _valueController.stream;
  M get value => _valueController.value;

  @override
  void dispose() {
    _valueController.close();
    super.dispose();
  }
}

abstract class BoneValues<M> extends Bone {
  Stream<List<M>> get outValue;
  List<M> get values;
}

class SkeletonValues<M> extends BlocBase implements BoneValues<M> {
  SkeletonValues({List<M> initialValue})
      : _valuesController = BehaviorSubject.seeded(initialValue) {
    _pocket = TinyPocket(_valuesController);
  }

  TinyPocket<List<M>> _pocket;
  TinyPocket<List<M>> get pocket => _pocket;

  final BehaviorSubject<List<M>> _valuesController;
  Stream<List<M>> get outValue => _valuesController.stream;
  List<M> get values => _valuesController.value;

  @override
  void dispose() {
    _valuesController.close();
    super.dispose();
  }
}


mixin PocketSkeleton {
  TinyPocket get pocketSub;
}