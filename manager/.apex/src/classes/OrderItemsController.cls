public with sharing class OrderItemsController {
	@AuraEnabled
	public static void createOrderItem(Id orderId, Id productId, Integer quantity, Integer price) {
		OrderItem__c newOrderItem = new OrderItem__c();
		newOrderItem.OrderId__c = orderId;
		newOrderItem.ProductId__c = productId;
		newOrderItem.Quantity__c = quantity;
		newOrderItem.Price__c = price;

		insert newOrderItem;
	}
}