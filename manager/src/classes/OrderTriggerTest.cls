@isTest
public class OrderTriggerTest {
	@isTest
	static void testOrderTrigger() {
		// Создаем тестовый заказ
		Order__c testOrder = new Order__c(Name = 'Test Order');
		insert testOrder;

		// Создаем тестовые позиции заказа
		OrderItem__c item1 = new OrderItem__c(OrderId__c = testOrder.Id, Quantity__c = 2, Price__c = 10);
		OrderItem__c item2 = new OrderItem__c(OrderId__c = testOrder.Id, Quantity__c = 3, Price__c = 20);
		insert new List<OrderItem__c> { item1, item2 };

		// Обновляем заказ, чтобы триггер сработал
		update testOrder;

		// Обновляем данные заказа из базы данных
		testOrder = [SELECT TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id = :testOrder.Id];

		// Проверяем, что триггер правильно посчитал количество продуктов и общую цену
		System.assertEquals(5, testOrder.TotalProductCount__c);
		System.assertEquals(80, testOrder.TotalPrice__c);
	}
}