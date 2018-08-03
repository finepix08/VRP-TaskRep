@isTest
public class TestVerifyDate {
    @isTest static void TestVerifyDateMethod() {
        Date date1 = date.newInstance(2018, 6, 1);
        Date date2 = date.newInstance(2018, 6, 31);
        Date date3 = date.newInstance(2018, 7, 5);
        Date CheakDate1 = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(date2, CheakDate1);
    }
}