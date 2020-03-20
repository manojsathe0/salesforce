/**
 * Created by jboles on 10/31/2016.
 */

public class IADPaymentTransaction
{
    public static Map<Integer, String> typeMap = new Map<Integer, String>
    {
            0 => 'UnSet',
            1 => 'Payment',
            2 => 'Refund',
            3 => 'Profile'
    };

    public static Map<Integer, String> statusMap = new Map<Integer, String>
    {
            0 => 'UnSet',
            1 => 'Pending',
            2 => 'Posted',
            3 => 'Approved',
            4 => 'Declined',
            5 => 'Error',
            6 => 'Chargeback'
    };

    public static Map<Integer, String> installmentBillStatusMap = new Map<Integer, String>
    {
            1 => 'Not Yet Due',
            2 => 'Payment Due',
            3 => 'Paid',
            4 => 'Past Due - Will Reharvest',
            5 => 'Past Due - Will Not Reharvest',
            6 => 'Error',
            7 => 'Manual 1 (TBD)',
            8 => 'Manual 2 (TBD)',
            9 => 'Uncollectible'
    };

    public static Map<Integer, String> storeCreditStatusMap = new Map<Integer, String>
    {
            1 => 'Pending',
            2 => 'Available',
            3 => 'Declined',
            4 => 'Expired'
    };

    public static Map<Integer, String> orderStatusMap = new Map<Integer, String>
    {
            1 => 'Pending',
            2 => 'Approved',
            3 => 'Declined',
            4 => 'Cancelled',
            5 => 'Uncollectible'
    };
}