import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passwd_hints/config/app_config.dart';
import 'package:passwd_hints/main.dart';
import 'package:passwd_hints/util/app_search_delegate.dart';
import 'package:passwd_hints/util/app_theme.dart';
import 'package:passwd_hints/util/buttons_actions.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:passwd_hints/util/rsa_cipher.dart';
import 'package:passwd_hints/widget/stateless/alphabet_index.dart';
import 'package:passwd_hints/widget/stateless/empty_list_card.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';

void main() {
  test('app config requires an explicit supported environment', () {
    expect(
      () => AppConfig.fromValues(''),
      throwsArgumentError,
    );

    final dev = AppConfig.fromValues('dev', apiBaseUrl: 'https://dev.example');
    expect(dev.environment, AppEnvironment.dev);
    expect(dev.apiBaseUrl, 'https://dev.example');
    expect(dev.appTitle, 'Passwd Hints Dev');

    final prod = AppConfig.fromValues('prod');
    expect(prod.environment, AppEnvironment.prod);
    expect(prod.appTitle, 'Passwd Hints');
  });

  test('light and dark themes use Material 3 with matching brightness', () {
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.light.brightness, Brightness.light);
    expect(AppTheme.dark.useMaterial3, isTrue);
    expect(AppTheme.dark.brightness, Brightness.dark);
    expect(
      AppTheme.light.appBarTheme.backgroundColor,
      AppTheme.light.colorScheme.primaryContainer,
    );
    expect(
      AppTheme.light.appBarTheme.backgroundColor,
      AppTheme.light.floatingActionButtonTheme.backgroundColor,
    );
    expect(
      AppTheme.dark.appBarTheme.backgroundColor,
      AppTheme.dark.floatingActionButtonTheme.backgroundColor,
    );
    expect(
      AppTheme.light.cardTheme.color,
      AppTheme.light.colorScheme.surfaceContainer,
    );
    expect(
      AppTheme.dark.cardTheme.color,
      AppTheme.dark.colorScheme.surfaceContainer,
    );
    expect(
      AppTheme.light.inputDecorationTheme.fillColor,
      AppTheme.light.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.65,
      ),
    );
    expect(
      AppTheme.dark.inputDecorationTheme.fillColor,
      AppTheme.dark.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.65,
      ),
    );
  });

  test('app bar status bar colors and icons contrast in both themes', () {
    final lightStyle = AppTheme.light.appBarTheme.systemOverlayStyle;
    final darkStyle = AppTheme.dark.appBarTheme.systemOverlayStyle;

    expect(lightStyle, isNotNull);
    expect(lightStyle!.statusBarColor,
        AppTheme.light.colorScheme.primaryContainer);
    expect(lightStyle.statusBarIconBrightness, Brightness.dark);
    expect(darkStyle, isNotNull);
    expect(
        darkStyle!.statusBarColor, AppTheme.dark.colorScheme.primaryContainer);
    expect(darkStyle.statusBarIconBrightness, Brightness.light);
  });

  testWidgets('alphabet index fits its area without scrolling or FAB overlap',
      (tester) async {
    final alphabets = [
      ...List.generate(26, (index) => String.fromCharCode(65 + index)),
      '0',
      '#',
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SizedBox(
            height: 700,
            child: AlphabetIndex(
              alphabets: alphabets,
              selectedLetter: null,
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    for (final letter in alphabets) {
      expect(find.text(letter), findsOneWidget);
    }
    expect(tester.getSize(find.byType(AlphabetIndex)).width, lessThan(48));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is GridView &&
            widget.physics is NeverScrollableScrollPhysics &&
            (widget.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
                    .crossAxisCount ==
                1,
      ),
      findsOneWidget,
    );
    expect(tester.getRect(find.text('#')).bottom, lessThanOrEqualTo(604));
  });

  testWidgets('home shows its title and add action', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.text('Passwd Hints'), findsOneWidget);
    expect(find.byTooltip('Search hints'), findsOneWidget);
    expect(find.text('Add hint'), findsOneWidget);
  });

  testWidgets('empty state offers a callback to create the first hint',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: EmptyListCard(onAddHint: () => tapped = true),
        ),
      ),
    );

    expect(find.text('No hints yet'), findsOneWidget);
    await tester.tap(find.text('Add your first hint'));
    expect(tapped, isTrue);
  });

  testWidgets('opening and dismissing hint details tears down its overlay',
      (tester) async {
    final cipher = RSACipherizer();
    final entry = HintEntry(
      'Example',
      cipher.cipherMessage('sample hint'),
      '',
    );
    final homeState = HomeState();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => hintEntryDisplayButtonOnPress(
                context,
                [entry],
                entry,
                homeState,
              ),
              child: const Text('Open hint'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open hint'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('opening a hint from search and dismissing it is safe',
      (tester) async {
    final cipher = RSACipherizer();
    final entry = HintEntry(
      'Example',
      cipher.cipherMessage('sample hint'),
      '',
    );
    final homeState = HomeState();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showSearch<void>(
                context: context,
                delegate: AppSearchDelegate([entry], context, homeState),
              ),
              child: const Text('Search'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Example'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('dismissing the new hint dialog from outside is safe',
      (tester) async {
    final homeState = HomeState();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => hintEntryAdditionButtonOnPress(
                context,
                homeState,
                [],
              ),
              child: const Text('Add'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextFormField).first);
    await tester.pump();
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    await tester.pump();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
