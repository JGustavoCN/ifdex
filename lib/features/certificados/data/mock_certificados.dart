import 'dart:typed_data';

import 'package:ifdex/features/certificados/models/certificado.dart';

List<Certificado> certificadosMock = [
  // ── SISPUBLI: Caso 1 ─────────────────────────────────────
  Certificado.criar(
    id: 'c89a35d1e6e4681b76d3b9f75648ff9169c36929effee5c7532e02d1b94944bd',
    origem: Origem.sispubli,
    titulo: 'Participação no(a) PFisc 2023',
    ano: 2023,
    instituicao: 'IFS',
    tipoDescricao: 'Participação',
    tags: ['Extensão', 'Eventos'],
    urlDocumento:
        'https://sispubli-api.vercel.app/api/pdf/gAAAAABp-OwKKoqtGjZyU15mQgH_8BQx95GpxVS6ugBDrlhfLIIlUAm5LMaWnmDaMdH6q2Aj8y7DLeR-wlAbUPq-oR3ZJVtvPVgeh-f42C5NK96WL-PUMQ3-z72BaeHf60QC4veaN2fB7klLK5WKIqm6Bwe1Scb_q2c3RTnTsnbSPzh1JIWks6PLfPSedTcpLWuMOVL6Wd0efrF2JTB_I7LtOMWtc-UlR3h_fbcajVaSFLjSqvEkGgynZ-ngXql-wfjKB3eDPlQRgGoV4Oy8TSVuelvNb1NR2g==',
    notaRelevancia: 4,
  ),

  // ── MANUAL: AWS Credly ───────────────────────────────────
  Certificado.criar(
    id: 'aws-badge-1',
    origem: Origem.manual,
    titulo: 'AWS Academy Graduate - Cloud Architecting',
    ano: 2024,
    instituicao: 'Amazon Web Services',
    tipoDescricao: 'Training Badge',
    cargaHoraria: 40,
    tags: ['Cloud', 'AWS', 'Architecture'],
    urlDocumento:
        'https://www.credly.com/badges/b45a690e-587e-47ee-9ed8-202f63acf4d7/public_url',
    notaRelevancia: 5,
  ),

  // ── SISPUBLI: Caso 2 ─────────────────────────────────────
  Certificado.criar(
    id: '86b8138df8436ae678c52c193c76d22f64135da945686b43001b3f1547777c95',
    origem: Origem.sispubli,
    titulo: 'Participação no(a) LIVE ABRIL INDÍGENA 2023',
    ano: 2023,
    instituicao: 'IFS',
    tipoDescricao: 'Participação',
    tags: ['Cultura', 'Social'],
    urlDocumento:
        'https://sispubli-api.vercel.app/api/pdf/gAAAAABp-OwKsJALTLD_2hcJHp-N9Q3heOqly864IUzNAGzOHSKW69iF5mczLCBaASSrUtv0WLjKFcMz9WyT9ZHOXoqmCfprxb33oZEPm5h6yg88WRT_Nh7nMY-PtEu01ImuZkZb9rIcLmVIm2FsQYqWs9AOL0M1pSVy6i5x0AUJkFqdN54HKyGfyWD6QcYP7GspYkO0SvR76P8Hmh1Yz3NUdfmBkP9EUoi9klV7RMKAeYdvArT1U9BssXFSsDCDf44hsrVGd9GYs5BpEcKjQU0TrwR2hUnDgg==',
    notaRelevancia: 3,
  ),

  // ── MANUAL: Simulação de Upload ──────────────────────────
  Certificado.criar(
    id: 'upload-sim-1',
    origem: Origem.manual,
    titulo: 'Comprovante de Monitoria - Algoritmos',
    ano: 2023,
    instituicao: 'IFS',
    tipoDescricao: 'Monitoria',
    cargaHoraria: 100,
    tags: ['Ensino', 'Python'],
    // Mock de cabeçalho de PDF
    uploadDocumento: Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D, 0x31]),
    notaRelevancia: 4,
  ),

  // ── SISPUBLI: Caso 3 ─────────────────────────────────────
  Certificado.criar(
    id: 'a02b2c4167f51b07d656ac990c77006f6a69aa539bb1aebac7147b496be72ce8',
    origem: Origem.sispubli,
    titulo: 'Oficina: A Importância da Autoliderança',
    ano: 2020,
    instituicao: 'IFS',
    tipoDescricao: 'Mini-Curso',
    tags: ['Soft Skills', 'Liderança'],
    urlDocumento:
        'https://sispubli-api.vercel.app/api/pdf/gAAAAABp-OwKI-Wk1zUJlvdNmHDXRCBxJF6fF6fzUwBKkpkpEkAEknWbrH02S5oNL4YC9tGtMj1vz9GUCWO2DlStoKIZzh1FujaSSAAL5rxRnViqDURQ7Pqhi9IEeB1jjjuTZDRYZlnuTcnrYUrZfHa8gQqJFk_xqu9QyUNdg8_SkAvx6yOJASOEQzPOFH2P3gXv89-5mesuFAR-8lojXLxb6AwDM2DWQlkzjTdRX0A6ioH5jEcT_ztLTQXLzJQwHfxYof14k6Hpgy28INiwk__qnYDTFMnqLqRF3JVUUMb1HV6gRvXOqJHGj9uu3myVmWE9Vtryez5S',
    notaRelevancia: 5,
  ),

  // ── MANUAL: Existente ───────────────────────────────────
  Certificado.criar(
    id: 'old-1',
    origem: Origem.manual,
    titulo: 'Desenvolvimento Web Moderno',
    ano: 2023,
    instituicao: 'Udemy',
    tipoDescricao: 'Curso',
    cargaHoraria: 40,
    tags: ['React', 'CSS'],
    urlDocumento: 'https://udemy.com/cert/123',
    notaRelevancia: 3,
  ),
];
