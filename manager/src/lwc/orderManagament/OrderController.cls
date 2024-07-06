public with sharing class OrderController {
	@AuraEnabled
	public static void saveOrder(List<Id> productIds, List<Decimal> prices) {
		if (productIds.size() != prices.size()) {
			throw new IllegalArgumentException('Product IDs and prices lists must have the same size');
		}

		// Создание новой записи Order__c
		Order__c newOrder = new Order__c();
		newOrder.Name = 'New Order';
		newOrder.AccountId__c = UserInfo.getUserId(); // Предполагается, что текущий пользователь - это аккаунт
		newOrder.TotalProductCount__c = productIds.size();
		newOrder.TotalPrice__c = 0;

		// Вставка записи Order__c
		insert newOrder;

		// Создание записей OrderItem__c
		List<OrderItem__c> orderItems = new List<OrderItem__c>();
		for (Integer i = 0; i < productIds.size(); i++) {
			OrderItem__c orderItem = new OrderItem__c();
			orderItem.OrderId__c = newOrder.Id;
			orderItem.ProductId__c = productIds[i];
			orderItem.Quantity__c = 1; // Предполагается, что количество равно 1 для простоты
			orderItem.Price__c = prices[i];
			orderItems.add(orderItem);

			// Обновление общей цены
			newOrder.TotalPrice__c += prices[i];
		}

		// Вставка записей OrderItem__c
		insert orderItems;

		// Обновление записи Order__c с общей ценой
		update newOrder;
	}
}