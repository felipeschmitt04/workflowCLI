# 8. Roteiro de implementação

1. Validar o modelo conceitual e recriar o diagrama.
2. Definir o catálogo `public` e o schema exclusivo de cada projeto.
3. Derivar o modelo lógico com PKs, FKs e restrições.
4. Criar e testar o DDL do PostgreSQL para o catálogo e para o schema de
   projeto.
5. Implementar o comando `workflowcli` e a descoberta da pasta de trabalho.
6. Implementar o fluxo guiado de primeira execução e o marcador local.
7. Implementar criação, seleção, troca de contexto e remoção de schemas.
8. Implementar conexão, carga inicial e remoção das tabelas do schema atual.
9. Implementar CRUD de participantes, projetos e tarefas.
10. Implementar etiquetas, comentários e dependências entre tarefas.
11. Implementar as três consultas e seus gráficos.
12. Implementar a geração e o armazenamento de embeddings das tarefas.
13. Implementar a busca de tarefas semelhantes e a sugestão de possíveis
   duplicatas.
14. Implementar a interface TUI com a biblioteca Textual, incluindo telas,
    menus, navegação por teclado e demonstração das operações do sistema.
15. Verificar a instalação do `git` e do `gh`.
16. Implementar autenticação com `gh auth status`.
17. Implementar operações GitHub com confirmação e tratamento de erros.
18. Implementar consultas ao repositório Git local.
19. Atualizar o relatório com exemplos reais, resultados e instruções de
    execução.

O núcleo local deve ser concluído e demonstrável antes das integrações
externas. Dessa forma, a apresentação não dependerá exclusivamente de
internet, autenticação ou disponibilidade da API do GitHub.
