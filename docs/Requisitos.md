# 1. Descrição do objetivo geral do sistema
O workflowCLI é um sistema de gestão de projetos voltado a equipes pequenas de desenvolvimento, incluindo estudantes e pesquisadores, que centraliza em um único ambiente as informações de participantes, projetos, tarefas (tasks) e o histórico de atividade de repositórios de código, como issues e pull requests. O sistema tem como objetivo reduzir a dispersão de informação entre diferentes ferramentas de gestão de tarefas e plataformas de versionamento, oferecendo uma interface única, executada diretamente no terminal (TUI), para consulta e manipulação desses dados. Além das operações convencionais de cadastro e consulta, o sistema incorpora recursos de Inteligência Artificial Generativa: um Large Language Model (LLM) auxilia na automação de funções e buscas dentro do sistema, enquanto embeddings gerados a partir do título e da descrição das issues permitem sugerir automaticamente itens semelhantes ou possíveis duplicatas. Dessa forma, o workflowCLI busca unir a agilidade de ferramentas de linha de comando com o apoio inteligente à tomada de decisão em contextos de gestão de projetos de software.

# 2. Detalhes e principais requisitos
## Contexto
Equipes de desenvolvimento de software costumam recorrer a múltiplas ferramentas para gerenciar seu trabalho: um quadro de tarefas, uma plataforma de versionamento de código e. frequentemente, ferramentas adicionais de comunicação. Essa fragmentação dificulta obter uma visão consolidada do andamento do projeto, já que informações sobre tarefas e sobre atividade de código ficam em sistemas isolados. O workflowCLI propões centralizar essas informações em um único banco de dados, acessível por meio de uma interface terminal, permitindo consultas que cruzem dados de gestão de projeto com dados de atividade de repositório.

## Requisitos funcionais
### Participantes e Projetos
- O sistema deve permitir o cadastro de participantes, cada um podendo estar associado a um ou mais projetos.
- Cada projeto deve possuir nome, descrição e data de criação.
- Um participante pode atual em múltiplos projetos, e um projeto pode ter múltiplos participantes.