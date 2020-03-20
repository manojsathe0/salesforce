public with sharing class NextPadOMController
{
    PageReference nextPadPage;
    public NextPadOMController() 
    {
        nextPadPage = Page.NextPad;
        String processingNumber;
        Map<String, String> currentParams = ApexPages.currentPage().getParameters();
        if(currentParams.containsKey(NextPadService.PROCESS_NUMBER))
        {
            processingNumber = currentParams.get(NextPadService.PROCESS_NUMBER);
                        
        }
        if(processingNumber != null)
        {
            nextPadPage.getParameters().put(NextPadService.PROCESS_NUMBER , processingNumber);
        }
    }
    
    public PageReference forWardRequest()
    {
        return nextPadPage;
    }
}