package com.victoryw.maven.surefire.junit5.parallel.setting;

import lombok.val;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class ParallelDemo3Test {

    @Test
    void should_return_method_value() throws InterruptedException {
        val parallelDemo3 =new ParallelDemo3();
        assertEquals(3, parallelDemo3.method());
    }

    @Test
    void should_return_method2_value() throws InterruptedException {
        val parallelDemo3 =new ParallelDemo3();
        assertEquals(4, parallelDemo3.method2());
    }

    @Test
    void should_return_method3_value() throws InterruptedException {
        val parallelDemo3 =new ParallelDemo3();
        assertEquals(4, parallelDemo3.method3());
    }
}