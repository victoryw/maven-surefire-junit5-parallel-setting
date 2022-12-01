#From JUnit Platform does not support running tests in parallel.
maven-surefire-parallel-thread-execution:
	./mvnw -e test -Dorg.slf4j.simpleLogger.showThreadName=true -Dparallel=method -DuseUnlimitedThreads=true

#maven surefire parallel fork process
forked-test-execution:
	./mvnw -e test -Dorg.slf4j.simpleLogger.showThreadName=true -DforkCount=2 -DreuseForks=false