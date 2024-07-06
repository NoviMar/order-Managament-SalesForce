public with sharing class OrdersControllers {
	@AuraEnabled
	public static Id createOrder(List<OrderItem__c> orderItems) {
		Order__c newOrder = new Order__c();
		insert newOrder;

		for (OrderItem__c item : orderItems) {
			item.OrderId__c = newOrder.Id;
		}
		insert orderItems;

		return newOrder.Id;
	}
}