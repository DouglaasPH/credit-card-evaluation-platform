# eurekaserver

Servidor de service discovery (Netflix Eureka) do ecossistema. Todos os outros serviços se registram aqui e o descobrem uns aos outros dinamicamente — ninguém depende de IP ou porta fixa.

## O que faz

- Mantém o registro de instâncias ativas de cada microsserviço (`msclientes`, `mscartoes`, `msavaliadorcredito`, `mscloudgateway`)
- Expõe um dashboard web para visualizar quem está registrado e com qual status
- Protegido por Basic Auth (usuário/senha fixos, definidos em `application.properties`) — os outros serviços já vêm configurados com essas credenciais embutidas na URL do Eureka client

## Configuração

| Propriedade | Valor |
|---|---|
| Porta | `8761` |
| Usuário | `curso-ms-eureka-user` |
| Senha | definida em `application.properties` |

> Essas credenciais estão hardcoded no `application.properties` só para fins de estudo/desenvolvimento local. Não use esse padrão em produção — mova para variáveis de ambiente/secrets.

## Rodando sozinho (sem Docker)

```bash
./mvnw spring-boot:run
```

Acesse o dashboard em `http://localhost:8761` (login com o usuário/senha acima).

## Rodando via Docker Compose

Já está incluído no `docker-compose.yml` da raiz do projeto. Veja o [README geral](../README.md) para subir o ecossistema completo.

## Variáveis de ambiente (Docker)

Nenhuma variável extra é necessária — o Eureka Server não depende de outro serviço para subir.
