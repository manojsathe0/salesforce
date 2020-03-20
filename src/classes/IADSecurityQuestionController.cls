public class IADSecurityQuestionController
{
    public string customerId{get;set;}
    public IADSecurityQuestionService securityQuestionService {get;set;}
    
    
    public IADSecurityQuestionController() 
    {
        customerId = ApexPages.currentPage().getParameters().get('customerId');
        securityQuestionService = new IADSecurityQuestionService();
    }
    public Object populateSecurityQuestion()
    {
         
        Object continuationObject;
        try
        {
          
            securityQuestionService.initWrapper(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID, 'processResponse');
            continuationObject = securityQuestionService.getSecurityQuestionByCustomerId(customerId);  
            
        }
        catch(IADException theException)
        {
            securityQuestionService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            securityQuestionService.populateErrorMessage(theException);
        }
        return continuationObject; 
            
    }
    // Callback method for Asynchronous
    public Object processResponse() 
    {   
          try
          {
              securityQuestionService.populateSecurityQuestion();
                           
          }
          catch(IADException theException)
          {
              securityQuestionService.populateErrorMessage(theException);
          }
          catch(Exception theException)
          {
              securityQuestionService.populateErrorMessage(theException);
          }
          return null;
      
    }
}