# 3. Modelo conceitual

O modelo conceitual será representado pela notação Chen. Ele será dividido
conceitualmente em duas áreas:

- **catálogo global:** entidades mantidas no schema `public`, compartilhadas
  entre os projetos;
- **dados do projeto:** entidades replicadas no schema de cada projeto, sem
  relacionamento direto com os dados operacionais de outro projeto.

O schema PostgreSQL não precisa aparecer como entidade no diagrama. Ele é a
decisão física que implementa o isolamento do relacionamento entre `Projeto`
e suas entidades operacionais.

## 3.1 Entidades do catálogo global

### Participante

Representa uma pessoa que utiliza o sistema.

**Atributos sugeridos:**

- `id_participante` — identificador único;
- `nome`;
- `email`;
- `nome_usuario` — identificador utilizado na aplicação;
- `criado_em`.

### Projeto

Representa um projeto cadastrado e o schema que armazena seus dados
operacionais.

**Atributos sugeridos:**

- `id_projeto` — identificador único;
- `nome`;
- `descricao`;
- `nome_schema` — nome físico do schema PostgreSQL;
- `caminho_raiz` — pasta associada ao projeto;
- `criado_em`;
- `ativo`.

### ParticipanteProjeto

Representa a associação entre uma identidade global e um projeto. No diagrama
Chen, pode ser apresentada como um relacionamento com atributos ou como uma
entidade associativa, conforme a ferramenta utilizada.

**Atributos sugeridos:**

- `id_participante`;
- `id_projeto`;
- `papel` — por exemplo, gestor ou desenvolvedor;
- `associado_em`.

## 3.2 Entidades de cada schema de projeto

As entidades desta seção existem dentro do schema do projeto atualmente
selecionado.

### Tarefa

Representa uma atividade executável do projeto.

**Atributos sugeridos:**

- `id_tarefa`;
- `titulo`;
- `descricao`;
- `criada_em`;
- `prazo`;
- `concluida_em`;
- `id_responsavel`.

### Status

Representa a situação possível de uma tarefa, como pendente, em andamento ou
concluída.

**Atributos sugeridos:**

- `id_status`;
- `nome`;
- `descricao`.

### Prioridade

Representa o nível de urgência ou importância de uma tarefa.

**Atributos sugeridos:**

- `id_prioridade`;
- `nome`;
- `nivel`;

### Categoria

Representa uma classificação funcional das tarefas do projeto.

**Atributos sugeridos:**

- `id_categoria`;
- `nome`;
- `descricao`.

### Checkpoint

Representa uma etapa ou objetivo importante do projeto.

**Atributos sugeridos:**

- `id_checkpoint`;
- `nome`;
- `descricao`;
- `data_inicio`;
- `data_fim`;

### Label

Representa uma classificação reutilizável, como `bug`, `documentacao` ou
`urgente`.

**Atributos sugeridos:**

- `id_label`;
- `nome`;
- `cor`;

### Comentario

Representa uma observação feita sobre uma tarefa.

**Atributos sugeridos:**

- `id_comentario`;
- `texto`;
- `criado_em`;
- `id_autor`.

### EmbeddingTarefa

Representa a representação vetorial gerada a partir do título e da descrição
de uma tarefa. Essa entidade existe para apoiar a busca de tarefas
semanticamente semelhantes.

**Atributos sugeridos:**

- `id_embedding`;
- `vetor`;
- `modelo`;
- `gerado_em`.

### DependenciaTarefa

Representa a relação de bloqueio entre duas tarefas. É uma entidade associativa
ou relacionamento recursivo, pois liga a entidade `Tarefa` a ela mesma.

**Atributos sugeridos:**

- `id_tarefa_bloqueadora`;
- `id_tarefa_bloqueada`;
- `criada_em`.

### TarefaLabel

Representa a associação entre tarefas e labels. É uma entidade associativa
necessária porque a relação é muitos-para-muitos.

**Atributos sugeridos:**

- `id_tarefa`;
- `id_label`;
- `associada_em`.

## 3.3 Relacionamentos e cardinalidades

As cardinalidades abaixo são as recomendadas para o diagrama Chen:

| Relacionamento | Cardinalidade | Interpretação |
|---|---|---|
| `Participante` — **possui acesso a** — `Projeto` | Participante `(0,N)`; Projeto `(1,N)` | Um participante pode acessar vários projetos. Um projeto deve possuir pelo menos um participante inicial. |
| `Projeto` — **contém** — `Tarefa` | Projeto `(0,N)`; Tarefa `(1,1)` | Um projeto pode começar sem tarefas; toda tarefa pertence a um único projeto. |
| `Participante` — **é responsável por** — `Tarefa` | Participante `(0,N)`; Tarefa `(0,1)` | Um participante pode ter várias tarefas; uma tarefa pode ainda não ter responsável. |
| `Status` — **classifica** — `Tarefa` | Status `(0,N)`; Tarefa `(1,1)` | Cada tarefa possui exatamente um status. |
| `Prioridade` — **define** — `Tarefa` | Prioridade `(0,N)`; Tarefa `(1,1)` | Cada tarefa possui exatamente uma prioridade. |
| `Categoria` — **organiza** — `Tarefa` | Categoria `(0,N)`; Tarefa `(0,1)` | Uma tarefa pode não ter categoria ou possuir uma categoria. |
| `Checkpoint` — **agrupa** — `Tarefa` | Checkpoint `(0,N)`; Tarefa `(0,1)` | Uma tarefa pode estar associada opcionalmente a um checkpoint. |
| `Tarefa` — **recebe** — `Comentario` | Tarefa `(0,N)`; Comentario `(1,1)` | Uma tarefa pode ter vários comentários; cada comentário pertence a uma tarefa. |
| `Participante` — **escreve** — `Comentario` | Participante `(0,N)`; Comentario `(1,1)` | Um participante pode escrever vários comentários; cada comentário possui um autor. |
| `Tarefa` — **possui** — `Label` | Tarefa `(0,N)`; Label `(0,N)` | Uma tarefa pode ter vários labels e um label pode classificar várias tarefas. |
| `Tarefa` — **possui embedding** — `EmbeddingTarefa` | Tarefa `(0,1)`; EmbeddingTarefa `(1,1)` | Uma tarefa pode ainda não ter embedding; cada embedding pertence a uma tarefa. |
| `Tarefa` — **bloqueia** — `Tarefa` | Tarefa bloqueadora `(0,N)`; Tarefa bloqueada `(0,N)` | Uma tarefa pode bloquear várias outras e também depender de várias tarefas. |

## 3.4 Observações para o diagrama Chen

- `ParticipanteProjeto`, `TarefaLabel` e `DependenciaTarefa` podem ser
  desenhadas como entidades associativas ou representadas diretamente como
  relacionamentos com atributos.
- `DependenciaTarefa` deve ser desenhada como um relacionamento recursivo
  entre duas ocorrências de `Tarefa`, com os papéis **bloqueadora** e
  **bloqueada**.
- `EmbeddingTarefa` pode ser desenhada como entidade dependente de `Tarefa`.
  No modelo lógico, sua chave pode ser o próprio `id_tarefa`, caso exista no
  máximo um embedding ativo por tarefa.
- `Participante` é global, mas tarefas e comentários pertencem ao schema do
  projeto atual. A implementação deverá garantir que o responsável e o autor
  tenham associação com o projeto antes de permitir a operação.
- As entidades de GitHub e Git local não são obrigatórias no modelo
  conceitual principal. Elas podem ser adicionadas posteriormente como
  entidades de integração, caso sejam persistidas no banco.
