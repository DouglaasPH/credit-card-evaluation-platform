# mscartoes

Microsserviço de catálogo de cartões e do vínculo entre cliente e cartão emitido. Também é quem efetivamente "emite" um cartão para um cliente, de forma assíncrona, ao receber uma solicitação via fila do RabbitMQ.

## O que faz

- Cadastra o catálogo de cartões disponíveis (nome, bandeira, limite básico)
- Consulta cartões elegíveis por faixa de renda
- Consulta os cartões já vinculados a um cliente (por CPF)
- **Consome** a fila `emissao-cartoes` do RabbitMQ: quando o `msavaliadorcredito` publica uma solicitação de emissão, este serviço processa e grava o vínculo cliente↔cartão no banco
- Persiste em banco próprio (`mscartoes_db`)

## Endpoints

| Método | Rota | Descrição |
|---|---|---|
| `GET` | `/cartoes` | Health check simples (`"ok"`) |
| `POST` | `/cartoes` | Cadastra um cartão no catálogo |
| `GET` | `/cartoes?renda={renda}` | Lista cartões com limite básico compatível com a renda |
| `GET` | `/cartoes?cpf={cpf}` | Lista cartões já emitidos para um cliente |

Documentação interativa via Swagger disponível em `/swagger-ui.html`.

## Mensageria

A fila `emissao-cartoes` é declarada em código (`RabbitMQConfig.java`), então ela é criada automaticamente pelo Spring AMQP na subida do serviço — não precisa criar manualmente no RabbitMQ.

## Dependências

- **Eureka** — se registra para ser descoberto pelo `msavaliadorcredito` (via Feign) e pelo `mscloudgateway`
- **RabbitMQ** — consumidor da fila `emissao-cartoes`
- **MySQL** — persistência via Spring Data JPA + Hibernate

## Variáveis de ambiente

| Variável | Descrição | Exemplo |
|---|---|---|
| `EUREKA_SERVER` | Host do Eureka Server | `eurekaserver` |
| `RABBITMQ_SERVER` | Host do RabbitMQ | `rabbitmq` |
| `MYSQL_SERVER` | Host do MySQL | `mysql` |
| `MYSQL_PORT` | Porta do MySQL | `3306` |
| `MYSQL_DATABASE` | Nome do banco | `mscartoes_db` |
| `MYSQL_USER` | Usuário do banco | `msuser` |
| `MYSQL_PASSWORD` | Senha do banco | `mspassword` |

## Rodando via Docker Compose

Já está incluído no `docker-compose.yml` da raiz do projeto. Veja o [README geral](../README.md) para subir o ecossistema completo.
