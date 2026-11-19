# GuardaRio

**Alerta comunitário de enchentes: o rio avisa antes de subir.**

App Flutter da Global Solution 2026/2 da FIAP (tema CitizenTech), disciplina Mobile Application Development. Entrega de 19/11/2026.

## Integrantes

| Nome | RM |
|---|---|
| Henrique Spoltore Moreno Pavão dos Santos | RM568130 |
| Raphael Oliveira Sinelli Mendonça | RM568346 |
| Arthur Lins Belarmino | RM566845 |

## A solução

O GuardaRio é um sistema de alerta antecipado de enchentes para quem mora em áreas ribeirinhas e de baixada. Estações de baixo custo medem o nível do rio e a chuva, uma API gera alertas automáticos para a área e o app mostra ao morador o que está acontecendo e o que fazer. Neste app o morador vê o nível do rio numa régua colorida, recebe o alerta ativo com as orientações por nível, procura abrigos com vaga (filtrando por pets, acessibilidade e favoritos), monta o kit de emergência e envia relatos de problemas, que ganham uma prioridade de 1 a 5 para a Defesa Civil atender primeiro quem está em perigo. Alertas, abrigos e nível do rio funcionam sem login, porque informação de segurança não pode depender de cadastro. Só o relato pede conta.

Esta é a primeira versão do app. Todos os dados são mockados e ficam em memória, em `lib/data/mock_data.dart`. As regras de risco e de prioridade são as mesmas da API Java do projeto, para a integração futura dar o mesmo resultado.

Contexto do problema: 8.270.127 pessoas moravam em áreas de risco de enchente e deslizamento nos 872 municípios monitorados pelo Cemaden (IBGE e Cemaden, 2018). Um aviso com 24 horas de antecedência pode reduzir os danos em até 30% (Global Commission on Adaptation, citada pela WMO).

## Cidadão beneficiado

**Dona Cida, 67 anos**, moradora do Jardim Pantanal, zona leste de São Paulo, às margens do Tietê. Mora com o neto e uma cadela, usa um celular Android simples e não tem carro. Na última cheia só saiu de casa quando a água já estava no joelho, porque não sabia se o abrigo aceitava a cadela. Ela precisa de um aviso cedo e fácil de entender, de saber qual abrigo tem vaga e aceita animais, e de um jeito rápido de pedir ajuda.

> Dona Cida é uma persona construída pelo grupo para orientar o design. O bairro é real e tem histórico de alagamentos, mas os detalhes pessoais são fictícios.

O app foi desenhado para ela: botões grandes, letras maiores que o padrão, e o risco sempre mostrado com cor, ícone e texto, nunca só com cor.

## ODS relacionados

| ODS | Meta | Como o GuardaRio contribui |
|---|---|---|
| 11 Cidades e comunidades sustentáveis | 11.5, reduzir mortes e pessoas afetadas por desastres, com foco nos vulneráveis | Alerta hiperlocal e antecipado, abrigos com vaga visível e relatos priorizados por gravidade |
| 13 Ação contra a mudança global do clima | 13.1, resiliência e capacidade de adaptação. 13.3, alerta precoce e conscientização | Alerta automático por nível de risco e kit de emergência educativo no app |
| 3 Saúde e bem-estar | 3.d, alerta precoce e gestão de riscos à saúde | Evacuação antes do pico e menos exposição à água contaminada |
| 10 Redução das desigualdades | 10.2, inclusão de todos | Uso sem login, filtro de abrigo acessível para PcD e interface pensada para uma pessoa idosa |
| 9 Indústria, inovação e infraestrutura | 9.1, infraestrutura resiliente e acessível | O app é a ponta de uma cadeia que segue funcionando fora do cenário ideal: estação com energia solar, MQTT e opção LoRaWAN. Nesta versão a leitura da estação é mockada |

## Telas

São 11 telas, mais a casca de navegação com a `BottomNavigationBar` (Início, Alertas, Abrigos, Perfil).

