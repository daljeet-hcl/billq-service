package com.demo.billq;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@Slf4j
public class BillqController {

  
    @GetMapping(value = "/billq/{id}",produces = MediaType.APPLICATION_JSON_VALUE)
    public Mono<String> getCustomerOrderBillq(@PathVariable String id){
        //log.info("BillqController");

        Mono<String> billq = Mono.just(System.getenv("price"));

        return billq;

    }
}
