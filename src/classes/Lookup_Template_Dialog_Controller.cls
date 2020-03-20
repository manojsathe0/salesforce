public without sharing class Lookup_Template_Dialog_Controller 
{
    public String textDataT{get;set;}
    
    public Lookup_Template_Dialog_Controller(ApexPages.StandardController controller)
    {
        textDataT = 'XYZ';
        List<TemplateDetail> con = new List<TemplateDetail>();
    }
    public PageReference ClearResult()
    {
        PageReference pageReference =  system.Page.Lookup_Template_Dialog;
        pageReference.setRedirect(true);
        searchT = null;
        return pageReference;
    }

    

    public List<SelectOption> getFolders()
    {
        
        List<SelectOption> options=new List<SelectOption>();
        List<String> folderNames = new List<String>();
        
        for(Folder theFolder : [SELECT Name FROM Folder WHERE Type = 'Email' AND DeveloperName NOT IN :emailTemplatesFoldersToExclude ORDER By Name asc])
        {
            folderNames.add(theFolder.Name);
        }
        
       
        options.add(new SelectOption('Please select a folder','Please select a folder'));

        for(integer i=0;i<folderNames.size();i++){
            options.add(new SelectOption(folderNames[i],folderNames[i]));
        }
        
        return options;
    }

    public class TemplateDetail{
        public  String name{get;set;}
        public  String Id{get;set;}
        public  String subjectcd{get;set;}
        public  String bodycd{get;set;}
        public  String templatetype{get;set;}
        public  String description{get;set;}
    }

    public PageReference searchContact(){
        PageReference pageReference =  system.page.Lookup_Template_Dialog;
        getsearchT();
        return pageReference;
    }
    public List<TemplateDetail> getsearchT(){
        return searchT;
    }
    
    public static List<String> emailTemplatesFoldersToExclude
    {
        get
        {
            if(emailTemplatesFoldersToExclude == null)
            {
                emailTemplatesFoldersToExclude = new List<String>();
                for( Email_Templates_Folder_To_Exclude__c folder : Email_Templates_Folder_To_Exclude__c.getall().values())
                {
                  emailTemplatesFoldersToExclude.add(folder.Email_Template_Developer_Name__c);
                }       
            }
        return emailTemplatesFoldersToExclude;
        }
        set;
        
    }
    
    public static Set<Id> emailTemplatesFoldersIdToExclude
    {
        get
        {
            if(emailTemplatesFoldersIdToExclude == null)
            {
                emailTemplatesFoldersIdToExclude = new Set<Id>();
                for(Folder theFolder : [SELECT Id FROM Folder WHERE DeveloperName IN :emailTemplatesFoldersToExclude])
                {
                    emailTemplatesFoldersIdToExclude.add(theFolder.Id);
                }       
            }
        return emailTemplatesFoldersIdToExclude;
        }
        set;
        
    }
    
    public List<TemplateDetail> searchT
    {
       get {
            
        if(searchT == null)
        {
            List<TemplateDetail> tempDetail = new List<TemplateDetail>();
            List<EmailTemplate> emailTemplates =  [Select id, Name, subject, body, htmlvalue, templatetype, description From EmailTemplate  where folder.name=: textDataT AND IsActive = true ORDER By Name asc limit 100];
            for(EmailTemplate theEmailtemplate :emailTemplates)
            {
                TemplateDetail result = new TemplateDetail();
                result.name = ''+theEmailtemplate.Name;
                result.subjectcd =''+ theEmailtemplate.subject;
                if(theEmailtemplate.htmlvalue!=null)
                {
                    String sbody =''+theEmailtemplate.htmlvalue;
                    result.bodycd=sbody;
                }
                else
                {
                    String sbody =''+theEmailtemplate.body.replaceAll('\n','ก');
                    result.bodycd=sbody;
                }
                result.id = ''+theEmailtemplate.id;
                result.templatetype=''+theEmailtemplate.templatetype;
                result.description=''+theEmailtemplate.description;
                tempDetail.add(result);
             }
                return tempDetail;
            }
            else
            {
                return searchT;
            }
            
            
       }
       set;   
    }
}