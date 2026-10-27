* Execução dos scripts

Os scripts devem ser executados na seguinte ordem:

1. scripts/site.sql
2. scripts/adm.sql
3. scripts/contabil.sql

Primeiramente, deve ser executado o `site.sql`, pois ele cria o schema `site` e suas principais tabelas, como `tutor_cliente`, `pet`, `produto`, `carrinho`, `pedido` e `servico`. Essas tabelas são utilizadas como referência por outras tabelas do projeto.
Em seguida, deve ser executado o `adm.sql`. Além de criar o schema `adm` e suas tabelas, esse script cria relacionamentos com tabelas do schema `site`. Um exemplo é a tabela `adm.estoque`, que possui uma chave estrangeira que referencia `site.produto`. O script também cria uma chave estrangeira entre `site.carrinho` e `adm.estoque`.
Por último, deve ser executado o `contabil.sql`, que cria o schema `contabil` e suas tabelas. Esse schema possui chaves estrangeiras que fazem referência a tabelas já criadas nos schemas `site` e `contabil`, como `site.servico`, `site.pedido` e `contabil.plano_contas`.
Portanto, a sequência `site.sql - adm.sql - contabil.sql` garante que as tabelas referenciadas já existam no momento em que as chaves estrangeiras forem criadas, evitando erros de dependência durante a execução dos scripts.

* Modelos lógicos

Os modelos lógicos foram desenvolvidos utilizando o brModelo:

- docs/Lógico_1.brM3 = modelo lógico do schema `site`.
- docs/Lógico_2.brM3 = modelo lógico do schema `adm`.
- docs/Lógico_3.brM3 = modelo lógico do schema `contabil`.

* Views

Foram criadas views para facilitar consultas frequentes:

* Schema site

- `site.clientes_pets`: utilizada pela equipe do site para consultar clientes e seus respectivos pets.
- `site.produto_catalogo`: utilizada pela equipe do site para visualizar os produtos disponíveis no catálogo.

* Schema adm

- `adm.lista_clientes`: utilizada pela equipe administrativa para consultar os dados dos clientes.
- `adm.relatorio_funcionarios`: utilizada pela equipe administrativa para consultar informações dos funcionários.

* Constraints

Foram adicionadas constraints `CHECK` para garantir a integridade dos dados:

- `chk_pet_idade`: impede idade de pet menor que zero.
- `chk_pet_peso`: impede peso de pet menor ou igual a zero.
- `chk_pedido_status`: permite apenas os status definidos para os pedidos.

Também foram revisadas as regras de `ON DELETE` e `ON UPDATE` das chaves estrangeiras, buscando preservar os registros importantes e manter a integridade dos relacionamentos.
