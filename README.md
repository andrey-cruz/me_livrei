<div align="center">

# 📚 Me Livrei

### *Liberte seus livros, liberte histórias*

[![Flutter Version](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-2.17+-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

## 🌟 Visão Geral

**Me Livrei** é um aplicativo mobile que revoluciona a forma como as pessoas compartilham livros. Mais que uma plataforma de troca, é uma **comunidade que transforma desapego em conexão**, conectando leitores apaixonados através de uma interface intuitiva e social.

### ✨ Problema que Resolvemos

- 📚 **Livros parados na estante** — Milhões de livros acumulam poeira sem serem lidos
- 💰 **Alto custo de livros novos** — Dificulta acesso à cultura e educação
- ♻️ **Desperdício ambiental** — Produção excessiva de papel e descarte inadequado
- 🤝 **Isolamento de leitores** — Falta de comunidades locais para compartilhar experiências literárias

### 💡 Nossa Solução

Um **ecossistema social de troca de livros** que democratiza o acesso à literatura, promove sustentabilidade e fortalece comunidades de leitores através de:

- 🔍 **Sistema de busca dual** — Procure por livros ou encontre pessoas com gostos literários similares
- 📍 **Geolocalização** — Encontre livros disponíveis perto de você
- ❤️ **Sistema de match** — Demonstre interesse e conecte-se diretamente com o dono

---

## 🎯 Funcionalidades Principais

<table>
<tr>
<td width="33%">

### 🔐 Autenticação & Perfil
- Login/Cadastro com email/senha
- Recuperação de senha
- Perfil personalizável completo
- Dashboard de estatísticas pessoais

</td>
<td width="33%">
  
### 📚 Gestão de Livros
- Cadastro com foto (Firebase Storage)
- Edição e exclusão de livros próprios
- Motivação de desapego personalizada

</td>
<td width="33%">

### ❤️ Sistema de Interesses
- Demonstrar interesse em livros
- Notificações em tempo real
- Lista de interessados detalhada
- Aceitar/recusar interesses
  
</td>
</tr>
</table>

---

## 🌍 Alinhamento com ODS

Este projeto está alinhado com os **Objetivos de Desenvolvimento Sustentável** da ONU (Agenda 2030):

<div align="center">

| ODS | Contribuição |
|:---:|:-------------|
| **📚 ODS 4<br>Educação de Qualidade** | Democratiza o acesso à leitura, permitindo que livros circulem entre pessoas de diferentes realidades socioeconômicas |
| **🌱 ODS 12<br>Consumo Responsável** | Incentiva economia circular no mercado editorial, reduzindo desperdício e produção desnecessária |
| **🏙️ ODS 11<br>Cidades Sustentáveis** | Fortalece comunidades locais de leitores, promovendo interação social saudável baseada em proximidade |
| **🤝 ODS 17<br>Parcerias** | Facilita colaboração entre leitores, clubes de leitura, bibliotecas comunitárias e sebos |

</div>

### 📊 Impacto Mensurável

- ♻️ **Cada livro trocado** = ~2.3 kg de CO₂ economizados
- 📚 **Cada livro circulando** = +3 novos leitores alcançados (média)
- 🌳 **Meta 2025:** 10.000 livros em circulação = 23 toneladas de CO₂ evitadas


---

## 🚀 Começando

### Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas:

- ✅ [Flutter SDK](https://flutter.dev/docs/get-started/install) `>= 3.0.0`
- ✅ [Dart](https://dart.dev/get-dart) `>= 2.17.0`
- ✅ [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/) com extensões Flutter/Dart
- ✅ [Git](https://git-scm.com/)
- ✅ [Firebase CLI](https://firebase.google.com/docs/cli) (para configuração)

### Instalação

**1. Clone o repositório**

```bash
git clone https://github.com/andrey-cruz/me-livrei.git
cd me-livrei
```

**2. Instale as dependências**

```bash
flutter pub get
```

**3. Configure o Firebase (veja seção abaixo)**

**4. Execute o aplicativo**

```bash
# Para Android
flutter run

# Para iOS
flutter run -d ios

# Para Web (em desenvolvimento)
flutter run -d chrome
```

---

### 🔥 Configuração Firebase

<details>
<summary><b>Clique para expandir o guia de configuração completo</b></summary>

#### 1. Criar Projeto Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Clique em "Adicionar Projeto"
3. Nomeie o projeto como `me-livrei-app`
4. Habilite Google Analytics (opcional mas recomendado)

#### 2. Adicionar Apps (Android/iOS)

##### Android:
```bash
# 1. No Firebase Console, adicione um app Android
# 2. Pacote: com.melivrei.app
# 3. Baixe google-services.json
# 4. Coloque em: android/app/google-services.json
```

##### iOS:
```bash
# 1. No Firebase Console, adicione um app iOS
# 2. Bundle ID: com.melivrei.app
# 3. Baixe GoogleService-Info.plist
# 4. Coloque em: ios/Runner/GoogleService-Info.plist
```

#### 3. Ativar Serviços Firebase

No Firebase Console, ative:

- ✅ **Authentication** → Email/Password + Google Sign-In
- ✅ **Firestore Database** → Modo de produção (ajustar regras depois)
- ✅ **Storage** → Configurar para uploads de imagens
- ✅ **Cloud Messaging** → Para notificações push

#### 4. Configurar FlutterFire

```bash
# Instale FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure o Firebase automaticamente
flutterfire configure
```

</details>

---

## 🤝 Contribuindo

Contribuições são muito bem-vindas! Este é um projeto acadêmico, mas estamos abertos a melhorias e novas ideias.

### Como Contribuir

1. **Fork** o projeto
2. Crie uma **branch** para sua feature (`git checkout -b feature/MinhaFeature`)
3. **Commit** suas mudanças (`git commit -m 'feat: adiciona nova feature'`)
4. **Push** para a branch (`git push origin feature/MinhaFeature`)
5. Abra um **Pull Request**

### Diretrizes

- 📝 Siga o [Conventional Commits](https://www.conventionalcommits.org/)
- ✅ Escreva testes para novas funcionalidades
- 📖 Atualize a documentação quando necessário
- 🎨 Respeite o guia de estilo do projeto (flutter_lints)
- 💬 Seja respeitoso e construtivo nos comentários

Para mais detalhes, leia nosso [Guia de Contribuição](CONTRIBUTING.md).

---

## 👥 Time de Desenvolvimento

<table align="center">
<tr>
<td align="center" width="20%">
<a href="https://github.com/andrey-cruz">
<img src="https://github.com/andrey-cruz.png" width="100px;" alt="Andrey Cruz"/><br>
<sub><b>Andrey Cruz</b></sub>
</a><br>
<sub>Soon</sub>
</td>
<td align="center" width="20%">
<a href="https://github.com/JoaoPedroBittar">
<img src="https://github.com/JoaoPedroBittar.png" width="100px;" alt="João Pedro Bittar"/><br>
<sub><b>João P. Bittar</b></sub>
</a><br>
<sub>Soon</sub>
</td>
<td align="center" width="20%">
<a href="https://github.com/MPicolli">
<img src="https://github.com/MPicolli.png" width="100px;" alt="Matheus Picolli Ishibashi"/><br>
<sub><b>Matheus Picolli</b></sub>
</a><br>
<sub>Soon</sub>
</td>
<td align="center" width="20%">
<a href="https://github.com/murilo-shaefer">
<img src="https://github.com/murilo-shaefer.png" width="100px;" alt="Murilo Shaefer"/><br>
<sub><b>Murilo Shaefer</b></sub>
</a><br>
<sub>Soon</sub>
</td>
<td align="center" width="20%">
<a href="https://github.com/KamilyCurcio">
<img src="https://github.com/KamilyCurcio.png" width="100px;" alt="Kamily Cúrcio"/><br>
<sub><b>Kamily Cúrcio</b></sub>
</a><br>
<sub>Soon</sub>
</td>
</tr>
</table>

---

## 📄 Licença

Este projeto está licenciado sob a **Licença MIT**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

```
MIT License

Copyright (c) 2025 Me Livrei Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software")...
```

---

## 📞 Contato

### Desenvolvimento

- 📧 **Email principal:** mcruz.estudante@gmail.com
- 🐙 **GitHub:** [@andrey-cruz](https://github.com/andrey-cruz)
- 💼 **LinkedIn:** [Andrey Cruz](https://linkedin.com/in/andrey-cruz)

### Contexto Acadêmico

- 🎓 **Instituição:** UNISUL — Universidade do Sul de Santa Catarina
- 👨‍🏫 **Professor Orientador:** Saulo Popov
- 📚 **Disciplina:** Desenvolvimento Web, Mobile e Jogos Digitais
- 🎯 **Tipo:** Projeto Acadêmico A3 — 2025/2

---

### Tecnologias e Ferramentas Utilizadas

- [Flutter](https://flutter.dev) — Framework mobile multiplataforma
- [Firebase](https://firebase.google.com) — Backend as a Service
- [Provider](https://pub.dev/packages/provider) — Gerenciamento de estado
- [Shields.io](https://shields.io) — Badges para README
- [Figma](https://figma.com) — Design e prototipagem
- [GitHub](https://github.com) — Hospedagem e versionamento

---

<div align="center">

## 📊 Estatísticas do Projeto

![GitHub contributors](https://img.shields.io/github/contributors/andrey-cruz/me-livrei?color=2DD4BF)
![GitHub issues](https://img.shields.io/github/issues/andrey-cruz/me-livrei?color=FF6B6B)
![GitHub pull requests](https://img.shields.io/github/issues-pr/andrey-cruz/me-livrei?color=10B981)
![GitHub stars](https://img.shields.io/github/stars/andrey-cruz/me-livrei?style=social)

---

### 💚 Apoie o Projeto

Se você achou este projeto útil ou interessante, considere:

⭐ Dar uma **estrela** no repositório  
🐛 Reportar **bugs** ou sugerir **melhorias**  
🤝 **Contribuir** com código ou documentação  
📢 **Compartilhar** com outros desenvolvedores e leitores

---

</div>

<div align="center">

**[⬆ Voltar ao topo](#-me-livrei)**

---

<sub>Desenvolvido por estudantes de Sistemas de Informação e ADS — UNISUL</sub>  
<sub>Projeto Acadêmico A3 • 2025 • Florianópolis, SC, Brasil 🇧🇷</sub>

*"Cada livro trocado é uma nova história que começa."*


</div>



