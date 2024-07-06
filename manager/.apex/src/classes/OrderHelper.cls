public class OrderHelper {
	public static void updateOrderTotals(Set<Id> orderIds) {
		List<Order__c> ordersToUpdate = new List<Order__c>();

		for (Id orderId : orderIds) {
			Order__c order = [SELECT Id, (SELECT Quantity__c, Price__c FROM OrderItems__r) FROM Order__c WHERE Id = :orderId];

			Decimal totalProductCount = 0;
			Decimal totalPrice = 0;

			for (OrderItem__c item : order.OrderItems__r) {
				totalProductCount += item.Quantity__c;
				totalPrice += item.Price__c * item.Quantity__c;
			}

			Order__c orderUpdate = new Order__c(Id = orderId);
			orderUpdate.TotalProductCount__c = totalProductCount;
			orderUpdate.TotalPrice__c = totalPrice;

			ordersToUpdate.add(orderUpdate);
		}

		update ordersToUpdate;
	}
}
