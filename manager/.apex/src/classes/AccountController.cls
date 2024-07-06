// AccountController.cls
public with sharing class AccountController {
	@AuraEnabled(cacheable=true)
	public static User getUserInfo() {
		return [
				SELECT Id, Name, IsManager__c
				FROM User
				WHERE Id = :UserInfo.getUserId()
		];
	}
}