| # | Tela | Arquivo | O que faz |
|---|---|---|---|
| 1 | Boas-vindas | `lib/telas/tela_boas_vindas.dart` | Logo, botão Entrar e botão Continuar sem conta |
| 2 | Login | `lib/telas/tela_login.dart` | Formulário de e-mail e senha com validação, olho para mostrar a senha e SnackBar vermelho para credencial errada |
| 3 | Início | `lib/telas/tela_inicio.dart` | Card do nível do rio com régua colorida, banner do alerta ativo, atalhos em GridView e botões Simular subida do rio e Reiniciar simulação |
| 4 | Alertas | `lib/telas/tela_alertas.dart` | Lista de cards coloridos por nível, com o alerta ativo em destaque |
| 5 | Detalhe do alerta | `lib/telas/tela_detalhe_alerta.dart` | Recebe o `Alerta` e mostra o que fazer agora para o nível |
| 6 | Abrigos | `lib/telas/tela_abrigos.dart` | FilterChips (pets, PcD, com vagas, favoritos), estrela para favoritar e mensagem de lista vazia |
| 7 | Detalhe do abrigo | `lib/telas/tela_detalhe_abrigo.dart` | Recebe o `Abrigo` e mostra ocupação, endereço, telefone e o selo ABERTO ou LOTADO |
| 8 | Novo relato | `lib/telas/tela_novo_relato.dart` | Formulário com tipo, bairro, descrição com contador e Switch, confirmação em AlertDialog e prioridade calculada |
| 9 | Meus relatos | `lib/telas/tela_meus_relatos.dart` | Lista que recebe o relato devolvido pelo formulário, com prioridade e status |
| 10 | Kit de emergência | `lib/telas/tela_kit.dart` | 12 itens em CheckboxListTile e o contador Itens prontos: X de 12 |
| 11 | Perfil | `lib/telas/tela_perfil.dart` | Nome, e-mail, atalhos, botão Sair e botão Entrar para visitante |

## Requisito da disciplina e onde está no código

