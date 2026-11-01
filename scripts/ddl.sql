CREATE SCHEMA projeto_a;
CREATE SCHEMA projeto_b;

CREATE TABLE public.Participante (
  id_participante INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  nome_usuario VARCHAR(50) NOT NULL UNIQUE,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.Projeto (
  id_projeto INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(150),
  nome_schema VARCHAR(100) NOT NULL UNIQUE,
  descricao TEXT,
  caminho_raiz TEXT NOT NULL,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE public.ParticipanteProjeto (
  id_participante REFERENCES public.Participante,
  id_projeto REFERENCES public.Projeto,
  papel VARCHAR(50),
  associado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
  PRIMARY KEY (id_participante, id_projeto)
)