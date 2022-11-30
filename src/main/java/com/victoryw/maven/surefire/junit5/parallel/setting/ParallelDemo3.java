package com.victoryw.maven.surefire.junit5.parallel.setting;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ParallelDemo3 {
    public long method() throws InterruptedException {
        log.debug("The method7 is run");
        Thread.currentThread().join(5*1000);
        log.debug("The method7 is run over");
        return 3;
    }

    public long method2() throws InterruptedException {
        log.debug("The method8 is run");
        Thread.currentThread().join(5*1000);
        log.debug("The method8 is run over");
        return 4;
    }

    public long method3() throws InterruptedException {
        log.debug("The method9 is run");
        Thread.currentThread().join(5*1000);
        log.debug("The method9 is run over");
        return 4;
    }
}
