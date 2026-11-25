import 'package:expense_tracker/services/update_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isNewer membandingkan versi lalu build number', () {
    expect(UpdateService.isNewer('1.0.1+2', '1.0.0+1'), isTrue);
    expect(UpdateService.isNewer('1.0.0+2', '1.0.0+1'), isTrue);
    expect(UpdateService.isNewer('1.1.0', '1.0.9+9'), isTrue);
    expect(UpdateService.isNewer('2.0.0+1', '1.9.9+99'), isTrue);
    expect(UpdateService.isNewer('1.0.0+1', '1.0.0+1'), isFalse);
    expect(UpdateService.isNewer('1.0.0+1', '1.0.1+1'), isFalse);
    expect(UpdateService.isNewer('1.0.10', '1.0.9'), isTrue);
  });
}
