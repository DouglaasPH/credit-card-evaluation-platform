# mscloudgateway

API Gateway do ecossistema, construído com Spring Cloud Gateway. É a única porta de entrada pública — todo o tráfego externo passa por aqui, que valida autenticação e roteia para o microsserviço correto.

## O que faz

- Expõe um único ponto de entrada HTTP para todos os microsserviços
- Roteia requisições automaticamente com base no nome do serviço registrado no Eureka (`discovery locator`) — não precisa configurar rota manualmente para cada serviço novo
- Valida tokens JWT emitidos pelo Keycloak (OAuth2 Resource Server) antes de deixar a requisição passar adiante

## Como o roteamento funciona

Com `discovery.locator.enabled=true`, uma requisição para:

```
http://localhost:9000/msclientes/clientes?cpf=12345678900
```

é automaticamente roteada para o serviço `msclientes` registrado no Eureka (o nome do serviço vira o primeiro segmento da URL, em minúsculas).

## Autenticação

Este serviço valida o token JWT usando o `issuer-uri` do realm `mscourserealm` no Keycloak. Requisições sem um token válido são rejeitadas antes de chegar aos microsserviços internos.

> **Atenção ao issuer do token:** o `iss` do JWT precisa bater exatamente com o `issuer-uri` configurado aqui (`http://keycloak:8080/realms/mscourserealm` dentro da rede Docker). Se você autenticar contra o Keycloak usando um host/porta diferente do que os containers enxergam entre si, a validação falha. Veja a seção sobre isso no [README geral](../README.md).

## Dependências

- **Eureka** — descobre os microsserviços disponíveis para rotear
- **Keycloak** — valida os tokens JWT das requisições

## Variáveis de ambiente

| Variável | Descrição | Exemplo |
|---|---|---|
| `EUREKA_SERVER` | Host do Eureka Server | `eurekaserver` |
| `KEYCLOAK_SERVER` | Host do Keycloak | `keycloak` |
| `KEYCLOAK_PORT` | Porta interna do Keycloak | `8080` |

## Porta

Internamente roda na porta `8080`. No `docker-compose.yml` é publicada como `9000` no host, para não conflitar com a porta do Keycloak.

## Rodando via Docker Compose

Já está incluído no `docker-compose.yml` da raiz do projeto. Veja o [README geral](../README.md) para subir o ecossistema completo.
