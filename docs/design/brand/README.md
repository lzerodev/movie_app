# Marca RTM — proposta 01

Símbolo: ingresso de cinema com estrela em recorte. A inclinação de 12 graus e os cantos arredondados dão movimento à forma; a silhueta única permite uso pequeno e monocromático, em uma direção visual compatível com o Material 3 do projeto.

## Arquivos

- `rtm-brand-preview.png`: apresentação nos temas claro/escuro e tamanhos pequenos.
- `rtm-mark.svg`: símbolo coral em fundo transparente.
- `rtm-mark-light.svg`: símbolo framboesa para superfícies claras.
- `rtm-mark.png` e `rtm-mark-light.png`: exportações transparentes de 1024 px.
- `rtm-app-icon.svg` e `rtm-app-icon.png`: ícone com fundo carvão opaco.

Fonte editável: `frontend/assets/brand/rtm-mark.svg`. O widget `RtmLogo` usa esse SVG e a cor primária do tema. Foi aplicado no cabeçalho e no diálogo Sobre; a transição Hero dos pôsteres e o BLoC não foram alterados.

Coral: `#FF6978`. Framboesa: `#B82D49`. Fundo do ícone: `#100F14`. Manter o recorte da estrela transparente e a proporção; não acrescentar brilho, contorno ou pequenos detalhes ao símbolo. O nome completo permanece como apoio à sigla RTM, fora do ícone.

## Exportação

A ferramenta `frontend/tool/export_brand_assets_test.dart` usa flutter_svg e o rasterizador do Flutter já presentes no projeto. Executar explicitamente com `flutter test tool/export_brand_assets_test.dart`, a partir de frontend. Não está na suíte test/ e não precisa de dependência adicional. Todos os ícones são derivados da mesma fonte, incluindo os PNGs de Android/iOS/macOS/web e o ICO multirresolução de Windows.

Os ícones de plataforma usam fundo opaco e PNG RGB sem canal alfa. O ICO contém versões 16/24/32/48/64/128/256. O desenho fica dentro da área central segura da versão maskable web. Os arquivos foram preparados; ver o novo ícone no executável/launcher exige recompilar e reabrir a aplicação, e o sistema pode manter cache de ícones.

## Verificação

Apresentação visual inspecionada nos dois temas; exportação concluída; PNGs e diretório do ICO verificados. Análise estática limpa, 85 testes da aplicação passaram e hot reload do cabeçalho confirmado no Windows. Não houve instalação ou validação dos launchers em Android/iOS/macOS, build de release ou publicação. O Figma não foi atualizado nesta rodada, pois a conexão havia atingido o limite do plano.
