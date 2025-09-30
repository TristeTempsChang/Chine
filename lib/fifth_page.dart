import 'package:flutter/material.dart';

class FifthPage extends StatefulWidget {
  const FifthPage({super.key});

  @override
  State<FifthPage> createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _orgController = TextEditingController();

  // State
  bool _submitted = false;
  bool _anonymous = false;
  bool _accept = false;
  String? _preferredChannel;
  String? _language;
  String? _category;
  String? _country;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  // Dispose
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

  // Validators
  String? _validateNotEmpty(String? v, {String field = '这个领域'}) {
    if (v == null || v.trim().isEmpty) return '$field 是必须的';
    return null;
  }

  String? _validateEmail(String? value) {
    if (_anonymous) return null;
    if (value == null || value.trim().isEmpty) return '需要电子邮件';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return '电子邮件格式无效';
    return null;
  }

  String? _validatePhone(String? value) {
    if (_preferredChannel != '电话') return null;
    if (value == null || value.trim().isEmpty) {
      return '所需电话联系号码';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 6) return '号码太短';
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) return '需要留言';
    if (value.trim().length < 20) {
      return '消息必须至少包含 20 个字符';
    }
    return null;
  }

  void _onSubmit() {
    setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid) return;

    if (!_accept) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('你必须接受向政府屈服并成为国家奴隶的指控')),
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
                          '与该党联系的表格',
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
                                  labelText: '全名',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) {
                                  if (_anonymous) return null;
                                  return _validateNotEmpty(v, field: '姓名');
                                },
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _orgController,
                                decoration: const InputDecoration(
                                  labelText: '组织',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: '电子邮件',
                                  border: OutlineInputBorder(),
                                ),
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: '电话',
                                  border: OutlineInputBorder(),
                                ),
                                validator: _validatePhone,
                              ),
                              const SizedBox(height: 12),

                              DropdownButtonFormField<String>(
                                value: _country,
                                decoration: const InputDecoration(
                                  labelText: '国家/地区',
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

                              // Langue
                              DropdownButtonFormField<String>(
                                value: _language,
                                decoration: const InputDecoration(
                                  labelText: '响应语言',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Français', child: Text('Français')),
                                  DropdownMenuItem(value: 'Anglais', child: Text('Anglais (English)')),
                                  DropdownMenuItem(value: 'Chinois (simplifié)', child: Text('Ching Chong')),
                                ],
                                onChanged: (v) => setState(() => _language = v ?? 'Français'),
                              ),
                              const SizedBox(height: 12),

                              // Préférence de réponse
                              DropdownButtonFormField<String>(
                                value: _preferredChannel,
                                decoration: const InputDecoration(
                                  labelText: '首选响应渠道',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(value: '电子邮件', child: Text('电子邮件')),
                                  DropdownMenuItem(value: '电话', child: Text('电话')),
                                  DropdownMenuItem(value: '邮件', child: Text('邮件')),
                                ],
                                onChanged: (v) => setState(() => _preferredChannel = v ?? '电子邮件'),
                              ),
                              const SizedBox(height: 12),

                              // Catégorie
                              DropdownButtonFormField<String>(
                                value: _category,
                                decoration: const InputDecoration(
                                  labelText: '请求类别',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(value: '一般问题', child: Text('一般问题')),
                                  DropdownMenuItem(value: '会员申请', child: Text('会员申请')),
                                  DropdownMenuItem(value: '新闻/媒体', child: Text('新闻/媒体')),
                                  DropdownMenuItem(value: '活动', child: Text('活动')),
                                  DropdownMenuItem(value: '其他', child: Text('其他')),
                                ],
                                onChanged: (v) => setState(() => _category = v ?? '一般问题'),
                              ),
                              const SizedBox(height: 12),

                              // Sujet
                              TextFormField(
                                controller: _subjectController,
                                decoration: const InputDecoration(
                                  labelText: '主题',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => _validateNotEmpty(v, field: '主题'),
                              ),
                              const SizedBox(height: 12),

                              // Message
                              TextFormField(
                                controller: _messageController,
                                maxLines: 6,
                                minLines: 4,
                                decoration: const InputDecoration(
                                  labelText: '信息',
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                ),
                                validator: _validateMessage,
                              ),
                              const SizedBox(height: 12),

                              // Consentement fictif
                              CheckboxListTile(
                                value: _accept,
                                onChanged: (v) => setState(() => _accept = v ?? false),
                                title: const Text('我将我的身体与灵魂献给党，并献上我的所有后代'),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                              const SizedBox(height: 8),

                              // Actions
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _onReset,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('重置'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _onSubmit,
                                      icon: const Icon(Icons.send),
                                      label: const Text('送走我的灵魂'),
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
                            '概括',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('匿名的 : ${_anonymous ? "是的" : "不"}'),
                          if (!_anonymous) ...[
                            Text('姓名 : ${_nameController.text}'),
                            if (_orgController.text.trim().isNotEmpty)
                              Text('组织 : ${_orgController.text}'),
                            Text('电子邮件 : ${_emailController.text}'),
                          ],
                          if (_preferredChannel == '电话')
                            Text('电话 : ${_phoneController.text}'),
                          Text('国家/地区 : $_country'),
                          Text('语言 : $_language'),
                          Text('最喜欢的频道 : $_preferredChannel'),
                          Text('类别 : $_category'),
                          Text('主题 : ${_subjectController.text}'),
                          const SizedBox(height: 8),
                          const Text('信息 :'),
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
                          const Text(
                            '谢谢 🌟',
                          ),
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
