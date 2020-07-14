@RestResource(urlMapping='/searchbulkaccount/*')
global without sharing class AcccountSearchBulkEndPoint {
    
    @HttpPost 
    global static List<Output> doGet(listInput lst) {
        
        try{
            
            System.debug('Parameter: ' + lst);
            
            // return variable : Deserialized at receiving end
            List<Output> lstouts= new List<Output>();
            
            for(Input ip: lst.inputList){
                String nm = ip.Name;
                String web = '';
                if(ip.Website != '' && ip.Website != null){
                    web = ip.Website.replace('http://','').replace('https://','').replace('www.','').split('/[/?#.]/')[0].split('\\.')[0];
                }
                
                System.debug('innn' + nm + web);
                List<Account> lstemp = Database.query('select Id, Name, Website from Account where Name =:nm and Website LIKE \'%'+ web+'%\'');
                
                Output temp = new Output();
                
                // Id to Identify which combination(Name+Website): passing same value came from input;
                temp.Id = ip.Id;
                temp.lst = new List<Account>();
                temp.lst = lstemp;
                lstouts.add(temp);
            }
            
            System.debug('res '+lstouts);
            return lstouts; 
            
        }catch(System.Exception e){
            System.debug('exception '+e);
            return null;  
        }
    }
    
    //Bulk Searching API - Input Format(Individual Request Unit)
    global class Input{
        global String Id;
        global String Name;
        global String Website;
    }
    
    //Bulk Searching API - Input Parameter: List of Inputs 
    global class listInput{
        global List<Input> inputlist;
    }
    
    // Bulk Response: Inner Class
    global class Output{
        global String Id;
        global List<Account> lst;
    }
}