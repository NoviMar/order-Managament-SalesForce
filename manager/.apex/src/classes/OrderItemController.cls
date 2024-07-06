public with sharing class OrderItemController {
	@AuraEnabled
	public static void createOrderItems(List<OrderItem> orderItems) {
		try {
			insert orderItems;
		} catch (Exception e) {
			throw new AuraHandledException('Error creating order items: ' + e.getMessage());
		}
	}
}