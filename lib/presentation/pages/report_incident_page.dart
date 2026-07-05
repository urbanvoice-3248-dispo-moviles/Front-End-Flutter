import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/report/report_bloc.dart';
import '../widgets/loading_overlay.dart';
import 'home_page.dart';

class ReportIncidentPage extends StatefulWidget {
  const ReportIncidentPage({super.key});

  @override
  State<ReportIncidentPage> createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends State<ReportIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'ROBBERY';
  bool _isAnonymous = false;
  double? _latitude;
  double? _longitude;
  String? _address;
  String? _mediaUrl;
  bool _locationLoading = true;

  final List<Map<String, String>> _incidentTypes = [
    {'value': 'ROBBERY', 'label': 'Robo'},
    {'value': 'ASSAULT', 'label': 'Asalto'},
    {'value': 'HARASSMENT', 'label': 'Acoso'},
    {'value': 'VANDALISM', 'label': 'Vandalismo'},
    {'value': 'ACCIDENT', 'label': 'Accidente'},
    {'value': 'OTHER', 'label': 'Otro'},
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _locationLoading = true);
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permiso de ubicación denegado')),
          );
        }
        setState(() => _locationLoading = false);
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permiso de ubicación denegado permanentemente. Actívalo en Ajustes.')),
          );
        }
        setState(() => _locationLoading = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _locationLoading = false;
        });
      }
    } on LocationServiceDisabledException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activa el GPS para obtener tu ubicación')),
        );
      }
      if (mounted) setState(() => _locationLoading = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al obtener ubicación. Intenta manualmente.')),
        );
      }
      if (mounted) setState(() => _locationLoading = false);
    }
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _mediaUrl = image.path);
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_latitude == null || _longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activando GPS, espere un momento...')),
        );
        return;
      }

      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        context.read<ReportBloc>().add(CreateReportEvent(
              userId: authState.profile.id,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              incidentType: _selectedType,
              latitude: _latitude!,
              longitude: _longitude!,
              address: _address,
              mediaUrl: _mediaUrl,
              isAnonymous: _isAnonymous,
            ));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar Incidente')),
      body: BlocConsumer<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reporte creado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (state is ReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state is ReportLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Describe el incidente',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de incidente',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: _incidentTypes.map((type) {
                        return DropdownMenuItem(
                          value: type['value'],
                          child: Text(type['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese un título';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Describa el incidente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _latitude != null
                                ? 'Ubicación capturada'
                                : _locationLoading
                                    ? 'Obteniendo ubicación...'
                                    : 'Ubicación no disponible',
                            style: TextStyle(
                              color: _latitude != null
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                        if (_locationLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        if (!_locationLoading && _latitude == null)
                          TextButton.icon(
                            onPressed: _getCurrentLocation,
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Reintentar'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _pickMedia,
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Agregar evidencia'),
                        ),
                        const SizedBox(width: 8),
                        if (_mediaUrl != null)
                          const Chip(
                            label: Text('1 archivo'),
                            deleteIcon: Icon(Icons.close, size: 18),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Reporte anónimo'),
                      subtitle: const Text(
                          'Ocultar mi identidad en el reporte'),
                      value: _isAnonymous,
                      onChanged: (value) =>
                          setState(() => _isAnonymous = value),
                      secondary:                     const Icon(Icons.visibility_off),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _handleSubmit,
                      icon: const Icon(Icons.send),
                      label: const Text('Enviar Reporte'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
