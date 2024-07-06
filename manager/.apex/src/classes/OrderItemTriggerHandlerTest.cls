@isTest
public class OrderItemTriggerHandlerTest {

	@isTest
	static void testCreateOrderWithItems() {
		// Создание тестовых данных
		Product2 testProduct = new Product2(Name = 'Test Product',Type = 'first Example',Family = 'first Example');
		insert testProduct;

		// Создание списков для передачи в метод
		List<Id> productIds = new List<Id>{testProduct.Id};
		List<Integer> quantities = new List<Integer>{2};
		List<Decimal> prices = new List<Decimal>{100};

		// Вызов тестируемого метода
		Test.startTest();
		OrderItemTriggerHandler.createOrderWithItems(productIds, quantities, prices);
		Test.stopTest();

		// Проверка результатов
		List<Order__c> orders = [SELECT Id, Name FROM Order__c];
		System.assertEquals(1, orders.size(), 'Должен быть создан один заказ');

		List<OrderItem__c> orderItems = [SELECT Id, OrderId__c, ProductId__c, Quantity__c, Price__c FROM OrderItem__c];
		System.assertEquals(1, orderItems.size(), 'Должен быть создан один элемент заказа');
		System.assertEquals(orders[0].Id, orderItems[0].OrderId__c, 'Элемент заказа должен быть связан с заказом');
		System.assertEquals(testProduct.Id, orderItems[0].ProductId__c, 'Элемент заказа должен быть связан с продуктом');
		System.assertEquals(2, orderItems[0].Quantity__c, 'Количество должно быть равно 2');
		System.assertEquals(200, orderItems[0].Price__c, 'Цена должна быть равна 200 (2 * 100)');
	}

	@isTest
	static void testCreateOrderWithItemsEmptyParams() {
		// Вызов тестируемого метода с пустыми параметрами и проверка исключения
		try {
			Test.startTest();
			OrderItemTriggerHandler.createOrderWithItems(new List<Id>(), new List<Integer>(), new List<Decimal>());
			Test.stopTest();
			System.assert(false, 'Ожидалось исключение IllegalArgumentException');
		} catch (IllegalArgumentException e) {
			System.assertEquals('Некоторые параметры не заполнены или пусты.', e.getMessage(), 'Сообщение исключения должно совпадать');
		}
	}

	@isTest
	static void testCreateOrderWithItemsNullParams() {
		// Вызов тестируемого метода с null параметрами и проверка исключения
		try {
			Test.startTest();
			OrderItemTriggerHandler.createOrderWithItems(null, null, null);
			Test.stopTest();
			System.assert(false, 'Ожидалось исключение IllegalArgumentException');
		} catch (IllegalArgumentException e) {
			System.assertEquals('Некоторые параметры не заполнены или пусты.', e.getMessage(), 'Сообщение исключения должно совпадать');
		}
	}
}