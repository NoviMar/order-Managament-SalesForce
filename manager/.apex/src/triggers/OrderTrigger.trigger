trigger OrderTrigger on Order__c (before insert, before update, after insert, after update) {
	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
		} else if (Trigger.isUpdate) {
		}
	}
}