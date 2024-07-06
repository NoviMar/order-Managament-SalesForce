public with sharing class OrderItemTriggerHandler {
	@AuraEnabled
	public static void createOrderWithItems(List<Id> productIds, List<Integer> quantities, List<Decimal> prices) {
		// Проверка на null
		if (productIds == null || quantities == null || prices == null ||
				productIds.isEmpty() || quantities.isEmpty() || prices.isEmpty()) {
			throw new IllegalArgumentException('Некоторые параметры не заполнены или пусты.');
		}

		System.debug('Содержимое корзины: ' + productIds + ', ' + quantities + ', ' + prices);

		// Создание заказа
		Order__c newOrder = new Order__c();
		newOrder.Name = 'Заказ ' + Datetime.now().format('yyyyMMddHHmmss');
		insert newOrder;
		System.debug('Создан новый заказ: ' + newOrder.Id);

		// Создание элементов заказа
		List<OrderItem__c> orderItems = new List<OrderItem__c>();
		for (Integer i = 0; i < productIds.size(); i++) {
			OrderItem__c orderItem = new OrderItem__c();
			orderItem.OrderId__c = newOrder.Id;
			orderItem.ProductId__c = productIds[i];
			orderItem.Quantity__c = quantities[i];
			orderItem.Price__c = quantities[i] * prices[i];
			orderItems.add(orderItem);
		}
		insert orderItems;
		System.debug('Созданы элементы заказа: ' + orderItems);

		// Обновление заказа с общими значениями
		update newOrder;
		System.debug('Заказ обновлен: ' + newOrder);
	}
}