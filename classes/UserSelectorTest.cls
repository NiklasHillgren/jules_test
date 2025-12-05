@IsTest
public with sharing class UserSelectorTest {
	@IsTest
	private static void testGetByIdSuccess() {
		Profile prof = ProfileSelector.getProfileByProfileName(ProfileConstants.SYSTEM_ADMINISTRATOR);
		User usr = testDataFactory.createUser('standt', prof.Id);
		/* Account account = testDataFactory.createAccountWithCVR('12345657');
		account.OwnerId = usr.Id;
		insert account; */

		Test.startTest();
		User u = new UserSelector().getById(usr.Id);
		Test.stopTest();

		Assert.isNotNull(u, 'A user should be returned');
	}

	@IsTest
	private static void testGetByIdNotFound() {
		Profile prof = ProfileSelector.getProfileByProfileName(ProfileConstants.SYSTEM_ADMINISTRATOR);
		User usr = testDataFactory.createUser('standt', prof.Id);

		Test.startTest();
		User notUser = new UserSelector().getById(StringUtils.makeRandomStringNoNumerics(10));
		Test.stopTest();

		Assert.isNull(notUser, 'A user should not be returned');
	}

}