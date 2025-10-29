public class devops_HelloWorld {
    
    /**
     * Method 1
     * @description: debug Product2 field values to the console log
     * - Name
     * - New Product 2
     */
	public static void returnProductValues1(Product2 p) {
        // debug Product2 field values to console
        // Product2 Name
        System.debug('Product2 Name: ' + p.Name);
        
        // Product2 New_Product_2__c
        System.debug('Product2 New Product 2: ' + p.New_Product_2__c);
    }
}
