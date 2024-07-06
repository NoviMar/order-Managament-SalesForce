@isTest
public class OrderItemTriggerTest {

	@testSetup
	static void setup() {
		// Создаем тестовые данные для продуктов
		Product__c product1 = new Product__c(Name = 'Test Product 1', Price__c = 100);
		Product__c product2 = new Product__c(Name = 'Test Product 2', Price__c = 200);
		insert new List<Product__c>{ product1, product2 };
	}

	@isTest
	static void testOrderItemInsert() {
		// Создаем тестовый заказ
		Order__c order = new Order__c();
		insert order;

		// Создаем элементы заказа
		OrderItem__c orderItem1 = new OrderItem__c(OrderId__c = order.Id, ProductId__c = [SELECT Id FROM Product__c WHERE Name = 'Test Product 1' LIMIT 1].Id, Quantity__c = 2, Price__c = 100);
		OrderItem__c orderItem2 = new OrderItem__c(OrderId__c = order.Id, ProductId__c = [SELECT Id FROM Product__c WHERE Name = 'Test Product 2' LIMIT 1].Id, Quantity__c = 1, Price__c = 200);
		insert new List<OrderItem__c>{ orderItem1, orderItem2 };

		// Проверяем, что поля TotalProductCount__c и TotalPrice__c обновлены
		order = [SELECT TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id = :order.Id];
		System.assertEquals(3, order.TotalProductCount__c);
		System.assertEquals(400, order.TotalPrice__c);
	}

	@isTest
	static void testOrderItemUpdate() {
		// Создаем тестовый заказ
		Order__c order = new Order__c();
		insert order;

		// Создаем элемент заказа
		OrderItem__c orderItem = new OrderItem__c(OrderId__c = order.Id, ProductId__c = [SELECT Id FROM Product__c WHERE Name = 'Test Product 1' LIMIT 1].Id, Quantity__c = 2, Price__c = 100);
		insert orderItem;

		// Обновляем элемент заказа
		orderItem.Quantity__c = 3;
		update orderItem;

		// Проверяем, что поля TotalProductCount__c и TotalPrice__c обновлены
		order = [SELECT TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id = :order.Id];
		System.assertEquals(3, order.TotalProductCount__c);
		System.assertEquals(300, order.TotalPrice__c);
	}

	@isTest
	static void testOrderItemDelete() {
		// Создаем тестовый заказ
		Order__c order = new Order__c();
		insert order;

		// Создаем элемент заказа
		OrderItem__c orderItem = new OrderItem__c(OrderId__c = order.Id, ProductId__c = [SELECT Id FROM Product__c WHERE Name = 'Test Product 1' LIMIT 1].Id, Quantity__c = 2, Price__c = 100);
		insert orderItem;

		// Удаляем элемент заказа
		delete orderItem;

		// Проверяем, что поля TotalProductCount__c и TotalPrice__c обновлены
		order = [SELECT TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id = :order.Id];
		System.assertEquals(0, order.TotalProductCount__c);
		System.assertEquals(0, order.TotalPrice__c);
	}
}