# msclientes

Microsserviço de cadastro de clientes. É a fonte de verdade dos dados pessoais (CPF, nome, idade) usados pelo `msavaliadorcredito` na hora de avaliar crédito.

## O que faz

- Cadastra novos clientes
- Consulta dados de um cliente pelo CPF
- Persiste em banco próprio (`msclientes_db`), seguindo o padrão *database per service*

## Endpoints

| Método | Rota | Descrição |
|---|---|---|
| `GET` | `/clientes` | Health check simples (`"ok"`) |
| `POST` | `/clientes` | Cadastra um cliente |
| `GET` | `/clientes?cpf={cpf}` | Busca cliente pelo CPF |

Documentação interativa via Swagger disponível em `/swagger-ui.html` (springdoc-openapi).

## Dependências

- **Eureka** — se registra para ser descoberto pelo `msavaliadorcredito` (via Feign) e pelo `mscloudgateway`
- **MySQL** — persistência via Spring Data JPA + Hibernate

## Variáveis de ambiente

| Variável | Descrição | Exemplo |
|---|---|---|
| `EUREKA_SERVER` | Host do Eureka Server | `eurekaserver` |
| `MYSQL_SERVER` | Host do MySQL | `mysql` |
| `MYSQL_PORT` | Porta do MySQL | `3306` |
| `MYSQL_DATABASE` | Nome do banco | `msclientes_db` |
| `MYSQL_USER` | Usuário do banco | `msuser` |
| `MYSQL_PASSWORD` | Senha do banco | `mspassword` |

## Rodando via Docker Compose

Já está incluído no `docker-compose.yml` da raiz do projeto. Veja o [README geral](../README.md) para subir o ecossistema completo.

## Observação sobre a porta

O serviço sobe com `server.port=0` (porta aleatória) de propósito — ele não é acessado diretamente por porta fixa, só via descoberta no Eureka (Feign clients e o Gateway resolvem o endereço dinamicamente).
