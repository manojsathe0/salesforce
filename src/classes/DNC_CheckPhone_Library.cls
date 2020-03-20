/**
     *  @author         Saikiran Salla - ssalla@legalzoom.com
     *  @description    Beans/Library class for "do-not-call/scrub?phoneNumber={phoneNumber}" api.
     *  @history        2019-March-25   -   Created
*/

public class DNC_CheckPhone_Library {
    public class MainResponse {
        //public List<cls_PhoneNumber> PhoneNumber;
        public cls_PhoneNumber PhoneNumber;
        public MainResponse() {
            //PhoneNumber = new List<cls_PhoneNumber>();
            PhoneNumber = new cls_PhoneNumber();
        }
    }

    //public class cls_PhoneNumber {
    //    public cls_PhoneNumberInner PhoneNumber;
    //    public cls_PhoneNumber() {
    //        PhoneNumber = new cls_PhoneNumberInner();
    //    }
    //}

    public class cls_PhoneNumber {
        public String sNumber;   //string    //Update to Number when deserializing it back
        public String ResultCode;   //string
        public String Definition;   //string
        public String EbrExpireDate;    //datetime
        public String Reason;   //string
        public String RegionAbbrev; //string
        public String Country;  //string
        public String Locale;   //string
        public String CarrierInfo;  //string
        public Integer NewReassignedAreaCode;   //1
        public Integer TzCode;  //1
        public String CallingWindow;    //string
        public Integer UtcOffset;   //1
        public boolean DoNotCallToday;
        public Integer CallingTimeRestrictions; //1
    }
}