package com.demo.billq;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class Test2 {

    @Autowired
    Test3 test;

    public void test(){
        System.out.println("hello");
        test.test();
    }
}
