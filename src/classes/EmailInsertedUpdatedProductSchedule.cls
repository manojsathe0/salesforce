global class EmailInsertedUpdatedProductSchedule implements Schedulable{

    global void execute(SchedulableContext sc)
    {   
        EmailInsertedUpdatedProduct.sendMail();
    }
    
}