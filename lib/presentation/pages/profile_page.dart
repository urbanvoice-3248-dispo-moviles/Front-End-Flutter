import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/network/token_manager.dart';
import '../../domain/entities/alert_config.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import 'login_page.dart';
import 'location_sharing_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context
          .read<ProfileBloc>()
          .add(GetProfileEvent(authState.profile.id));
      context
          .read<ProfileBloc>()
          .add(GetAlertConfigEvent(authState.profile.id));
    }
  }

  void _startEdit(UserProfile profile) {
    _nameController.text = profile.name;
    _lastNameController.text = profile.lastName;
    _ageController.text = profile.age.toString();
    _phoneController.text = profile.phoneNumber;
    setState(() => _isEditing = true);
  }

  void _saveEdit(int id) {
    context.read<ProfileBloc>().add(UpdateProfileEvent(
          id: id,
          name: _nameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          phoneNumber: _phoneController.text.trim(),
        ));
    setState(() => _isEditing = false);
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(LogoutEvent());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                final state = context.read<ProfileBloc>().state;
                if (state is ProfileLoaded) {
                  _startEdit(state.profile);
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadProfile,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          if (state is ProfileLoaded) {
            final profile = state.profile;
            final config = state.alertConfig;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${profile.name[0]}${profile.lastName[0]}',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${profile.name} ${profile.lastName}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 32),
                  _isEditing
                      ? _buildEditForm(context, profile.id)
                      : _buildInfoCard(context, profile),
                  const SizedBox(height: 16),
                  _buildAlertRadiusCard(context, config),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.share_location),
                      title: const Text('Contactos de confianza'),
                      subtitle: const Text(
                          'Gestionar contactos con ubicación compartida'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const LocationSharingPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, int id) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Edad'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() => _isEditing = false),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _saveEdit(id),
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.person, 'Nombres', profile.name),
            const Divider(),
            _buildInfoRow(
                Icons.person_outline, 'Apellidos', profile.lastName),
            const Divider(),
            _buildInfoRow(
                Icons.numbers, 'Edad', profile.age.toString()),
            const Divider(),
            _buildInfoRow(Icons.email, 'Correo', profile.email),
            const Divider(),
            _buildInfoRow(
                Icons.phone, 'Teléfono', profile.phoneNumber),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Miembro desde',
                DateFormat('dd/MM/yyyy').format(profile.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertRadiusCard(
      BuildContext context, AlertConfig? config) {
    final radius = config?.radiusInKm ?? 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Preferencias de seguridad',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<double>(
              initialValue: radius > 0 ? radius : 0,
              decoration: const InputDecoration(
                labelText: 'Radio de alerta (km)',
                prefixIcon: Icon(Icons.notifications_active),
              ),
              items: const [
                DropdownMenuItem(value: 0.0, child: Text('Todas')),
                DropdownMenuItem(value: 1.0, child: Text('1 km')),
                DropdownMenuItem(value: 2.0, child: Text('2 km')),
                DropdownMenuItem(value: 5.0, child: Text('5 km')),
                DropdownMenuItem(value: 10.0, child: Text('10 km')),
                DropdownMenuItem(value: 20.0, child: Text('20 km')),
              ],
              onChanged: (value) {
                if (value != null) {
                  final authState =
                      context.read<AuthBloc>().state;
                  if (authState is AuthAuthenticated) {
                    context.read<ProfileBloc>().add(
                          UpdateAlertConfigEvent(
                            userId: authState.profile.id,
                            radiusInKm: value,
                          ),
                        );
                    TokenManager().saveAlertRadius(value);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
