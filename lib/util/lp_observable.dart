typedef void LpObserver<D>(D data);

class LpObservable<C, D> {
  final _observers = <C, List<LpObserver<D>>>{};

  void observe(C change, LpObserver<D> observer) {
    if (!_observers.containsKey(change)) {
      _observers[change] = [];
    }
    _observers[change].add(observer);
  }

  void unobserve(C change, LpObserver<D> observer) {
    if (_observers.containsKey(change)) {
      _observers[change].remove(observer);
    }
  }

  void notify(C change, D data) {
    if (_observers.containsKey(change)) {
      _observers[change].forEach((observer) => observer(data));
    }
  }
}
