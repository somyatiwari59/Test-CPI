@RestResource(urlMapping='/Account2/')
//https://somyatiwari-developer-edition.ap15.force.com/services/apexrest/Account2/
global class GetAccountData {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        Map<String, Object> request = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
        Map<String, Object> response = new Map<String, Object>();
        if(request.containsKey('filterDate')){
            response.put('success', true);
            try{
                String dateVal = String.valueOf(request.get('filterDate'));
                List<String> dateValues = dateVal.split('/');
                Date filterDate = Date.newInstance(Integer.ValueOf(dateValues[0]),Integer.ValueOf(dateValues[1]), Integer.ValueOf(dateValues[2]));   
                if(Schema.sObjectType.Account.fields.Name.isAccessible() && 
                   Schema.sObjectType.Account.fields.OwnerId.isAccessible() && 
                   Schema.sObjectType.Account.fields.BillingAddress.isAccessible() && 
                   Schema.sObjectType.Account.fields.CreatedDate.isAccessible() && 
                   Schema.sObjectType.Account.fields.Description.isAccessible() && 
                   Schema.sObjectType.User.fields.Name.isAccessible()){
                       List<Account> allAccounts = [SELECT ID, Name, Owner.Name, BillingAddress, CreatedDate, Description FROM Account WHERE CreatedDate >=: filterDate LIMIT 5];  
                       List<Object> AccountsToSend = new List<Object>();
                       for(Account acc : allAccounts){
                           Map<String, Object> currentAccount = new Map<String, Object>();
                           currentAccount.put('name', acc.Name);
                           currentAccount.put('source', '#FIELDNOTFOUND');
                           currentAccount.put('createdOn', acc.CreatedDate);
                           currentAccount.put('description', acc.Description);
                           currentAccount.put('billingAddr', acc.BillingAddress);
                           currentAccount.put('acctOwner', acc.Owner.Name );
                           AccountsToSend.add(currentAccount);
                       }
                       response.put('msg', 'Success: Successfully Retrieved');       
                       response.put('data', AccountsToSend);     
                   }
                else{                    
                    response.put('msg', 'Error: Fields Not Accessible');       
                    response.put('data', null); 
                }                
            }
            catch(Exception e){
                
                response.put('success', false);       
                response.put('msg', 'Error: Invalid Input');       
                response.put('data', e.getStackTraceString() + e.getMessage());     
            }
            
        }
        else{
            response.put('success', false);       
            response.put('msg', 'Error: Invalid Input');       
            response.put('data', null);       
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
    }
}
