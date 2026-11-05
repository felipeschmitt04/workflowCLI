# 4. Modelo lógico

O modelo lógico será derivado do modelo conceitual e implementado em
PostgreSQL. A aplicação utilizará a arquitetura **schema-per-project**:

- o schema `public` terá o catálogo central de projetos;
- o schema `public` terá as identidades globais de participantes e suas
  associações com projetos;
- cada projeto terá um schema próprio;
- cada schema de projeto conterá as tabelas operacionais da aplicação;
- as tabelas de projetos diferentes não compartilharão dados de domínio.

Cada tabela deverá indicar sua chave primária, suas chaves estrangeiras,
atributos obrigatórios e regras de integridade.

## 4.1 Tabelas previstas

### Catálogo central (`public`)

- `projeto`
- `participante`
- `participante_projeto`

### Schema de cada projeto

- `status`
- `prioridade`
- `categoria`
- `checkpoint`
- `tarefa`
- `label`
- `tarefa_label`
- `comentario`
- `dependencia_tarefa`
- `embedding_tarefa`

## 4.2 Regras a definir no modelo final

- unicidade do nome ou identificador de projetos;
- unicidade de e-mail ou identificador global de participantes;
- unicidade da associação entre participante e projeto;
- valores permitidos para status e prioridade;
- obrigatoriedade de projeto e título na tarefa;
- comportamento ao excluir um projeto com tarefas;
- comportamento ao excluir participante responsável por tarefas;
- prevenção de uma tarefa depender dela mesma;
- prevenção de dependências duplicadas;
- obrigatoriedade ou não de data de conclusão.

O catálogo central deverá registrar o nome físico do schema de cada projeto.
O schema deverá ser criado e removido com confirmação explícita, e sua
identificação deverá ser validada antes da execução de SQL dinâmico.

O script DDL deverá ser produzido a partir deste modelo, evitando manter uma
versão diferente da estrutura efetivamente executada pela aplicação.
