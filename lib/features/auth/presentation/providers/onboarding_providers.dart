import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier para menjar el indice actual del PageView
/// Usamos [Notifier] para manejar el estado de que pagina esta viendo el usuario
class PageIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int index) {
    state = index;
  }
}

final pageIndexProvider = NotifierProvider<PageIndexNotifier, int>(
  PageIndexNotifier.new,
);
