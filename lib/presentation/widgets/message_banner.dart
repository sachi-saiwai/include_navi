import 'package:flutter/material.dart';

import '../../app/app_scope.dart';

class MessageBanner extends StatelessWidget {
  const MessageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final error = controller.errorMessage;
    final info = controller.infoMessage;
    if (error == null && info == null) {
      return const SizedBox.shrink();
    }

    final isError = error != null;
    return Card(
      color: isError ? const Color(0xFFFFE7E4) : const Color(0xFFE8F6EE),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isError ? const Color(0xFFFFC9C2) : const Color(0xFFCFEAD8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isError ? Icons.error_outline : Icons.info_outline,
                color: isError ? const Color(0xFFB42318) : const Color(0xFF18794E),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    isError ? 'エラー' : 'お知らせ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(error ?? info!),
                ],
              ),
            ),
            IconButton(
              onPressed: controller.clearMessages,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}
