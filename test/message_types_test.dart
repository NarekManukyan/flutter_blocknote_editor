library;

import 'package:flutter_blocknote_editor/src/bridge/message_types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JsToFlutterMessage.fromJson — known types round-trip', () {
    test('type "ready" produces ReadyMessage', () {
      final msg = JsToFlutterMessage.fromJson({'type': 'ready'});
      expect(msg, isA<ReadyMessage>());
      expect(msg.type, JsToFlutterMessageType.ready);
    });

    test('type "transactions" produces TransactionsMessage', () {
      final msg = JsToFlutterMessage.fromJson({
        'type': 'transactions',
        'data': [
          {'baseVersion': 1, 'operations': [], 'timestamp': 0},
        ],
        'timestamp': 123,
      });
      expect(msg, isA<TransactionsMessage>());
      final t = msg as TransactionsMessage;
      expect(t.type, JsToFlutterMessageType.transactions);
      expect(t.data.length, 1);
      expect(t.timestamp, 123);
    });

    test('type "error" produces ErrorMessage', () {
      final msg = JsToFlutterMessage.fromJson({
        'type': 'error',
        'message': 'something broke',
      });
      expect(msg, isA<ErrorMessage>());
      expect((msg as ErrorMessage).message, 'something broke');
    });

    test('type "error" with missing message field uses fallback text', () {
      final msg = JsToFlutterMessage.fromJson({'type': 'error'});
      expect(msg, isA<ErrorMessage>());
      expect((msg as ErrorMessage).message, isNotEmpty);
    });

    test('type "toolbar_popup_request" produces ToolbarPopupRequestMessage',
        () {
      final msg = JsToFlutterMessage.fromJson({
        'type': 'toolbar_popup_request',
        'requestId': 'req-1',
        'popupType': 'colorStyle',
        'options': [
          {'value': 'red', 'label': 'Red'},
        ],
      });
      expect(msg, isA<ToolbarPopupRequestMessage>());
      final t = msg as ToolbarPopupRequestMessage;
      expect(t.type, JsToFlutterMessageType.toolbarPopupRequest);
      expect(t.requestId, 'req-1');
      expect(t.popupType, 'colorStyle');
      expect(t.options.length, 1);
    });

    test('type "document" produces DocumentMessage', () {
      final msg = JsToFlutterMessage.fromJson({
        'type': 'document',
        'requestId': 'doc-req-1',
        'document': {'blocks': []},
      });
      expect(msg, isA<DocumentMessage>());
      final d = msg as DocumentMessage;
      expect(d.type, JsToFlutterMessageType.document);
      expect(d.requestId, 'doc-req-1');
      expect(d.document, containsPair('blocks', []));
    });

    test('type "link_tap" produces LinkTapMessage', () {
      final msg = JsToFlutterMessage.fromJson({
        'type': 'link_tap',
        'url': 'https://example.com',
      });
      expect(msg, isA<LinkTapMessage>());
      expect((msg as LinkTapMessage).url, 'https://example.com');
    });
  });

  group('JsToFlutterMessage.fromJson — unknown type', () {
    test('unrecognised type string returns UnknownMessage without throwing', () {
      final msg = JsToFlutterMessage.fromJson({'type': 'totally_new_event'});
      expect(msg, isA<UnknownMessage>());
      expect(msg.type, JsToFlutterMessageType.unknown);
      expect((msg as UnknownMessage).rawType, 'totally_new_event');
    });

    test('empty string type returns UnknownMessage', () {
      final msg = JsToFlutterMessage.fromJson({'type': ''});
      expect(msg, isA<UnknownMessage>());
    });

    test('camelCase type that does not match any enum returns UnknownMessage',
        () {
      final msg = JsToFlutterMessage.fromJson({'type': 'weirdEvent'});
      expect(msg, isA<UnknownMessage>());
    });
  });

  group('JsToFlutterMessage.fromJson — malformed / missing fields', () {
    test('transactions with empty data list is valid', () {
      final msg = JsToFlutterMessage.fromJson({
        'type': 'transactions',
        'data': <dynamic>[],
      });
      expect(msg, isA<TransactionsMessage>());
      expect((msg as TransactionsMessage).data, isEmpty);
    });

    test('transactions with missing timestamp field does not throw', () {
      final msg = JsToFlutterMessage.fromJson({
        'type': 'transactions',
        'data': <dynamic>[],
        // no 'timestamp' key
      });
      expect(msg, isA<TransactionsMessage>());
      expect((msg as TransactionsMessage).timestamp, isNull);
    });

    test('document with no extra keys in document map is valid', () {
      final msg = JsToFlutterMessage.fromJson({
        'type': 'document',
        'requestId': 'r',
        'document': <String, dynamic>{},
      });
      expect(msg, isA<DocumentMessage>());
      expect((msg as DocumentMessage).document, isEmpty);
    });
  });

  group('snake_case to camelCase conversion', () {
    test('single-word type is passed through unchanged', () {
      // "ready" has no underscore — should still match.
      final msg = JsToFlutterMessage.fromJson({'type': 'ready'});
      expect(msg.type, JsToFlutterMessageType.ready);
    });

    test('multi-word snake_case is converted to camelCase enum name', () {
      // "toolbar_popup_request" -> "toolbarPopupRequest"
      final msg = JsToFlutterMessage.fromJson({
        'type': 'toolbar_popup_request',
        'requestId': 'x',
        'popupType': 'blockTypeSelect',
        'options': <dynamic>[],
      });
      expect(msg.type, JsToFlutterMessageType.toolbarPopupRequest);
    });

    test('link_tap snake_case converts correctly', () {
      final msg = JsToFlutterMessage.fromJson({
        'type': 'link_tap',
        'url': 'https://dart.dev',
      });
      expect(msg.type, JsToFlutterMessageType.linkTap);
    });
  });

  group('FlutterToJsMessage.toJson — spot checks', () {
    test('LoadDocumentMessage serialises type and document', () {
      const msg = LoadDocumentMessage(document: {'blocks': <dynamic>[]});
      final json = msg.toJson();
      expect(json['type'], 'load_document');
      expect(json['data'], {'blocks': <dynamic>[]});
    });

    test('SetReadonlyMessage serialises value', () {
      const msg = SetReadonlyMessage(value: true);
      final json = msg.toJson();
      expect(json['type'], 'set_readonly');
      expect(json['value'], isTrue);
    });

    test('GetDocumentMessage serialises requestId', () {
      const msg = GetDocumentMessage(requestId: 'my-id');
      final json = msg.toJson();
      expect(json['type'], 'get_document');
      expect(json['requestId'], 'my-id');
    });

    test('SetDebounceDurationMessage serialises durationMs', () {
      const msg = SetDebounceDurationMessage(durationMs: 250);
      final json = msg.toJson();
      expect(json['type'], 'set_debounce_duration');
      expect(json['durationMs'], 250);
    });

    test('UpdateWebViewHeightMessage serialises extraBottomPadding', () {
      const msg = UpdateWebViewHeightMessage(extraBottomPadding: 42);
      final json = msg.toJson();
      expect(json['type'], 'update_webview_height');
      expect(json['extraBottomPadding'], 42);
    });

    test('ToolbarPopupResponseMessage serialises all fields', () {
      const msg = ToolbarPopupResponseMessage(
        requestId: 'r1',
        popupType: 'colorStyle',
        selectedValue: 'blue',
      );
      final json = msg.toJson();
      expect(json['type'], 'toolbar_popup_response');
      expect(json['requestId'], 'r1');
      expect(json['popupType'], 'colorStyle');
      expect(json['selectedValue'], 'blue');
    });

    test('SetSchemaConfigMessage with null config and isRequired=true', () {
      const msg = SetSchemaConfigMessage(isRequired: true);
      final json = msg.toJson();
      expect(json['type'], 'set_schema_config');
      expect(json['data'], isNull);
      expect(json['required'], isTrue);
    });
  });
}
