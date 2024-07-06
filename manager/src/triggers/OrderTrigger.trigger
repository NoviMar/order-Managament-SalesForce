trigger OrderTrigger on Order__c (after insert, after update) {
	for (Order__c order : Trigger.new) {
		List<OrderItem__c> orderItems = [SELECT Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :order.Id];
		Decimal totalProductCount = 0;
		Decimal totalPrice = 0;

		for (OrderItem__c item : orderItems) {
			totalProductCount += item.Quantity__c;
			totalPrice += item.Price__c * item.Quantity__c;
		}

		order.TotalProductCount__c = totalProductCount;
		order.TotalPrice__c = totalPrice;
		update order;
	}
}