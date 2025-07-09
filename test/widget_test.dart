import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileplatform10/sign_up_page.dart';

void main() {
  testWidgets('Sign Up Page Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: SignUpPage()));

    // Verify that the sign-up button is present
    expect(find.text('Sign Up'), findsOneWidget);

    // Verify that email and password fields are present
    expect(find.byType(TextField), findsNWidgets(2));

    // Enter text into the email and password fields
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password123');

    // Tap the sign-up button
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // Verify that the status message is updated (you can customize this check based on your logic)
    expect(find.text('회원가입 실패'), findsNothing);  // Adjust this line based on your actual logic
  });
}
