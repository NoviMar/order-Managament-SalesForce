public with sharing class ProductController {
	@AuraEnabled(cacheable=true)
	public static List<Product__c> getAllProducts() {
		return [SELECT Id, Name, Description__c, Type__c, Family__c, Image__c, Price__c FROM Product__c];
	}
}