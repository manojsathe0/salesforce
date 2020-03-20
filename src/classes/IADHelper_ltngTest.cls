@isTest
private class IADHelper_ltngTest {
    static testMethod void testIADHelper_ltng()
    {
        IADHelper_ltng helper = new IADHelper_ltng();
        IADHelper_ltng.getAPIBaseURL();
        IADHelper_ltng.saveAccessToken('token');
        IADHelper_ltng.getEnvironmentName();
        IADHelper_ltng.getAppIdToAppURL();
    }
}