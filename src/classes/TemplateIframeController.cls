public class  TemplateIframeController
{
    public String templateCode{get;set;}
    public String templateDetails{get;set;}
    
    public void populateTemplateDetails()
    {
        String escapedTemplateCode = String.escapeSingleQuotes(templateCode);
        String templateBody = '';
        List<EmailTemplate> emailTemplates = [SELECT Id , Body , Description , HtmlValue FROM EmailTemplate WHERE Description =: templateCode];
        if(!emailTemplates.isEmpty()){
            templateDetails = emailTemplates[0].HtmlValue;
        }
        else{   
            templateDetails = 'No Template Body to display.';
        }
        
    }
}