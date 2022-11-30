package com.victoryw.maven.surefire.junit5.parallel.setting;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ParallelDemo2 {
    public long method() throws InterruptedException {
        log.debug("The method4 is run");
        Thread.currentThread().join(5*1000);
        log.debug("The method4 is run over");
        return 3;
    }

    public long method2() throws InterruptedException {
        log.debug("The method5 is run");
        Thread.currentThread().join(5*1000);
        log.debug("The method5 is run over");
        return 4;
    }

    public long method3() throws InterruptedException {
        log.debug("The method6 is run");
        Thread.currentThread().join(5*1000);
        log.debug("The method6 is run over");
        return 4;
    }
}
