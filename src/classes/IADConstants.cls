/************************************************************************************** 
 Apex Class Name     : IADConstants
 Created Date        : 
 Function            : This class tracks the constants
 Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*                          5/5/2016                 Original Version
*************************************************************************************/
public with sharing class IADConstants {

    /*
     * @description: default constructor
     *
     */
    public IADConstants() {
        system.debug('This constructor is for covering the class');
    }
    
    // JSON Header Types 
    public static final string CONTENTTYPE_JSON = 'application/json';
    public static final string CONTENTTYPE_URL = 'application/x-www-form-urlencoded';
    public static final string CONTENTLENGTH = '4096';
    public static final Integer TIMEOUT = 120000;
}