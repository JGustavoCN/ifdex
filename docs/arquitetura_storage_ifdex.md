# 🏛️ Especificação da Arquitetura de Storage (IFdex)

> **Versão:** 1.0 (Arquitetura Definitiva)
> **Stack:** Flutter (Client) + Firebase (Auth/Firestore) + Supabase (Storage) + Next.js (Proxy)
> **Status:** ❄️ Aprovado e Congelado

## 1. Visão Geral da Arquitetura (Híbrida e 100% Gratuita)

O IFdex utiliza uma arquitetura descentralizada para maximizar performance e reduzir custos a zero, aproveitando o melhor de cada ecossistema:

* **Identidade (Firebase Auth):** Gerencia os usuários (Anônimos ou Logados).
* **Metadados e Lógica (Firestore):** Armazena os dados dos certificados (indexação rápida e deduplicação baseada no `id_unico` do Sispubli).
* **Arquivos Pesados (Supabase Storage):** Contorna o limite de 1MB do Firestore, suportando PDFs/Imagens de até 10MB em um Bucket Privado.
* **Compartilhamento (Next.js):** Atua como Proxy VIP, gerando Smart Links (`/c/{id}`) e consumindo o Supabase via *Service Role Key*.

---

## 2. O Segredo da Integração JWT (Contornando o Limite do Firebase Spark)

O Supabase possui suporte nativo ao **Third-Party Auth** (gratuito até 50.000 MAUs). Isso permite que o Supabase valide assinaturas criptográficas dos tokens JWT gerados pelo Firebase.

**O Problema do Plano Gratuito (Spark):** A documentação do Supabase sugere injetar `custom claims` (`role: authenticated`) via Firebase Cloud Functions, o que exige um plano pago (Blaze). 
**A Nossa Solução:** Não usaremos *custom claims*. O Supabase identificará nosso usuário Flutter como `anon`, mas nossas políticas **RLS (Row Level Security)** vão interceptar e abrir o payload do JWT do Firebase para liberar o acesso, desde que o `sub` (UID do Firebase) seja igual ao nome da pasta.

### 🔴 Configuração Obrigatória no Painel Supabase
Para o RLS funcionar, o painel do Supabase deve estar configurado:
1. Acesse **Authentication > Providers > Firebase Auth**.
2. Ative a integração e insira o ID do projeto: `ifdex-app`.
3. Isso instrui o Supabase a baixar as chaves JWKS do Google para decriptar os tokens.

---

## 3. Infraestrutura de Banco de Dados (SQL do Storage)

O script abaixo é idempotente e provisiona a segurança absoluta do bucket.

**Regras Aplicadas:**
- Bucket estritamente PRIVADO.
- O acesso exige validação do `iss` (Issuer) e `aud` (Audience) apontando para `ifdex-app`.
- Impedimento de caminhos malformados (arquivos na raiz do bucket).
- Isolamento criptográfico: O caminho do arquivo (`folder`) deve bater obrigatoriamente com o `sub` do token Firebase.

