CREATE TABLE IF NOT EXISTS public.participante (
  id_participante INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome            VARCHAR(100) NOT NULL,
  email           VARCHAR(100) NOT NULL UNIQUE,
  nome_usuario    VARCHAR(50) NOT NULL UNIQUE,
  criado_em       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.projeto (
  id_projeto    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome          VARCHAR(150) NOT NULL,
  nome_schema   VARCHAR(63) NOT NULL UNIQUE,
  descricao     TEXT,
  caminho_raiz  TEXT NOT NULL UNIQUE,
  criado_em     TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ativo         BOOLEAN NOT NULL DEFAULT TRUE,

  CONSTRAINT projeto_nome_schema_valido
      CHECK (nome_schema ~ '^[a-z][a-z0-9_]{0,62}$')
);

CREATE TABLE IF NOT EXISTS public.participante_projeto (
  id_participante INTEGER NOT NULL,
  id_projeto      INTEGER NOT NULL,
  papel           VARCHAR(50) NOT NULL DEFAULT 'desenvolvedor',
  associado_em    TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (id_participante, id_projeto),

  CONSTRAINT participante_projeto_participante_fk
    FOREIGN KEY (id_participante)
    REFERENCES public.participante (id_participante)
    ON DELETE RESTRICT,

  CONSTRAINT participante_projeto_projeto_fk
    FOREIGN KEY (id_projeto)
    REFERENCES public.projeto (id_projeto)
    ON DELETE RESTRICT
);

CREATE OR REPLACE FUNCTION public.criar_schema_projeto(
  p_nome_schema TEXT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  IF p_nome_schema IS NULL
      OR p_nome_schema !~ '^[a-z][a-z0-9_]{0,62}$' THEN
      RAISE EXCEPTION
          'Nome de schema inválido: %. Use letras minúsculas, números e underscore.',
          p_nome_schema;
  END IF;

  IF p_nome_schema IN ('public', 'information_schema')
      OR p_nome_schema LIKE 'pg_%' THEN
      RAISE EXCEPTION
          'O schema % não pode ser utilizado como schema de projeto.',
          p_nome_schema;
  END IF;

  EXECUTE format('CREATE SCHEMA IF NOT EXISTS %I', p_nome_schema);

  EXECUTE format($sql$
      CREATE TABLE IF NOT EXISTS %I.status (
          id_status   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          nome        VARCHAR(50) NOT NULL UNIQUE,
          descricao   TEXT
      )
  $sql$, p_nome_schema);

  EXECUTE format($sql$
      CREATE TABLE IF NOT EXISTS %I.prioridade (
          id_prioridade INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          nome          VARCHAR(50) NOT NULL UNIQUE,
          nivel         INTEGER NOT NULL UNIQUE,
          CONSTRAINT prioridade_nivel_positivo CHECK (nivel > 0)
      )
  $sql$, p_nome_schema);

  EXECUTE format($sql$
      CREATE TABLE IF NOT EXISTS %I.categoria (
          id_categoria INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          nome         VARCHAR(100) NOT NULL UNIQUE,
          descricao    TEXT
      )
  $sql$, p_nome_schema);

  EXECUTE format($sql$
      CREATE TABLE IF NOT EXISTS %I.checkpoint (
          id_checkpoint    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          nome        VARCHAR(150) NOT NULL,
          descricao   TEXT,
          data_inicio DATE,
          data_fim    DATE,

          CONSTRAINT checkpoint_datas_validas
              CHECK (
                  data_fim IS NULL
                  OR data_inicio IS NULL
                  OR data_fim >= data_inicio
              )
      )
  $sql$, p_nome_schema);

  EXECUTE format($sql$
      CREATE TABLE IF NOT EXISTS %I.label (
          id_label INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          nome        VARCHAR(100) NOT NULL UNIQUE,
          cor         VARCHAR(20)
      )
  $sql$, p_nome_schema);

  EXECUTE format($sql$
      CREATE TABLE IF NOT EXISTS %I.tarefa (
          id_tarefa       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          titulo          VARCHAR(200) NOT NULL,
          descricao       TEXT,
          criada_em       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
          prazo           DATE,
          concluida_em    TIMESTAMPTZ,

          id_status       INTEGER NOT NULL,
          id_prioridade   INTEGER NOT NULL,
          id_categoria    INTEGER,
          id_checkpoint        INTEGER,
          id_responsavel  INTEGER,

          CONSTRAINT tarefa_status_fk
              FOREIGN KEY (id_status)
              REFERENCES %I.status (id_status)
              ON DELETE RESTRICT,

          CONSTRAINT tarefa_prioridade_fk
              FOREIGN KEY (id_prioridade)
              REFERENCES %I.prioridade (id_prioridade)
              ON DELETE RESTRICT,

          CONSTRAINT tarefa_categoria_fk
              FOREIGN KEY (id_categoria)
              REFERENCES %I.categoria (id_categoria)
              ON DELETE SET NULL,

          CONSTRAINT tarefa_checkpoint_fk
              FOREIGN KEY (id_checkpoint)
              REFERENCES %I.checkpoint (id_checkpoint)
              ON DELETE SET NULL,

          CONSTRAINT tarefa_responsavel_fk
              FOREIGN KEY (id_responsavel)
              REFERENCES public.participante (id_participante)
              ON DELETE SET NULL,

          CONSTRAINT tarefa_titulo_nao_vazio
              CHECK (length(trim(titulo)) > 0),

          CONSTRAINT tarefa_conclusao_coerente
              CHECK (
                  concluida_em IS NULL
                  OR id_status IS NOT NULL
              )
      )
  $sql$, p_nome_schema, p_nome_schema, p_nome_schema,
        p_nome_schema, p_nome_schema, p_nome_schema);

  EXECUTE format($sql$
      CREATE TABLE IF NOT EXISTS %I.embedding_tarefa (
          id_embedding INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          id_tarefa   INTEGER NOT NULL UNIQUE,
          vetor       DOUBLE PRECISION[] NOT NULL,
          modelo      VARCHAR(100) NOT NULL,
          gerado_em   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

          CONSTRAINT embedding_tarefa_tarefa_fk
              FOREIGN KEY (id_tarefa)
              REFERENCES %I.tarefa (id_tarefa)
              ON DELETE CASCADE
      )
  $sql$, p_nome_schema, p_nome_schema);

  EXECUTE format($sql$
      CREATE TABLE IF NOT EXISTS %I.comentario (
          id_comentario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          id_tarefa     INTEGER NOT NULL,
          id_autor      INTEGER NOT NULL,
          texto         TEXT NOT NULL,
          criado_em     TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

          CONSTRAINT comentario_tarefa_fk
              FOREIGN KEY (id_tarefa)
              REFERENCES %I.tarefa (id_tarefa)
              ON DELETE CASCADE,

          CONSTRAINT comentario_autor_fk
              FOREIGN KEY (id_autor)
              REFERENCES public.participante (id_participante)
              ON DELETE RESTRICT,

          CONSTRAINT comentario_texto_nao_vazio
              CHECK (length(trim(texto)) > 0)
      )
  $sql$, p_nome_schema, p_nome_schema);

  EXECUTE format($sql$
      CREATE TABLE IF NOT EXISTS %I.tarefa_label (
          id_tarefa   INTEGER NOT NULL,
          id_label INTEGER NOT NULL,
          associada_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

          PRIMARY KEY (id_tarefa, id_label),

          CONSTRAINT tarefa_label_tarefa_fk
              FOREIGN KEY (id_tarefa)
              REFERENCES %I.tarefa (id_tarefa)
              ON DELETE CASCADE,

          CONSTRAINT tarefa_label_label_fk
              FOREIGN KEY (id_label)
              REFERENCES %I.label (id_label)
              ON DELETE CASCADE
      )
  $sql$, p_nome_schema, p_nome_schema, p_nome_schema);

  EXECUTE format($sql$
      CREATE TABLE IF NOT EXISTS %I.dependencia_tarefa (
          id_tarefa_bloqueadora INTEGER NOT NULL,
          id_tarefa_bloqueada   INTEGER NOT NULL,
          criada_em             TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

          PRIMARY KEY (
              id_tarefa_bloqueadora,
              id_tarefa_bloqueada
          ),

          CONSTRAINT dependencia_bloqueadora_fk
              FOREIGN KEY (id_tarefa_bloqueadora)
              REFERENCES %I.tarefa (id_tarefa)
              ON DELETE CASCADE,

          CONSTRAINT dependencia_bloqueada_fk
              FOREIGN KEY (id_tarefa_bloqueada)
              REFERENCES %I.tarefa (id_tarefa)
              ON DELETE CASCADE,

          CONSTRAINT dependencia_nao_circular_direta
              CHECK (
                  id_tarefa_bloqueadora <> id_tarefa_bloqueada
              )
      )
  $sql$, p_nome_schema, p_nome_schema, p_nome_schema);

  RAISE NOTICE 'Schema de projeto criado: %', p_nome_schema;
END;
$$;