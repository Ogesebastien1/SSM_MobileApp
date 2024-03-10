import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ssm_oversight/items/board.dart';
import 'package:ssm_oversight/items/workspace.dart';
// import 'package:ssm_oversight/items/card.dart';
// import 'package:ssm_oversight/items/list.dart';

import 'package:ssm_oversight/pages/board.dart';
// import 'package:ssm_oversight/pages/home.dart';
// import 'package:ssm_oversight/pages/workspace.dart';


// import 'package:ssm_oversight/services/create.dart';
// import 'package:ssm_oversight/services/delete.dart';
// import 'package:ssm_oversight/services/read.dart';
// import 'package:ssm_oversight/services/update.dart';

// import 'package:ssm_oversight/main.dart';

void main() {
  group('Items', () {
    group('Board', () {
      testWidgets('BoardButton Renders Correctly', (WidgetTester tester) async {
        // Create a BoardItem instance
        final boardItem = BoardItem(name: 'Test Board');

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

    group('Card', () {
      // Add tests for the Card item if needed
    });

    group('List', () {
      // Add tests for the List item if needed
    });

    group('Workspace', () {
      testWidgets('WorkspaceButton Renders Correctly', (WidgetTester tester) async {
        // Create a WorkspaceItem instance
        final workspaceItem = WorkspaceItem(name: 'Test Workspace', id: '');

        // Build the WorkspaceButton widget
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: WorkspaceButton(workspace: workspaceItem),
          ),
        ));

        // Verify that the text 'Test Workspace' is rendered
        expect(find.text('Test Workspace'), findsOneWidget);

        // Verify that the text style is applied correctly
        final textWidget = tester.widget<Text>(find.text('Test Workspace'));
        expect(textWidget.style!.fontSize, 16.0); // Verify font size
      });
    });
  });

  group('Pages', () {
    group('Board', () {
      testWidgets('BoardPage Renders Correctly', (WidgetTester tester) async {
        // Create a test widget with the BoardPage
        await tester.pumpWidget(const MaterialApp(
          home: BoardPage(name: 'Test Board'),
        ));

        // Verify that the title in the AppBar matches the provided name
        expect(find.text('Test Board'), findsOneWidget);

        // Verify that the welcome message is displayed correctly
        expect(find.text('Bienvenue sur le tableau Test Board'), findsOneWidget);
      });
    });
    // Add tests for other pages here
  });
}


