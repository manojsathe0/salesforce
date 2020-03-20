public class IADOrderLinksController 
{
    public String theId{get;set;}
    public IADOrderLinksController () 
    {
        theId = ApexPages.currentPage().getParameters().get('id');
        system.debug('the id ' + theId);
    }
}