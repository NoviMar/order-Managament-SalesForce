@isTest
public class ProductControllerTest {

	@testSetup
	static void setup() {
		// Создание тестовых данных
		Product__c product1 = new Product__c(
				Name = 'Test Product 1',
				Description__c = 'Description for Test Product 1',
				Type__c = 'first Example',
				Family__c = 'first Example',
				Price__c = 100,
				Image__c = 'https://example.com/image1.jpg'
		);
		Product__c product2 = new Product__c(
				Name = 'Test Product 2',
				Description__c = 'Description for Test Product 2',
				Type__c = 'second Example',
				Family__c = 'second Example',
				Price__c = 200,
				Image__c = 'https://example.com/image2.jpg'
		);
		insert new List<Product__c>{ product1, product2 };
	}

	@isTest
	static void testGetAllProducts() {
		// Вызов метода контроллера
		Test.startTest();
		List<Product__c> products = ProductController.getAllProducts();
		Test.stopTest();

		// Проверка результатов
		System.assertNotEquals(null, products, 'Метод должен вернуть список продуктов');
		System.assertEquals(2, products.size(), 'Должно быть два продукта');
		System.assertEquals('Test Product 1', products[0].Name, 'Имя первого продукта должно совпадать');
		System.assertEquals('Test Product 2', products[1].Name, 'Имя второго продукта должно совпадать');
	}

	@isTest
	static void testSaveProduct() {
		// Вызов метода контроллера
		Test.startTest();
		ProductController.saveProduct('New Product', 'New Description', 'first Example', 'first Example', 'https://example.com/newimage.jpg', 300);
		Test.stopTest();

		// Проверка результатов
		Product__c savedProduct = [SELECT Name, Description__c, Type__c, Family__c, Price__c, Image__c FROM Product__c WHERE Name = 'New Product' LIMIT 1];
		System.assertNotEquals(null, savedProduct, 'Продукт должен быть сохранен');
		System.assertEquals('New Product', savedProduct.Name, 'Имя продукта должно совпадать');
		System.assertEquals('New Description', savedProduct.Description__c, 'Описание продукта должно совпадать');
		System.assertEquals('first Example', savedProduct.Type__c, 'Тип продукта должен совпадать');
		System.assertEquals('first Example', savedProduct.Family__c, 'Семейство продукта должно совпадать');
		System.assertEquals(300, savedProduct.Price__c, 'Цена продукта должна совпадать');
		System.assertEquals('https://example.com/newimage.jpg', savedProduct.Image__c, 'URL изображения продукта должен совпадать');
	}

	@isTest
	static void testSaveProductWithInvalidType() {
		// Вызов метода контроллера с некорректным типом
		Test.startTest();
		try {
			ProductController.saveProduct('Invalid Product', 'Invalid Description', 'invalid Type', 'first Example', 'https://example.com/invalidimage.jpg', 300);
			System.assert(false, 'Ожидалось исключение при передаче некорректного типа');
		} catch (AuraHandledException e) {
			System.assertEquals('Некорректное значение для типа.', e.getMessage(), 'Сообщение об ошибке должно совпадать');
		}
		Test.stopTest();
	}

	@isTest
	static void testSaveProductWithInvalidFamily() {
		// Вызов метода контроллера с некорректным семейством
		Test.startTest();
		try {
			ProductController.saveProduct('Invalid Product', 'Invalid Description', 'first Example', 'invalid Family', 'https://example.com/invalidimage.jpg', 300);
			System.assert(false, 'Ожидалось исключение при передаче некорректного семейства');
		} catch (AuraHandledException e) {
			System.assertEquals('Некорректное значение для семейства.', e.getMessage(), 'Сообщение об ошибке должно совпадать');
		}
		Test.stopTest();
	}

	@isTest
	static void testSaveProductWithException() {
		// Вызов метода контроллера с некорректными данными для вызова исключения
		Test.startTest();
		try {
			ProductController.saveProduct(null, 'Description', 'first Example', 'first Example', 'https://example.com/image.jpg', 300);
			System.assert(false, 'Ожидалось исключение при передаче некорректных данных');
		} catch (AuraHandledException e) {
			System.assertEquals('Произошла ошибка при сохранении продукта. Пожалуйста, попробуйте еще раз.', e.getMessage(), 'Сообщение об ошибке должно совпадать');
		}
		Test.stopTest();
	}
}