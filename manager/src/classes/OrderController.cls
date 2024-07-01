public class OrderController {
	@AuraEnabled
	public static void recalculateOrderTotals(Id orderId) {
		// Запрашиваем заказ и связанные с ним элементы заказа
		Order__c order = [SELECT Id, (SELECT Id FROM OrderItems__r) FROM Order__c WHERE Id = :orderId LIMIT 1];

		// Запрашиваем все связанные OrderItem__c
		List<OrderItem__c> orderItems = [SELECT Id FROM OrderItem__c WHERE Order__c = :orderId];

		// Обновляем все OrderItem__c
		if (!orderItems.isEmpty()) {
			update orderItems;
		}

		// Обновляем заказ, чтобы триггер пересчитал значения
		update order;
	}
}
