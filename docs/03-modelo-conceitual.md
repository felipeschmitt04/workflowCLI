# 3. Modelo conceitual

O modelo conceitual representa o núcleo de gerenciamento de projetos e
tarefas. As entidades de integração externa devem ser incluídas somente se
forem necessárias ao modelo lógico e às consultas definidas para a versão
final.

O sistema será multi-tenant: cada projeto terá um schema PostgreSQL próprio.
O catálogo central de projetos e a forma de associação entre a pasta local e o
schema deverão ser detalhados no modelo lógico.

## 3.1 Entidades previstas

- **Participante:** pessoa cadastrada no sistema.
- **Projeto:** registro do catálogo central que identifica uma unidade de
  trabalho e seu schema.
- **Tarefa:** atividade pertencente a um projeto.
- **Status:** situação atual de uma tarefa.
- **Prioridade:** nível de urgência de uma tarefa.
- **Etiqueta:** classificação reutilizável.
- **TarefaEtiqueta:** associação entre tarefas e etiquetas.
- **Comentário:** observação registrada em uma tarefa.
- **DependênciaTarefa:** relação que indica que uma tarefa bloqueia outra.
- **Categoria:** agrupamento funcional de tarefas.
- **Marco:** objetivo ou etapa importante de um projeto.

## 3.2 Relacionamentos principais

- um projeto possui várias tarefas;
- cada participante pertence ao projeto do schema atual;
- cada projeto possui seus próprios participantes;
- uma tarefa possui um status e uma prioridade;
- uma tarefa pode possuir várias etiquetas;
- uma etiqueta pode estar associada a várias tarefas;
- uma tarefa pode possuir vários comentários;
- uma tarefa pode depender de outras tarefas;
- um projeto pode possuir categorias e marcos;
- uma tarefa pode estar associada opcionalmente a uma categoria ou marco.

O diagrama conceitual será recriado após a validação deste conjunto de
entidades e relacionamentos.
