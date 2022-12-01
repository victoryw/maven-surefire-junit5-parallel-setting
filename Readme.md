# java 测试并行的几种方法
## TLDR

本文说明了

* 通过`maven surefire`可以通过`fork test execution`使用多进程的方式并行执行java测试
* 及`junit5`通过 `junit.jupiter.execution.parallel`使用线程的方式并行执行java测试
* 以及`maven fork test execution` 和 `junit.jupiter.execution.parallel`同时使用会对测试方法级别的并发产生不同的影响

![image](imgs/java-parallel-setting.png)

## maven surefire 的 fork test execution

### maven surefire 并行测试的历史和现状

`maven surefire` 本身提供了两种并行执行测试的模式： 多线程模式的`parallel test execution` 和 多进程模式的`fork test execution`。`parallel test execution` 需要依赖测试套件（例如：TestNG、Junit）来实现，但是最近的 `Junit 5`已经[不再支持 `parallel test execution` ](https://maven.apache.org/surefire/maven-surefire-plugin/examples/junit-platform.html#running-tests-in-parallel)  
**示例**：执行 `make maven-surefire-parallel-thread-execution`   
虽然我在这个示例中配置了`parallel=method`但是我们看到测试实际是依次运行的
``` shell
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[57722]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run
[57722]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run over
[57722]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run
[57722]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run over
[57722]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run
[57722]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run over
[ThreadedStreamConsumer] [INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 15.135 s - in com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo3Test

```

### fork test execution的执行过程

`maven surefire` 执行 `fork test execution`：
1. 根据 `forkCount` 启动 N 个 `JVM` 进程
2. `maven surefire` 将 一个 `testClass` 放入 一个 进程中运行测试

**示例**： 执行 `make forked-test-execution`, 首先在不同进程(59338,59339)中同时开始执行了两个测试类（`ParallelDemo1Test`, `ParallelDemo3Test`）的用例；在之前的测试类执行完毕后，在进程（59436）中执行 `ParallelDemo2Test`测试类的用例

``` shell
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo3Test
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[59338]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run
[59339]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method8 is run
[59338]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run over
[59339]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method8 is run over
[59338]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method3 is run
[59339]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method9 is run
[59338]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method3 is run over
[59338]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run
[59339]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method9 is run over
[59339]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method7 is run
[59338]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run over
[59339]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method7 is run over
[ThreadedStreamConsumer] [INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 15.127 s - in com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo3Test
[ThreadedStreamConsumer] [INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 15.126 s - in com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo2Test
[59436]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo2 - The method5 is run
[59436]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo2 - The method5 is run over
[59436]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo2 - The method6 is run
[59436]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo2 - The method6 is run over
[59436]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo2 - The method4 is run
[59436]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo2 - The method4 is run over
[ThreadedStreamConsumer] [INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 15.125 s - in com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo2Test

```

### reuseForks 的配置

`reuseForks` 是用来配置新的测试类在执行测试时候是否复用已有的测试进程，可以减少资源浪费和进程间的冲突  

**示例**：`make forked-test-execution-reuse-forks`，可以看到执行 `ParallelDemo2`的测试用例时，复用了已有的进程64186
``` shell
[64186]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method7 is run over
[64185]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run over
[ThreadedStreamConsumer] [INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 15.141 s - in com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo3Test
[ThreadedStreamConsumer] [INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 15.141 s - in com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo2Test
[64186]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo2 - The method5 is run
```


## junit5 的 junit.jupiter.execution.parallel
`junit5` 通过对 `junit.jupiter.execution.parallel`下的参数进行设置，从而实现方法级、类级的并行测试。
这里重点说明三个参数，以及三个参数间的互相作用：

* `junit.jupiter.execution.parallel.enabled`  
当`enabled`为`true`时，意味着开启多线程测试；为`false`时则是只用单行程运行测试
* `junit.jupiter.execution.parallel.mode.default`  
当`enabled`为`true`时，`mode.default`设置为`same_thread`，则一个类内的测试用例是在同单线程串行执行；`mode.default`设置为`CONCURRENT`多线程并行执行
* `junit.jupiter.execution.parallel.mode.classes.default`  
当`enabled`为`true`时，`mode.classes.default`设置为`same_thread`，则所有的测试类在串行启动；`mode.classes.default`设置为`CONCURRENT`则所有的测试类在并行启动

### 三个参数的不同组合
### junit.jupiter.execution.parallel.enabled 的全局控制
当`enabled`为`false`时，则无论其他两个参数如何设置，测试用例为串行执行  
**示例：** `make junit-disable-parallel-method`, 则所有的测试用例串行执行：

``` shell
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[67577]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run 
[67577]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run over 
[67577]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method3 is run 
[67577]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method3 is run over 
[67577]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run 
[67577]-[main] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run over 
[ThreadedStreamConsumer] [INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 15.123 s - in com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo3Test
```
### mode.default 和 mode.classes.default 的协作
根据对 `mode.default` 和 `mode.classes.default` 的不同设置，测试用例的执行情况如下图（来自 Junit 5 官网）：
![image](https://junit.org/junit5/docs/current/user-guide/images/writing-tests_execution_mode.svg)

#### mode.default 为 same_thread， mode.classes.default 为 concurrent 时
**示例：** `make junit-enable-concurrent-class-same-thread-method`, 很奇怪这个执行和上图的说明并不一样  
实际上是，测试类依次串行执行：

``` shell
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[68062]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run 
[68062]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run over 
[68062]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method3 is run 
[68062]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method3 is run over 
[68062]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run 
[68062]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run over 
[ThreadedStreamConsumer] [INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 15.125 s - in com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo3Test
[68088]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method8 is run 
[68088]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method8 is run over 
[68088]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method9 is run 
[68088]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method9 is run over 
[68088]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method7 is run 
[68088]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method7 is run over 
[ThreadedStreamConsumer] [INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 15.134 s - in com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo3Test
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo2Test
[68106]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo2 - The method5 is run 
[68106]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo2 - The method5 is run over 
```

#### mode.default 为 concurrent， mode.classes.default 为 same_thread 时
**示例：** `make junit-enable-same-thread-class-concurrent-method`, 此时测试类依次执行，但是每个测试的测试方法并行执行

``` shell
ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[68300]-[ForkJoinPool-1-worker-2] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run 
[68300]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run 
[68300]-[ForkJoinPool-1-worker-3] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method3 is run 
[68300]-[ForkJoinPool-1-worker-3] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method3 is run over 
[68300]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method is run over 
[68300]-[ForkJoinPool-1-worker-2] DEBUG c.v.m.s.j.p.setting.ParallelDemo1 - The method2 is run over 
[ThreadedStreamConsumer] [INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 5.115 s - in com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo1Test
[ThreadedStreamConsumer] [INFO] Running com.victoryw.maven.surefire.junit5.parallel.setting.ParallelDemo3Test
[68310]-[ForkJoinPool-1-worker-2] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method8 is run 
[68310]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method7 is run 
[68310]-[ForkJoinPool-1-worker-3] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method9 is run 
[68310]-[ForkJoinPool-1-worker-2] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method8 is run over 
[68310]-[ForkJoinPool-1-worker-1] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method7 is run over 
[68310]-[ForkJoinPool-1-worker-3] DEBUG c.v.m.s.j.p.setting.ParallelDemo3 - The method9 is run over 
```
## 联合应用 fork test execution 和 junit.jupiter.execution.parallel

## 代码库的简单说明
