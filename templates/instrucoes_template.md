# Template de Instruções para Genie Agent

Copie e adapte este template ao criar um novo Genie Agent.

---

## Contexto do Domínio

Este Genie Agent responde perguntas sobre [DOMÍNIO].
Os dados cobrem o período de [DATA_INICIO] até hoje.
Atualização: [FREQUÊNCIA — diária/horária/tempo real].

## Definições de Métricas

| Métrica | Fórmula SQL | Descrição |
|---------|-------------|------------|
| Receita Total | `SUM(total_revenue)` | Receita líquida de devoluções |
| Ticket Médio | `SUM(total_revenue) / COUNT(DISTINCT order_id)` | Valor médio por pedido |
| Taxa de Conversão | `COUNT(DISTINCT orders) / COUNT(DISTINCT sessions) * 100` | % de sessões que viraram pedido |

## Regras de Negócio

- Sempre exclua registros onde `status IN ('CANCELADO', 'TESTE', 'FRAUDE')`
- Considere apenas dados a partir de [DATA_CORTE]
- O ano fiscal começa em [MÊS]

## Mapeamento de Termos (Sinônimos)

| O usuário diz... | Use a coluna... |
|---|---|
| "faturamento", "receita", "vendas" | `total_revenue` |
| "lucro", "margem" | `net_profit` |
| "cliente", "comprador" | `customer_name` |
| "produto", "item", "SKU" | `product_name` |

## Joins Recomendados

```sql
-- Vendas + Clientes
FROM sales s
JOIN customers c ON s.customer_id = c.id

-- Vendas + Produtos
FROM sales s
JOIN products p ON s.product_id = p.id
```

## Valores Padrão

- Se o usuário não especificar período: use os últimos 30 dias
- Se não especificar granularidade: agrupe por dia
- Se não especificar ordenação: ordene pelo valor mais relevante DESC

## Limitações Conhecidas

- Dados de [FONTE_X] podem ter atraso de até 24h
- A coluna [COLUNA_Y] tem ~5% de valores nulos para registros antes de [DATA]
- Não temos dados de [INFORMAÇÃO_AUSENTE]

## Formatação

- Valores monetários: BRL com 2 casas decimais
- Percentuais: 1 casa decimal + símbolo %
- Datas: formato DD/MM/YYYY
- Grandes números: usar separador de milhar (1.234.567)
