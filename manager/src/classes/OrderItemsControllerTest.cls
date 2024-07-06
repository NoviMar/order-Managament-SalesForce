@isTest
public class OrderItemsControllerTest {

	@testSetup
	static void setup() {
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

		Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
		insert testProduct;

		Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

		PricebookEntry testPricebookEntry = new PricebookEntry(
				Pricebook2Id = standardPricebook.Id,
				Product2Id = testProduct.Id,
				UnitPrice = 100,
				IsActive = true
		);
		insert testPricebookEntry;

		Order testOrder = new Order(
				AccountId = testAccount.Id,
				Pricebook2Id = standardPricebook.Id,
				Status = 'Draft',
				EffectiveDate = System.today()
		);
		insert testOrder;
	}

	@isTest
	static void testCreateOrderItem() {
		Order testOrder = [SELECT Id FROM Order LIMIT 1];
		Product2 testProduct = [SELECT Id FROM Product2 LIMIT 1];
		Test.startTest();
		OrderItemsController.createOrderItem(testOrder.Id, testProduct.Id, 10, 100);
		Test.stopTest();
		OrderItem__c[] orderItems = [SELECT OrderId__c, ProductId__c, Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :testOrder.Id];
		System.assertEquals(1, orderItems.size(), 'Должен быть создан один элемент заказа');
		System.assertEquals(testOrder.Id, orderItems[0].OrderId__c, 'OrderId должен совпадать');
		System.assertEquals(testProduct.Id, orderItems[0].ProductId__c, 'ProductId должен совпадать');
		System.assertEquals(10, orderItems[0].Quantity__c, 'Quantity должен быть равен 10');
		System.assertEquals(100, orderItems[0].Price__c, 'Price должен быть равен 100');
	}

	@isTest
	static void testCreateOrderItemWithInvalidData() {
		Order testOrder = [SELECT Id FROM Order LIMIT 1];
		Product2 testProduct = [SELECT Id FROM Product2 LIMIT 1];
		Test.startTest();
		try {
			OrderItemsController.createOrderItem(null, testProduct.Id, 10, 100);
			System.assert(false, 'Ожидалось исключение при передаче null OrderId');
		} catch (Exception e) {
			System.assert(true, 'Исключение было выброшено как ожидалось');
		}

		try {
			OrderItemsController.createOrderItem(testOrder.Id, null, 10, 100);
			System.assert(false, 'Ожидалось исключение при передаче null ProductId');
		} catch (Exception e) {
			System.assert(true, 'Исключение было выброшено как ожидалось');
		}
		Test.stopTest();
	}
}