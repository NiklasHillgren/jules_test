/**
 * @description An interface for a factory that creates batch job instances.
 * This is used to allow for dependency  injection in tests.
 * @author Kenneth Houkjaer
 */
public interface IBatchJobFactory {
    
    /**
     * @description Creates an instance of a batch job.
     * @param jobName The name of the job class to instantiate.
     * @return An instance of a class that implements IBatchJob.
     */
    IBatchJob create(String jobName);
}