-- ============================================================
-- EXEMPLOS DE SQL PARA GENIE AGENT
-- Domínio: [SEU DOMÍNIO]
-- ============================================================

-- ============================================================
-- EXEMPLO 1: Consulta Simples — Métrica Total
-- ============================================================
-- Pergunta: "Qual o faturamento total?"
-- Tipo: Agregação simples

SELECT 
  SUM(total_revenue) AS faturamento_total
FROM catalog.schema.sales
WHERE status NOT IN ('CANCELADO', 'TESTE');


-- ============================================================
-- EXEMPLO 2: Agrupamento por Dimensão
-- ============================================================
-- Pergunta: "Faturamento por região"
-- Tipo: GROUP BY com ordenação

SELECT 
  region AS regiao,
  SUM(total_revenue) AS faturamento,
  COUNT(DISTINCT order_id) AS pedidos
FROM catalog.schema.sales
WHERE status NOT IN ('CANCELADO', 'TESTE')
GROUP BY region
ORDER BY faturamento DESC;


-- ============================================================
-- EXEMPLO 3: Filtro Temporal — Último Mês
-- ============================================================
-- Pergunta: "Vendas do mês passado"
-- Tipo: Filtro de data relativo

SELECT 
  DATE_TRUNC('day', order_date) AS dia,
  SUM(total_revenue) AS faturamento_diario
FROM catalog.schema.sales
WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL 1 MONTH)
  AND order_date < DATE_TRUNC('month', CURRENT_DATE)
  AND status NOT IN ('CANCELADO', 'TESTE')
GROUP BY 1
ORDER BY 1;


-- ============================================================
-- EXEMPLO 4: Top N com Ranking
-- ============================================================
-- Pergunta: "Top 10 clientes por receita"
-- Tipo: LIMIT com ordenação

SELECT 
  c.customer_name AS cliente,
  SUM(s.total_revenue) AS receita_total,
  COUNT(DISTINCT s.order_id) AS total_pedidos
FROM catalog.schema.sales s
JOIN catalog.schema.customers c ON s.customer_id = c.id
WHERE s.status NOT IN ('CANCELADO', 'TESTE')
GROUP BY c.customer_name
ORDER BY receita_total DESC
LIMIT 10;


-- ============================================================
-- EXEMPLO 5: Comparação Período a Período (MoM)
-- ============================================================
-- Pergunta: "Comparar vendas deste mês com o mês passado"
-- Tipo: Comparação temporal com CTE

WITH mes_atual AS (
  SELECT SUM(total_revenue) AS receita
  FROM catalog.schema.sales
  WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE)
    AND status NOT IN ('CANCELADO', 'TESTE')
),
mes_anterior AS (
  SELECT SUM(total_revenue) AS receita
  FROM catalog.schema.sales
  WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL 1 MONTH)
    AND order_date < DATE_TRUNC('month', CURRENT_DATE)
    AND status NOT IN ('CANCELADO', 'TESTE')
)
SELECT 
  ma.receita AS receita_mes_atual,
  mp.receita AS receita_mes_anterior,
  ROUND((ma.receita - mp.receita) / mp.receita * 100, 1) AS variacao_pct
FROM mes_atual ma
CROSS JOIN mes_anterior mp;


-- ============================================================
-- EXEMPLO 6: Tendência ao Longo do Tempo
-- ============================================================
-- Pergunta: "Tendência de vendas nos últimos 6 meses"
-- Tipo: Série temporal mensal

SELECT 
  DATE_TRUNC('month', order_date) AS mes,
  SUM(total_revenue) AS receita_mensal,
  COUNT(DISTINCT order_id) AS pedidos,
  ROUND(SUM(total_revenue) / COUNT(DISTINCT order_id), 2) AS ticket_medio
FROM catalog.schema.sales
WHERE order_date >= CURRENT_DATE - INTERVAL 6 MONTHS
  AND status NOT IN ('CANCELADO', 'TESTE')
GROUP BY 1
ORDER BY 1;


-- ============================================================
-- EXEMPLO 7: Participação / Share
-- ============================================================
-- Pergunta: "Qual a participação de cada categoria no total?"
-- Tipo: Percentual do total

SELECT 
  p.category AS categoria,
  SUM(s.total_revenue) AS receita,
  ROUND(SUM(s.total_revenue) / SUM(SUM(s.total_revenue)) OVER () * 100, 1) AS participacao_pct
FROM catalog.schema.sales s
JOIN catalog.schema.products p ON s.product_id = p.id
WHERE s.status NOT IN ('CANCELADO', 'TESTE')
GROUP BY p.category
ORDER BY receita DESC;
