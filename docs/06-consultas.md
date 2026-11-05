# 6. Consultas e visualizações

As consultas devem envolver pelo menos três tabelas, projetar pelo menos duas
colunas e utilizar uma função de agregação. Os resultados deverão ser
apresentados em formato tabular e em gráfico.

## Consulta 1 — Tarefas concluídas por participante

**Objetivo:** calcular a quantidade média de tarefas concluídas por
participante no projeto atual durante o último mês.

**Tabelas previstas:** `tarefa`, `participante` e `status`, no schema do
projeto atual.

**Agregação:** `COUNT` e/ou `AVG`.

## Consulta 2 — Distribuição de tarefas por status

**Objetivo:** mostrar quantas tarefas existem em cada status, agrupadas por
prioridade no schema do projeto atual.

**Tabelas previstas:** `tarefa`, `status`, `prioridade` e `label`.

**Agregação:** `COUNT`.

## Consulta 3 — Carga de trabalho por projeto

**Objetivo:** comparar a quantidade de tarefas por responsável e prioridade no
schema do projeto atual.

**Tabelas previstas:** `tarefa`, `participante` e `prioridade`, considerando o
catálogo global de participantes.

**Agregação:** `COUNT`.

As consultas SQL definitivas, amostras de resultados e gráficos serão
adicionados após a estabilização do modelo lógico e a carga de dados de teste.
