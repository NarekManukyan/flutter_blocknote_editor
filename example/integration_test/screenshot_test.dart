import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:blocknote_editor_example/main.dart' as app;

/// Integration test that captures screenshots of the editor in various states.
///
/// Run with:
/// ```
/// cd example
/// flutter test integration_test/screenshot_test.dart -d <device_id>
/// ```
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Editor Screenshots', () {
    testWidgets('Capture editor screenshots', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for the editor to fully load (WebView + BlockNote.js init).
      // The editor needs time to copy assets, load the HTML, and init React.
      await _waitForEditorReady(tester, timeout: const Duration(seconds: 30));

      // Extra settle time for WebView rendering
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // 1. Editor Light Mode
      await _takeScreenshot(binding, 'editor_light');

      // 2. Editor Dark Mode - toggle dark mode
      await _tapIconButton(tester, Icons.dark_mode);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await _takeScreenshot(binding, 'editor_dark');

      // Turn dark mode off for next screenshots
      await _tapIconButton(tester, Icons.light_mode);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // 3. Custom Theme - open settings menu, toggle custom theme
      await _openSettingsAndToggle(tester, 'Custom Theme');
      await tester.pump(const Duration(seconds: 2));
      await _takeScreenshot(binding, 'custom_theme');

      // Turn off custom theme
      await _openSettingsAndToggle(tester, 'Custom Theme');
      await tester.pumpAndSettle();

      // 4. Custom Font
      await _openSettingsAndToggle(tester, 'Custom Font');
      await tester.pump(const Duration(seconds: 2));
      await _takeScreenshot(binding, 'custom_font');

      // Turn off custom font
      await _openSettingsAndToggle(tester, 'Custom Font');
      await tester.pumpAndSettle();

      // 5. Read-only mode
      await _tapIconButton(tester, Icons.lock_open);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      await _takeScreenshot(binding, 'read_only');

      // Turn off read-only
      await _tapIconButton(tester, Icons.lock);
      await tester.pumpAndSettle();

      // 6. Modal editor
      await _tapIconButton(tester, Icons.open_in_full);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Tap the first sample document in the picker
      final meetingNotes = find.text('Meeting Notes');
      if (meetingNotes.evaluate().isNotEmpty) {
        await tester.tap(meetingNotes);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 5));
        await _takeScreenshot(binding, 'modal_editor');

        // Close the modal
        final closeButton = find.byIcon(Icons.close);
        if (closeButton.evaluate().isNotEmpty) {
          await tester.tap(closeButton.last);
          await tester.pumpAndSettle();
        }
      }

      // Note: slash_menu, custom_slash_commands, toolbar, and custom_block
      // screenshots require interacting with the WebView content (typing "/",
      // selecting text) which cannot be done via Flutter integration tests.
      // These should be captured manually from the simulator.
    });
  });
}

Future<void> _waitForEditorReady(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 500));
    // Check if the "Editor Ready" text appears in the status bar
    final readyText = find.text('Editor Ready');
    if (readyText.evaluate().isNotEmpty) {
      return;
    }
  }
  // Continue anyway even if not ready
}

Future<void> _tapIconButton(WidgetTester tester, IconData icon) async {
  final button = find.byIcon(icon);
  expect(button, findsWidgets);
  await tester.tap(button.first);
  await tester.pumpAndSettle();
}

Future<void> _openSettingsAndToggle(
  WidgetTester tester,
  String itemText,
) async {
  // Tap settings icon
  final settingsButton = find.byIcon(Icons.settings);
  await tester.tap(settingsButton);
  await tester.pumpAndSettle();

  // Tap the menu item
  final menuItem = find.text(itemText);
  expect(menuItem, findsOneWidget);
  await tester.tap(menuItem);
  await tester.pumpAndSettle();
}

Future<void> _takeScreenshot(
  IntegrationTestWidgetsFlutterBinding binding,
  String name,
) async {
  await binding.takeScreenshot(name);
}
