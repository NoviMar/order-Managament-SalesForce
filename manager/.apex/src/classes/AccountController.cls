public with sharing class AccountController {
	@AuraEnabled(cacheable=true)
	public static Account getAccount(Id accountId) {
		return [SELECT Id, Name FROM Account WHERE Id = :accountId LIMIT 1];
	}
}