```sql
-- 1. Criação do Bucket Privado (Limite: 10MB, Apenas PDF e Imagens)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types) 
VALUES ('certificados_arquivos', 'certificados_arquivos', false, 10485760, ARRAY['application/pdf', 'image/jpeg', 'image/png']::text[]) 
ON CONFLICT (id) DO UPDATE SET file_size_limit = 10485760, public = false;

-- Limpeza para idempotência
DROP POLICY IF EXISTS "Upload seguro para usuarios Firebase" ON storage.objects;
DROP POLICY IF EXISTS "Update seguro para usuarios Firebase" ON storage.objects;
DROP POLICY IF EXISTS "Select seguro para usuarios Firebase" ON storage.objects;
DROP POLICY IF EXISTS "Delete seguro para usuarios Firebase" ON storage.objects;

-- 2. POLICY: INSERT (Upload Isolado)
CREATE POLICY "Upload seguro para usuarios Firebase" 
ON storage.objects FOR INSERT TO anon, authenticated
WITH CHECK (
  bucket_id = 'certificados_arquivos'
  AND auth.jwt()->>'iss' = 'https://securetoken.google.com/ifdex-app'
  AND auth.jwt()->>'aud' = 'ifdex-app'
  AND (storage.foldername(name))[1] IS NOT NULL
  AND (storage.foldername(name))[1] = auth.jwt()->>'sub'
);

-- 3. POLICY: UPDATE (Para `upsert: true` no Flutter funcionar)
CREATE POLICY "Update seguro para usuarios Firebase" 
ON storage.objects FOR UPDATE TO anon, authenticated
USING (
  bucket_id = 'certificados_arquivos'
  AND auth.jwt()->>'iss' = 'https://securetoken.google.com/ifdex-app'
  AND auth.jwt()->>'aud' = 'ifdex-app'
  AND (storage.foldername(name))[1] = auth.jwt()->>'sub'
)
WITH CHECK (
  bucket_id = 'certificados_arquivos'
  AND auth.jwt()->>'iss' = 'https://securetoken.google.com/ifdex-app'
  AND auth.jwt()->>'aud' = 'ifdex-app'
  AND (storage.foldername(name))[1] IS NOT NULL
  AND (storage.foldername(name))[1] = auth.jwt()->>'sub'
);

-- 4. POLICY: SELECT (Permite baixar os próprios PDFs no app Flutter)
CREATE POLICY "Select seguro para usuarios Firebase" 
ON storage.objects FOR SELECT TO anon, authenticated
USING (
  bucket_id = 'certificados_arquivos'
  AND auth.jwt()->>'iss' = 'https://securetoken.google.com/ifdex-app'
  AND auth.jwt()->>'aud' = 'ifdex-app'
  AND (storage.foldername(name))[1] = auth.jwt()->>'sub'
);

-- 5. POLICY: DELETE (Exclusão pelo dono original)
CREATE POLICY "Delete seguro para usuarios Firebase" 
ON storage.objects FOR DELETE TO anon, authenticated
USING (
  bucket_id = 'certificados_arquivos'
  AND auth.jwt()->>'iss' = 'https://securetoken.google.com/ifdex-app'
  AND auth.jwt()->>'aud' = 'ifdex-app'
  AND (storage.foldername(name))[1] = auth.jwt()->>'sub'
);
```

---

## 4. Implementação Client-Side (Flutter)

A inicialização não deve usar `signInAnonymously()` nem criar múltiplos clientes. Usamos o recurso `accessToken` para garantir sincronia automática.

### 4.1 Inicialização (`main.dart` ou `app.dart`)

```dart
await Supabase.initialize(
  url: AppConstants.supabaseUrl,
  anonKey: AppConstants.supabaseAnonKey,
  accessToken: () async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return await user.getIdToken(); // Supabase consome o Firebase JWT automaticamente
  },
);
```

### 4.2 CertificadoArquivoDatasource

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class CertificadoArquivoDatasource {
  final SupabaseClient _supabase;
  final String _bucket = 'certificados_arquivos';

  CertificadoArquivoDatasource(this._supabase);

  Future<void> uploadArquivo(
    String uid,
    String certificadoId,
    Uint8List bytes,
    String fileName,
  ) async {
    // Lógica para definir extensão e contentType
    // ...
    final caminho = '$uid/$certificadoId$ext';
    await _supabase.storage.from(_bucket).uploadBinary(
      caminho, 
      bytes,
      fileOptions: FileOptions(upsert: true, contentType: contentType),
    );
  }

  Future<Uint8List> downloadArquivo(String uid, String idHash) async {
    final caminho = '$uid/$idHash.pdf';
    return await _supabase.storage.from(_bucket).download(caminho);
  }
  
  Future<void> deletarArquivo(String uid, String idHash) async {
    final caminho = '$uid/$idHash.pdf';
    await _supabase.storage.from(_bucket).remove([caminho]);
  }
}
```

---

## 5. Roteamento Público (Next.js Proxy)

Para exibir certificados de forma elegante via link de compartilhamento, o bucket é privado e a rota depende de validação.

**Fluxo Obrigatório em `/api/certificado/[id]`:**

1. Recebe a requisição com o `id_unico` (Hash).
2. **Checa o Firestore:** O servidor acessa o Firestore via `Firebase Admin SDK` e busca o metadado.
3. Se o metadado **NÃO** existir, aborta com `404 Not Found` (evita abuso da banda do Supabase).
4. Se existir, extrai a `urlDocumento` ou o `UID` do dono.
5. Utilizando o SDK do Supabase inicializado com a **Service Role Key** (ignora RLS), o Next.js faz o download do arquivo do caminho `uid/hash.pdf`.
6. Envia os bytes (Stream) de volta para o cliente final.

## 6. Prevenção de Arquivos Órfãos

**Regra Operacional Crítica:** A persistência no sistema sempre ocorre na ordem: **Upload no Supabase primeiro -> Salva no Firestore depois.** Isso previne a existência de certificados na interface que não possuem arquivo anexado. Arquivos que subirem para o Supabase, mas falharem na etapa do Firestore (arquivos órfãos), serão tolerados em produção inicial e futuramente removidos por um Job de Garbage Collection agendado que cruzará a base do Storage com a base do Firestore.
