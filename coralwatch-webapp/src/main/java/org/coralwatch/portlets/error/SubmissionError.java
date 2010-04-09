package org.coralwatch.portlets.error;

public class SubmissionError {
    private final String errorMessage;

    public SubmissionError(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getErrorMessage() {
        return this.errorMessage;
    }
}
