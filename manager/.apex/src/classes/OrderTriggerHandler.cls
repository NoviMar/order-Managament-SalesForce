public with sharing class OrderTriggerHandler {
	public static void calculateTotalValues(List<Order__c> orders) {
		for (Order__c order : orders) {
			// Initialize total product count and total price
			Decimal totalProductCount = 0;
			Decimal totalPrice = 0;

			// Query related Order Items using the child relationship name
			List<OrderItem__c> orderItems = [SELECT Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :order.Id];

			// Calculate total product count and total price
			for (OrderItem__c item : orderItems) {
				totalProductCount += item.Quantity__c;
				totalPrice += item.Quantity__c * item.Price__c;
			}

			// Set the calculated values to the order
			order.TotalProductCount__c = totalProductCount;
			order.TotalPrice__c = totalPrice;
		}
	}
}