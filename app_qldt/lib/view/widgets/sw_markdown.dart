import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linkify/linkify.dart';
import 'package:app_qldt/controller/user_provider.dart';
import 'package:app_qldt/core/router/url.dart';
import 'package:app_qldt/core/theme/typestyle.dart';
import 'package:app_qldt/view/pages/profile/profile_other_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/palette.dart';

class SWMarkdown extends ConsumerWidget {
  final String data;
  final int? maxChildren;
  final double textScaleFactor;
  final String style;

  const SWMarkdown(
      {super.key,
      required this.data,
      this.maxChildren,
      this.textScaleFactor = 1,
      required this.style});

  void goToProfile(BuildContext context, WidgetRef ref, String userId) {
    if (userId == ref.read(userProvider).value?.userId) {
      context.go(profileRoute);
    } else {
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => ProfileOtherPage(userId: userId)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elements = linkify(data,
            linkifiers: [...defaultLinkifiers, const _CustomTelLinkifier()])
        .whereType<LinkableElement>()
        .toList();

    var newData = data.replaceAll("\n", "  \n");
    for (var e in elements) {
      final url = e.url.replaceAll(RegExp(r"[\(\)]"), "");
      final originText = e.originText;
      newData = newData.replaceAll(url, "[$originText]($url)");
      newData = newData.replaceAll("([$originText]($url))", "($url)");
    }

    var bodyMedium = style != "delete" ? TypeStyle.body3 : TypeStyle.body3.copyWith(fontStyle: FontStyle.italic, color: Palette.grey10);
    return _CustomMarkdownBody(
        key: UniqueKey(),
        data: newData,
        onTapLink: (String text, String? href, String title) {
          if (href == null) return;
          if (href.startsWith("@")) {
            goToProfile(context, ref, href.substring(1));
            return;
          }
          launchUrl(Uri.parse(href));
        },
        maxChildren: maxChildren,
        styleSheet: MarkdownStyleSheet(
          blockSpacing: 0,
          h1: style != "delete" ? TypeStyle.heading : TypeStyle.heading.copyWith(fontStyle: FontStyle.italic, color: Palette.grey10),
          h2: style != "delete" ?  TypeStyle.title1 : TypeStyle.title1.copyWith(fontStyle: FontStyle.italic, color: Palette.grey10),
          h3: style != "delete" ?  TypeStyle.title2 : TypeStyle.title2.copyWith(fontStyle: FontStyle.italic, color: Palette.grey10),
          a: bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
          p: bodyMedium,
          listBullet: bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ));
  }
}

final _customMarkdownBodyProvider =
    ChangeNotifierProvider.family<_CustomMarkdownBodyNotifier, UniqueKey>(
        (ref, key) => _CustomMarkdownBodyNotifier());

class _CustomMarkdownBodyNotifier extends ChangeNotifier {
  bool isOverflowed = false;

  void setStateWithoutNotify(bool value) {
    isOverflowed = value;
  }

  void toggleState() {
    isOverflowed = !isOverflowed;
    notifyListeners();
  }
}

class _CustomMarkdownBody extends MarkdownBody {
  final int? maxChildren;

  get unikey => key as UniqueKey;

  const _CustomMarkdownBody(
      {required UniqueKey key,
      required super.data,
      super.onTapLink,
      super.styleSheet,
      this.maxChildren})
      : super(key: key);

  @override
  Widget build(BuildContext context, List<Widget>? children) {
    if (children!.length == 1 && shrinkWrap) {
      return children.single;
    }
    var newChildren = children;
    var isFirstTime = true;

    return Consumer(builder: (context, ref, child) {
      if (isFirstTime &&
          maxChildren != null &&
          maxChildren! < children.length) {
        isFirstTime = false;
        newChildren = children.sublist(0, maxChildren);
        ref
            .read(_customMarkdownBodyProvider(unikey))
            .setStateWithoutNotify(true);
      }

      return InkWell(
        onTap: children.length != newChildren.length
            ? ref.read(_customMarkdownBodyProvider(unikey)).toggleState
            : null,
        child: Container(
          child: ref.watch(_customMarkdownBodyProvider(unikey)).isOverflowed
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize:
                          shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
                      crossAxisAlignment: fitContent
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.stretch,
                      children: newChildren,
                    ),
                    const Text("Xem thêm...")
                  ],
                )
              : Column(
                  mainAxisSize:
                      shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
                  crossAxisAlignment: fitContent
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.stretch,
                  children: children,
                ),
        ),
      );
    });
  }
}

class _CustomTelLinkifier extends Linkifier {
  const _CustomTelLinkifier();

  @override
  List<LinkifyElement> parse(
      List<LinkifyElement> elements, LinkifyOptions options) {
    final list = <LinkifyElement>[];
    for (var element in elements) {
      if (element is TextElement) {
        var match = RegExp(
          r'^(.*?)((tel:)?[+]*[0-9]{8,15})',
          caseSensitive: false,
          dotAll: true,
        ).firstMatch(element.text);

        if (match == null) {
          list.add(element);
        } else {
          final text = element.text.replaceFirst(match.group(0)!, '');

          if (match.group(1)?.isNotEmpty == true) {
            list.add(TextElement(match.group(1)!));
          }

          if (match.group(2)?.isNotEmpty == true) {
            list.add(PhoneNumberElement(
              match.group(2)!.replaceFirst(RegExp(r'tel:'), ''),
            ));
          }

          if (text.isNotEmpty) {
            list.addAll(parse([TextElement(text)], options));
          }
        }
      } else {
        list.add(element);
      }
    }
    return list;
  }
}
