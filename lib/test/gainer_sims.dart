import 'package:flutter/material.dart';

class GainerSims extends StatelessWidget {
  const GainerSims({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text('Performing hot reload...'
            'Syncing files to device sdk gphone64 arm64...'
            'Reloaded 1 of 2241 libraries in 303ms (compile: 18 ms, reload: 156 ms, reassemble: 104 ms).'
            'Reloaded 2 of 2683 libraries in 281ms (compile: 17 ms, reload: 132 ms, reassemble: 83 ms)'),
      ),
    );
  }
}
