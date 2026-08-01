# Taxa de Cumprimento de SLA por Prioridade

## Resumo Executivo

A taxa de cumprimento de SLA varia significativamente conforme a prioridade dos chamados, com desempenho inversamente proporcional à urgência. Chamados de baixa prioridade atingem 100% de cumprimento, enquanto chamados críticos apresentam apenas 41,7%.

## Resultados por Prioridade

| Prioridade | Total de Chamados | Dentro do SLA | Fora do SLA | Taxa de Cumprimento (%) |
|------------|-------------------|---------------|-------------|-------------------------|
| Crítico    | 12                | 5             | 7           | 41,7                    |
| Alto       | 13                | 7             | 6           | 53,8                    |
| Médio      | 23                | 17            | 6           | 73,9                    |
| Baixo      | 12                | 12            | 0           | 100,0                   |

### Crítico (prazo: 4 horas)
- **Taxa de cumprimento: 41,7%**
- 5 de 12 chamados dentro do SLA
- 7 chamados violaram o prazo

### Alto (prazo: 8 horas)
- **Taxa de cumprimento: 53,8%**
- 7 de 13 chamados dentro do SLA
- 6 chamados violaram o prazo

### Médio (prazo: 24 horas)
- **Taxa de cumprimento: 73,9%**
- 17 de 23 chamados dentro do SLA
- 6 chamados violaram o prazo

### Baixo (prazo: 72 horas)
- **Taxa de cumprimento: 100%**
- Todos os 12 chamados foram resolvidos dentro do prazo

## Principais Achados

- **Crítico e Alto estão abaixo de 55%**, indicando dificuldade da equipe em atender prazos mais agressivos — 7 de 12 chamados críticos e 6 de 13 chamados de alta prioridade violaram o SLA.
- **Médio** apresenta desempenho razoável com ~74%, mas ainda com 6 violações.
- **Baixo** atinge 100% de cumprimento, demonstrando que prazos mais longos são consistentemente atendidos.

## Prazos de SLA Utilizados

| Prioridade | Prazo (horas) |
|------------|---------------|
| Crítico    | 4             |
| Alto       | 8             |
| Médio      | 24            |
| Baixo      | 72            |

Fonte: Política de SLA (Google Drive) aplicada sobre a tabela de chamados de suporte.
