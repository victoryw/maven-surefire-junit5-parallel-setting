# java 测试并行的几种方法
## TLDR

本文说明了

* 通过`maven surefire`可以通过`fork test execution`使用多进程的方式并行执行java测试
* 及`junit5`通过 `junit.jupiter.execution.parallel`使用线程的方式并行执行java测试
* 以及`maven fork test execution` 和 `junit.jupiter.execution.parallel`同时使用会对测试方法级别的并发产生不同的影响

<img src="imgs/java-parallel-setting.png">

## maven surefire 的 fork test execution

### maven surefire 并行测试的历史和现状

`maven surefire` 本身提供了两种并行执行测试的模式： 多线程模式的`parallel test execution` 和 多进程模式的`fork test execution`。`parallel test execution` 需要依赖测试套件（例如：TestNG、Junit）来实现，但是最近的 `Junit 5`已经[不再支持 `parallel test execution` ](https://maven.apache.org/surefire/maven-surefire-plugin/examples/junit-platform.html#running-tests-in-parallel)  
**示例**：执行 `make maven-surefire-parallel-thread-execution`

## junit5 的 junit.jupiter.execution.parallel

## 联合应用 fork test execution 和 junit.jupiter.execution.parallel

## 代码库的简单说明
