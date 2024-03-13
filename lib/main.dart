import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

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

enum City {
  newyork,
  london,
  paris,
}

typedef WeatheEmoji = String;

Future<WeatheEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.london: '⛈️',
      City.newyork: '🌤️',
      City.paris: '☁️',
    }[city]!,
  );
}

//ui writes and reads from this
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unkwonwaetheremoji = '🤷🏻';
//ui reads this
final weatherProvider = FutureProvider<WeatheEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return unkwonwaetheremoji;
  }
});

class HomepageScreen extends ConsumerWidget {
  const HomepageScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Text(
              data,
              style: const TextStyle(fontSize: 40),
            ),
            error: (_, __) => const Text('Error 😭'),
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: City.values.length,
                  itemBuilder: (context, index) {
                    final city = City.values[index];
                    final isSelected = city == ref.watch(currentCityProvider);

                    return ListTile(
                      title: Text(city.toString()),
                      trailing: isSelected ? const Icon(Icons.check) : null,
                      onTap: () {
                        ref.read(currentCityProvider.notifier).state = city;
                      },
                    );
                  }))
        ],
      ),
    );
  }
}
