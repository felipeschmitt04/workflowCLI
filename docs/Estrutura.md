# workflowCLI — Estrutura do Projeto

### Trabalho Final — Banco de Dados I (DEC7129)

> Este documento é um **rascunho de ponto de partida** para discutirmos juntos — principalmente a modelagem conceitual (item 3, vale 3,0 dos 10 pontos), que é melhor a gente fechar em conjunto do que já chegar pronta.

---

## 1. Visão geral

Sistema de gestão de projetos e tarefas que combina duas camadas:

- Uma camada de **gestão de trabalho** (projetos, tarefas/TODOs, prioridades, prazos, membros de equipe)
- Uma camada **estilo GitHub** (repositórios, commits, issues, pull requests) alimentada com dados reais via API pública do GitHub

A aplicação é uma **TUI (terminal UI) interativa**, inspirada no `lazygit` — painéis, navegação por teclado, preview ao vivo dos registros — só que aplicada ao domínio de gestão de projeto + dados de repositório, com um módulo de IA generativa para triagem/apoio à decisão.

## 2. Funcionalidades da aplicação (TUI)

- **Layout em painéis**, tipo lazygit: lista de entidades à esquerda (projetos, tarefas, repos...), detalhe/preview à direita, barra de status embaixo
- **Navegação 100% por teclado** (setas ou hjkl), com atalhos visíveis na tela — sem reimplementar edição de texto/buffers
- **CRUD completo** por tabela, respeitando dependências entre elas (ex.: não deixar apagar um projeto que ainda tem tarefas)
- **Painel de consultas**: roda as 3 consultas do item 6 sob demanda, mostra resultado em tabela E em gráfico (ASCII no terminal ou export de imagem, a decidir)
- **Setup/reset**: opção de criar todas as tabelas do zero + carregar dados (parte via API do GitHub, parte fictícia) e opção de dropar tudo
- **Painel de IA generativa**: separado no menu, com as features do item 5 abaixo

## 3. Domínio e escopo

**Dentro do escopo:**

- Gestão de projetos e tarefas (TODOs) com prioridade, status, prazo, responsável
- Vínculo opcional entre uma tarefa e uma issue/PR real de um repositório
- Ingestão de dados reais de repositórios via API do GitHub (commits, issues, PRs, contribuidores)

**Fora do escopo (importante não deixar isso crescer de novo):**

- Nenhuma reimplementação de editor de texto (sem buffers, sem modos de edição)
- Nenhuma manipulação real de git pela aplicação (sem commit/branch/merge feitos pelo sistema) — git entra só como fonte de leitura via API
- **Nota de cuidado:** se formos usar tarefas "inspiradas" no nosso workflow do VISIA como dado de exemplo, melhor usar dados fictícios (nomes/descrições inventados) em vez de tarefas reais do laboratório, já que o repositório do trabalho pode ir pro GitHub público.

## 4. Entidades candidatas (rascunho — não é a modelagem final)

**Camada de gestão:**

- Usuário/Membro
- Projeto
- Tarefa/TODO (status, prioridade, prazo)
- Equipe (se quisermos separar de Projeto)

**Camada estilo GitHub:**

- Repositório
- Linguagem
- Commit
- Pull Request
- Issue
- Review
- Comentário
- Label/Tag
- Dependência (pacote/lib)

**Relações que já dá pra prever que vão gerar discussão de cardinalidade:**

- Tarefa ↔ Issue (uma tarefa pode ou não estar linkada a uma issue do GitHub)
- Tarefa ↔ Tarefa (autorrelacionamento — tarefa bloqueada por outra)
- Repositório ↔ Linguagem (M:N)
- Desenvolvedor ↔ Repositório (M:N, via commits/PRs)
- Issue ↔ Label (M:N)

_(Atributos, chaves primárias/estrangeiras e cardinalidades exatas ficam para a gente definir juntos — é o próximo passo.)_

## 5. Exemplos de consulta (rascunho, item 6)

1. Número médio de tarefas concluídas por membro, por projeto, no último mês (AVG/COUNT cruzando Tarefa + Usuário + Projeto)
2. Tempo médio de resolução de issue, agrupado por linguagem do repositório (AVG cruzando Issue + Repositório + Linguagem)
3. Distribuição de tarefas por status, separando projetos com repositório vinculado dos que não têm (mistura as duas camadas)

## 6. Onde entra a IA generativa (item 7f)

- Resumir automaticamente uma issue longa ou thread de comentários via LLM
- Gerar embeddings de título/descrição de issues para sugerir "issues parecidas/possível duplicata"
- Sugerir prioridade/label de uma tarefa nova a partir da descrição (LLM)

## 7. Próximos passos

- [ ] Fechar nome do sistema
- [ ] Definir juntos atributos, PKs/FKs e cardinalidades de cada entidade (item 3)
- [ ] Escolher stack (linguagem + lib de TUI, ex. `textual`/Python, `ratatui`/Rust, `bubbletea`/Go)
- [ ] Decidir formato do gráfico no terminal (ASCII vs. export de imagem)
- [ ] Escrever o texto de até 10 linhas para o Moodle — **prazo 20/09**