# workflowCLI

Sistema multi-tenant de gerenciamento de projetos e tarefas executado no
terminal com uma interface TUI desenvolvida usando a biblioteca Textual, com
integração opcional com repositórios Git locais e com a API do GitHub.

## Escopo

O núcleo do sistema gerencia participantes, projetos e tarefas em um banco
PostgreSQL. Cada projeto possui um schema próprio com uma cópia completa do
modelo da aplicação, mantendo seus dados isolados dos demais projetos. A
aplicação deverá oferecer operações de cadastro, consulta, alteração e
exclusão, além das consultas agregadas exigidas pelo trabalho.

## Uso esperado

Dentro da pasta de um projeto, o usuário executará:

```text
workflowcli
```

Na primeira execução naquele diretório, a aplicação deverá iniciar um
assistente de configuração para solicitar as informações necessárias, criar o
registro do projeto no catálogo central, gerar seu schema PostgreSQL, criar as
tabelas e gravar um marcador local que identifique o contexto. Nas execuções
seguintes, o marcador será localizado e a aplicação abrirá diretamente no
schema correspondente.

Como integração complementar, a aplicação poderá consultar e alterar issues,
pull requests, comentários e labels do GitHub. Essa integração utilizará o
GitHub CLI (`gh`) para autenticação e comunicação com a API. Operações sobre
branches e commits locais poderão ser realizadas por meio do executável `git`.

O sistema também utilizará embeddings para sugerir tarefas semelhantes ou
possíveis duplicatas. LLMs e outras automações inteligentes estão fora do
escopo desta versão.

## Documentação

- [Objetivo e escopo](docs/01-objetivo-e-escopo.md)
- [Requisitos](docs/02-requisitos.md)
- [Modelo conceitual](docs/03-modelo-conceitual.md)
- [Modelo lógico](docs/04-modelo-logico.md)
- [Consultas](docs/06-consultas.md)
- [Decisões de projeto](docs/07-decisoes-de-projeto.md)
- [Roteiro de implementação](docs/08-roteiro-de-implementacao.md)

Os documentos oficiais do trabalho da disciplina estão em
`docs/DEC7129-Trabalho-Final.pdf`.