| Requisito | Onde está |
|---|---|
| Navegação com `BottomNavigationBar` | `lib/telas/casca_navegacao.dart:37` |
| `Navigator.push` com `MaterialPageRoute` | `lib/telas/tela_boas_vindas.dart:44` e `lib/telas/tela_alertas.dart:91` |
| Parâmetro na ida: objeto pelo construtor | `lib/telas/tela_alertas.dart:94` recebido em `lib/telas/tela_detalhe_alerta.dart:11`. `lib/telas/tela_abrigos.dart:172` recebido em `lib/telas/tela_detalhe_abrigo.dart:9` |
| Parâmetro na volta: `Navigator.pop(context, relato)` | Devolvido em `lib/telas/tela_novo_relato.dart:160` e recebido em `lib/telas/tela_meus_relatos.dart:29` |
| Troca da pilha de telas | `lib/telas/tela_login.dart:74` no login e `lib/telas/tela_perfil.dart:116` no Sair |
| `Scaffold` e `AppBar` | `lib/telas/tela_kit.dart:32` e `lib/telas/tela_kit.dart:33` |
| `Column` e `Row` | `lib/telas/tela_inicio.dart:165` e `lib/telas/tela_inicio.dart:168` |
| `Container`, `Padding` e `SizedBox` | `lib/widgets/selo_risco.dart:86`, `lib/telas/tela_kit.dart:39` e `lib/telas/tela_kit.dart:48` |
| `Card`, `Icon` e `Image` | `lib/telas/tela_kit.dart:38`, `lib/telas/tela_perfil.dart:35` e `lib/telas/tela_boas_vindas.dart:26` |
| `ListView` e `GridView` | `lib/telas/tela_alertas.dart:23`, `lib/telas/tela_inicio.dart:142` e `lib/telas/tela_inicio.dart:361` |
| Tema único (azul `#1F7AB8`, cores de risco, espaçamentos 8, 16 e 24, cards com raio 12) | `lib/theme/app_theme.dart:4` |
| Risco com cor, ícone e texto | `lib/widgets/selo_risco.dart:77` |
| Estado com `setState`: simular subida do rio | `lib/telas/tela_inicio.dart:40` |
| Estado com `setState`: filtros e favoritos de abrigos | `lib/telas/tela_abrigos.dart:68` e `lib/telas/tela_abrigos.dart:223` |
| Estado com `setState`: kit de emergência | `lib/telas/tela_kit.dart:91` |
| Estado com `setState`: lista de relatos | `lib/telas/tela_meus_relatos.dart:39` |
| `Form` com `GlobalKey<FormState>` | `lib/telas/tela_login.dart:17` e `lib/telas/tela_novo_relato.dart:20` |
| `TextFormField` com `validator` | `lib/telas/tela_login.dart:119` e `lib/telas/tela_novo_relato.dart:214` |
| `DropdownButtonFormField` | `lib/telas/tela_novo_relato.dart:180` |
| `validate()` no envio | `lib/telas/tela_login.dart:57` e `lib/telas/tela_novo_relato.dart:74` |
| `SnackBar` | `lib/telas/tela_login.dart:66` (erro e sucesso do login) e `lib/telas/tela_meus_relatos.dart:41` (relato enviado) |
| `AlertDialog` via `showDialog` | `lib/telas/tela_novo_relato.dart:94` (confirmação) e `lib/widgets/dialogo_login.dart:8` (exige login) |
| Feedback visual de erro nos formulários | `lib/theme/app_theme.dart:114` (borda vermelha) e as mensagens dos validators |
| Régua de risco e agravante de chuva (RN01) | `lib/regras/regras_risco.dart:15` |
| Prioridade do relato (RN06) | `lib/regras/regras_risco.dart:35` |
| Alerta automático (RN02) | `lib/regras/regras_risco.dart:75` |
| Dados mockados | `lib/data/mock_data.dart:13` |
| Testes unitários das regras | `test/regras_risco_test.dart:30` |
| Testes de widget | `test/tela_login_test.dart:11`, `test/tela_novo_relato_test.dart:15`, `test/tela_kit_test.dart:7` e `test/tela_inicio_test.dart:22` |

## Estrutura de pastas

```
guardario-mobile/
  assets/
    logo.png                      logo gerado com Pillow (gota d'água com uma onda)
  lib/
    main.dart                     MaterialApp com o tema e a tela de boas-vindas
    theme/app_theme.dart          cores, espaçamentos, raio dos cards e ThemeData
    models/                       Alerta, Abrigo, Relato, Estacao, Usuario, ItemKit, NivelRisco
    regras/regras_risco.dart      régua de risco, prioridade, simulação e alerta automático
    data/mock_data.dart           dados mockados e estado em memória
    utils/formatar_data.dart      datas formatadas à mão
    widgets/                      SeloRisco, Etiqueta, etiquetas do abrigo e diálogo de login
    telas/                        uma tela por arquivo, mais a casca de navegação
  test/                           testes unitários e de widget
  android/                        projeto Android gerado pelo Flutter
  pubspec.yaml                    só flutter, cupertino_icons, flutter_test e flutter_lints
```

## Como executar

Versões usadas no desenvolvimento e nos testes: **Flutter 3.44.9 (stable)**, **Dart 3.12.2**, Android SDK 36 e JDK 17. Com o Flutter 3.50 o `flutter analyze` marca `package:flutter/material.dart` como deprecado, por isso o projeto foi feito na 3.44.9.

1. Instale o Flutter 3.44.9 e o Android SDK, e confira com `flutter doctor`.
2. Clone o repositório:
   ```
   git clone https://github.com/Raphael-Sinelli/guardario-mobile.git
   cd guardario-mobile
   ```
3. Baixe as dependências:
   ```
   flutter pub get
   ```
