import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerPage extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const LocationPickerPage({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng? _selectedPosition;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedPosition =
          LatLng(widget.initialLatitude!, widget.initialLongitude!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar ubicación'),
        actions: [
          TextButton(
            onPressed: _selectedPosition != null
                ? () => Navigator.pop(
                    context,
                    {
                      'latitude': _selectedPosition!.latitude,
                      'longitude': _selectedPosition!.longitude,
                    },
                  )
                : null,
            child: const Text('Confirmar'),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedPosition ??
                  const LatLng(-12.0464, -77.0428),
              zoom: 14,
            ),
            onMapCreated: (_) {},
            onTap: (latLng) {
              setState(() => _selectedPosition = latLng);
            },
            markers: _selectedPosition != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedPosition!,
                    ),
                  }
                : {},
          ),
          if (_selectedPosition == null)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.touch_app),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Toca el mapa para seleccionar una ubicación',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_selectedPosition != null)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Lat: ${_selectedPosition!.latitude.toStringAsFixed(6)}, '
                    'Lng: ${_selectedPosition!.longitude.toStringAsFixed(6)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
