import 'package:commonground/core/shared/domain/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('subclasses carry their message', () {
      const failure = BusFailure('bus down');
      expect(failure.message, 'bus down');
      expect(failure.toString(), contains('BusFailure'));
    });

    test('PluginFailure carries pluginId for bus-level tracing', () {
      const failure = PluginFailure(
        'plugin crashed',
        pluginId: 'com.commonground.rto-toolkit',
      );
      expect(failure.pluginId, 'com.commonground.rto-toolkit');
    });
  });
}