4. Abra um emulador Android. Liste os emuladores com `flutter emulators` e inicie um com `flutter emulators --launch` seguido do id que aparecer na lista, por exemplo `flutter emulators --launch Pixel_6_API_35`. Se não houver nenhum, crie um no Device Manager do Android Studio (os testes foram feitos com Android 15, API 35).
5. Rode o app:
   ```
   flutter run
   ```
6. Para conferir a qualidade do código:
   ```
   flutter analyze
   flutter test
   ```

## Usuário de teste

| E-mail | Senha | Nome |
|---|---|---|
| `cida@guardario.com` | `123456` | Cida Souza |

A tela de login mostra esses dados e tem o botão Preencher os campos.

## Roteiro rápido de teste

1. Na tela de boas-vindas, toque em **Entrar**. Toque em Entrar com os campos vazios para ver os erros, digite `cida@guardario` para ver o erro de formato e depois use o usuário de teste.
2. Na tela **Início**, toque em **Simular subida do rio** quatro vezes. O nível passa de 130 cm para 170, 210, 250 e 290 cm, e o risco muda de NORMAL para ATENÇÃO, ATENÇÃO, ALERTA e EMERGÊNCIA. No 3º e no 4º toque aparece um alerta novo. Toque em **Reiniciar simulação** para voltar ao começo.
3. Toque no banner do alerta ativo para abrir o **detalhe do alerta**. Na aba **Alertas** veja a lista, com o ativo em destaque.
4. Na aba **Abrigos**, ligue os filtros. Ligue Favoritos sem favoritar nada para ver a mensagem de lista vazia. Toque num abrigo para abrir o **detalhe**.
5. Em **Início**, abra **Novo relato**. Envie o formulário vazio para ver os erros. Preencha, envie, confira o resumo e a prioridade no AlertDialog e confirme. O relato aparece em **Meus relatos**.
6. Abra o **Kit de emergência** e marque itens para ver o contador mudar.
7. Na aba **Perfil**, toque em **Sair**. De volta às boas-vindas, toque em **Continuar sem conta** e tente abrir Novo relato: aparece o aviso com o botão para o login.

## Regras de negócio mockadas

São as mesmas regras da API Java (RN01, RN02 e RN06), em `lib/regras/regras_risco.dart`.

| Regra | Valor |
|---|---|
| Estação | Ponte da Rua Capachós, Rio Tietê, Jardim Pantanal (São Paulo) |
| Cotas | atenção 150 cm, alerta 220 cm, transbordo 300 cm |
| Leitura inicial | 130 cm e 8 mm/h |
| Régua | abaixo de 150 cm é NORMAL. A partir de 150, 220 e 300 cm sobe para ATENÇÃO, ALERTA e EMERGÊNCIA |
| Agravante de chuva | chuva de 50 mm/h ou mais sobe um nível, até EMERGÊNCIA |
| Simulação | cada toque soma 40 cm e 12 mm/h, com teto de 330 cm |
| Alerta automático | com risco ALERTA ou maior, cria um alerta se não houver ativo de nível igual ou maior, e encerra os ativos de nível menor |
| Prioridade do relato | PESSOA_ILHADA 5, DESLIZAMENTO 4, RIO_SUBINDO 3, ALAGAMENTO_VIA 3, BUEIRO_ENTUPIDO 2, OUTRO 1, mais 1 se a área estiver em ALERTA ou EMERGÊNCIA, com teto 5 |

Os nomes e endereços dos abrigos são ilustrativos e os telefones seguem o formato `(11) 0000-0000`, sem número real.

## Publicação

O APK de release (`flutter build apk --release`) é gerado a partir do último commit e publicado em GitHub Releases:

https://github.com/Raphael-Sinelli/guardario-mobile/releases

## Vídeo

VIDEO_PENDENTE

## Uso de IA generativa

| Ferramenta | Para quê |
|---|---|
| Claude (Anthropic) | Pesquisar dados sobre enchentes e organizar o plano da solução |
| Claude Code (Anthropic) | Escrever e revisar o código do app a partir do documento da solução, incluindo os testes e este README |

A equipe revisou o código, rodou os testes e consegue explicar cada arquivo do app.
