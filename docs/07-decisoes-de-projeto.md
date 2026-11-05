# 7. Decisões de projeto

## 7.1 PostgreSQL

O PostgreSQL foi escolhido porque atende diretamente ao requisito da
disciplina e oferece suporte a chaves estrangeiras, restrições, agregações e
transações necessárias ao sistema.

## 7.2 Arquitetura multi-tenant

O sistema adotará o padrão **schema-per-project**, em que cada projeto é um
tenant isolado. O schema `public` funcionará como catálogo central, registrando
os projetos existentes e o schema correspondente a cada um. Cada schema de
projeto conterá uma cópia completa das tabelas e dos dados da aplicação,
exceto o catálogo central, que permanece no schema `public`.

Essa abordagem foi escolhida porque os projetos não terão relação entre si.
Ela permite separar fisicamente os dados por projeto e configurar o contexto da
aplicação com o `search_path` do PostgreSQL. A pasta de trabalho do projeto
servirá como ponto de descoberta do contexto, por meio de um marcador local
que referencia o projeto ou seu schema.

As identidades dos participantes ficarão no catálogo global e poderão ser
associadas a vários projetos por meio de uma tabela de relacionamento. Os
dados operacionais, como tarefas, comentários e labels, permanecerão
isolados no schema do projeto. Assim, o mesmo participante pode acessar vários
projetos sem misturar os dados operacionais entre eles.

Para efeitos de demonstração, a criação e a carga podem ser executadas em um
único schema de projeto. A remoção pode apagar os dados e tabelas desse schema
ou, quando solicitado, excluir o schema completo e o respectivo registro do
catálogo.

Nomes de schema serão validados antes de qualquer SQL dinâmico e serão tratados
como identificadores, não como valores de consulta. O sistema não deverá
montar comandos de criação ou remoção por concatenação insegura.

## 7.3 Inicialização pelo comando principal

O ponto de entrada será o comando `workflowcli`, executado dentro da pasta de
um projeto. A pasta funcionará como contexto local da aplicação, de forma
semelhante ao modo como o Git identifica um repositório a partir de uma pasta
`.git`.

Na primeira execução, um fluxo guiado solicitará as informações iniciais,
como nome do projeto, identificador do schema, participante inicial e
parâmetros de conexão com o PostgreSQL quando ainda não estiverem
configurados. Em seguida, a aplicação criará o registro no catálogo `public`,
associará o participante ao projeto, provisionará o schema e aplicará as
tabelas operacionais. Por fim, gravará um marcador local com a referência do
projeto e do schema.

Nas execuções posteriores, o marcador será localizado na pasta atual ou em um
diretório pai. A aplicação abrirá diretamente a TUI no contexto correto,
configurando o `search_path` para o schema do projeto. O marcador não será
usado para armazenar senhas, tokens ou outras credenciais.

Um marcador ausente, inválido ou incompatível deverá produzir uma mensagem
explícita e oferecer uma nova inicialização, nunca selecionar silenciosamente
outro projeto.

O comando `workflowcli projects` exibirá os projetos associados ao participante
atual. O comando `workflowcli open <projeto>` permitirá abrir um projeto
autorizado diretamente, enquanto a TUI poderá oferecer a mesma seleção após a
abertura do contexto local.

## 7.4 Aplicação em Python

Python permite desenvolver a aplicação de terminal e integrar o banco, o
executável `git` e o GitHub CLI com uma quantidade controlada de código.

## 7.5 Interface de terminal

A interface TUI será implementada em Python utilizando a biblioteca Textual.
Essa biblioteca fornece componentes, layouts, navegação por teclado e
atualização da tela necessários para organizar as telas de projetos, tarefas,
consultas e integrações externas.

A aplicação terá menus e navegação por teclado. O objetivo é permitir
demonstrar todas as operações de CRUD e as consultas sem exigir uma aplicação
web ou gráfica.

## 7.6 Integração com o GitHub

O GitHub será uma integração externa opcional. O sistema próprio continuará
responsável por projetos, participantes e tarefas, enquanto a API do GitHub
será usada para operações como criação de issues, comentários, labels e pull
requests.

O GitHub CLI será responsável pelo login. A aplicação verificará o estado com
`gh auth status` e usará o contexto autenticado para realizar chamadas à API.
O token não será gravado pelo sistema.

Para criar um pull request, as branches de origem e destino precisam existir
no repositório remoto. A API cria o pull request, mas não substitui operações
locais como editar arquivos, criar commits ou enviar uma branch com `push`.

## 7.7 Dependência de internet

O PostgreSQL será executado localmente, preferencialmente com instalação local
ou Docker. Portanto, o núcleo de CRUD e consultas poderá funcionar sem
internet.

A internet será necessária para operações no GitHub, autenticação online,
`push`, `pull` e outras operações que dependam de um repositório remoto.
Falhas nessas operações devem ser apresentadas ao usuário sem comprometer os
dados já salvos localmente.

## 7.8 Escolha de embeddings

Embeddings foram escolhidos como o recurso de inteligência artificial desta
versão. Eles são mais adequados ao domínio porque permitem comparar o
significado de títulos e descrições, identificando tarefas relacionadas mesmo
quando utilizam palavras diferentes.

Ao criar uma tarefa, a aplicação poderá gerar seu embedding e compará-lo com
os embeddings das tarefas existentes. O resultado será uma lista de possíveis
duplicatas ou tarefas semelhantes, apresentada como sugestão para o usuário.
A aplicação não fará alterações automáticas com base nessa sugestão.

Essa escolha também possui impacto acadêmico relevante: integra aplicação,
banco de dados e inteligência artificial em uma funcionalidade diretamente
relacionada ao problema do sistema. Em comparação com um LLM usado apenas
para gerar textos, a busca semântica demonstra uma aplicação mais específica
e mensurável de IA.

Na primeira implementação, os embeddings serão gerados somente para tarefas
locais. Eles poderão ser armazenados junto à tarefa e a busca poderá ser feita
com suporte vetorial do PostgreSQL ou pela aplicação, conforme a infraestrutura
disponível. O uso de um serviço externo para gerar os vetores deverá ser
isolado em um módulo próprio, para não misturar essa dependência com o CRUD.

## 7.9 Recursos adiados

LLMs, geração automática de textos, classificação automática, sincronização
avançada e merge automático foram deixados fora do escopo para manter o
projeto viável no prazo da disciplina.
