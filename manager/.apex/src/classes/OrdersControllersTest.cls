@isTest
public class OrdersControllersTest {
	@testSetup
	static void setup() {
		// Создание тестовых продуктов
		List<Product__c> products = new List<Product__c>();
		for (Integer i = 0; i < 3; i++) {
			products.add(new Product__c(
					Name = 'Test Product ' + i,
					Price__c = 100 * (i + 1),
					Image__c = 'https://example.com/image' + i + '.jpg' // Добавляем значение для поля Image__c
			));
		}
		insert products;
	}

	@isTest
	static void testCreateOrder() {
		// Получение тестовых продуктов
		List<Product__c> products = [SELECT Id, Price__c FROM Product__c LIMIT 3];

		// Создание элементов заказа
		List<OrderItem__c> orderItems = new List<OrderItem__c>();
		for (Product__c product : products) {
			orderItems.add(new OrderItem__c(ProductId__c = product.Id, Quantity__c = 2, Price__c = product.Price__c));
		}

		// Вызов метода createOrder
		Test.startTest();
		Id orderId = OrdersControllers.createOrder(orderItems);
		Test.stopTest();

		// Проверка, что заказ создан
		Order__c createdOrder = [SELECT Id, TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id = :orderId];
		System.assertNotEquals(null, createdOrder, 'Заказ должен быть создан');

		// Проверка, что элементы заказа созданы
		List<OrderItem__c> createdOrderItems = [SELECT Id, OrderId__c, ProductId__c, Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :orderId];
		System.assertEquals(3, createdOrderItems.size(), 'Должно быть 3 элемента заказа');

		// Проверка итоговых значений заказа
		Decimal expectedTotalQuantity = 6; // 3 элемента * 2 количество каждого
		Decimal expectedTotalPrice = 600; // (100 + 200 + 300) * 2

		System.assertEquals(expectedTotalQuantity, createdOrder.TotalProductCount__c, 'Общее количество продуктов должно быть правильным');
		System.assertEquals(expectedTotalPrice, createdOrder.TotalPrice__c, 'Общая цена должна быть правильной');
	}
}