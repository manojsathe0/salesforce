/**
 * Created by hravuru on 4/16/2019.
 */

    global class OrderItemMatchingBatchScheduler implements Schedulable
    {
        global void execute(SchedulableContext sc)
        {
            String timeFrame = 'last_n_days:15'; //use Last_n_days:15 if we want run this for last 15 days
            OrderItemMatchingBatch theBatch = new OrderItemMatchingBatch(timeFrame);
            Database.executeBatch(theBatch , 50);
        }
    }