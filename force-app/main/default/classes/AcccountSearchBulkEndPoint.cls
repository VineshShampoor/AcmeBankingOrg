@RestResource(urlMapping='/searchbulkaccount/*')
global without sharing class AcccountSearchBulkEndPoint {
    
    @HttpPost 
    global static List<Output> doGet(listInput lst) {
        
        try{
            
            System.debug('Parameter: ' + lst);
            
            // return variable : Deserialized at receiving end
            List<Output> lstouts= new List<Output>();
            
            List<Account> fullList = new List<Account>();
            
            Set<String> names = new Set<String>();
            
            for(Input ip: lst.inputList){
                names.add(ip.Name);
            }
            
            fullList = [select Id, Name, Website from Account where Name IN :names ];
            
            for(Input ip: lst.inputList){
                
                String web = '';
                if(ip.Website != '' && ip.Website != null){
                    web = ip.Website.replace('http://','').replace('https://','').replace('www.','').split('/[/?#.]/')[0].split('\\.')[0];
                }
                
                List<Account> lstemp = new List<Account>();
                for(Account act: fullList){
                    if(act.Website.toLowerCase().contains(web)){
                        lstemp.add(act);
                    }
                }
                
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