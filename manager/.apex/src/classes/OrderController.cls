public with sharing class OrderController {
	@AuraEnabled
	public static Order__c createOrder(String productName, Integer totalProductCount, Integer totalPrice) {
		Order__c newOrder = new Order__c();
		newOrder.Name = productName;
		newOrder.TotalProductCount__c = totalProductCount;
		newOrder.TotalPrice__c = totalPrice;

		// Сохранить новый заказ
		insert newOrder;

		// Возвратить созданный заказ
		return newOrder;
	}
}