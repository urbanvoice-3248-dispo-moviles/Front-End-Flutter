import 'package:flutter_test/flutter_test.dart';
import 'package:urbanvoice/data/models/alert_model.dart';
import 'package:urbanvoice/data/models/location_model.dart';

void main() {
  group('LocationModel', () {
    test('parses location json and converts it to a domain entity', () {
      final json = {
        'id': 1,
        'latitude': -12.0464,
        'longitude': -77.0428,
        'address': 'Centro de Lima',
        'district': 'Lima',
        'risk_level': 3,
        'risk_category': 'Medium',
        'incident_count': 4,
        'description': 'Zona con reportes frecuentes',
        'last_updated': '2026-07-01T10:00:00.000Z',
      };

      final model = LocationModel.fromJson(json);
      final entity = model.toEntity();

      expect(model.district, 'Lima');
      expect(model.incidentCount, 4);
      expect(entity.riskLevel, 3);
      expect(model.toJson()['risk_category'], 'Medium');
    });
  });

  group('AlertModel', () {
    test('uses alert_type fallback and defaults unread alerts', () {
      final json = {
        'id': 5,
        'user_id': 12,
        'alert_type': 'NEARBY_INCIDENT',
        'title': 'Alerta cercana',
        'message': 'Se reporto un incidente cerca de tu ubicacion',
        'latitude': -12.05,
        'longitude': -77.03,
        'created_at': '2026-07-01T11:30:00.000Z',
      };

      final model = AlertModel.fromJson(json);
      final entity = model.toEntity();

      expect(model.type, 'NEARBY_INCIDENT');
      expect(model.isRead, isFalse);
      expect(entity.userId, 12);
      expect(model.toJson()['is_read'], isFalse);
    });
  });
}
