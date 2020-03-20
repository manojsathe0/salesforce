global class ScheduledTestResultCheck implements Schedulable{
    global void execute(SchedulableContext ctx){
        ApexTestResult[] todaysResults = [
            SELECT ApexClass.Name, ApexLogId, Message, MethodName, Outcome, QueueItemId, StackTrace 
            FROM ApexTestResult 
            WHERE TestTimestamp >= TODAY
              AND Outcome != 'Pass'
        ];
        
        if(todaysResults.size() > 0){
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{'salesforceteam@legalzoom.com'});
            mail.setSubject('Test Failures for ' + Date.today().format());
            String htmlBody = '<table><tr><th>Class</th><th>Method</th><th>Outcome</th><th>Message</th><th>Stack Trace</th></tr>';
            String textBody = 'Class\tMethod\tOutcome\tMessage\tStack Trace\n';
            for(ApexTestResult res : todaysResults){
                htmlBody += '<tr><td>' + res.ApexClass.Name + '</td><td>' + res.MethodName + 
                            '</td><td>' + res.Outcome + '</td><td>' + res.Message + '</td><td>' +
                            res.StackTrace + '</td></tr>';
                textBody += res.ApexClass.Name + '\t' + res.MethodName + '\t' + res.Outcome + '\t' + 
                            res.Message + '\t' + res.StackTrace + '\n';
            }
            mail.setPlainTextBody(textBody);
            mail.setHtmlBody(htmlBody);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        }
    }
}