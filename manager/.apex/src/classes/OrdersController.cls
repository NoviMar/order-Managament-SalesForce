public with sharing class OrdersController {
	@AuraEnabled
	public static Id createOrder(String productName, Integer totalProductCount, Integer totalPrice) {
		Order__c newOrder = new Order__c();

		newOrder.Name = 'Order - ' + productName;
		newOrder.TotalProductCount__c = totalProductCount;
		newOrder.TotalPrice__c = totalPrice;
		insert newOrder;
		return newOrder.Id;
	}
}