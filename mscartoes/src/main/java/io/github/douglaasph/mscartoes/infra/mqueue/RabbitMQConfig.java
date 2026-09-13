package io.github.douglaasph.mscartoes.infra.mqueue;

import org.springframework.amqp.core.Queue;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@Configuration
public class RabbitMQConfig {
    @Bean
    public Queue emissaoCartaoQueue(@Value("${mq.queues.emissao-cartoes}") String queueName) {
        return new Queue(queueName, true);
    }
}
