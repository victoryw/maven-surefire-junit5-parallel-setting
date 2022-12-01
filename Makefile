#From JUnit Platform does not support running tests in parallel.
maven-surefire-parallel-thread-execution:
	./mvnw -e test -Dorg.slf4j.simpleLogger.showThreadName=true -Dparallel=method -DuseUnlimitedThreads=true

#maven surefire parallel fork process
forked-test-execution:
	./mvnw -e test -Dorg.slf4j.simpleLogger.showThreadName=true -DforkCount=2 -DreuseForks=false

forked-test-execution-reuse-forks:
	./mvnw -e test -Dorg.slf4j.simpleLogger.showThreadName=true -DforkCount=2 -DreuseForks=true

#Junit 5 parallel test
junit-disable-parallel-method:
	./mvnw -e test -Dorg.slf4j.simpleLogger.showThreadName=true \
 		-Djunit.jupiter.execution.parallel.enabled=false \
 		-Djunit.jupiter.execution.parallel.mode.default=CONCURRENT \
 		-Djunit.jupiter.execution.parallel.mode.classes.default=CONCURRENT

junit-enable-concurrent-class-same-thread-method:
	./mvnw -e test -Dorg.slf4j.simpleLogger.showThreadName=true \
 		-Djunit.jupiter.execution.parallel.enabled=true \
 		-Djunit.jupiter.execution.parallel.mode.default=same_thread \
 		-Djunit.jupiter.execution.parallel.mode.classes.default=concurrent

junit-enable-same-thread-class-concurrent-method:
	./mvnw -e test -Dorg.slf4j.simpleLogger.showThreadName=true \
 		-Djunit.jupiter.execution.parallel.enabled=true \
 		-Djunit.jupiter.execution.parallel.mode.default=concurrent \
 		-Djunit.jupiter.execution.parallel.mode.classes.default=same_thread

#Junit5 parallel mix with maven surefire fork text execution
maven-surefire-fork-count-2-reuseForks-junit-enable-concurrent-class-concurrent-method:
		./mvnw -e test -DforkCount=2 -DreuseForks=true \
			-Dorg.slf4j.simpleLogger.showThreadName=true \
     		-Djunit.jupiter.execution.parallel.enabled=true \
     		-Djunit.jupiter.execution.parallel.mode.default=CONCURRENT \
     		-Djunit.jupiter.execution.parallel.mode.classes.default=CONCURRENT

maven-surefire-fork-count-2-not-reuseForks-junit-enable-concurrent-class-concurrent-method:
		./mvnw -e test -DforkCount=2 -DreuseForks=false \
			-Dorg.slf4j.simpleLogger.showThreadName=true \
     		-Djunit.jupiter.execution.parallel.enabled=true \
     		-Djunit.jupiter.execution.parallel.mode.default=CONCURRENT \
     		-Djunit.jupiter.execution.parallel.mode.classes.default=CONCURRENT

maven-surefire-fork-count-2-reuseForks-junit-enable-same_thread-class-concurrent-method:
		./mvnw -e test -DforkCount=2 -DreuseForks=true \
			-Dorg.slf4j.simpleLogger.showThreadName=true \
     		-Djunit.jupiter.execution.parallel.enabled=true \
     		-Djunit.jupiter.execution.parallel.mode.default=CONCURRENT \
     		-Djunit.jupiter.execution.parallel.mode.classes.default=same_thread

maven-surefire-fork-count-2-reuseForks-junit-enable-concurrent-class-same_thread-method:
		./mvnw -e test -DforkCount=2 -DreuseForks=true \
			-Dorg.slf4j.simpleLogger.showThreadName=true \
     		-Djunit.jupiter.execution.parallel.enabled=true \
     		-Djunit.jupiter.execution.parallel.mode.default=same_thread \
     		-Djunit.jupiter.execution.parallel.mode.classes.default=concurrent

maven-surefire-fork-count-2-reuseForks-junit-enable-same_thread-class-same_thread-method:
		./mvnw -e test -DforkCount=2 -DreuseForks=true \
			-Dorg.slf4j.simpleLogger.showThreadName=true \
     		-Djunit.jupiter.execution.parallel.enabled=true \
     		-Djunit.jupiter.execution.parallel.mode.default=same_thread \
     		-Djunit.jupiter.execution.parallel.mode.classes.default=same_thread
