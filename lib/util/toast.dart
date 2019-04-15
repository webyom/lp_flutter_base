import 'util.dart';

void showSuccess(String text) {
  callNativeMethod('showSuccess', {'text': text});
}

void showWarning(String text) {
  callNativeMethod('showWarning', {'text': text});
}

void showError(String text) {
  callNativeMethod('showError', {'text': text});
}

void showToast(String text) {
  callNativeMethod('showToast', {'text': text});
}
