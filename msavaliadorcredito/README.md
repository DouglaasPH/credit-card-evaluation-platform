# msavaliadorcredito

Microsserviço orquestrador: avalia o crédito de um cliente combinando dados de `msclientes` e `mscartoes`, e dispara a solicitação de emissão de cartão de forma assíncrona via RabbitMQ.

## O que faz

- Consulta a situação de um cliente (dados pessoais + cartões já emitidos), combinando chamadas síncronas ao `msclientes` e ao `mscartoes` via Feign Client
- Realiza a avaliação de crédito: busca cartões elegíveis pela renda informada e calcula o limite aprovado para cada um, com base na idade do cliente
- Publica uma solicitação de emissão de cartão na fila do RabbitMQ (processada de forma assíncrona pelo `mscartoes`) e retorna um protocolo de acompanhamento
- **Não tem banco de dados próprio** — é um serviço de orquestração/regra de negócio, stateless

## Endpoints

| Método | Rota | Descrição |
|---|---|---|
| `GET` | `/avaliacoes-credito` | Health check simples (`"ok"`) |
| `GET` | `/avaliacoes-credito/situacao-cliente?cpf={cpf}` | Retorna dados do cliente + cartões já emitidos |
| `POST` | `/avaliacoes-credito` | Realiza avaliação de crédito (body: `cpf`, `renda`) |
| `POST` | `/avaliacoes-credito/solicitacoes-cartao` | Solicita emissão assíncrona de um cartão |

Documentação interativa via Swagger disponível em `/swagger-ui.html`.

## Como a avaliação funciona

1. Busca os dados do cliente no `msclientes` (via Feign)
2. Busca no `mscartoes` os cartões cujo limite básico é compatível com a renda informada
3. Para cada cartão elegível, calcula o limite aprovado com base na idade do cliente (`(idade / 10) × limite básico`)

## Mensageria

Publica na fila `emissao-cartoes` (RabbitMQ) — quem consome e efetivamente registra a emissão é o `mscartoes`.

## Dependências

- **Eureka** — se registra e descobre `msclientes`/`mscartoes` dinamicamente
- **RabbitMQ** — publisher da fila `emissao-cartoes`
- `msclientes` e `mscartoes` — via Feign Client (comunicação síncrona HTTP)

## Variáveis de ambiente

| Variável | Descrição | Exemplo |
|---|---|---|
| `EUREKA_SERVER` | Host do Eureka Server | `eurekaserver` |
| `RABBITMQ_SERVER` | Host do RabbitMQ | `rabbitmq` |

## Rodando via Docker Compose

Já está incluído no `docker-compose.yml` da raiz do projeto. Veja o [README geral](../README.md) para subir o ecossistema completo.
