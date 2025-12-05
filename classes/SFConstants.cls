@IsTest
public with sharing class SFConstants {
    //NUMBER RESERVATION CONSTANTS
    public static final String DEFAULT_OPENSERIES_PRODUCTGROUP = 'P';
    public static final String DEFAULT_OPENSERIES_NUMBERLOCATION = 'EKC';
    public static final String DEFAULT_OPENSERIES_PRODUCTTYPE = 'GSM';

    //NUMBER RESERVATION EXECUTORS
    public static final String NUMBER_ACTIVATION_LINES_EXECUTOR_HANDLER = 'NumberActivationLinesExecutorHandler';  // TO BE DELETED
    public static final String NUMBER_ASSIGNMENT_RESET_EXECUTOR_HANDLER = 'NumberAssignmentResetExecutorHandler';
    public static final String NUMBER_RESERVATION_EXECUTOR_HANDLER = 'NumberReservationExecutorHandler';
    public static final String NUMBER_CASE_EXECUTOR_HANDLER = 'NumberCaseExecutorHandler';

    //NUMBER RESERVATION CTN STATUS
    public static final String ASSIGNED_AVAILABLE = 'AA';
    public static final String ASSIGNED_RESERVED = 'AR';
    public static final String ASSIGNED_INUSE = 'AI';
    public static final String ASSIGNED_SUSPENDED = 'AS';
    
    //SHARED CONSTANTS
    public static final String SUCCESS = 'Success';
    public static final String ERROR = 'Error';
    public static final STring INPROGRESS = 'INPROGRESS';
    
}