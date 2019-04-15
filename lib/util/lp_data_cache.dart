class LpDataCache<T> {
  final int _life; // seconds
  int _birth;
  T _data;

  LpDataCache(this._life) : assert(_life > 0);

  T get() {
    if (_data == null) {
      return null;
    }
    if (DateTime.now().millisecondsSinceEpoch - _birth > _life) {
      _data = null;
      return null;
    }
    return _data;
  }

  void set(T data) {
    _data = data;
    _birth = DateTime.now().millisecondsSinceEpoch;
  }
}
