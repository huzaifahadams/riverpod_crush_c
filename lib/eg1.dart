import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() {
    state = state == null ? 1 : state! + 1;
  }

  void zeroo() {
    state = state == null ? 0 : null;
  }

  void sub1() {
    state = state == null ? 1 : state! - 1;
  }
}

final counterProvider =
    StateNotifierProvider<Counter, int?>((ref) => Counter());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const HomepageScreen(),
    );
  }
}

class HomepageScreen extends ConsumerWidget {
  const HomepageScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);

            final data = count == null ? 'Press button' : count.toString();
            return Text(data);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: ref.read(counterProvider.notifier).increment,
            child: const Text('Increment'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: ref.read(counterProvider.notifier).sub1,
              child: const Text('Decrement')),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: ref.read(counterProvider.notifier).zeroo,
              child: const Text('Reset '))
        ],
      ),
    );
  }
}
