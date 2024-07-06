public with sharing class ImageController {
	@AuraEnabled
	public static String fetchImageUrl(String productName) {
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('http://www.glyffix.com/api/Image?word=' + EncodingUtil.urlEncode(productName, 'UTF-8'));
		request.setMethod('GET');

		HttpResponse response = http.send(request);
		if (response.getStatusCode() == 200) {
			Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			return (String) responseBody.get('imageUrl');
		} else {
			throw new AuraHandledException('Failed to fetch image URL');
		}
	}
}