import 'package:flutter/material.dart';

class FifthPage extends StatefulWidget {
  const FifthPage({super.key});

  @override
  State<FifthPage> createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _orgController = TextEditingController();

  bool _submitted = false;
  bool _anonymous = false;
  bool _accept = false;
  String? _preferredChannel;
  String? _language;
  String? _category;
  String? _country;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _phoneController.dispose();
    _orgController.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? v, {String field = 'Ce champ'}) {
    if (v == null || v.trim().isEmpty) return '$field est obligatoire';
    return null;
  }

  String? _validateEmail(String? value) {
    if (_anonymous) return null;
    if (value == null || value.trim().isEmpty) return 'L’adresse e-mail est requise';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Format d’e-mail invalide';
    return null;
  }

  String? _validatePhone(String? value) {
    if (_preferredChannel != 'Téléphone') return null;
    if (value == null || value.trim().isEmpty) {
      return 'Numéro de téléphone requis';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 6) return 'Numéro trop court';
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) return 'Un message est requis';
    if (value.trim().length < 20) {
      return 'Le message doit contenir au moins 20 caractères';
    }
    return null;
  }

  void _onSubmit() {
    setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid) return;

    if (!_accept) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez accepter les conditions avant de soumettre.')),
      );
      return;
    }

    setState(() {
      _submitted = true;
    });

    FocusScope.of(context).unfocus();
  }

  void _onReset() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
    _phoneController.clear();
    _orgController.clear();
    setState(() {
      _submitted = false;
      _accept = false;
      _autovalidate = AutovalidateMode.disabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Formulaire de contact du Parti',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Image(
                          image: AssetImage('assets/photo/miam.jpg'),
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 16),
                        Form(
                          key: _formKey,
                          autovalidateMode: _autovalidate,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nom complet',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) {
                                  if (_anonymous) return null;
                                  return _validateNotEmpty(v, field: 'Nom');
                                },
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _orgController,
                                decoration: const InputDecoration(
                                  labelText: 'Organisation',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'E-mail',
                                  border: OutlineInputBorder(),
                                ),
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Téléphone',
                                  border: OutlineInputBorder(),
                                ),
                                validator: _validatePhone,
                              ),
                              const SizedBox(height: 12),

                              DropdownButtonFormField<String>(
                                value: _country,
                                decoration: const InputDecoration(
                                  labelText: 'Pays/Région',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'France', child: Text('France')),
                                  DropdownMenuItem(value: 'Belgique', child: Text('Belgique (les arbres)')),
                                  DropdownMenuItem(value: 'Suisse', child: Text('Suisse (les fromages)')),
                                  DropdownMenuItem(value: 'Canada', child: Text('Canada (inshallah)')),
                                  DropdownMenuItem(value: 'Autre', child: Text('Autre')),
                                ],
                                onChanged: (v) => setState(() => _country = v ?? 'France'),
                              ),
                              const SizedBox(height: 12),

                              DropdownButtonFormField<String>(
                                value: _language,
                                decoration: const InputDecoration(
                                  labelText: 'Langue de réponse',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Français', child: Text('Français')),
                                  DropdownMenuItem(value: 'Anglais', child: Text('Anglais (English)')),
                                  DropdownMenuItem(value: 'Chinois (simplifié)', child: Text('Chinois')),
                                ],
                                onChanged: (v) => setState(() => _language = v ?? 'Français'),
                              ),
                              const SizedBox(height: 12),

                              DropdownButtonFormField<String>(
                                value: _preferredChannel,
                                decoration: const InputDecoration(
                                  labelText: 'Canal de contact préféré',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'E-mail', child: Text('E-mail')),
                                  DropdownMenuItem(value: 'Téléphone', child: Text('Téléphone')),
                                  DropdownMenuItem(value: 'Courrier', child: Text('Courrier')),
                                ],
                                onChanged: (v) => setState(() => _preferredChannel = v ?? 'E-mail'),
                              ),
                              const SizedBox(height: 12),

                              DropdownButtonFormField<String>(
                                value: _category,
                                decoration: const InputDecoration(
                                  labelText: 'Catégorie de la demande',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Question générale', child: Text('Question générale')),
                                  DropdownMenuItem(value: 'Adhésion', child: Text('Demande d’adhésion')),
                                  DropdownMenuItem(value: 'Presse', child: Text('Presse / Médias')),
                                  DropdownMenuItem(value: 'Événement', child: Text('Événement')),
                                  DropdownMenuItem(value: 'Autre', child: Text('Autre')),
                                ],
                                onChanged: (v) => setState(() => _category = v ?? 'Question générale'),
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _subjectController,
                                decoration: const InputDecoration(
                                  labelText: 'Sujet',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => _validateNotEmpty(v, field: 'Sujet'),
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _messageController,
                                maxLines: 6,
                                minLines: 4,
                                decoration: const InputDecoration(
                                  labelText: 'Message',
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                ),
                                validator: _validateMessage,
                              ),
                              const SizedBox(height: 12),

                              CheckboxListTile(
                                value: _accept,
                                onChanged: (v) => setState(() => _accept = v ?? false),
                                title: const Text('J’accepte les conditions du Parti.'),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _onReset,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Réinitialiser'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _onSubmit,
                                      icon: const Icon(Icons.send),
                                      label: const Text('Envoyer'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (_submitted)
                  Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Récapitulatif',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Anonyme : ${_anonymous ? "Oui" : "Non"}'),
                          if (!_anonymous) ...[
                            Text('Nom : ${_nameController.text}'),
                            if (_orgController.text.trim().isNotEmpty)
                              Text('Organisation : ${_orgController.text}'),
                            Text('E-mail : ${_emailController.text}'),
                          ],
                          if (_preferredChannel == 'Téléphone')
                            Text('Téléphone : ${_phoneController.text}'),
                          Text('Pays : $_country'),
                          Text('Langue : $_language'),
                          Text('Canal préféré : $_preferredChannel'),
                          Text('Catégorie : $_category'),
                          Text('Sujet : ${_subjectController.text}'),
                          const SizedBox(height: 8),
                          const Text('Message :'),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(_messageController.text),
                          ),
                          const SizedBox(height: 12),
                          const Text('Merci 🌟'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
