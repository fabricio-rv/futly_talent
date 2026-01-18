import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'agora';
    } else if (difference.inMinutes < 60) {
      return 'há ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else if (difference.inHours < 24) {
      return 'há ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inDays < 7) {
      return 'há ${difference.inDays} dia${difference.inDays > 1 ? 's' : ''}';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  static String formatCurrency(int value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '€',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  static String formatCurrencyBRL(int value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  static String getAge(int birthYear) {
    final now = DateTime.now();
    return (now.year - birthYear).toString();
  }
}

class StringUtils {
  static String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  static String truncate(String str, int length) {
    if (str.length <= length) return str;
    return '${str.substring(0, length)}...';
  }
}

class ValidationUtils {
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    if (!isValidEmail(value)) {
      return 'Email inválido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (!isValidPassword(value)) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }
}
