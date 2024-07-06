trigger OrderItemTrigger on OrderItem__c (after insert, after update, after delete) {
	Set<Id> orderIds = new Set<Id>();

	if (Trigger.isInsert || Trigger.isUpdate) {
		for (OrderItem__c item : Trigger.new) {
			orderIds.add(item.OrderId__c);
		}
	}

	if (Trigger.isDelete) {
		for (OrderItem__c item : Trigger.old) {
			orderIds.add(item.OrderId__c);
		}
	}

	List<Order__c> ordersToUpdate = new List<Order__c>();

	for (Id orderId : orderIds) {
		AggregateResult[] groupedResults = [
				SELECT SUM(Quantity__c) totalQuantity, SUM(Price__c) totalPrice
				FROM OrderItem__c
				WHERE OrderId__c = :orderId
				GROUP BY OrderId__c
		];

		if (groupedResults.size() > 0) {
			AggregateResult result = groupedResults[0];
			Decimal totalQuantity = (Decimal)result.get('totalQuantity');
			Decimal totalPrice = 0;
			List<OrderItem__c> orderItems = [
					SELECT Quantity__c, Price__c
					FROM OrderItem__c
					WHERE OrderId__c = :orderId
			];

			for (OrderItem__c item : orderItems) {
				totalPrice += item.Quantity__c * item.Price__c;
			}

			Order__c orderToUpdate = new Order__c(
					Id = orderId,
					TotalProductCount__c = totalQuantity,
					TotalPrice__c = totalPrice
			);
			ordersToUpdate.add(orderToUpdate);
		} else {
			Order__c orderToUpdate = new Order__c(
					Id = orderId,
					TotalProductCount__c = 0,
					TotalPrice__c = 0
			);
			ordersToUpdate.add(orderToUpdate);
		}
	}

	if (!ordersToUpdate.isEmpty()) {
		update ordersToUpdate;
	}
}