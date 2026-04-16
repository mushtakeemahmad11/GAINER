import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pin_controller.dart';

class PinScreen extends StatelessWidget {
  PinScreen({super.key});

  final PinController controller = Get.put(PinController());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE9EBFF), Color(0xFFF7F5FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth > 420
                    ? 380.0
                    : constraints.maxWidth * 0.86;

                return Container(
                  width: cardWidth,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 20,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.isSettingUp.value
                            ? 'Set Passcode'
                            : 'Enter Passcode',
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.isSettingUp.value
                            ? 'Create a 6-digit code'
                            : 'Please enter your passcode',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: Colors.black54),
                      ),
                      const SizedBox(height: 24),

                      /// PIN DOTS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          final filled =
                              index < controller.digits.length;
                          return AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 150),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: filled
                                  ? const Color(0xFF4C6FFF)
                                  : Colors.black12,
                            ),
                          );
                        }),
                      ),

                      /// ERROR TEXT
                      if (controller.errorText?.value.isNotEmpty ==
                          true) ...[
                        const SizedBox(height: 12),
                        Text(
                          controller.errorText!.value,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      /// NUMPAD
                      _Numpad(
                        onDigit: controller.onDigitTap,
                        onBackspace: controller.onBackspace,
                      ),
                    ],
                  )),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Numpad extends StatelessWidget {
  const _Numpad({
    required this.onDigit,
    required this.onBackspace,
  });

  final void Function(int) onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final buttonSize = MediaQuery.sizeOf(context).width / 4.2;
    return Column(
      children: [
        const SizedBox(height: 8),
        for (final row in const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row
                .map(
                  (n) => _NumpadButton(
                label: '$n',
                size: buttonSize,
                onTap: () => onDigit(n),
              ),
            )
                .toList(),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: buttonSize, height: buttonSize),
            _NumpadButton(
              label: '0',
              size: buttonSize,
              onTap: () => onDigit(0),
            ),
            _NumpadIconButton(
              icon: Icons.backspace_outlined,
              size: buttonSize,
              onTap: onBackspace,
            ),
          ],
        ),
      ],
    );
  }
}

class _NumpadButton extends StatelessWidget {
  const _NumpadButton({
    required this.label,
    required this.size,
    required this.onTap,
  });

  final String label;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: const Color(0xFFF4F5FF),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NumpadIconButton extends StatelessWidget {
  const _NumpadIconButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Icon(icon, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
