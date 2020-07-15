@isTest
public class APIEndpointControllersTest {
    
    @testSetup static void setup() {
        Profile pr=[SELECT id FROM Profile WHERE name='System Administrator'];
        User usr = new User(alias = 'usr',
                            email='us.name@vmail.com',
                            emailencodingkey='UTF-8',
                            firstname='firstname',
                            lastname='lstname',
                            timezonesidkey='America/Los_Angeles',
                            languagelocalekey='en_US',
                            localesidkey='en_US',
                            ProfileId = pr.Id,
                            //UserRoleId=Urole.Id,
                            username='nikeel@testorg.com',
                            Department='CS-testuser');
        
        insert usr;     
    }
    
    @isTest static void testTriggerHandler() {
        User usr = [SELECT Id FROM User WHERE firstname='firstname' LIMIT 1];
        
        system.runAs(usr){
            
            // Perform test
            Test.startTest(); 
            
            Account testacc3 = new Account(Name = 'name', Website = 'domain');
            insert testacc3;
            
            System.assert(AccountSearchRestController.doGet('name', 'domain').size() == 1);
            System.assert(AccountSearchRestController.doGet('name', 'domain!@#$%\'') == null);
            
            AcccountSearchBulkEndPoint.listInput lst=new AcccountSearchBulkEndPoint.listInput();
            lst.inputlist = new List<AcccountSearchBulkEndPoint.Input>();
            AcccountSearchBulkEndPoint.Input inp= new AcccountSearchBulkEndPoint.Input();
            inp.Id = 'testid';
            inp.Name = 'testname';
            inp.Website = 'testwebsite';
            lst.inputlist.add(inp);
            
            // Assert Number of records returned = 1(inserted above)
            System.assert(AcccountSearchBulkEndPoint.doGet(lst).size() == 1);
            
            Test.stopTest();
        }
    }
    
}