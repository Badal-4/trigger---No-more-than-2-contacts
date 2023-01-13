trigger trg2 on Contact(after Insert,after Update,after Delete,after Undelete)
{
    if(trigger.isAfter && (trigger.isInsert || trigger.isUndelete))
    {
        if(trigger.new.size() > 0)
        {
            trgController.trgMethod(trigger.new,null);
        }
    }

    if(trigger.isAfter && trigger.isUpdate)
    {
        if(trigger.new.size() > 0 && trigger.oldMap != null)
        {
            trgController.trgMethod(trigger.new,trigger.oldMap);
        }
    }

    if(trigger.isAfter && trigger.isDelete)
    {
        iF(trigger.old.size() > 0)
        {
            trgController.trgMethod(trigger.old,null);
        }
    }
}


//CHATGPT VERSION
trigger LimitContacts on Contact (before insert) {
    // Get the account Ids of the new contacts
    Set<Id> accountIds = new Set<Id>();
    for (Contact con : Trigger.new) {
        accountIds.add(con.AccountId);
    }

    // Count the number of contacts associated with each account
    Map<Id, Integer> contactCount = new Map<Id, Integer>();
    for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) contactCount
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
        contactCount.put((Id)ar.get('AccountId'), (Integer)ar.get('contactCount'));
    }

    // Check if the number of contacts for each account exceeds the limit
    for (Contact con : Trigger.new) {
        if (contactCount.get(con.AccountId) >= 2) {
            con.addError('An account can have maximum of 2 contacts');
        }
    }
}
