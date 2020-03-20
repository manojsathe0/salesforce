({
    getIntial : function(cmp,event) {
        
        
        var action =cmp.get("c.intialsetup");
        action.setParams({ recid : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                if(response.getReturnValue()!=null)
                {   
                    var a= response.getReturnValue();
                    var size =JSON.stringify(response.getReturnValue()).length;
                    var res =response.getReturnValue();
                    console.log('stringified response');
                    console.log(JSON.stringify(response.getReturnValue()))
                    
                    
                    console.log('the size of response  '+response.getReturnValue().length);
                    if(response.getReturnValue().length>0)
                    {
                        cmp.set('v.hascases',true);
                        cmp.set('v.allcases' ,response.getReturnValue() );
                        console.log('The response'+response.getReturnValue());
                    }
                    
                }
                else
                {
                    //alert('data no ');
                }
            }
            
        });
        
        
        $A.enqueueAction(action);
        
    }
})