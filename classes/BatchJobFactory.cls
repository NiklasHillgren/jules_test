/**
 * @description The default factory for creating batch job instances.
 * @author Kenneth Houkjaer
 */
public class BatchJobFactory implements IBatchJobFactory {
    
    
    /**
     * @description Creates an instance of a batch job using Type.forName.
     * @param jobName The name of the job class to instantiate.
     * @return An instance of a class that implements IBatchJob.
     */
    public IBatchJob create(String jobName) {
        Type t = Type.forName(jobName);
        if (t != null) {
            return (IBatchJob) t.newInstance();
        }
        return null;
    }
}