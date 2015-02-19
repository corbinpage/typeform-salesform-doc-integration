@isTest
public class TypeformIntegrationTests {
    @isTest
    static void testCreateContact() { 
        Datetime now = Datetime.now();
        String dateLand = String.valueOf(now);
        Contact con = TypeformIntegration.createContact('TestUser Name', 'test_create@test.com', '704-867-5309', dateLand);
        System.assertEquals('TestUser Name', con.LastName);
        System.assertEquals('test_create@test.com', con.Email);
        System.assertEquals('704-867-5309', con.Phone);
        Boolean dateWorks = now.isSameDay(con.userEnteredDate__c);
        System.assertEquals(true, dateWorks);
    }
    
    @isTest
    static void testCreateOrUpdateContact() { 
        Datetime now = Datetime.now();
        String dateLand = String.valueOf(now);
        Contact con = TypeformIntegration.createContact('User Name', 'test@test.com', '704-867-5309', dateLand);
        Contact con2 = TypeformIntegration.createOrUpdateContact('User Name', 'test@test.com', '704-867-5309', dateLand,'testFilePath');
        Contact con3 = TypeformIntegration.createOrUpdateContact('User Name', 'test3@test.com', '704-867-5309', dateLand,'testFilePath');
        
        System.assertEquals(con.Id, con2.Id);
        System.assertNotEquals(con.Id, con3.Id);
    }
}