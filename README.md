# 🧞 Genie One — Boas Práticas

Guia completo de boas práticas para criação, curadoria e manutenção de **Genie Agents** (anteriormente Genie Spaces) no Databricks.

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Preparação dos Dados](#preparação-dos-dados)
3. [Criação do Genie Agent](#criação-do-genie-agent)
4. [Instruções de Curadoria](#instruções-de-curadoria)
5. [Exemplos de SQL](#exemplos-de-sql)
6. [Testes e Validação](#testes-e-validação)
7. [Manutenção Contínua](#manutenção-contínua)
8. [Anti-Patterns](#anti-patterns)

---

## Visão Geral

O **Genie One** é a interface de linguagem natural do Databricks que permite a usuários de negócio consultar dados usando perguntas em texto livre. Um Genie Agent bem curado traduz perguntas em SQL preciso, retornando respostas confiáveis.

### Princípios Fundamentais

| Princípio | Descrição |
|-----------|-----------|
| **Menos é mais** | Prefira poucas tabelas bem documentadas a muitas tabelas genéricas |
| **Contexto é rei** | Instruções claras superam schemas complexos |
| **Itere sempre** | Revise e melhore com base no feedback dos usuários |
| **Teste como usuário** | Faça perguntas reais antes de publicar |

---

## Preparação dos Dados

### ✅ Boas Práticas de Modelagem

1. **Use tabelas Gold/Agregadas**
   - Prefira tabelas já transformadas e prontas para consumo
   - Evite expor tabelas raw/bronze diretamente

2. **Nomes descritivos**
   - Colunas: `total_revenue`, `customer_name` (não `col1`, `amt`)
   - Tabelas: `sales_monthly_summary` (não `tbl_001`)

3. **Documente no Unity Catalog**
   - Adicione `COMMENT` em todas as colunas
   - Adicione `COMMENT` na tabela descrevendo seu propósito
   - Use tags para categorização

4. **Minimize JOINs necessários**
   - Desnormalize quando possível para o contexto do Genie
   - Crie views materializadas que já fazem os joins comuns

5. **Tipos de dados corretos**
   - Datas como `DATE` ou `TIMESTAMP`, não strings
   - Valores monetários como `DECIMAL` ou `DOUBLE`
   - Categorias com valores consistentes (sem variações de casing)

### Exemplo de Documentação no Unity Catalog

```sql
COMMENT ON TABLE catalog.schema.sales_summary IS 
  'Resumo mensal de vendas por região e produto. Atualizado diariamente. Fonte: ERP SAP.';

COMMENT ON COLUMN catalog.schema.sales_summary.total_revenue IS 
  'Receita total em BRL, já líquida de devoluções e cancelamentos.';

COMMENT ON COLUMN catalog.schema.sales_summary.region IS 
  'Região geográfica. Valores possíveis: Norte, Nordeste, Centro-Oeste, Sudeste, Sul.';
```

---

## Criação do Genie Agent

### Escopo Bem Definido

Cada Genie Agent deve ter um **domínio claro e limitado**:

| ✅ Bom Escopo | ❌ Escopo Ruim |
|---|---|
| "Análise de vendas do e-commerce" | "Todos os dados da empresa" |
| "Métricas de RH — headcount e turnover" | "RH, Financeiro e Operações" |
| "Performance de campanhas de marketing" | "Marketing e Vendas e Produto" |

### Seleção de Tabelas

- **Máximo recomendado**: 5-8 tabelas por Genie Agent
- **Critério**: Inclua apenas tabelas que respondem perguntas do domínio
- **Relacionamento**: As tabelas devem ter chaves de join claras entre si

### Título e Descrição

```
Título: Análise de Vendas — E-commerce Brasil
Descrição: Responde perguntas sobre vendas, pedidos, clientes e produtos 
do e-commerce. Cobre dados de Jan/2024 em diante. Métricas incluem: 
receita, ticket médio, taxa de conversão e NPS.
```

---

## Instruções de Curadoria

As instruções são o **coração** de um Genie Agent bem-sucedido. Elas ensinam o modelo a interpretar corretamente as perguntas dos usuários.

### Tipos de Instrução

#### 1. Definições de Negócio (Business Terms)

```
Instrução: "Cliente ativo" significa um cliente que fez pelo menos 1 compra 
nos últimos 90 dias (campo last_purchase_date >= CURRENT_DATE - INTERVAL 90 DAYS).
```

#### 2. Regras de Filtro

```
Instrução: Sempre exclua pedidos com status = 'CANCELADO' ou 'TESTE' 
das métricas de vendas, a menos que o usuário peça explicitamente.
```

#### 3. Mapeamento de Sinônimos

```
Instrução: Quando o usuário perguntar sobre "faturamento", "receita" ou 
"vendas", use a coluna `total_revenue`. Quando perguntar sobre "lucro" 
ou "margem", use a coluna `net_profit`.
```

#### 4. Lógica de Cálculo

```
Instrução: O ticket médio é calculado como SUM(total_revenue) / COUNT(DISTINCT order_id).
A taxa de conversão é calculada como COUNT(DISTINCT orders) / COUNT(DISTINCT sessions) * 100.
```

#### 5. Contexto Temporal

```
Instrução: O ano fiscal começa em Abril. Quando o usuário perguntar sobre 
"este ano fiscal", filtre por data >= primeiro dia de Abril do ano corrente.
Se perguntar "mês passado" sem especificar, use o mês calendário anterior completo.
```

#### 6. Formatação de Saída

```
Instrução: Valores monetários devem ser apresentados em BRL com 2 casas decimais.
Percentuais com 1 casa decimal. Datas no formato DD/MM/YYYY.
```

### Template de Instrução Geral

```
## Contexto do Domínio
[Descreva o que este Genie Agent cobre]

## Definições de Métricas
- Métrica A = [fórmula SQL]
- Métrica B = [fórmula SQL]

## Regras de Negócio
- Sempre filtrar por [condição]
- Nunca incluir [exclusão]

## Mapeamento de Termos
- "termo do usuário" → coluna_x
- "outro termo" → coluna_y

## Joins Recomendados
- tabela_a JOIN tabela_b ON tabela_a.id = tabela_b.fk_id

## Notas Importantes
- [Caveats, limitações, dados faltantes]
```

---

## Exemplos de SQL

Exemplos de SQL são **extremamente poderosos** — eles ensinam o Genie por demonstração.

### Boas Práticas para Exemplos

1. **Cubra os padrões mais comuns** (80/20)
2. **Varie a complexidade** — do simples ao avançado
3. **Inclua a pergunta em linguagem natural** como comentário
4. **Use CTEs** para legibilidade

### Exemplo Estruturado

```sql
-- Pergunta: "Qual foi o faturamento por região no último trimestre?"
-- Descrição: Receita total agrupada por região, filtrada pelo trimestre anterior

WITH periodo AS (
  SELECT 
    DATE_TRUNC('quarter', CURRENT_DATE - INTERVAL 3 MONTHS) AS inicio,
    DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL 1 DAY AS fim
)
SELECT 
  s.region AS regiao,
  SUM(s.total_revenue) AS faturamento_total,
  COUNT(DISTINCT s.order_id) AS total_pedidos,
  ROUND(SUM(s.total_revenue) / COUNT(DISTINCT s.order_id), 2) AS ticket_medio
FROM catalog.schema.sales_summary s
CROSS JOIN periodo p
WHERE s.order_date BETWEEN p.inicio AND p.fim
  AND s.status NOT IN ('CANCELADO', 'TESTE')
GROUP BY s.region
ORDER BY faturamento_total DESC;
```

### Quantidade Recomendada

| Complexidade do Domínio | Exemplos Recomendados |
|---|---|
| Simples (1-3 tabelas) | 5-10 exemplos |
| Médio (4-6 tabelas) | 10-20 exemplos |
| Complexo (7+ tabelas) | 20-30 exemplos |

---

## Testes e Validação

### Checklist de Validação

- [ ] Perguntas simples retornam resultados corretos
- [ ] Sinônimos são interpretados corretamente
- [ ] Filtros temporais funcionam (ontem, semana passada, último mês)
- [ ] Métricas calculadas batem com dashboards existentes
- [ ] Perguntas ambíguas recebem clarificação (não respostas erradas)
- [ ] Perguntas fora do escopo são tratadas graciosamente

### Perguntas de Teste Sugeridas

```
# Básicas
- "Qual o faturamento total?"
- "Quantos clientes temos?"
- "Top 10 produtos por receita"

# Temporais
- "Vendas de ontem"
- "Comparar este mês com o mês passado"
- "Tendência de receita nos últimos 6 meses"

# Filtros
- "Vendas da região Sudeste"
- "Pedidos acima de R$ 1.000"
- "Clientes que compraram mais de 3 vezes"

# Cálculos
- "Qual o ticket médio por categoria?"
- "Taxa de crescimento mês a mês"
- "Participação de cada região no total"

# Edge Cases
- "Vendas" (sem contexto temporal — deve assumir padrão)
- "Dados de 2019" (fora do range — deve informar)
- "Previsão para próximo mês" (fora do escopo — deve informar)
```

---

## Manutenção Contínua

### Ciclo de Melhoria

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  Monitorar  │────▶│   Analisar   │────▶│  Melhorar   │
│  Perguntas  │     │   Feedback   │     │ Instruções  │
└─────────────┘     └──────────────┘     └─────────────┘
       ▲                                        │
       └────────────────────────────────────────┘
```

### O que Monitorar

1. **Perguntas que falharam** — Adicione instruções ou exemplos
2. **Perguntas frequentes** — Otimize com exemplos diretos
3. **Respostas incorretas** — Corrija com instruções mais específicas
4. **Novos termos de negócio** — Atualize definições

### Frequência de Revisão

| Fase | Frequência |
|------|-----------|
| Primeiras 2 semanas | Diária |
| Mês 1-2 | Semanal |
| Após estabilização | Quinzenal/Mensal |

---

## Anti-Patterns

### ❌ Evite

| Anti-Pattern | Por quê | Alternativa |
|---|---|---|
| Incluir todas as tabelas do schema | Confunde o modelo, gera JOINs desnecessários | Selecione apenas tabelas relevantes |
| Instruções vagas ("use bom senso") | O modelo precisa de regras explícitas | Seja específico e dê exemplos |
| Nenhum exemplo de SQL | O modelo não aprende os padrões do domínio | Adicione 10+ exemplos representativos |
| Colunas sem documentação | O modelo adivinha o significado | Documente com COMMENT no UC |
| Escopo muito amplo | Respostas imprecisas e lentas | Crie múltiplos Genie Agents focados |
| Não testar antes de publicar | Usuários encontram erros | Valide com o checklist acima |
| Ignorar feedback | O Agent não evolui | Revise regularmente |

---

## 📚 Recursos Adicionais

- [Documentação oficial — AI/BI Genie](https://docs.databricks.com/en/genie/index.html)
- [Databricks Community — Genie Best Practices](https://community.databricks.com/)
- [Unity Catalog — Documentando tabelas](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Abra uma issue ou PR com sugestões de melhoria.

---

*Criado com ❤️ para a comunidade Databricks Brasil*
