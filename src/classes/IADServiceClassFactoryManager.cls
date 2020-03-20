public with sharing class IADServiceClassFactoryManager 
{
    public IADServiceClassFactoryManager ()
    {
        system.debug('code coverage');
    }

    // Return the appropriate class instance based on className
    public IADIServiceClassFactory newClassInstance(String className)
    {
        Type t = Type.forName(className);
        return (IADIServiceClassFactory) t.newInstance();
    }

    public IADISubServiceClassFactory newSubClassInstance(String className)
    {
        Type t = Type.forName(className);
        return (IADISubServiceClassFactory) t.newInstance();
    }
}