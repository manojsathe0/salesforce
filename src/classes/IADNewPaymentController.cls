public with sharing class IADNewPaymentController
{
    public String tabId{get;set;}
    public static Boolean showModal{get;set;}
    public Boolean showDupeModal{get;set;}
    public IADContractBeans.IADNewPaymentProfileRequest newPayment{get;set;}
    public String customerId{get;set;}
    public String orderId{get;set;}
    public Map<String,Order__c>orderNumToOrder{get;set;}
    public Map<String, IADContractBeans.IADInstallmentBean> installmentIdToInstallment{get;set;}
    public Map<String, IADContractBeans.IADPaymentProfileBean> profileIdToProfile{get;set;}

    public IADNewPaymentService newPaymentService{get;set;}
    public IADPaymentProfilesService paymentProfileService{get;set;}
    public List<Order__c> contactOrders{get;set;}
    public List<IADContractBeans.IADPaymentProfileBean> dupeProfiles{get;set;}

    public String wrapIds{get;set;}
    public Integer apiIndex{get;set;}
    public Integer apiChainSize{get;set;}
    public IADContractBeans.IADPaymentProfileBean responseData{get;set;}
    public IADIServiceClassFactory instServiceClass{get;set;}
    public IADISubServiceClassFactory subServiceClass{get;set;}
    public List<IADAPIChain> apiChains{get;set;}
    public List<IADContractBeans.IADInstallmentBean> installments{get;set;}
    public List<IADContractBeans.IADInstallmentBean> installmentResponses{get;set;}

    public List<IADContractBeans.IADSubscription> subscriptions{get;set;}

    public List<IADContractBeans.IADPaymentProfileBean> profiles{get;set;}
    public List<GridWrapper> gridWrappers{get;set;}
    public List<IADMessage> iadMessages{get;set;}
    public String prevPage {get;set;}
    public String invokingPageId {get;set;}
    public List<SelectOption> expMonths{get;set;}
    public List<SelectOption> paymentTypes {get;set;}
    public List<SelectOption> expYears {get;set;}
    public List<SelectOption> statePicklist {get;set;}

    public static String nameOfInstallmentService = 'IADInstallmentService';
    public static String nameOfSubscriptionService = 'IADSubscriptionPanelService';



    public IADNewPaymentController()
    {
        contactOrders = new List<Order__c>();
        iadMessages = new List<IADMessage>();
        orderNumToOrder= new Map<String,Order__c>();
        newPayment = new IADContractBeans.IADNewPaymentProfileRequest();
        hideDupePanel();
        if(ApexPages.currentPage().getParameters().get('tabId') != null)
            tabId = ApexPages.currentPage().getParameters().get('tabId');

        prevPage = ApexPages.currentPage().getParameters().get('prevPage');
        invokingPageId = ApexPages.currentPage().getParameters().get('invokingpageid');

        orderId= ApexPages.currentPage().getParameters().get('orderid');
        customerId = ApexPages.currentPage().getParameters().get('customerid');
        dupeProfiles = new List<IADContractBeans.IADPaymentProfileBean>();



        if(UtilityLibrary.isNotNullOrBlank(customerId))
        {
            customerId = ApexPages.currentPage().getParameters().get('customerid');
            String contactid = [select id from Contact where fkUser__c =: customerId and Contact_Type__c='Primary Contact' limit 1].Id;
            contactOrders = [SELECT Id, Name, Product_Name__c FROM Order__c WHERE Contact__c = :contactid ORDER BY Name DESC];
        }
        else
        {
            String orderContactId = [select contact__c from Order__c where name =: orderId].Contact__c;
            String contactid = [select id from Contact where id =: orderContactId].Id;

            contactOrders = [SELECT Id, Name, Product_Name__c FROM Order__c WHERE Contact__c = :contactid ORDER BY Name DESC];

            customerId = [select Contact__r.FKUser__c from Order__c where name =:orderId limit 1].Contact__r.FKUser__c;
        }


        if(contactOrders != null && contactOrders.size() > 0)
        {
            for(Order__c o : contactOrders)
            {
                orderNumToOrder.put(o.Name, o);
            }
        }
        apiChains = new List<IADAPIChain>();
        subscriptions = new List<IADContractBeans.IADSubscription>();
        installments= new List<IADContractBeans.IADInstallmentBean>();
        installmentResponses = new List<IADContractBeans.IADInstallmentBean>();
        gridWrappers= new List<GridWrapper>();

        paymentProfileService = new IADPaymentProfilesService();
        profiles = new List<IADContractBeans.IADPaymentProfileBean>();

        installmentIdToInstallment = new Map<String, IADContractBeans.IADInstallmentBean>();
        profileIdToProfile = new Map<String, IADContractBeans.IADPaymentProfileBean>();

        populateInstallmentChains();
        populateSubscriptionChains();
        expMonths = UtilityLibrary.expMonths;
        paymentTypes = UtilityLibrary.paymentTypes;
        expYears = UtilityLibrary.expYears;
        statePicklist = UtilityLibrary.statePicklist;

        newPaymentService = new IADNewPaymentService();



        apiIndex =0;
    }
    public Object addNewPayment()
    {
        Object continuationObject;
        try
        {
            newPaymentService.clearMessages();
            if(newPayment.accountNumber.length() != 15 && newPayment.accountType == UtilityLibrary.profileNameToAccountTypeMap.get('American Express'))
            {
                newPaymentService.populateErrorMessage('American Express cards should have 15 digits only.');
            }
            if(newPayment.month < System.today().month() && newPayment.year == system.today().year())
            {
                newPaymentService.populateErrorMessage('Expiry date should be in the future');
            }
            if(newPaymentService.errorCount==0)
            {
                newPayment.firstDigit = newPayment.accountNumber.substring(0, 1);
                newPayment.last4Digits = newPayment.accountNumber.right(4);
                newPayment.customerId = customerId;
                newPaymentService.initWrapper(IADNewPaymentService.ADDNEWPAYMENT, 'processAddPaymentProfileResponse');
                IADContractBeans.IADNewPaymentProfileRequestBean bean = new IADContractBeans.IADNewPaymentProfileRequestBean();
                bean.paymentProfile = newPayment;
                continuationObject = newPaymentService.postNewPayment(bean);
            }
        }
        catch(IADException theException)
        {
            newPaymentService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            newPaymentService.populateErrorMessage(theException.getMessage());
        }

        return continuationObject;
    }

    //callback method
    public Object processAddPaymentProfileResponse()
    {
        try
        {
            newPaymentService.readNewPaymentResponse();
            responseData = newPaymentService.theProfile;

            if(newPaymentService.statusCode == '201')
            {
                newPaymentService.populateSuccessMessage('Payment profile successfully created! Please wait while we check the system for any installments / subscriptions to apply the new profile to.');
            }
        }
        catch(IADException theException)
        {
            newPaymentService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            newPaymentService.populateErrorMessage(theException.getMessage());
        }
        return null;
    }

    public Object populateTheProfiles()
    {
        system.debug('populateProfiles');
        Object continuationObject;
        try
        {
            paymentProfileService = new IADPaymentProfilesService();
            paymentProfileService.initWrapper(IADPaymentProfilesService.GETPROFILESBYUSERID, 'processProfileResponse');
            continuationObject = paymentProfileService.getPaymentProfilesByUserId(customerId);
        }
        catch(IADException theException)
        {
            newPaymentService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            newPaymentService.populateErrorMessage(theException.getMessage());
        }

        syncProfileMessages();
        return continuationObject;
    }

    //Callback method for Asynchronous
    public Object processProfileResponse()
    {

        system.debug('processProfileResponse');
        try
        {
            paymentProfileService.initHTTPResponse(IADPaymentProfilesService.GETPROFILESBYUSERID);

            paymentProfileService.populateProfiles();

            if(paymentProfileService.hasPaymentProfiles)
            {
                profiles = paymentProfileService.allProfiles;
                for(IADContractBeans.IADPaymentProfileBean theProfile : profiles)
                {
                    profileIdToProfile.put(theProfile.profileId, theProfile);
                }
                dupeProfiles.clear();
                newPayment.firstDigit = newPayment.accountNumber.substring(0, 1);
                newPayment.last4Digits = newPayment.accountNumber.right(4);
                system.debug('digits ' + newPayment.firstDigit + ' last ' + newPayment.last4Digits);
                for(IADContractBeans.IADPaymentProfileBean theProfile : paymentProfileService.profiles)
                {
                    if(newPayment.firstDigit == theProfile.firstDigit && newPayment.last4Digits == theProfile.last4Digits)
                    {
                        dupeProfiles.add(theProfile);
                        showDupeModal = true;
                    }

                }
            }
            system.debug('setting showDupeModal ' + showDupeModal);
        }
        catch(IADException theException)
        {
            newPaymentService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            newPaymentService.populateErrorMessage(theException.getMessage());
        }

        syncProfileMessages();
        return null;
    }

    public Object makeAPICallout()
    {
        apiIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('apiIndex'));
        system.debug('apiIndex + ' + apiIndex);

        Object continuationObject;
        if(apiChainSize > 0 && apiIndex < apiChainSize)
        {
            try
            {
                IADAPIChain chain = apiChains.get(apiIndex);

                if(chain != null)
                {
                    IADServiceClassFactoryManager cfm = new IADServiceClassFactoryManager ();
                    if(chain.serviceClassName == nameOfInstallmentService)
                    {
                        instServiceClass = cfm.newClassInstance(chain.serviceClassName);
                        if(instServiceClass.getErrorCount() == 0)
                        {
                            newPaymentService.clearMessages();
                            system.debug('chain.endpointName ' + chain.endpointName + ' chain.methodResponseName + ' + chain.methodResponseName);
                            instServiceClass.initWrapper(chain.endpointName, chain.methodResponseName);

                            if(chain.endpointName == IADInstallmentService.GETINSTALLMENTSBYORDERID)
                            {
                                String orderId = String.valueOf(chain.objects[0]);
                                continuationObject = instServiceClass.getInstallmentsByOrderId(orderId);
                            }
                            else if(chain.endpointName == IADInstallmentService.PUTUPDATEINSTALLMENTBYINSTALLMENTID)
                            {
                                String instId = String.valueOf(chain.objects[0]);

                                system.debug('instId ' + instId );

                                IADContractBeans.IADInstallmentBean inst = installmentIdToInstallment.get(instId);
                                IADContractBeans.IADInstallmentUpdateBean updateBean = new IADContractBeans.IADInstallmentUpdateBean();
                                updateBean.dueDate = inst.dueDate;
                                system.debug('profileId ' + newPaymentService.profileId);
                                updateBean.paymentProfileId = Integer.valueOf(newPaymentService.profileId);
                                updateBean.updatedBy = UtilityLibrary.generateUpdatedBy();

                                system.debug('updatebean ' + updateBean);

                                continuationObject = instServiceClass.putInstallmentByInstallmentId(JSON.serialize(updateBean), instId);
                            }
                        }
                        else
                        {
                            apiChainSize = 0;
                        }
                    }
                    else if(chain.serviceClassName == nameOfSubscriptionService)
                    {
                        subServiceClass = cfm.newSubClassInstance(chain.serviceClassName);
                        if(subServiceClass.getErrorCount() == 0)
                        {
                            newPaymentService.clearMessages();
                            system.debug('chain.endpointName ' + chain.endpointName + ' chain.methodResponseName + ' + chain.methodResponseName);
                            subServiceClass.initWrapper(chain.endpointName, chain.methodResponseName);

                            if(chain.endpointName == IADSubscriptionPanelService.GETSUBSCRIPTIONSBYORDERID)
                            {
                                String orderId = String.valueOf(chain.objects[0]);
                                continuationObject = subServiceClass.getSubscriptionsyByOrderId(orderId);
                            }
                            else if(chain.endpointName == IADSubscriptionPanelService.PUTSUBSCRIPTIONBYSUBSCRIPTIONID)
                            {
                                String subId = String.valueOf(chain.objects[0]);

                                continuationObject = subServiceClass.putSubscriptionBySubscriptionId(subId, 1, Integer.valueOf(newPaymentService.profileId));
                            }
                        }
                        else
                        {
                            apiChainSize = 0;
                        }
                    }
                }
            }
            catch(IADException theException)
            {
                newPaymentService.populateErrorMessage(theException);
            }
            catch(Exception theException)
            {
                newPaymentService.populateErrorMessage(theException);
            }
            syncInstMessages();
            syncSubMessages();
        }
        return continuationObject;

    }

    //Callback method for Asynchronous
    public Object processInstallmentsResponse()
    {
        try
        {
            system.debug('Getinstallments response');

            apiIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('apiIndex'));


            system.debug('apiIndex ' + apiIndex);

            IADAPIChain chain = apiChains.get(apiIndex);

            instServiceClass.initHTTPResponse(chain.endpointName);

            system.debug('chain.endpointName ' + chain.endpointName);

            instServiceClass.populateInstallments();


            APIRequestResponseWrapper response =  instServiceClass.getAPItoWrapper().get(chain.endpointName);


            system.debug('response ' + response);

            if(response.resultObjects != null)
            {
                installments.addAll(instServiceClass.getInstallments().installments);
            }

        }
        catch(IADException theException)
        {
            newPaymentService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            newPaymentService.populateErrorMessage(theException);
        }
        syncInstMessages();

        return null;
    }
    public Object processSubscriptionsResponse()
    {
        try
        {
            system.debug('processSubscriptionsResponse response');

            apiIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('apiIndex'));


            system.debug('apiIndex ' + apiIndex);

            IADAPIChain chain = apiChains.get(apiIndex);

            subServiceClass.initHTTPResponse(chain.endpointName);

            system.debug('chain.endpointName ' + chain.endpointName);

            subServiceClass.populateSubscription();


            APIRequestResponseWrapper response =  subServiceClass.getAPItoWrapper().get(chain.endpointName);


            system.debug('response ' + response);

            if(response.resultObjects != null)
            {
                subscriptions.addAll(subServiceClass.getSubscriptions().subscriptions);
            }

        }
        catch(IADException theException)
        {
            newPaymentService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            newPaymentService.populateErrorMessage(theException);
        }

        syncSubMessages();

        return null;
    }

    public Object processInstallmentUpdateResponse()
    {
        try
        {
            apiIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('apiIndex'));

            IADAPIChain chain = apiChains.get(apiIndex);

            instServiceClass.initHTTPResponse(chain.endpointName);

            instServiceClass.populateInstallmentUpdateReponse();


        }
        catch(IADException theException)
        {
            newPaymentService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            newPaymentService.populateErrorMessage(theException);
        }

        syncInstMessages();
        return null;
    }
    public Object processSubscriptionUpdateResponse()
    {
        try
        {
            apiIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('apiIndex'));

            IADAPIChain chain = apiChains.get(apiIndex);

            subServiceClass.initHTTPResponse(chain.endpointName);

            subServiceClass.populatePutSubscriptionBySubcriptionId();


        }
        catch(IADException theException)
        {
            newPaymentService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            newPaymentService.populateErrorMessage(theException);
        }

        syncSubMessages();

        return null;
    }



    public void populateSubscriptionChains()
    {

        for(Order__c o : contactOrders)
        {
			IADAPIChain chain = new IADAPIChain();
			chain.serviceClassName = nameOfSubscriptionService;
			chain.endpointName = IADSubscriptionPanelService.GETSUBSCRIPTIONSBYORDERID;
			chain.methodResponseName = 'processSubscriptionsResponse';
			chain.objects = new List<Object>();
			chain.objects.add(o.Name);

			apiChains.add(chain);

        }
        apiChainSize = apiChains.size();
    }
    public void closeModal()
    {
        if(newPaymentService.errorCount == 0)
        {
            newPaymentService.clearMessages();
            newPaymentService.populateSuccessMessage('New payment method has been successfully added to the selected subscriptions or installments.');
        }

        showModal = false;

    }
    public void populateUpdateChains()
    {
        wrapIds = ApexPages.currentPage().getParameters().get('wrapIds');
        if(wrapIds != null && wrapIds != '')
        {
            apiIndex = 0;
            apiChains.clear();
            system.debug('wrapIds ' + wrapIds);
            List<String> strList =  wrapIds.split(',');

            system.debug('strList ' + strList.size());
            for(string wrapId : strList)
            {
                if(wrapId.contains('inst'))
                {
                    wrapId = wrapId.replace('inst', '');
                    IADAPIChain chain = new IADAPIChain();
                    chain.serviceClassName = nameOfInstallmentService;
                    chain.endpointName = IADInstallmentService.PUTUPDATEINSTALLMENTBYINSTALLMENTID;
                    chain.methodResponseName = 'processInstallmentUpdateResponse';
                    chain.objects = new List<Object>();
                    chain.objects.add(wrapId);

                    apiChains.add(chain);
                }
                else if(wrapId.contains('sub'))
                {
                    wrapId = wrapId.replace('sub', '');
                    IADAPIChain chain = new IADAPIChain();
                    chain.serviceClassName = nameOfSubscriptionService;
                    chain.endpointName = IADSubscriptionPanelService.PUTSUBSCRIPTIONBYSUBSCRIPTIONID;
                    chain.methodResponseName = 'processSubscriptionUpdateResponse';
                    chain.objects = new List<Object>();
                    chain.objects.add(wrapId);

                    apiChains.add(chain);
                }
            }
            apiChainSize = apiChains.size();
            system.debug('IADAPIChain ' + apiChainSize);

        }
    }
    public void populateInstallmentChains()
    {

        for(Order__c o : contactOrders)
        {
            IADAPIChain chain = new IADAPIChain();
            chain.serviceClassName = nameOfInstallmentService;
            chain.endpointName = IADInstallmentService.GETINSTALLMENTSBYORDERID;
            chain.methodResponseName = 'processInstallmentsResponse';
            chain.objects = new List<Object>();
            chain.objects.add(o.Name);

            apiChains.add(chain);
        }
        apiChainSize = apiChains.size();
    }

    public class GridWrapper
    {
        public String wrapId{get;set;}
        public Integer index{get;set;}
        public String orderNum{get;set;}
        public String orderDesc{Get;set;}
        public String ccInfo {get;set;}
        public String lastChargeDate{get;set;}
        public String lastChargeAmnt{get;set;}
        public String status{get;set;}
        public String wrapType{get;set;}
        public Boolean show{get;set;}
    }
    public void populateWrappers()
    {

        gridWrappers.clear();

        system.debug('installments ' + installments);
        if(installments != null && installments.size()>0)
        {
            for(IADContractBeans.IADInstallmentBean inst : installments)
            {
                installmentIdToInstallment.put(inst.installmentId, inst);
            }
            for(IADContractBeans.IADInstallmentBean inst : installments)
            {
                Integer index = 0;
                system.debug('inst ' + inst);
                if(IADPaymentTransaction.installmentBillStatusMap.get(inst.installmentBillStatus) != 'Paid')
                {

                    IADContractBeans.IADPaymentProfileBean profile = profileIdToProfile.get(inst.paymentProfileId);
                    system.debug('profile ' + profile);
                    GridWrapper wrap = new GridWrapper();
                    wrap.wrapId = inst.installmentId;
                    wrap.index = index;
                    wrap.orderNum = 'Inst-' +  inst.orderId;
                    wrap.orderDesc = orderNumToOrder.get(inst.orderId).Product_Name__c;
                    if(profile != null)
                        wrap.ccInfo = UtilityLibrary.profileAccountTypeToNameMap.get(profile.AccountType) +' xxxx' + profile.last4Digits;
                    wrap.lastChargeDate = inst.adjDueDateInString;
                    wrap.lastChargeAmnt = inst.balanceDueAmount;
                    wrap.status = IADPaymentTransaction.installmentBillStatusMap.get(inst.installmentBillStatus);
                    wrap.show=true;
                    wrap.wrapType='installment';
                    gridWrappers.add(wrap);
                    if(prevPage=='installment'  && invokingPageId==inst.installmentId)
                        wrap.show=false;
                    index++;
                }
            }
        }
        system.debug('subscriptions ' + subscriptions);
        if(subscriptions != null && subscriptions.size()>0)
        {
            for(IADContractBeans.IADSubscription sub : subscriptions)
            {
                system.debug('sub ' + sub);
                Integer index = 0;
                if(sub.status != 'Cancelled' && sub.status != 'Expired')
                {
                    IADContractBeans.IADPaymentProfileBean profile = profileIdToProfile.get(sub.paymentProfileId);
                    system.debug('profile ' + profile);
                    GridWrapper wrap = new GridWrapper();
                    wrap.wrapId = sub.orderItemSubscriptionId;
                    wrap.index = index;
                    wrap.orderNum = 'Sub-' + sub.orderId;
                    wrap.orderDesc = sub.productName;
                    if(profile != null)
                        wrap.ccInfo = UtilityLibrary.profileAccountTypeToNameMap.get(profile.AccountType) +' xxxx' + profile.last4Digits;
                    wrap.lastChargeDate = sub.adjSubscriptionEndDate;
                    wrap.lastChargeAmnt = String.valueOf(sub.renewalPrice);
                    wrap.status = sub.Status;
                    wrap.show=true;
                    wrap.wrapType='subscription';
                    gridWrappers.add(wrap);
                    if(prevPage=='subscription'  && invokingPageId==sub.orderItemSubscriptionId)
                        wrap.show=false;
                    index++;
                }
            }
        }
        if(gridWrappers.size() > 0)
        {
            showModal = true;

            system.debug('setting showModal ' + showModal);
        }

        system.debug('gridWrappers ' + gridWrappers);
    }
    public void syncInstMessages()
    {
        if(instServiceClass!= null)
        {
            newPaymentService.addMessages(instServiceClass.getIadMessages(), instServiceClass.getErrorCount());
        }
    }
    public void syncSubMessages()
    {
        if(subServiceClass!= null)
        {
            newPaymentService.addMessages(subServiceClass.getIadMessages(), subServiceClass.getErrorCount());
        }

    }
    public void syncProfileMessages()
    {
        if(subServiceClass!= null)
        {
            newPaymentService.addMessages(paymentProfileService.getIadMessages(), paymentProfileService.getErrorCount());
        }

    }
    public void hideDupePanel()
    {
        showDupeModal = false;
    }

}