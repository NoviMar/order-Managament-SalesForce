public with sharing class filerProductController {
	@AuraEnabled(cacheable=true)
	public static List<Product__c> filterProducts(String typeFilter, String familyFilter) {
		String query = 'SELECT Name__c, Description__c, Type__c, Family__c FROM Product__c' +
				'WHERE Type = :typeFilter AND Family = :familyFilter';

		return Database.query(query);
	}
}