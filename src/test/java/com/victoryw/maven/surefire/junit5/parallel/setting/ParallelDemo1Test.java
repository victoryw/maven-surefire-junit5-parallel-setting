package com.victoryw.maven.surefire.junit5.parallel.setting;

import lombok.val;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ParallelDemo1Test {

    @Test
    void should_return_method_value() throws InterruptedException {
        val ParallelDemo1 =new ParallelDemo1();
        assertEquals(1, ParallelDemo1.method());
    }

    @Test
    void should_return_method2_value() throws InterruptedException {
        val ParallelDemo1 =new ParallelDemo1();
        assertEquals(2, ParallelDemo1.method2());
    }

    @Test
    void should_return_method3_value() throws InterruptedException {
        val ParallelDemo1 =new ParallelDemo1();
        assertEquals(2, ParallelDemo1.method2());
    }
}