@isTest
public class AccountControllerTest {

	@testSetup
	static void setup() {

		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User testUser = new User(
				Alias = 'testuser',
				Email = 'testuser@example.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Test',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				ProfileId = p.Id,
				TimeZoneSidKey = 'America/Los_Angeles',
				UserName = 'testuser@example.com',
				IsManager__c = true
		);
		insert testUser;
	}

	@isTest
	static void testGetUserInfo() {
		User testUser = [SELECT Id FROM User WHERE UserName = 'testuser@example.com' LIMIT 1];

		System.runAs(testUser) {
			Test.startTest();
			User result = AccountController.getUserInfo();
			Test.stopTest();

			System.assertNotEquals(null, result, 'Метод должен вернуть пользователя');
			System.assertEquals(testUser.Id, result.Id, 'Id пользователя должен совпадать');
			System.assertEquals(testUser.Name, result.Name, 'Имя пользователя должно совпадать');
			System.assertEquals(testUser.IsManager__c, result.IsManager__c, 'Поле IsManager__c должно совпадать');
		}
	}
}