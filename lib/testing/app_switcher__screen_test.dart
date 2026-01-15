import 'package:flutter/material.dart';

class AppSwitcherScreen extends StatelessWidget {
  const AppSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F3D2E),
              Color(0xFF1F6B55),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Choose Your App',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Switch between your Gainer business apps',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        title: 'Dead Stock\nLiquidation',
                        icon: Icons.local_shipping_outlined,
                        buttonText: 'Switch to Gainer',
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => LogisticsHome()));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppCard(
                        title: 'Smart Inventory\nManagement System',
                        icon: Icons.analytics_outlined,
                        buttonText: 'Switch to SIMS',
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => ErpHome()));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String buttonText;
  final VoidCallback onTap;

  const AppCard({
    super.key,
    required this.title,
    required this.icon,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        // color: Colors.white.withOpacity(0.15),
        color: Colors.white.withAlpha(38),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Color(0xFF0F3D2E),
        //     Color(0xFF1F6B55),
        //   ],
        // ),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(icon, size: 40, color: Color(0xFF1F6B55)),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1F6B55),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(16),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(buttonText),
                const SizedBox(width: 3),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
