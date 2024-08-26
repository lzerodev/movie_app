# Avaliação Técnica - Projeto Android

## Descrição do Projeto

Este projeto tem como objetivo avaliar suas habilidades em desenvolvimento Android. Você deverá criar um aplicativo simples que consuma uma API pública e exiba os dados em uma lista. O aplicativo deve permitir ao usuário visualizar detalhes de cada item da lista em uma nova tela.

## Funcionalidades Requeridas

[x] 1. **Tela de Lista de Itens**
   - Exibir uma lista de itens recuperados de uma API pública.
   - Cada item deve mostrar pelo menos um título e uma breve descrição.

[x] 2. **Tela de Detalhes do Item** 
   - Exibir detalhes adicionais do item selecionado na lista.
   - Incluir informações como título, descrição completa e qualquer outra informação relevante fornecida pela API.

[x] 3. **Pesquisa**
   - Incluir uma funcionalidade de pesquisa que permita ao usuário filtrar a lista de itens pelo título.

[x] 4. **Tratamento de Erros**
   - Exibir mensagens de erro adequadas em caso de falha na requisição da API ou problemas de conectividade.

## Requisitos Técnicos

[x] 1. **Consumo de API** - Api escolhida foi The Movie Database
   - Utilize uma API pública de sua escolha (ex.: JSONPlaceholder, The Movie Database, etc.).

[x] 2. **Boas Práticas**
   - Código limpo e bem documentado.
   - Tratamento adequado de erros e exceções.

## Instruções de Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/lzerodev/movie_app.git
   ```

2. **Abra o diretório no Android Studio e crie seu emulador**

3. **Instale as dependências do projeto**
   ```
   flutter pub get
   ```

4. **Rode a aplicação usando o emulador criado**
   ```
   flutter run
   ```
   
## Dependências adicionadas:

dio
flutter_svg
mockito
tests
build_runner