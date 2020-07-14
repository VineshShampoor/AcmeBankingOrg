@RestResource(urlMapping='/searchaccount/*')
global without sharing class AccountSearchRestController {
    
    @HttpPost
    global static List<Account> doGet(String name, String domain) {
        
        try{
            List<Account> accounts = Database.query('select Id, Name, Website from Account where Name =:name and Website LIKE \'%'+ domain+'%\'');
            return accounts;         
        }catch(System.Exception e){
            
            System.debug('exception '+e);
            return null;  
        }
    } 
}