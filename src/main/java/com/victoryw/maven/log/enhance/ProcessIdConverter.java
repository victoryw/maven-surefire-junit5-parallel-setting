package com.victoryw.maven.log.enhance;

import ch.qos.logback.classic.pattern.ClassicConverter;
import ch.qos.logback.classic.spi.ILoggingEvent;

public class ProcessIdConverter extends ClassicConverter {
    @Override
    public String convert(final ILoggingEvent event) {
        return String.valueOf(ProcessHandle.current().pid());
    }
}
