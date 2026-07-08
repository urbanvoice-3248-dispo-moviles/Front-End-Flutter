List<List<double>> decodePolyline(String encoded) {
  final poly = <List<double>>[];
  var index = 0;
  var lat = 0;
  var lng = 0;

  while (index < encoded.length) {
    var sum = 0;
    var shift = 0;
    int b;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      sum |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    final dlat = (sum & 1) != 0 ? ~(sum >> 1) : (sum >> 1);
    lat += dlat;

    shift = 0;
    sum = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      sum |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    final dlng = (sum & 1) != 0 ? ~(sum >> 1) : (sum >> 1);
    lng += dlng;

    poly.add([lat / 1e5, lng / 1e5]);
  }
  return poly;
}
