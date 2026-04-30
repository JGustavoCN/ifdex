import '../models/certificado.dart';

List<Certificado> certificadosMock = [
  Certificado(
    id: '1',
    origem: Origem.manual,
    titulo: 'Desenvolvimento Web Moderno',
    ano: 2023,
    instituicao: 'Udemy',
    tipoDescricao: 'Curso',
    cargaHoraria: 40,
    tags: ['React', 'CSS'],
    urlDocumento: 'https://udemy.com/cert/123',
  ),
  Certificado(
    id: '2',
    origem: Origem.sispubli,
    titulo: 'Segurança da Informação II',
    ano: 2024,
    instituicao: 'IFS',
    tipoDescricao: 'Participação',
    tags: ['Criptografia'],
  ),
  Certificado(
    id: '3',
    origem: Origem.sispubli,
    titulo: 'Semana de Tecnologia IFS',
    ano: 2024,
    instituicao: 'IFS',
    tipoDescricao: 'Palestrante',
    tags: ['Educação'],
  ),
];