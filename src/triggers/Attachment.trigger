trigger Attachment on Attachment (After insert) {
    
    if(Trigger.isInsert){
        EmailAttachmentCaseCls.emailAttachmentCaseEmailInsert(Trigger.new);
    }

}