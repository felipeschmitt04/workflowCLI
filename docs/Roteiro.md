# Roteiro: Backend multi-schema do workflowCLI (PostgreSQL)

> Este roteiro cobre só a parte de dados/backend (schema-per-project). TUI, packaging e a camada "GitHub" ficam pra depois — construa primeiro contra dados de teste simples.

---

## Pré-requisitos rápidos

- PostgreSQL instalado local (ou via Docker) — se nunca configurou, é um bom primeiro exercício isolado
- Ambiente virtual Python + `psycopg` (versão 3): `pip install "psycopg[binary]"`
- Um cliente pra inspecionar o banco manualmente: `psql` no terminal, ou uma GUI tipo DBeaver/TablePlus — você vai querer _ver_ o que está acontecendo, não confiar só no que o Python imprime

---

## Fase 1 — Fundamentos de schema, na unha (sem Python ainda)

**Estudar:** diferença entre `schema` e `database` no Postgres; comandos `CREATE SCHEMA`, `DROP SCHEMA ... CASCADE`; o parâmetro `search_path`; a view `information_schema.schemata` (lista os schemas existentes).

**Exercício antes de codar:** abra o `psql` e, manualmente:

1. Crie dois schemas de teste (`projeto_a`, `projeto_b`)
2. Crie a mesma tabela simples nos dois (ex.: uma tabela `nota` com `id` e `texto`)
3. Rode `SET search_path TO projeto_a;` e insira uma linha
4. Troque pra `projeto_b` e confirme que a tabela de lá está vazia

Só avance pra Fase 2 quando esse comportamento fizer sentido intuitivo pra você — é a base de tudo que vem depois.

---

## Fase 2 — Desenhar o catálogo e o DDL "template"

**Implementar:**

- A tabela `projetos` (schema `public`): algo como `id`, `nome`, `nome_schema`, `criado_em`. É o único lugar que sabe quais projetos existem.
- O script DDL das suas ~14 tabelas do trabalho, escrito de um jeito que possa rodar **dentro de qualquer schema** sem alteração (ou seja, sem referências fixas a `public.` nas suas tabelas de domínio).

**Cuidado:** esse é o mesmo DDL que vai pro relatório (item 5) — não escreva duas versões diferentes, uma "de mentira" pro relatório e outra real no código. Gere o relatório a partir do que roda de verdade.

---

## Fase 3 — Conexão básica com psycopg

**Estudar:** objetos `connection` e `cursor` do psycopg; como rodar múltiplos comandos numa transação; `conn.autocommit` (`CREATE SCHEMA` normalmente pode rodar em transação, mas vale entender quando o autocommit é necessário, ex. `CREATE DATABASE` não pode).

**Implementar:** uma função central de conexão (ex. `get_connection()`), sem lógica de schema ainda — só prove que conecta e roda um `SELECT 1`.

---

## Fase 4 — `workflowcli init`, passo a passo lógico

Não é código ainda, é a sequência que a função vai seguir:

1. Receber/validar o nome do projeto (ver seção de segurança abaixo — **isso vem antes de tocar no banco**)
2. Inserir o registro na tabela `projetos` (catálogo)
3. `CREATE SCHEMA <nome_validado>`
4. Aplicar o DDL template dentro desse schema recém-criado
5. Gravar o marcador local na pasta (arquivo `.workflowcli.json` com `projeto_id` e `nome_schema`)

---

## Fase 5 — Marcador local e busca ascendente de diretório

**Estudar:** `pathlib.Path` e como subir diretórios pais até encontrar um arquivo — é o mesmo princípio que o `git` usa pra achar a pasta `.git` mesmo se você estiver em uma subpasta do projeto.

Esta fase é Python puro, sem SQL — bom pra isolar e testar sozinha antes de integrar com o resto.

---

## Fase 6 — Troca de contexto a cada execução

**Implementar:** ao abrir o app numa pasta com marcador: ler o arquivo → pegar `nome_schema` → abrir conexão → `SET search_path TO <schema>, public;` → só então seguir com CRUD normal. Daqui pra frente, o resto do seu código (CRUD, consultas do item 6) não precisa saber que existe multi-schema.

---

## Fase 7 — Cuidado de segurança: identificadores não são valores

Esse é o ponto que você perguntou especificamente, então vale destacar bem.

**O problema:** parâmetros bind (`%s` no psycopg) protegem contra SQL injection só quando o que está sendo inserido é um **valor** (`WHERE id = %s`). Nome de schema/tabela numa instrução `CREATE SCHEMA` ou `CREATE TABLE` é um **identificador**, não um valor — o driver não sabe escapar isso do mesmo jeito, porque sintaticamente não é a mesma coisa.

**Concretamente, o risco:** se o nome do projeto vem de uma entrada do usuário (ex. `workflowcli init "meu projeto"`) e você simplesmente concatena isso numa string SQL, alguém digitando algo como `teste; DROP SCHEMA public CASCADE;--` como nome do projeto pode literalmente apagar seu banco inteiro.

**Duas camadas de defesa (pesquise as duas):**

1. **Whitelist antes de qualquer SQL** — valide o nome com uma regex restritiva (ex.: só letras minúsculas, números e underscore, começando com letra) e rejeite qualquer coisa fora disso, _antes_ de montar qualquer query.
2. **`psycopg.sql.Identifier`** — pesquise o módulo `psycopg.sql` da biblioteca; ele existe exatamente pra montar SQL dinamicamente com identificadores de forma segura, em vez de f-string/concatenação crua.

**Teste que prova que funciona:** tente rodar `workflowcli init` com um nome de projeto malicioso (tipo o exemplo acima) e confirme que sua validação recusa **antes** de qualquer coisa chegar no banco. Vale documentar esse teste no relatório — é exatamente o tipo de cuidado que impressiona um professor forte em BD.

---

## Fase 8 — Provar o isolamento de verdade

Crie dois projetos de teste, insira dados diferentes em cada um, e confirme via `psql` (não só confiando no seu código Python) que `projeto_a.tarefa` e `projeto_b.tarefa` realmente não se misturam. Essa é a demonstração visual que vale a pena mostrar na apresentação.

---

## Recomendações gerais

- **Não construa contra multi-schema desde o dia 1.** Primeiro faça CRUD e as 3 consultas funcionarem contra um único schema fixo. Só depois generalize pra multi-schema — assim você separa "meu CRUD tá certo?" de "meu isolamento de schema tá certo?" quando algo quebrar.
- **Mantenha um registro informal das decisões** (por que schema-per-project, por que Postgres, o que você tentou e descartou). Isso vira ouro na hora de escrever a seção 2 do relatório e quando o professor perguntar "por que vocês fizeram assim" na apresentação.