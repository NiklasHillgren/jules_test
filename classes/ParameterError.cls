/**
 * represents an input paramter error
 * @log:
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth H. Pedersen  09/01/2023      Initial version with GET
 *
 * From the guidelines of IETF devised RFC 7807, which creates a generalized error-handling schema.
 * https://tools.ietf.org/html/rfc7807
 *
 * Consumers MUST use the "type" string as the primary identifier for
 * the problem type; the "title" string is advisory and included only
 * for users who are not aware of the semantics of the URI and do not
 * have the ability to discover them (e.g., offline log analysis).
 * Consumers SHOULD NOT automatically dereference the type URI.
 *
 *
 * The "detail" member, if present, ought to focus on helping the client
 * correct the problem, rather than giving debugging information.
 * Consumers SHOULD NOT parse the "detail" member for information;
 * extensions are more suitable and less error-prone ways to obtain such
 * information.
 *
 * Note that both "type" and "instance" accept relative URIs; this means
 * that they must be resolved relative to the document's base URI, as
 * per [RFC3986], Section 5.
 *
 * @author Kenneth H. Pedersen
 * @date 09/01/2023
 */
public class ParameterError{
    /*
    "type" (string) - A URI reference [RFC3986] that identifies the
      problem type.  This specification encourages that, when
      dereferenced, it provide human-readable documentation for the
      problem type (e.g., using HTML [W3C.REC-html5-20141028]).  When
      this member is not present, its value is assumed to be
      "about:blank".
    */
    //public String type;

    /*
    "title" (string) - A short, human-readable summary of the problem
      type.  It SHOULD NOT change from occurrence to occurrence of the
      problem, except for purposes of localization (e.g., using
      proactive content negotiation; see [RFC7231], Section 3.4).
    */
    //public String title;

    public String parameterName;

    /*
    "detail" (string) - A human-readable explanation specific to this
      occurrence of the problem.
    */
    public String reason;

    public String exceptionSeverityName;

    public String uniqueErrorIdentifier;

    /*
    "instance" (string) - A URI reference that identifies the specific
      occurrence of the problem.  It may or may not yield further
      information if dereferenced.
    */
    //public String instance;

    public ParameterError(String parameterName, String reason){
        this(parameterName, reason, null, null);
    }

    public ParameterError(String parameterName, String reason, String exceptionSeverityName, String uniqueErrorIdentifier){
        this.parameterName = parameterName;
        this.reason = reason;
        this.exceptionSeverityName = exceptionSeverityName;
        this.uniqueErrorIdentifier = uniqueErrorIdentifier;
    }
}