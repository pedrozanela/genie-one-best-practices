# Taxa de Cumprimento de SLA por Prioridade

## Resumo Executivo

A taxa de cumprimento de SLA varia significativamente conforme a prioridade dos chamados, com desempenho crítico nas prioridades mais altas. Chamados de prioridade **Crítico** apresentam apenas **41,7%** de cumprimento, enquanto chamados de **Baixa** prioridade atingem **100%**.

## Resultados por Prioridade

| Prioridade | Total de Chamados | Dentro do SLA | Fora do SLA | Taxa de Cumprimento (%) |
|------------|-------------------|---------------|-------------|-------------------------|
| Crítico    | 12                | 5             | 7           | 41,7                    |
| Alto       | 13                | 7             | 6           | 53,8                    |
| Médio      | 23                | 17            | 6           | 73,9                    |
| Baixo      | 12                | 12            | 0           | 100,0                   |

### Crítico (prazo: 4 horas)
- **Taxa de cumprimento: 41,7%**
- 5 de 12 chamados resolvidos dentro do prazo
- 7 chamados violaram o SLA

### Alto (prazo: 8 horas)
- **Taxa de cumprimento: 53,8%**
- 7 de 13 chamados resolvidos dentro do prazo
- 6 chamados violaram o SLA

### Médio (prazo: 24 horas)
- **Taxa de cumprimento: 73,9%**
- 17 de 23 chamados resolvidos dentro do prazo
- 6 chamados violaram o SLA

### Baixo (prazo: 72 horas)
- **Taxa de cumprimento: 100%**
- 12 de 12 chamados resolvidos dentro do prazo
- Nenhuma violação de SLA

## Prazos de SLA Aplicados

| Prioridade | Prazo (horas) |
|------------|---------------|
| Crítico    | 4             |
| Alto       | 8             |
| Médio      | 24            |
| Baixo      | 72            |

## SQL Utilizada

```sql
SELECT
  prioridade,
  COUNT(*) AS total_chamados,
  SUM(CASE
    WHEN horas_resolucao <= CASE prioridade
      WHEN 'Critico' THEN 4
      WHEN 'Alto' THEN 8
      WHEN 'Medio' THEN 24
      WHEN 'Baixo' THEN 72
    END THEN 1
    ELSE 0
  END) AS dentro_do_sla,
  SUM(CASE
    WHEN horas_resolucao > CASE prioridade
      WHEN 'Critico' THEN 4
      WHEN 'Alto' THEN 8
      WHEN 'Medio' THEN 24
      WHEN 'Baixo' THEN 72
    END THEN 1
    ELSE 0
  END) AS fora_do_sla,
  ROUND(100.0 * SUM(CASE
    WHEN horas_resolucao <= CASE prioridade
      WHEN 'Critico' THEN 4
      WHEN 'Alto' THEN 8
      WHEN 'Medio' THEN 24
      WHEN 'Baixo' THEN 72
    END THEN 1
    ELSE 0
  END) / COUNT(*), 1) AS taxa_cumprimento_pct
FROM pedro_zanela.webinar.chamados_suporte
GROUP BY prioridade
ORDER BY CASE prioridade
  WHEN 'Critico' THEN 1
  WHEN 'Alto' THEN 2
  WHEN 'Medio' THEN 3
  WHEN 'Baixo' THEN 4
END
```

## Conclusão

As prioridades **Crítico** e **Alto** estão significativamente abaixo de uma meta típica de 80% de cumprimento, indicando necessidade de atenção urgente nos tempos de resposta para chamados de alta prioridade. Recomenda-se investigar os gargalos operacionais que impedem a resolução rápida desses chamados e considerar ações como reforço de equipe, escalonamento automático ou revisão dos processos de triagem.

---

*Atualizado em: 2026-08-01 | Fonte: Genie Space "Suporte — SLA & Chamados" | Tabela: `pedro_zanela.webinar.chamados_suporte`*
