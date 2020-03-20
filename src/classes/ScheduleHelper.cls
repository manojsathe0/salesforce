public class ScheduleHelper{
    public static String cronStringFromDatetime(DateTime dt){
        String cronString = '';
        cronString += String.valueOf(dt.second()) + ' ';
        cronString += String.valueOf(dt.minute()) + ' ';
        cronString += String.valueOf(dt.hour())   + ' ';
        cronString += String.valueOf(dt.day())    + ' ';
        cronString += String.valueOf(dt.month())  + ' ? ';
        cronString += String.valueOf(dt.year());
        return cronString;
    }
}