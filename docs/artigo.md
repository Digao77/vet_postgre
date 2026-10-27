# Desenvolvimento e Organização de um Banco de Dados PostgreSQL para a Clínica Veterinária Melhor Amigo.

## 1. Introdução

Este projeto tem como objetivo desenvolver e organizar um banco de dados para a clínica veterinária Melhor Amigo. O sistema foi pensado para armazenar e organizar informações importantes para o funcionamento da clínica, como dados de clientes, animais de estimação, produtos, serviços, pedidos, estoque, funcionários e informações relacionadas à área contábil.

Inicialmente, o banco de dados havia sido desenvolvido utilizando MySQL. Com a evolução do projeto, surgiu a necessidade de realizar a migração para o PostgreSQL, adaptando a estrutura existente e aproveitando os recursos oferecidos pelo novo Banco de Dados que viria a ser utilizado.

Durante essa reorganização, as tabelas foram divididas em três schemas: `site`, `adm` e `contabil`. Essa divisão foi feita para separar melhor as diferentes áreas do sistema e facilitar a organização e a manutenção do banco de dados.

Além da reorganização da estrutura, também foram criadas views para facilitar consultas realizadas com frequência, constraints para ajudar a evitar dados inválidos e regras para definir como as tabelas relacionadas devem se comportar quando determinados registros são alterados ou excluídos.

## 2. Metodologia

### 2.1 Migração do MySQL para PostgreSQL

O primeiro passo do trabalho foi adaptar a estrutura do banco de dados que já existia em MySQL para o PostgreSQL. Durante essa etapa, foi necessário fazer algumas alterações na sintaxe e na estrutura para que o banco pudesse funcionar corretamente no novo SGBD.

Também foram revisadas as tabelas, chaves primárias, chaves estrangeiras e outras restrições que já faziam parte do projeto. Depois dessas adaptações, os comandos SQL foram organizados em arquivos separados, de acordo com os schemas do banco.

### 2.2 Organização em schemas

Após a migração, o banco de dados foi dividido em três schemas: `site`, `adm` e `contabil`.

O schema `site` reúne as principais informações utilizadas pelo sistema da clínica, como clientes, pets, produtos, carrinhos, pedidos e serviços.

O schema `adm` reúne informações relacionadas à administração da clínica, como funcionários, estoque e histórico.

Já o schema `contabil` concentra as informações relacionadas à parte contábil, incluindo pagamentos, plano de contas e lançamentos.

Essa divisão ajuda a deixar o banco mais organizado, pois cada área possui suas próprias tabelas e responsabilidades.

### 2.3 Implementação de Views

Depois de organizar os schemas, foram criadas algumas views para facilitar consultas que podem ser realizadas com frequência.

No schema `site`, foi criada a view `clientes_pets`, que permite consultar os clientes juntamente com os seus respectivos pets. Dessa forma, a aplicação consegue obter essas informações sem precisar montar novamente o mesmo `JOIN`.

Também foi criada a view `produto_catalogo`, que apresenta o nome e o valor dos produtos cadastrados. Ela pode ser utilizada para facilitar a consulta das informações que serão apresentadas no catálogo de produtos.

No schema `adm`, foi criada a view `lista_clientes`, que facilita a consulta dos dados dos clientes pela equipe administrativa. Também foi criada a view `relatorio_funcionarios`, que reúne informações dos funcionários, como nome, setor, salário e benefício.

A criação dessas views facilita o acesso às informações e evita a repetição de consultas que são utilizadas com frequência.

### 2.4 Implementação de Constraints

Para ajudar a manter os dados corretos no banco, foram adicionadas algumas constraints do tipo `CHECK`.

Na tabela `site.pet`, foi criada uma constraint para impedir que a idade de um animal seja cadastrada com um valor negativo. Outra constraint foi utilizada para impedir que o peso seja menor ou igual a zero.

Na tabela `site.pedido`, foi criada uma constraint para limitar os possíveis valores do campo de status. Dessa forma, o campo pode receber apenas os valores `pendente`, `pago`, `cancelado` ou `concluido`.

Também foram revisadas as chaves estrangeiras do banco de dados. Para cada relacionamento, foram definidas regras de `ON DELETE` e `ON UPDATE`, utilizando opções como `RESTRICT` e `CASCADE`.

Essas regras ajudam a controlar o que acontece com os registros relacionados quando uma informação é alterada ou excluída, evitando problemas de integridade entre as tabelas.

### 2.5 Organização do projeto

Além da organização do banco de dados, os arquivos do projeto também foram reorganizados para facilitar sua utilização.

Os scripts SQL foram separados de acordo com os schemas e armazenados na pasta `scripts`. O arquivo `site.sql` contém as estruturas relacionadas ao schema `site`, enquanto `adm.sql` contém as estruturas do schema `adm` e `contabil.sql` contém as estruturas do schema `contabil`.

Também foi criada a pasta `docs`, onde foram armazenados os modelos lógicos desenvolvidos no brModelo e os demais documentos relacionados ao projeto.

Por fim, foi criado um arquivo `README.md` com uma explicação sobre o projeto, sua organização e a ordem correta para executar os scripts. A sequência definida é `site.sql`, `adm.sql` e `contabil.sql`, pois existem dependências entre algumas tabelas dos diferentes schemas.
