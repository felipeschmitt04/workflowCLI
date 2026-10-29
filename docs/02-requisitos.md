# 2. Requisitos

## 2.1 Requisitos funcionais

### Participantes e projetos

- **RF01:** o sistema deve permitir cadastrar, consultar, alterar e remover
  participantes.
- **RF02:** o sistema deve permitir cadastrar, consultar, alterar e remover
  projetos.
- **RF03:** cada projeto deve possuir seus próprios participantes, isolados dos
  participantes dos demais projetos.
- **RF04:** o sistema deve impedir a remoção de registros que possuam
  dependências, ou deve tratá-la conforme as regras definidas no modelo
  lógico.

### Tarefas

- **RF05:** o sistema deve permitir cadastrar, consultar, alterar e remover
  tarefas.
- **RF06:** cada tarefa deve possuir título, descrição, status, prioridade,
  prazo e responsável, quando aplicável.
- **RF07:** uma tarefa deve pertencer ao projeto correspondente ao schema
  atualmente selecionado.
- **RF08:** o sistema deve permitir associar etiquetas e comentários às
  tarefas.
- **RF09:** o sistema deve permitir registrar dependências entre tarefas,
  indicando quando uma tarefa bloqueia outra.
- **RF10:** o sistema deve respeitar as dependências entre tabelas em todas as
  operações de CRUD.

### Banco de dados e consultas

- **RF11:** o comando `workflowcli` deve iniciar a aplicação a partir da
  pasta de trabalho atual.
- **RF12:** a aplicação deve conectar-se a um banco PostgreSQL.
- **RF13:** na primeira execução em uma pasta, a aplicação deve solicitar as
  informações iniciais necessárias para configurar o projeto.
- **RF14:** a aplicação deve permitir criar um projeto e seu schema exclusivo,
  contendo o modelo completo da aplicação.
- **RF15:** a aplicação deve oferecer uma opção para criar as tabelas e
  carregar dados iniciais no schema do projeto atual.
- **RF16:** a aplicação deve oferecer uma opção para remover as tabelas e os
  dados do schema do projeto atual.
- **RF17:** a aplicação deve permitir excluir o schema completo de um projeto,
  mediante confirmação explícita.
- **RF18:** a aplicação deve localizar o marcador do projeto na pasta atual ou
  em um diretório pai e selecionar o schema correspondente.
- **RF19:** a aplicação deve impedir que dados de um projeto sejam acessados
  acidentalmente a partir do schema de outro projeto.
- **RF20:** a aplicação deve executar três consultas agregadas envolvendo pelo
  menos três tabelas.
- **RF21:** cada consulta deve apresentar o resultado em formato tabular e em
  representação gráfica.

### Inteligência artificial

- **RF22:** o sistema deve gerar um embedding a partir do título e da
  descrição de cada tarefa elegível.
- **RF23:** ao cadastrar ou consultar uma tarefa, o sistema deve permitir
  buscar tarefas semanticamente semelhantes.
- **RF24:** o sistema deve apresentar as tarefas sugeridas como possíveis
  duplicatas ou tarefas relacionadas, deixando a decisão final para o usuário.

### GitHub e Git

- **RF25:** a aplicação deve verificar a autenticação do usuário por meio do
  GitHub CLI (`gh`).
- **RF26:** a aplicação deve permitir listar, criar, editar e fechar issues
  por meio da API do GitHub.
- **RF27:** a aplicação deve permitir consultar e criar pull requests, desde
  que as branches necessárias já existam no repositório remoto.
- **RF28:** a aplicação deve permitir adicionar comentários e labels em issues
  quando o usuário possuir a permissão necessária.
- **RF29:** a aplicação deve permitir consultar branches, commits e status de
  um repositório Git local.
- **RF30:** falhas de internet, de autenticação ou de permissão devem ser
  informadas claramente e não podem corromper os dados locais.

## 2.2 Requisitos não funcionais

- **RNF01:** a aplicação deve ser desenvolvida em Python.
- **RNF02:** a interface TUI deve ser implementada com a biblioteca Textual e
  executada no terminal.
- **RNF03:** o banco de dados deve ser PostgreSQL.
- **RNF04:** tokens do GitHub não devem ser persistidos pelo sistema.
- **RNF05:** as operações externas devem exigir confirmação antes de criar,
  editar ou fechar recursos no GitHub.
- **RNF06:** a aplicação deve funcionar para o núcleo local e para a busca de
  embeddings já armazenados mesmo sem conexão com a internet.
- **RNF07:** a geração e a busca de embeddings não devem alterar ou excluir
  tarefas automaticamente.
- **RNF08:** nomes de schemas recebidos de entrada devem ser validados e
  tratados como identificadores SQL, nunca concatenados diretamente em
  comandos.
- **RNF09:** a troca de contexto entre projetos deve configurar
  explicitamente o schema ativo da conexão.
- **RNF10:** o marcador local deve conter somente referências de contexto,
  nunca senhas, tokens ou outras credenciais.
