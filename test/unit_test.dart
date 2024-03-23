import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssm_oversight/items/board.dart';
import 'package:ssm_oversight/items/workspace.dart';
import 'package:ssm_oversight/pages/board.dart';
import 'package:ssm_oversight/pages/home.dart';
import 'package:ssm_oversight/pages/workspace.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  group('Items', () {
    group('Board', () {
      testWidgets('BoardButton Renders Correctly', (WidgetTester tester) async {
        // Create a BoardItem instance
        final boardItem = BoardItem(id: '', name: 'Test Board');

        // Build the BoardButton widget
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: BoardButton(board: boardItem),
          ),
        ));

        // Verify that the text 'Test Board' is rendered on the button
        expect(find.text('Test Board'), findsOneWidget);

        // Verify that the button is rendered with elevated button widget
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });


  });

  group('Pages', () {
    group('Home', () {
      testWidgets('Renders without crashing', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Home(),
        ));
        expect(find.byType(Home), findsOneWidget);
      });
    });

    group('Workspace', () {
      testWidgets('Workspace page renders without crashing', (WidgetTester tester) async {
        // Build the Workspace page
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: Workspace(workspaceId: 'TestUnit'),
          ),
        ));

        // Verify that the Workspace page renders without crashing
        expect(find.byType(Workspace), findsOneWidget);
      });
    });
  });
}