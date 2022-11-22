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
