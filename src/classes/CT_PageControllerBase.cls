public virtual class CT_PageControllerBase
{
    public Boolean InErrorState {get; private set;}

    protected void InfoMessage(ApexPages.Severity pSeverity, String pMessage)
    {
        InErrorState = false;
        ApexPages.addMessage(new ApexPages.Message(pSeverity, pMessage));
    }

    protected void ErrorMessage(ApexPages.Severity pSeverity, String pMessage)
    {
        InErrorState = true;
        ApexPages.addMessage(new ApexPages.Message(pSeverity, pMessage));
    }
    
    protected void ErrorMessageFatal(String pMessage)
    {
        ErrorMessage(ApexPages.Severity.FATAL, pMessage);
    }
    
    protected void ErrorMessageInfo(String pMessage)
    {
        InfoMessage(ApexPages.Severity.INFO, pMessage);
    }

}