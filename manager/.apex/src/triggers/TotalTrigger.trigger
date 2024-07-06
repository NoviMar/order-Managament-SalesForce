trigger TotalTrigger on Order__c (before insert) {
	for (Order__c order : Trigger.new) {
		List<OrderItem__c> orderItems = [
				SELECT Quantity__c, Price__c
				FROM OrderItem__c
				WHERE OrderId__c = :order.Id
		];
		order.TotalProductCount__c = 0;
		order.TotalPrice__c = 0;
		for (OrderItem__c item : orderItems) {
			order.TotalProductCount__c += item.Quantity__c;
			order.TotalPrice__c += item.Price__c * item.Quantity__c;
		}
	}
}
