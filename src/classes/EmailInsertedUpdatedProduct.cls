public with sharing class EmailInsertedUpdatedProduct {

    public final static String TO_ADDRESS = 'Product Email Alert';
    public final static String DATE_FORMAT = 'MM-dd-yyyy';
    public final static String TIME_ZONE = 'PST';
    public static MAP<Id,String> CreatedDate {get;set;}
    public static MAP<Id,String> LastModifiedDate {get;set;}
    public static void sendMail()
    {
        EmailTemplate et = [SELECT id FROM EmailTemplate where developername='Product_Email_Alert_Template'];
        String[] toAddresses = new String[] {EmailAddress};
        
        try{
                        
            List<Product2> updatedProduct = getUpdatedProduct();
            if(!updatedProduct.isEmpty()){
                 
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTemplateId(et.id);
                email.setTargetObjectId(targetObjectId);
                email.setToAddresses(toAddresses);
                email.setSaveAsActivity(false);
                Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
            }
            
        }catch(Exception e){
            System.debug('Can not send email.'+e);        
        }
        
    }
    
    
    public static List<Product2> getUpdatedProduct(){
        CreatedDate = new Map<Id,String>{};
        LastModifiedDate = new Map<Id,String>{};
        List<Product2> updatedProduct = [SELECT Name,LZ_Product_ID__c,CreatedDate,LastModifiedDate 
                                              FROM Product2 
                                              WHERE LastModifiedDate=YESTERDAY];
        if(Test.isRunningTest()){
        	updatedProduct = [SELECT Name,LZ_Product_ID__c,CreatedDate,LastModifiedDate 
                                              FROM Product2 
                                              WHERE LastModifiedDate=TODAY];
        }
        for(Product2 product : updatedProduct){
            CreatedDate.put(product.Id,product.CreatedDate.format(DATE_FORMAT,TIME_ZONE));
            LastModifiedDate.put(product.Id,product.LastModifiedDate.format(DATE_FORMAT,TIME_ZONE));
        }
        return updatedProduct;
    }
    
    public static String ModifiedDate{
        get{
            if(ModifiedDate == null)
            {
                Datetime yesterdayDate = Datetime.now().addDays(-1);
                ModifiedDate = yesterdayDate.format(DATE_FORMAT,TIME_ZONE);
            }
            return ModifiedDate;
        }
    }
    
    public static String EmailAddress
    {
        get
        {
            if(EmailAddress == null)
            {
                Map<String,Product_Email_Alert__c> emails = Product_Email_Alert__c.getAll();
                if(!emails.isEmpty())
                {
                    EmailAddress = emails.get(TO_ADDRESS).email__c;
                }
            }
            return EmailAddress;    
        }
    }
    
    public static String targetObjectId
    {
        get
        {
            if(targetObjectId == null)
            {
                Product_Email_Alert__c emails = Product_Email_Alert__c.getInstance(TO_ADDRESS);  
                targetObjectId = emails.targetObjectId__c;
                
            }
            return targetObjectId;    
        }
    }
}