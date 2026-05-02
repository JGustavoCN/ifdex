/// Classificação da procedência de um [Certificado].
///
/// - [sispubli]: Dados importados da API oficial do IFS.
///   Campos-chave são read-only e há restrições adicionais.
/// - [manual]: Dados inseridos pelo usuário.
///   Todos os campos editáveis são livres.
enum Origem { sispubli, manual }
