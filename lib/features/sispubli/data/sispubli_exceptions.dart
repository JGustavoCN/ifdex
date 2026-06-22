/// Hierarquia de exceções tipadas para a API Sispubli.
///
/// Cada exceção mapeia um código de erro HTTP específico,
/// permitindo que o ViewModel traduza em mensagens amigáveis.
sealed class SispubliException implements Exception {
  final String message;
  const SispubliException(this.message);

  @override
  String toString() => message;
}

/// 400 — CPF inválido ou malformado.
class SispubliCpfInvalidoException extends SispubliException {
  const SispubliCpfInvalidoException([super.message = 'CPF inválido.']);
}

/// 401 — Token expirado ou inválido.
class SispubliNaoAutorizadoException extends SispubliException {
  const SispubliNaoAutorizadoException([super.message = 'Não autorizado.']);
}

/// 429 — Rate limit excedido.
class SispubliRateLimitException extends SispubliException {
  const SispubliRateLimitException([super.message = 'Rate limit excedido.']);
}

/// 502 — Sispubli fora do ar (upstream indisponível).
class SispubliIndisponivelException extends SispubliException {
  const SispubliIndisponivelException([
    super.message = 'Sispubli indisponível.',
  ]);
}

/// 504 — Timeout ao comunicar com o Sispubli.
class SispubliTimeoutException extends SispubliException {
  const SispubliTimeoutException([super.message = 'Timeout do Sispubli.']);
}

/// Resposta inesperada (não mapeada).
class SispubliDesconhecidaException extends SispubliException {
  const SispubliDesconhecidaException([
    super.message = 'Erro desconhecido na API.',
  ]);
}
