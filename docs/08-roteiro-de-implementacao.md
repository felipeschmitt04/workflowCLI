# 8. Roteiro de implementação

1. Validar o modelo conceitual e recriar o diagrama.
2. Definir o catálogo `public`, as identidades globais e as associações de
   participantes com projetos.
3. Derivar o modelo lógico com PKs, FKs e restrições.
4. Criar e testar o DDL do PostgreSQL para o catálogo e para o schema de
   projeto.
5. Implementar os comandos `workflowcli`, `workflowcli .`, `workflowcli init`,
   `workflowcli projects` e `workflowcli open`.
6. Implementar o fluxo guiado de primeira execução e o marcador local.
7. Implementar criação, seleção, troca de contexto e remoção de schemas.
8. Implementar conexão, carga inicial e remoção das tabelas do schema atual.
9. Implementar CRUD de participantes globais, projetos e associações de
   acesso.
10. Implementar CRUD de tarefas.
11. Implementar labels, comentários e dependências entre tarefas.
12. Implementar as três consultas e seus gráficos.
13. Implementar a geração e o armazenamento de embeddings das tarefas.
14. Implementar a busca de tarefas semelhantes e a sugestão de possíveis
   duplicatas.
15. Implementar a interface TUI com a biblioteca Textual, incluindo telas,
    menus, navegação por teclado e demonstração das operações do sistema.
16. Verificar a instalação do `git` e do `gh`.
17. Implementar autenticação com `gh auth status`.
18. Implementar operações GitHub com confirmação e tratamento de erros.
19. Implementar consultas ao repositório Git local.
20. Atualizar o relatório com exemplos reais, resultados e instruções de
    execução.

O núcleo local deve ser concluído e demonstrável antes das integrações
externas. Dessa forma, a apresentação não dependerá exclusivamente de
internet, autenticação ou disponibilidade da API do GitHub.
