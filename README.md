# Saborê

Aplicativo mobile para descobrir receitas, pesquisar pelo nome, ler ingredientes e modo de preparo e guardar favoritos. Os dados vêm da API pública [DummyJSON Recipes](https://dummyjson.com/docs/recipes). Projeto final de Desenvolvimento Mobile.

## Funcionalidades

- **Explorar:** tela inicial com a marca, acesso à pesquisa e a lista de receitas carregada na primeira abertura.
- **Listagem:** nome, imagem, tempo, dificuldade e nota. Se a imagem faltar ou falhar, aparece um ícone no lugar.
- **Pesquisa:** busca pelo endpoint remoto, remove espaços nas pontas e recusa texto vazio. "Limpar pesquisa" e "Ver todas as receitas" voltam à listagem.
- **Detalhes:** ingredientes, passos numerados, porções, tempo e nota. A tela rola para conteúdo longo.
- **Favoritos:** adiciona e remove durante a sessão, sem duplicatas, pelo coração do cartão ou do detalhe. Uma aba própria lista os salvos.
- **Carregamento:** esqueleto animado e botão de busca desativado enquanto a consulta roda.
- **Erros:** falha de rede, status diferente de 200 e JSON fora do formato têm mensagens próprias e botão de nova tentativa.
- **Estados vazios:** "Nenhum resultado" (busca sem correspondência) e "Nenhum favorito" são telas diferentes do erro.
- **Navegação:** abrir um detalhe e voltar mantém a pesquisa e os resultados.

## Decisões de implementação

- **Detalhe:** a resposta de listagem e de pesquisa já traz todos os campos da receita, então o detalhe reaproveita o objeto selecionado em vez de chamar `/recipes/{id}`.
- **Fonte única de verdade:** `RecipeStore` (um `ChangeNotifier`) guarda o catálogo, a pesquisa e os favoritos. Ele é entregue às telas por um `InheritedNotifier`, sem pacote de gerenciamento de estado.
- **Consultas concorrentes:** o catálogo só inicia uma carga por vez. A pesquisa usa um token: se o usuário limpar ou mudar a consulta, a resposta antiga é descartada. A carga inicial é disparada uma vez em `main()`, e não a cada reconstrução de tela.
- **Tempo total:** só é somado quando preparo e cozimento vêm como número. Se vier só um dos dois, ele é mostrado com o próprio nome ("preparo" ou "cozimento"), sem tratar o ausente como zero.
- **Campos tolerantes:** `rating` é lido como `num`, `mealType` como lista (aceita texto único) e itens sem `id` são ignorados.

## Estrutura

```
lib/
  main.dart
  app.dart               tema, abas e navegação
  theme.dart             cores e estilos
  models/recipe.dart     modelo e leitura do JSON
  data/recipe_api.dart   chamadas HTTP e erros
  state/recipe_store.dart
  screens/               home, busca, detalhe, favoritos
  widgets/               cabeçalho, botões, cartão, estados
test/
```

## Dependências

- `http` para as requisições
- `material_ui` (já vem no template do Flutter 3.50)
- `flutter_lints` e `flutter_test` em desenvolvimento

## SDK

- Flutter 3.50.0 (stable)
- Dart 3.14.0
- Android SDK 36

## Como executar

1. Instale o Flutter 3.50 ou superior e o Android Studio com um emulador, ou conecte um celular Android.
2. Clone e entre na pasta:

   ```bash
   git clone https://github.com/daviburke/ProjetoFinal_Flutter4BI.git
   cd ProjetoFinal_Flutter4BI
   ```

3. Baixe as dependências e rode:

   ```bash
   flutter pub get
   flutter run
   ```

Testes:

```bash
flutter test
```

O aparelho precisa de internet para carregar as receitas. Os nomes e instruções vêm em inglês da API e não foram traduzidos.
