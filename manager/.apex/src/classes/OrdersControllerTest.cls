@isTest
public class OrdersControllerTest {

	@testSetup
	static void setup() {
	}

	@isTest
	static void testCreateOrder() {
		Test.startTest();
		Id orderId = OrdersController.createOrder('Test Product', 10, 1000);
		Test.stopTest();

		Order__c createdOrder = [SELECT Id, Name, TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id = :orderId LIMIT 1];
		System.assertNotEquals(null, createdOrder, 'Заказ должен быть создан');
		System.assertEquals('Order - Test Product', createdOrder.Name, 'Имя заказа должно совпадать');
		System.assertEquals(10, createdOrder.TotalProductCount__c, 'Общее количество продуктов должно совпадать');
		System.assertEquals(1000, createdOrder.TotalPrice__c, 'Общая цена должна совпадать');
	}

	@isTest
	static void testCreateOrderWithInvalidData() {
		// Вызов метода контроллера с некорректными данными для вызова исключения
		Test.startTest();
		try {
			OrdersController.createOrder(null, 10, 1000);
			System.assert(false, 'Ожидалось исключение при передаче некорректного имени продукта');
		} catch (Exception e) {
			System.assert(true, 'Исключение было выброшено как ожидалось');
		}

		try {
			OrdersController.createOrder('Test Product', null, 1000);
			System.assert(false, 'Ожидалось исключение при передаче некорректного общего количества продуктов');
		} catch (Exception e) {
			System.assert(true, 'Исключение было выброшено как ожидалось');
		}

		try {
			OrdersController.createOrder('Test Product', 10, null);
			System.assert(false, 'Ожидалось исключение при передаче некорректной общей цены');
		} catch (Exception e) {
			System.assert(true, 'Исключение было выброшено как ожидалось');
		}
		Test.stopTest();
	}
}