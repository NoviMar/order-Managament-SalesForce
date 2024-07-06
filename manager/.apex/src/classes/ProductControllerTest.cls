@isTest
public class ProductControllerTest {

	@testSetup
	static void setup() {
		List<Product__c> products = new List<Product__c>();
		for (Integer i = 0; i < 5; i++) {
			products.add(new Product__c(
					Name = 'Product ' + i,
					Description__c = 'Description ' + i,
					Type__c = 'Type ' + (i / 2),
					Family__c = 'Family ' + i,
					Image__c = 'Image ' + i,
					Price__c = 10.0 * i
				));
		}
		insert products;
	}

	@isTest
	static void testGetFilteredProductsNoMatch() {
		List<Product__c> result = ProductController.getFilteredProducts('NonExistentType');

		System.assertEquals(0, result.size(), 'There should be no products with type NonExistentType');
	}

	@isTest
	static void testGetFilteredProductsEmptyString() {
		List<Product__c> result = ProductController.getFilteredProducts('');

		System.assertEquals(5, result.size(), 'There should be 5 products without a filter');
	}

	@isTest
	static void testGetFilteredProductsWhitespaceString() {
		List<Product__c> result = ProductController.getFilteredProducts(' ');

		System.assertEquals(5, result.size(), 'There should be 5 products without a filter');
	}
}