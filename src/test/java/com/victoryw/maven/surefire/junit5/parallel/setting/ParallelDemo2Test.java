package com.victoryw.maven.surefire.junit5.parallel.setting;

import lombok.val;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class ParallelDemo2Test {

    @Test
    void should_return_method_value() throws InterruptedException {
        val parallelDemo2 =new ParallelDemo2();
        assertEquals(3, parallelDemo2.method());
    }

    @Test
    void should_return_method2_value() throws InterruptedException {
        val parallelDemo2 =new ParallelDemo2();
        assertEquals(4, parallelDemo2.method2());
    }

    @Test
    void should_return_method3_value() throws InterruptedException {
        val parallelDemo2 =new ParallelDemo2();
        assertEquals(4, parallelDemo2.method3());
    }
}