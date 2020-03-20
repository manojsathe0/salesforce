@istest private class ITPtest_ltng

{




  @isTest static void testGetAccountStatus()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        Contact con2;
        system.runAs(u)
        {
            con2 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con2;

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234', PrimaryContact__c=con2.id);
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.AccountStatus(con1.id);
        Test.stopTest();

    }
    @isTest static void testGetAccountStatusnegative()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  '';
      mock.statusCode=404;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.AccountStatus(con1.id);
        Test.stopTest();

    }
     @isTest static void testGetAccountStatusnegative1()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=404;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.AccountStatus(null);
        Test.stopTest();

    }
      @isTest static void testGetAccountStatusnegative2()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  null;
      mock.statusCode=404;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.AccountStatus(null);
        Test.stopTest();

    }
       @isTest static void testGetAccountStatusnegative3()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =   '{"errors":[{"code":"string","message":"string","fieldErrors":[{"field":"string","type":"string","detail":"string"}],"exception":{"message":"string","data":{},"innerException":{},"targetSite":{"methodImplementationFlags":"managed","methodHandle":{"value":{}},"attributes":"reuseSlot","callingConvention":"standard","isGenericMethodDefinition":true,"containsGenericParameters":true,"isGenericMethod":true,"isPublic":true,"isPrivate":true,"isFamily":true,"isAssembly":true,"isFamilyAndAssembly":true,"isFamilyOrAssembly":true,"isStatic":true,"isFinal":true,"isVirtual":true,"isHideBySig":true,"isAbstract":true,"isSpecialName":true,"isConstructor":true,"memberType":"constructor","name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{"attributeType":"string","constructor":{"memberType":"constructor","methodImplementationFlags":"managed","methodHandle":{"value":{}},"attributes":"reuseSlot","callingConvention":"standard","isGenericMethodDefinition":true,"containsGenericParameters":true,"isGenericMethod":true,"isPublic":true,"isPrivate":true,"isFamily":true,"isAssembly":true,"isFamilyAndAssembly":true,"isFamilyOrAssembly":true,"isStatic":true,"isFinal":true,"isVirtual":true,"isHideBySig":true,"isAbstract":true,"isSpecialName":true,"isConstructor":true,"name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{"customAttributes":[{}],"mdStreamVersion":0,"fullyQualifiedName":"string","moduleVersionId":"string","metadataToken":0,"scopeName":"string","name":"string","assembly":{"codeBase":"string","fullName":"string","entryPoint":{"memberType":"constructor","returnType":"string","returnParameter":{"parameterType":"string","name":"string","hasDefaultValue":true,"defaultValue":{},"rawDefaultValue":{},"position":0,"attributes":"none","member":{"memberType":"constructor","name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"isIn":true,"isOut":true,"isLcid":true,"isRetval":true,"isOptional":true,"metadataToken":0,"customAttributes":[{}]},"returnTypeCustomAttributes":{},"methodImplementationFlags":"managed","methodHandle":{"value":{}},"attributes":"reuseSlot","callingConvention":"standard","isGenericMethodDefinition":true,"containsGenericParameters":true,"isGenericMethod":true,"isPublic":true,"isPrivate":true,"isFamily":true,"isAssembly":true,"isFamilyAndAssembly":true,"isFamilyOrAssembly":true,"isStatic":true,"isFinal":true,"isVirtual":true,"isHideBySig":true,"isAbstract":true,"isSpecialName":true,"isConstructor":true,"name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"exportedTypes":["string"],"definedTypes":["string"],"manifestModule":{},"customAttributes":[{}],"reflectionOnly":true,"modules":[{}],"location":"string","imageRuntimeVersion":"string","isDynamic":true},"moduleHandle":{"mdStreamVersion":0}}},"constructorArguments":[{"argumentType":"string","value":{}}],"namedArguments":[{"memberInfo":{"memberType":"constructor","name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{"customAttributes":[{}],"mdStreamVersion":0,"fullyQualifiedName":"string","moduleVersionId":"string","metadataToken":0,"scopeName":"string","name":"string","assembly":{"codeBase":"string","fullName":"string","entryPoint":{"memberType":"constructor","returnType":"string","returnParameter":{"parameterType":"string","name":"string","hasDefaultValue":true,"defaultValue":{},"rawDefaultValue":{},"position":0,"attributes":"none","member":{},"isIn":true,"isOut":true,"isLcid":true,"isRetval":true,"isOptional":true,"metadataToken":0,"customAttributes":[{}]},"returnTypeCustomAttributes":{},"methodImplementationFlags":"managed","methodHandle":{"value":{}},"attributes":"reuseSlot","callingConvention":"standard","isGenericMethodDefinition":true,"containsGenericParameters":true,"isGenericMethod":true,"isPublic":true,"isPrivate":true,"isFamily":true,"isAssembly":true,"isFamilyAndAssembly":true,"isFamilyOrAssembly":true,"isStatic":true,"isFinal":true,"isVirtual":true,"isHideBySig":true,"isAbstract":true,"isSpecialName":true,"isConstructor":true,"name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"exportedTypes":["string"],"definedTypes":["string"],"manifestModule":{},"customAttributes":[{}],"reflectionOnly":true,"modules":[{}],"location":"string","imageRuntimeVersion":"string","isDynamic":true},"moduleHandle":{"mdStreamVersion":0}}},"typedValue":{"argumentType":"string","value":{}},"memberName":"string","isField":true}]}],"metadataToken":0,"module":{"customAttributes":[{"attributeType":"string","constructor":{"memberType":"constructor","methodImplementationFlags":"managed","methodHandle":{"value":{}},"attributes":"reuseSlot","callingConvention":"standard","isGenericMethodDefinition":true,"containsGenericParameters":true,"isGenericMethod":true,"isPublic":true,"isPrivate":true,"isFamily":true,"isAssembly":true,"isFamilyAndAssembly":true,"isFamilyOrAssembly":true,"isStatic":true,"isFinal":true,"isVirtual":true,"isHideBySig":true,"isAbstract":true,"isSpecialName":true,"isConstructor":true,"name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"constructorArguments":[{"argumentType":"string","value":{}}],"namedArguments":[{"memberInfo":{"memberType":"constructor","name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"typedValue":{"argumentType":"string","value":{}},"memberName":"string","isField":true}]}],"mdStreamVersion":0,"fullyQualifiedName":"string","moduleVersionId":"string","metadataToken":0,"scopeName":"string","name":"string","assembly":{"codeBase":"string","fullName":"string","entryPoint":{"memberType":"constructor","returnType":"string","returnParameter":{"parameterType":"string","name":"string","hasDefaultValue":true,"defaultValue":{},"rawDefaultValue":{},"position":0,"attributes":"none","member":{"memberType":"constructor","name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{"attributeType":"string","constructor":{"memberType":"constructor","methodImplementationFlags":"managed","methodHandle":{"value":{}},"attributes":"reuseSlot","callingConvention":"standard","isGenericMethodDefinition":true,"containsGenericParameters":true,"isGenericMethod":true,"isPublic":true,"isPrivate":true,"isFamily":true,"isAssembly":true,"isFamilyAndAssembly":true,"isFamilyOrAssembly":true,"isStatic":true,"isFinal":true,"isVirtual":true,"isHideBySig":true,"isAbstract":true,"isSpecialName":true,"isConstructor":true,"name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"constructorArguments":[{"argumentType":"string","value":{}}],"namedArguments":[{"memberInfo":{},"typedValue":{"argumentType":"string","value":{}},"memberName":"string","isField":true}]}],"metadataToken":0,"module":{}},"isIn":true,"isOut":true,"isLcid":true,"isRetval":true,"isOptional":true,"metadataToken":0,"customAttributes":[{"attributeType":"string","constructor":{"memberType":"constructor","methodImplementationFlags":"managed","methodHandle":{"value":{}},"attributes":"reuseSlot","callingConvention":"standard","isGenericMethodDefinition":true,"containsGenericParameters":true,"isGenericMethod":true,"isPublic":true,"isPrivate":true,"isFamily":true,"isAssembly":true,"isFamilyAndAssembly":true,"isFamilyOrAssembly":true,"isStatic":true,"isFinal":true,"isVirtual":true,"isHideBySig":true,"isAbstract":true,"isSpecialName":true,"isConstructor":true,"name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"constructorArguments":[{"argumentType":"string","value":{}}],"namedArguments":[{"memberInfo":{"memberType":"constructor","name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"typedValue":{"argumentType":"string","value":{}},"memberName":"string","isField":true}]}]},"returnTypeCustomAttributes":{},"methodImplementationFlags":"managed","methodHandle":{"value":{}},"attributes":"reuseSlot","callingConvention":"standard","isGenericMethodDefinition":true,"containsGenericParameters":true,"isGenericMethod":true,"isPublic":true,"isPrivate":true,"isFamily":true,"isAssembly":true,"isFamilyAndAssembly":true,"isFamilyOrAssembly":true,"isStatic":true,"isFinal":true,"isVirtual":true,"isHideBySig":true,"isAbstract":true,"isSpecialName":true,"isConstructor":true,"name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{"attributeType":"string","constructor":{"memberType":"constructor","methodImplementationFlags":"managed","methodHandle":{"value":{}},"attributes":"reuseSlot","callingConvention":"standard","isGenericMethodDefinition":true,"containsGenericParameters":true,"isGenericMethod":true,"isPublic":true,"isPrivate":true,"isFamily":true,"isAssembly":true,"isFamilyAndAssembly":true,"isFamilyOrAssembly":true,"isStatic":true,"isFinal":true,"isVirtual":true,"isHideBySig":true,"isAbstract":true,"isSpecialName":true,"isConstructor":true,"name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"constructorArguments":[{"argumentType":"string","value":{}}],"namedArguments":[{"memberInfo":{"memberType":"constructor","name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"typedValue":{"argumentType":"string","value":{}},"memberName":"string","isField":true}]}],"metadataToken":0,"module":{}},"exportedTypes":["string"],"definedTypes":["string"],"manifestModule":{},"customAttributes":[{"attributeType":"string","constructor":{"memberType":"constructor","methodImplementationFlags":"managed","methodHandle":{"value":{}},"attributes":"reuseSlot","callingConvention":"standard","isGenericMethodDefinition":true,"containsGenericParameters":true,"isGenericMethod":true,"isPublic":true,"isPrivate":true,"isFamily":true,"isAssembly":true,"isFamilyAndAssembly":true,"isFamilyOrAssembly":true,"isStatic":true,"isFinal":true,"isVirtual":true,"isHideBySig":true,"isAbstract":true,"isSpecialName":true,"isConstructor":true,"name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"constructorArguments":[{"argumentType":"string","value":{}}],"namedArguments":[{"memberInfo":{"memberType":"constructor","name":"string","declaringType":"string","reflectedType":"string","customAttributes":[{}],"metadataToken":0,"module":{}},"typedValue":{"argumentType":"string","value":{}},"memberName":"string","isField":true}]}],"reflectionOnly":true,"modules":[{}],"location":"string","imageRuntimeVersion":"string","isDynamic":true},"moduleHandle":{"mdStreamVersion":0}}},"stackTrace":"string","helpLink":"string","source":"string","hResult":0}}]}';
      mock.statusCode=404;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.AccountStatus(con1.id);
        Test.stopTest();

    }
     
  @isTest static void testGetInvitationDetails()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.InvitationDetails(con1.id);
        Test.stopTest();

    }
        
  @isTest static void testGetInvitationDetailsNegative()
  {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=400;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.InvitationDetails(con1.id);
        Test.stopTest();

    }
    
     @isTest static void testGetInvitationDetailsNegative1()
  {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=400;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.InvitationDetails(null);
        Test.stopTest();

    }
    
     @isTest static void testDeactivateAccount()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.DeActivateAccount(con1.id ,'1234','test');
        Test.stopTest();

    }
     @isTest static void testGetInvitationDetailsnull()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  null;
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.InvitationDetails(con1.id);
        Test.stopTest();

    }
        
  @isTest static void testDeactivateAccountnull()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  null;
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.DeActivateAccount(con1.id ,'1234','test');
        Test.stopTest();

    }
    @isTest static void testSendInvitation()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody = IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.sendInvitation(con1.id ,'1234');
        Test.stopTest();

    }
 @isTest static void testSendInvitationnull()
    {
          User u = [select id, profileid from User where name = 'Integration User' limit 1];
        Order__c order1 ;
        Contact con1;
        system.runAs(u)
        {

             con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

           order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }
       ITPContactController_ltng  inst = new  ITPContactController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody = IADTestDataUtil_ltng.getAccountStatusITP();
      mock.statusCode=500;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
        ITPContactController_ltng.sendInvitation(con1.id ,'1234');
        Test.stopTest();

    }

}