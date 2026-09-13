# Credit Card Evaluation & Issuance Platform

Ecossistema de microsserviços orientado a eventos para cadastro de clientes, avaliação de crédito e emissão de cartões, construído com Java 17, Spring Boot, Spring Cloud, RabbitMQ, Keycloak, MySQL e Docker.

## Arquitetura

```
                         ┌─────────────┐
                         │   Cliente   │
                         │  (externo)  │
                         └──────┬──────┘
                                │
                         ┌──────▼──────┐
                         │ mscloudgateway │  ← porta de entrada única (9000)
                         │  (Gateway +    │     valida JWT no Keycloak
                         │   discovery)   │
                         └──────┬──────┘
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
       ┌──────▼──────┐  ┌───────▼───────┐  ┌──────▼───────┐
       │  msclientes  │  │  mscartoes    │  │msavaliadorcredito│
       │  (cadastro)  │  │ (catálogo +   │  │ (orquestrador)   │
       │              │  │  emissão)     │  │                  │
       └──────┬──────┘  └───────┬───────┘  └────────┬─────────┘
              │                 │                    │
              │           ┌─────▼─────┐              │
              │           │ RabbitMQ  │◄─────────────┘
              │           │  (fila)   │
              │           └───────────┘
              │                 │
       ┌──────▼─────────────────▼──────┐
       │            MySQL              │
       │  (msclientes_db / mscartoes_db)│
       └────────────────────────────────┘

  Todos os serviços se registram no eurekaserver (service discovery)
  mscloudgateway valida tokens contra o keycloak (autenticação)
```

## Serviços

| Serviço | Descrição | README |
|---|---|---|
| `eurekaserver` | Service discovery (Netflix Eureka) e Registry | [eurekaserver/README.md](eurekaserver/README.md) |
| `msclientes` | Registrar e recuperar dados de clientes | [msclientes/README.md](msclientes/README.md) |
| `mscartoes` | Gerenciar cartões, processar emissão assíncrona | [mscartoes/README.md](mscartoes/README.md) |
| `msavaliadorcredito` | Avaliar crédito, solicitar emissão, orquestrar | [msavaliadorcredito/README.md](msavaliadorcredito/README.md) |
| `mscloudgateway` | Roteamento centralizado (API Gateway) + autenticação (validação de JWT) | [mscloudgateway/README.md](mscloudgateway/README.md) |

## Infraestrutura

| Componente | Papel |
|---|---|
| **RabbitMQ** | Mensageria assíncrona entre `msavaliadorcredito` e `mscartoes` |
| **Keycloak** | Autenticação/autorização via OAuth2/JWT (realm `mscourserealm`) |
| **MySQL** | Persistência de `msclientes` e `mscartoes` (um banco por serviço) |

## Pré-requisitos

- Docker e Docker Compose
- (Opcional, só se for rodar algum serviço fora do Docker) Java 17 e Maven

## Como subir o ecossistema completo

```bash
git clone https://github.com/DouglaasPH/spring-cloud-microsservices-ecossystem.git
cd spring-cloud-microsservices-ecossystem
docker compose up --build
```

A subida segue uma ordem em camadas, garantida pelo `docker-compose.yml`:

1. **Infraestrutura** — `rabbitmq`, `keycloak`, `mysql` (sobem em paralelo)
2. **eurekaserver** — espera a infraestrutura ficar saudável
3. **Microsserviços** — `msclientes`, `mscartoes`, `msavaliadorcredito` esperam o Eureka
4. **mscloudgateway** — espera os microsserviços iniciarem

> A primeira subida é mais lenta (o MySQL inicializa os arquivos de banco do zero e o Keycloak faz o build interno do Quarkus, ambos só na primeira vez). Nas subidas seguintes fica bem mais rápido, já que os volumes de dados persistem.

## URLs de acesso

| Serviço | URL | Credenciais |
|---|---|---|
| Gateway (entrada pública) | `http://localhost:9000` | — |
| Eureka dashboard | `http://localhost:8761` | `curso-ms-eureka-user` / ver `eurekaserver/application.properties` |
| Keycloak admin console | `http://keycloak:8080` * | `admin` / `admin` |
| RabbitMQ management | `http://localhost:15672` | `guest` / `guest` |
| MySQL | `localhost:3306` | `root` / `root` (ou `msuser` / `mspassword` para as bases da aplicação) |

\* **Importante:** acesse o Keycloak pelo hostname `keycloak`, não por `localhost`. Para isso, adicione ao seu arquivo de hosts (`C:\Windows\System32\drivers\etc\hosts` no Windows, como administrador):
```
127.0.0.1 keycloak
```
Isso é necessário porque o token JWT emitido carrega o `issuer` baseado no host usado no login — e o `mscloudgateway` valida esse token usando o hostname interno da rede Docker (`keycloak:8080`). Se você logar via `localhost:8080`, o `iss` do token não vai bater com o que o Gateway espera, e a validação falha.

> Todo endpoint passa pelo Gateway, que exige um token JWT válido do Keycloak — inclua o header `Authorization: Bearer <token>` obtido via login no realm `mscourserealm`.

## Documentação da API

Cada microsserviço expõe Swagger UI em `/swagger-ui.html` (via springdoc-openapi), acessível diretamente na porta interna do serviço durante desenvolvimento local.

## Stack técnica

- **Linguagem:** Java 17
- **Framework:** Spring Boot 4, Spring Cloud 2025.x
- **Service discovery:** Netflix Eureka
- **Gateway:** Spring Cloud Gateway (discovery locator)
- **Mensageria:** RabbitMQ (Spring AMQP)
- **Autenticação:** Keycloak (OAuth2 / JWT)
- **Persistência:** MySQL + Spring Data JPA / Hibernate
- **Comunicação síncrona entre serviços:** OpenFeign
- **Containers:** Docker + Docker Compose
