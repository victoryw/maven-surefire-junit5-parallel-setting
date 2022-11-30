package com.victoryw.maven.surefire.junit5.parallel.setting;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ParallelDemo1 {
    public long method() throws InterruptedException {
        log.debug("The method is run");
        Thread.currentThread().join(5*1000);
        log.debug("The method is run over");
        return 1;
    }

    public long method2() throws InterruptedException {
        log.debug("The method2 is run");
        Thread.currentThread().join(5*1000);
        log.debug("The method2 is run over");
        return 2;
    }

    public long method3() throws InterruptedException {
        log.debug("The method3 is run");
        Thread.currentThread().join(5*1000);
        log.debug("The method3 is run over");
        return 2;
    }
}
