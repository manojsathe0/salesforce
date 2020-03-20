trigger CaseComment on CaseComment (after insert) {
	 //Padma @B-33310
 /* if(Trigger.isAfter && Trigger.isInsert) 
 {
     CaseCommentService.callCaseOrderService(Trigger.new);
 }   
 */     
}