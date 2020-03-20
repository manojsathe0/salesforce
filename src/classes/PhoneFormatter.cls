public with sharing class PhoneFormatter 
{
	//SFDC javascript phone format method and apex equivalent
	/*function formatPhone(a) {
    a.value = trim(a.value);
    var b = a.value,
        c = "",
        d = -1;
    if (0 < b.length && "+" != b.charAt(0)) {
        var e = 0;
        if ("1" == b.charAt(0)) b = b.substring(1, b.length);
        for (i = 0; i < b.length; i++) 
        {
            var f = b.charAt(i);
            if (f >= "0" && f <= "9") 
            {
                if (e == 0) c += "(";
                else if (e == 3) c += ") ";
                else if (e == 6) c += "-";
                c += f;
                e++
            }
            if (!(f >= "0" && f <= "9") && f != " " && f != "-" && f != "." && f != "(" && f != ")") 
            {
                d = i;
                break
            }
        }
        if (d >= 0) c += " " + b.substring(d, b.length);
        if (e == 10 && c.length <= 40) a.value = c
    }
    return true
}*/
	
	static Map<String,Integer> stringNumberToIntegerMap
	{
		get
		{
			if(stringNumberToIntegerMap == null)
			{
				stringNumberToIntegerMap = new Map<String,Integer>{'0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4,'5'=>5,'6'=>6,'7'=>7,'8'=>8,'9'=>9};
			}
			
			return stringNumberToIntegerMap;
		}
		set;
	}
	
	public static String formatPhone(String phoneNumber)
	{
		String formattedNumber = phoneNumber;
		String trimmedPhone = phoneNumber.trim();
		List<String> c = new List<String>();
		Integer d = -1;
		if(trimmedPhone.length() > 0 && !(trimmedPhone.startsWith('+')))
		{
			Integer e = 0 ;
			String cleanPhone = '';
			if(trimmedPhone.startsWith('1'))
				 trimmedPhone = trimmedPhone.subString(1 , trimmedPhone.length());
		    Integer i = 0;
            List<String> b = trimmedPhone.split('');
			for(;i < b.size() ; i++)
			{
                String f = b[i];
				Integer theNumber = -1;
				if(stringNumberToIntegerMap.containsKey(f))
           		{
	                theNumber = stringNumberToIntegerMap.get(f);
	                if (theNumber >= 0 && theNumber <= 9) 
            		{
                        if (e == 0) c.add('(');
                        else if (e == 3) c.add(') ');
                        else if (e == 6) c.add('-');
                        c.add(String.valueOf(theNumber));
                        e++;
                    }
            	}
							
				if (!(theNumber >= 0 && theNumber <= 9) && f != ' ' && f != '-' && f != '.' && f != '(' && f != ')' && f != '') 
	            {
	                d = i;
	                break;
	            }
			}
			
			if (d >= 0)
			{
				 c.add(' ');
				 List<String> tempList = new List<String>();
				 for(Integer j = d;j<b.size();++j)
				 {
				 	tempList.add(b[j]);
				 }
				 c.addAll(tempList);
			}
        	if (e == 10 && c.size() <= 40)
            {
        		formattedNumber = '';
        		for(String a : c)
                {
                	formattedNumber+=a;
                }
            }
        }
		return formattedNumber;
	}
}