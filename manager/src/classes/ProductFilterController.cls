public with sharing class ProductFilterController {

	@AuraEnabled(cacheable=true)
	public static List<Product__c> getFilteredProducts(String typeFilter, String filterFilter) {
		String query = 'SELECT Id, Name, Type__c, Filter__c FROM Product__c WHERE ';

		if (typeFilter != null) {
			query += 'Type__c = \'' + String.escapeSingleQuotes(typeFilter) + '\'';
		}

		if (filterFilter != null) {
			if (typeFilter != null) {
				query += ' AND ';
			}
			query += 'Filter__c = \'' + String.escapeSingleQuotes(filterFilter) + '\'';
		}

		return Database.query(query);
	}

}
