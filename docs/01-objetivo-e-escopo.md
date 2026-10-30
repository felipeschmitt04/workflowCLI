# 1. Objetivo geral e escopo

## 1.1 Objetivo geral

O workflowCLI é um sistema de gerenciamento de projetos e tarefas voltado
para pequenas equipes de desenvolvimento, como grupos de estudantes e
pesquisadores. O sistema centraliza informações sobre participantes, projetos,
tarefas, prioridades, prazos e dependências em um banco de dados PostgreSQL.
Os participantes são identidades globais e podem ter acesso a vários projetos.
Cada projeto possui seu próprio schema para os dados operacionais, mantendo
esses dados isolados dos demais projetos.
Sua interface TUI, desenvolvida com a biblioteca Textual e executada no
terminal, permite consultar e manipular os dados de forma objetiva, sem
depender de uma aplicação gráfica. Como recurso complementar, o sistema pode
integrar-se a repositórios Git locais e à API do GitHub para acompanhar
commits, issues e pull requests. O objetivo é oferecer uma visão unificada do
planejamento do trabalho e da atividade de desenvolvimento, mantendo o
gerenciamento principal sob controle da aplicação.

## 1.2 Escopo principal

Fazem parte do núcleo do sistema:

- cadastro e manutenção de participantes;
- cadastro e manutenção de projetos;
- associação de participantes a projetos;
- cadastro e manutenção de tarefas;
- controle de status, prioridade, prazo e responsável;
- etiquetas, comentários e dependências entre tarefas;
- consultas agregadas sobre projetos e tarefas;
- criação, carga inicial e remoção das tabelas do banco;
- sugestão de tarefas semelhantes por meio de embeddings.

## 1.3 Arquitetura multi-tenant e identidade global

O banco PostgreSQL utilizará a abordagem **schema-per-project**. Um catálogo
central no schema `public` manterá os projetos, os participantes globais e as
associações de acesso entre participantes e projetos. Para cada projeto
cadastrado, a aplicação criará um schema exclusivo contendo as tabelas e os
dados operacionais daquele projeto.

Ao ser executada dentro da pasta de um projeto, a aplicação identificará o
schema correspondente e configurará o `search_path` da conexão para operar
somente naquele contexto. Projetos diferentes não compartilharão tarefas ou
demais registros operacionais. A identidade do participante, entretanto, será
mantida no catálogo global e poderá ser associada a vários projetos.

Para a demonstração da disciplina, a opção de criar e carregar o banco poderá
atuar sobre um único schema de projeto, e a opção de remoção poderá excluir
todos os dados e tabelas desse schema. Também deverá existir uma operação de
remoção do schema completo, com confirmação explícita, quando o objetivo for
eliminar o projeto inteiro.

## 1.4 Integrações opcionais

A aplicação poderá oferecer integrações que não impedem o funcionamento do
núcleo:

- **GitHub:** listar, criar, editar e fechar issues; adicionar comentários e
  labels; consultar e criar pull requests; consultar branches e commits.
- **Git local:** identificar o repositório atual e exibir branches, histórico
  de commits e status por meio do executável `git`.

O GitHub CLI (`gh`) será utilizado para autenticar o usuário e realizar as
chamadas à API. A aplicação não armazenará tokens no banco nem em arquivos do
projeto.

## 1.5 Comandos e fluxo de inicialização

O comando principal da aplicação será `workflowcli`. Os comandos previstos
serão:

- `workflowcli init`: cria um novo projeto na pasta atual;
- `workflowcli` ou `workflowcli .`: abre o projeto associado à pasta atual;
- `workflowcli projects`: lista os projetos aos quais o participante atual tem
  acesso;
- `workflowcli open <projeto>`: permite selecionar e abrir diretamente outro
  projeto autorizado.

Na execução de `workflowcli init`, a aplicação deverá:

1. solicitar as informações iniciais do projeto;
2. validar o nome e o identificador que serão usados;
3. registrar o projeto no catálogo central do schema `public`;
4. associar o participante inicial ao projeto;
5. criar o schema exclusivo do projeto;
6. criar as tabelas operacionais nesse schema;
7. carregar os dados iniciais, quando aplicável;
8. gravar um marcador local com a referência do projeto e do schema.

Nas execuções seguintes, a aplicação deverá localizar o marcador na pasta
atual ou em um diretório pai, abrir a conexão com o schema indicado e iniciar
diretamente a interface TUI. A tela inicial poderá apresentar os projetos
autorizados do participante para permitir a troca de contexto. O marcador não
deverá armazenar credenciais do banco ou tokens do GitHub.

Se o marcador estiver ausente, inválido ou apontar para um schema inexistente,
a aplicação deverá informar o problema e oferecer uma nova inicialização, sem
selecionar silenciosamente outro projeto.

## 1.6 Inteligência artificial

O sistema utilizará embeddings gerados a partir do título e da descrição das
tarefas. Ao cadastrar uma nova tarefa, a aplicação poderá compará-la com as
tarefas existentes e sugerir possíveis duplicatas ou tarefas relacionadas.
Essa funcionalidade servirá como apoio à organização do projeto, sem alterar
automaticamente os dados.

## 1.7 Fora do escopo

Não fazem parte desta versão:

- recriar o GitHub ou hospedar repositórios;
- implementar um servidor Git;
- merge automático e resolução de conflitos;
- gerenciamento avançado de permissões do GitHub;
- LLMs, geração automática de textos e classificação automática;
- criação de um editor de código ou de texto;
- operações destrutivas sem confirmação explícita.
