public class ContentDocumentLinkTriggerHandler extends TriggerHandler {


	private List<ContentDocumentLink> triggerNew;

	private final CaseService caseService;
	private final ContentDocumentLinkService contentDocumentLinkService;

	@TestVisible
    private ContentDocumentLinkTriggerHandler(ContentDocumentLinkService contentDocumentLinkService, CaseService caseService) {
        this.contentDocumentLinkService = contentDocumentLinkService;
		this.caseService = caseService;
    }

	public ContentDocumentLinkTriggerHandler() {
        this(SingletonFactory.getFactory());
    }

	private ContentDocumentLinkTriggerHandler(SingletonFactory singletonFactory) {
        this.contentDocumentLinkService = (ContentDocumentLinkService) singletonFactory.getOrRegisterSingleton(ContentDocumentLinkService.class);
       	this.caseService = (caseService) singletonFactory.getOrRegisterSingleton(CaseService.class);

		this.triggerNew = (List<ContentDocumentLink>) Trigger.new;
    }

	public override void afterInsert() {
		List<Id> caseIds = contentDocumentLinkService.getRelatedCasesByLinkedEntityIds(triggerNew);

		caseService.updateCustomerServiceCasesToAwaitingUser(caseIds);
	}
}