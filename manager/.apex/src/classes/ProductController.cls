public with sharing class ProductController {
	@AuraEnabled(cacheable=true)
	public static List<Product__c> getAllProducts() {
		return [SELECT Id, Name, Description__c, Type__c, Family__c, Price__c, Image__c FROM Product__c];
	}

	@AuraEnabled
	public static void saveProduct(String name, String description, String type, String family, String image, Decimal price) {
		try {
			List<String> validTypes = new List<String>{'first Example', 'second Example', 'third Example'};
			List<String> validFamilies = new List<String>{'first Example', 'second Example', 'third Example'};

			if (!validTypes.contains(type)) {
				throw new AuraHandledException('Некорректное значение для типа.');
			}

			if (!validFamilies.contains(family)) {
				throw new AuraHandledException('Некорректное значение для семейства.');
			}

			Product__c product = new Product__c(
					Name = name,
					Name__c = name,
					Description__c = description,
					Type__c = type,
					Family__c = family,
					Image__c = image,
					Price__c = price
			);
			insert product;
		} catch (Exception e) {
			System.debug('Exception: ' + e.getMessage());
			throw new AuraHandledException('Ошибка при сохранении продукта: ' + e.getMessage());
		}
	}
}