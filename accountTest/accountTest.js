import { LightningElement, track } from 'lwc';
import makeContactPrimary from '@salesforce/apex/AccountTest.makeContactPrimary';
import getAccounts from '@salesforce/apex/AccountTest.getAccounts';
export default class AccountTest extends LightningElement {
    @track
    Accounts
    connectedCallback(){
        getAccounts()
        .then(result =>{
            let returnVal = JSON.parse(result);
            if(returnVal.success){
                let accs = returnVal.accounts;
                for(var i = 0; i<accs.length ; i++){
                    accs[i].showContacts = false;
                }
                this.Accounts = accs;
                console.log(accs)
            }
        })
        .catch(error => {

        })
    }
    makeConPrimary(event){
        let AccId = event.currentTarget.dataset.accid
        let ConId = event.currentTarget.dataset.conid;
        makeContactPrimary({
            AccountID : AccId,
            ContactId : ConId
        })
        .then(result =>{
            getAccounts()
            .then(result =>{
                let returnVal = JSON.parse(result);
                if(returnVal.success){
                    let accs = returnVal.accounts;
                    for(var i = 0; i<accs.length ; i++){
                        accs[i].showContacts = false;
                    }
                    this.Accounts = accs;
                    console.log(accs)
                }
            })
            .catch(error => {
    
            })
        })
        .catch(error => {

        })
    }
    showContacts(event){
        let accId = event.currentTarget.dataset.accid;
        let accs = this.Accounts;
        for(var i = 0; i<accs.length ; i++){
            if(accs[i].Id == accId)
                accs[i].showContacts = !accs[i].showContacts;
        }
        this.Accounts = accs;
    }
}