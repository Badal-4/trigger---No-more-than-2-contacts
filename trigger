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


//optimized code trigger trg2 on Contact(before Insert,before Update)
{
    Set<Id> accIds = new Set<Id>();
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
    {
        if(!trigger.new.isEmpty())
        {
            for(Contact c : trigger.new)
            {
                if(c.AccountId != null)
                {
                   accIds.add(c.AccountId);
                }
            }
        }
   
        Map<Id,Integer> contactCount = new Map<Id,Integer>();
        List<AggregateResult> aggrList = [Select AccountId,count(Id) contactCount from Contact where AccountId IN : accIds
                                         group by AccountId];
        
        if(!aggrList.isEmpty())
        {
            for(AggregateResult aggr : aggrList)
            {
                contactCount.put((Id)aggr.get('AccountId'),(Integer)aggr.get('contactCount'));
            }
        }
        
          if(!trigger.new.isEmpty())
          {
                for(Contact con : trigger.new)
                {
                    if(con.AccountId != null  && contactCount.get(con.AccountId) >= 2)
                    {
                        con.addError('You cannot insert this contact as there are already 2 contacts present on this account');
                    }
                }
          }        
    }
}
ˇ
