import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/audio_service.dart';

class SoundButton extends StatelessWidget {
  const SoundButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audioService, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    audioService.isSoundEnabled
                        ? Icons.volume_up
                        : Icons.volume_off,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ses',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              Switch.adaptive(
                value: audioService.isSoundEnabled,
                onChanged: (value) async {
                  await audioService.toggleSound();
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.green.withOpacity(0.5),
                inactiveThumbColor: Colors.white70,
                inactiveTrackColor: Colors.red.withOpacity(0.3),
              ),
            ],
          ),
        );
      },
    );
  }
}
