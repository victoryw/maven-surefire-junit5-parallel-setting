#From JUnit Platform does not support running tests in parallel.
maven-surefire-parallel-thread-execution:
	./mvnw -e test -Dorg.slf4j.simpleLogger.showThreadName=true -Dparallel=method -DuseUnlimitedThreads=true