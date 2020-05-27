package com.demo.billq;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class Test1 {

    @Autowired
    Test2 test2;

    public void test(){
        System.out.println("hello");
        test2.test();
    }
}
