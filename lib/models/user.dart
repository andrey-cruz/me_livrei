class UserModel {
  final String? id;
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String state;
  final String city;
  final String genre;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.state,
    required this.city,
    required this.genre,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phone': phone,
      'state': state,
      'city': city,
      'genre': genre,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      fullName: map['fullName'] as String? ?? '',
      username: map['username'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      state: map['state'] as String? ?? '',
      city: map['city'] as String? ?? '',
      genre: map['genre'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => toMap().toString();

  UserModel copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? phone,
    String? state,
    String? city,
    String? genre,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      state: state ?? this.state,
      city: city ?? this.city,
      genre: genre ?? this.genre,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName {
    return fullName.isNotEmpty ? fullName : username;
  }

  String get initials {
    if (fullName.isEmpty) return '?';

    final names = fullName.trim().split(' ');

    if (names.length == 1) {
      return names[0][0].toUpperCase();
    }

    return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
  }

  String get firstName {
    if (fullName.isEmpty) return '';
    return fullName.trim().split(' ').first;
  }

  String get lastName {
    if (fullName.isEmpty) return '';
    final names = fullName.trim().split(' ');
    if (names.length <= 1) return '';
    return names.last;
  }

  bool get isProfileComplete {
    return fullName.isNotEmpty &&
        username.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        state.isNotEmpty &&
        city.isNotEmpty &&
        genre.isNotEmpty;
  }

  bool get isNew => id == null || id!.isEmpty;

  String get phoneNumbers {
    return phone.replaceAll(RegExp(r'\D'), '');
  }

  String get emailLowerCase {
    return email.toLowerCase().trim();
  }

  bool get hasValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool get hasValidPhone {
    final numbers = phoneNumbers;
    return numbers.length >= 10 && numbers.length <= 13;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.username == username &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ username.hashCode ^ email.hashCode;
  }

  /// Cria um usuário vazio (útil para inicializações)
  factory UserModel.empty() {
    return const UserModel(
      fullName: '',
      username: '',
      email: '',
      phone: '',
      state: '',
      city: '',
      genre: '',
    );
  }

  /// Cria um usuário de exemplo (útil para testes)
  factory UserModel.example() {
    return UserModel(
      id: '1',
      fullName: 'João Silva',
      username: 'joaosilva',
      email: 'joao@email.com',
      phone: '+55 (48) 98888-8888',
      state: '42',  // Santa Catarina
      city: '4205407',  // Florianópolis
      genre: 'Ficção Científica',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
