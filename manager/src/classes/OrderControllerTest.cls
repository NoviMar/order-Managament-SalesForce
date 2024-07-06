@isTest
public class OrderControllerTest {

	@testSetup
	static void setup() {
		List<Product__c> products = new List<Product__c>();
		for (Integer i = 0; i < 3; i++) {
			products.add(new Product__c(
					Name = 'Product ' + i,
					Price__c = 100 + i
			));
		}
		insert products;
	}

	@isTest
	static void testSaveOrder() {
		List<Product__c> products = [SELECT Id, Price__c FROM Product__c LIMIT 3];
		List<Id> productIds = new List<Id>();
		List<Decimal> prices = new List<Decimal>();

		for (Product__c product : products) {
			productIds.add(product.Id);
			prices.add(product.Price__c);
		}

		Test.startTest();
		OrderController.saveOrder(productIds, prices);
		Test.stopTest();

		Order__c newOrder = [SELECT Id, Name, AccountId__c, TotalProductCount__c, TotalPrice__c FROM Order__c LIMIT 1];
		System.assertNotEquals(null, newOrder, 'Order should not be null');
		System.assertEquals('New Order', newOrder.Name, 'Order Name should be "New Order"');
		System.assertEquals(UserInfo.getUserId(), newOrder.AccountId__c, 'Order AccountId should match the current user ID');
		System.assertEquals(3, newOrder.TotalProductCount__c, 'TotalProductCount should be 3');
		System.assertEquals(300, newOrder.TotalPrice__c, 'TotalPrice should be the sum of product prices');

		List<OrderItem__c> orderItems = [SELECT Id, OrderId__c, ProductId__c, Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :newOrder.Id];
		System.assertEquals(3, orderItems.size(), 'There should be 3 order items');
		for (Integer i = 0; i < orderItems.size(); i++) {
			System.assertEquals(newOrder.Id, orderItems[i].OrderId__c, 'OrderItem OrderId should match the new order ID');
			System.assertEquals(productIds[i], orderItems[i].ProductId__c, 'OrderItem ProductId should match the product ID');
			System.assertEquals(1, orderItems[i].Quantity__c, 'OrderItem Quantity should be 1');
			System.assertEquals(prices[i], orderItems[i].Price__c, 'OrderItem Price should match the product price');
		}
	}

	@isTest
	static void testSaveOrderWithMismatchedLists() {
		List<Id> productIds = new List<Id>{'001000000000001', '001000000000002'};
		List<Decimal> prices = new List<Decimal>{100};

		try {
			Test.startTest();
			OrderController.saveOrder(productIds, prices);
			Test.stopTest();
			System.assert(false, 'Expected IllegalArgumentException was not thrown');
		} catch (IllegalArgumentException e) {
			System.assertEquals('Product IDs and prices lists must have the same size', e.getMessage(), 'Exception message should match');
		}
	}
}