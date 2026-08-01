# ✅ Checklist de Validação — Pré-Publicação do Genie Agent

Use este checklist antes de disponibilizar o Genie Agent para usuários finais.

---

## 1. Estrutura e Configuração

- [ ] Título claro e descritivo
- [ ] Descrição explica o escopo e limitações
- [ ] Tabelas selecionadas são apenas as necessárias (máx 5-8)
- [ ] Todas as tabelas têm COMMENT no Unity Catalog
- [ ] Todas as colunas relevantes têm COMMENT

## 2. Instruções de Curadoria

- [ ] Definições de métricas documentadas com fórmula SQL
- [ ] Regras de filtro padrão definidas (exclusões)
- [ ] Sinônimos/termos de negócio mapeados
- [ ] Contexto temporal definido (ano fiscal, padrões de data)
- [ ] Joins entre tabelas documentados
- [ ] Valores padrão definidos (quando usuário não especifica)

## 3. Exemplos de SQL

- [ ] Mínimo de 5 exemplos para domínios simples
- [ ] Mínimo de 10 exemplos para domínios médios
- [ ] Exemplos cobrem: agregação simples, filtro temporal, top N, comparação, tendência
- [ ] Cada exemplo tem a pergunta em linguagem natural como comentário
- [ ] Exemplos usam CTEs para legibilidade
- [ ] Exemplos aplicam os filtros padrão definidos nas instruções

## 4. Testes Funcionais

### Perguntas Básicas
- [ ] "Qual o total de [métrica principal]?" → Resultado correto
- [ ] "Quantos [entidade] temos?" → COUNT correto
- [ ] "Top 10 [entidade] por [métrica]" → Ranking correto

### Filtros Temporais
- [ ] "[métrica] de ontem" → Filtra corretamente
- [ ] "[métrica] da semana passada" → Período correto
- [ ] "[métrica] do último mês" → Mês anterior completo
- [ ] "[métrica] deste ano" → Ano corrente

### Sinônimos
- [ ] Todos os sinônimos definidos retornam a mesma métrica
- [ ] Termos ambíguos pedem clarificação (não adivinham)

### Cálculos
- [ ] Ticket médio calculado corretamente
- [ ] Percentuais somam ~100% quando aplicável
- [ ] Comparações MoM/YoY retornam variação correta

### Edge Cases
- [ ] Pergunta sem contexto temporal → Usa padrão definido
- [ ] Pergunta fora do escopo → Resposta educada informando limitação
- [ ] Pergunta sobre período sem dados → Informa que não há dados

## 5. Qualidade dos Dados

- [ ] Valores nulos tratados ou documentados
- [ ] Sem duplicatas que inflam métricas
- [ ] Dados atualizados (verificar freshness)
- [ ] Valores categóricos consistentes (sem variações de casing)

## 6. Performance

- [ ] Queries executam em < 30 segundos
- [ ] Tabelas grandes têm particionamento adequado
- [ ] Não há full table scans desnecessários

## 7. Governança

- [ ] Permissões de acesso configuradas corretamente
- [ ] Dados sensíveis mascarados ou excluídos
- [ ] Compliance com LGPD/políticas internas

---

## Resultado

| Critério | Status |
|----------|--------|
| Estrutura | ⬜ Aprovado / ⬜ Pendente |
| Instruções | ⬜ Aprovado / ⬜ Pendente |
| Exemplos SQL | ⬜ Aprovado / ⬜ Pendente |
| Testes | ⬜ Aprovado / ⬜ Pendente |
| Dados | ⬜ Aprovado / ⬜ Pendente |
| Performance | ⬜ Aprovado / ⬜ Pendente |
| Governança | ⬜ Aprovado / ⬜ Pendente |

**Aprovado para publicação?** ⬜ Sim / ⬜ Não

**Revisor:** _______________  
**Data:** _______________
