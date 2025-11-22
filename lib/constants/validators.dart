class AuthValidator {
  AuthValidator._();

  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  static final RegExp _phoneRegex = RegExp(r'^\d{10,13}$');

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu e-mail';
    }

    final trimmedValue = value.trim();
    if (!_emailRegex.hasMatch(trimmedValue)) {
      return 'Por favor, insira um e-mail válido';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }

    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome';
    }

    final trimmedValue = value.trim();
    if (trimmedValue.length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }

    if (value != password) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um nome de usuário';
    }

    final trimmedValue = value.trim();
    if (!_usernameRegex.hasMatch(trimmedValue)) {
      return 'O username deve ter entre 3 e 20 caracteres e conter apenas letras, números e _';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu telefone';
    }

    final phone = value.replaceAll(RegExp(r'\D'), '');

    if (!_phoneRegex.hasMatch(phone)) {
      return 'Telefone inválido, use DDD + número (10 ou 11 dígitos)';
    }
    return null;
  }

  static Map<String, String?> validateLoginForm(String email, String password) {
    return {
      'email': validateEmail(email),
      'password': validatePassword(password),
    };
  }

  static Map<String, String?> validateRegisterForm(String name,
      String username,
      String email,
      String phone,
      String password,
      String confirmPassword,) {
    return {
      'name': validateName(name),
      'username': validateUsername(username),
      'email': validateEmail(email),
      'phone': validatePhone(phone),
      'password': validatePassword(password),
      'confirmPassword': validateConfirmPassword(confirmPassword, password),
    };
  }

  static Map<String, String?> validateProfileForm(String name,
      String email,
      String phone,) {
    return {
      'name': validateName(name),
      'email': validateEmail(email),
      'phone': validatePhone(phone),
    };
  }
}

class BookValidator {
  BookValidator._();

  static String? validateBookTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o título do livro';
    }

    final trimmedValue = value.trim();
    if (trimmedValue.length < 2) {
      return 'O título deve ter pelo menos 2 caracteres';
    }

    if (trimmedValue.length > 100) {
      return 'O título não pode ter mais de 100 caracteres';
    }

    return null;
  }

  static String? validateBookAuthor(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o autor do livro';
    }

    final trimmedValue = value.trim();
    if (trimmedValue.length < 2) {
      return 'O nome do autor deve ter pelo menos 2 caracteres';
    }

    if (trimmedValue.length > 100) {
      return 'O nome do autor não pode ter mais de 100 caracteres';
    }

    return null;
  }

  static String? validateBookCoverUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'A URL da capa é obrigatória';
    }

    final trimmedValue = value.trim();
    final urlRegex = RegExp(r'^https?:\/\/', caseSensitive: false);

    if (!urlRegex.hasMatch(trimmedValue)) {
      return 'Por favor, insira uma URL válida começando com http:// ou https://';
    }

    return null;
  }

  static String? validateBookPublisher(String? value) {
    if (value == null || value.isEmpty) return null;

    final trimmedValue = value.trim();
    if (trimmedValue.length > 100) {
      return 'O nome da editora não pode ter mais de 100 caracteres';
    }

    return null;
  }

  static String? validateBookGenre(String? value) {
    if (value == null || value.isEmpty) return null;

    final trimmedValue = value.trim();
    if (trimmedValue.length > 30) {
      return 'O gênero não pode ter mais de 30 caracteres';
    }

    return null;
  }

  static String? validateBookCondition(String? value) {
    if (value == null || value.isEmpty) return null;

    final trimmedValue = value.trim();
    if (trimmedValue.length > 100) {
      return 'A condição não pode ter mais de 100 caracteres';
    }

    return null;
  }

  static String? validateBookDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma descrição do livro';
    }

    final trimmedValue = value.trim();
    if (trimmedValue.length < 10) {
      return 'A descrição deve ter pelo menos 10 caracteres';
    }

    if (trimmedValue.length > 500) {
      return 'A descrição não pode ter mais de 500 caracteres';
    }

    return null;
  }

  static Map<String, String?> validateBookForm({
    required String title,
    required String author,
    required String description,
    required String coverUrl,
    String? publisher,
    String? genre,
    String? condition,
  }) {
    return {
      'title': validateBookTitle(title),
      'author': validateBookAuthor(author),
      'description': validateBookDescription(description),
      'coverUrl': validateBookCoverUrl(coverUrl),
      'publisher': validateBookPublisher(publisher),
      'genre': validateBookGenre(genre),
      'condition': validateBookCondition(condition),
    };
  }
}

class FormUtils {
  FormUtils._();

  static bool isFormValid(Map<String, String?> errors) {
    return errors.values.every((error) => error == null);
  }
}