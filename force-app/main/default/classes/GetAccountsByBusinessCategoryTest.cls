// Date:    03/26/24
// Author:  Ksenia Choate
// Created with the help from GPT4 and GitHub Copilot
// Description: Class created to test GetAccountsByBusinessCategory class.
// History: V.1

@isTest
public class GetAccountsByBusinessCategoryTest {
 
    // Utility method to create test accounts with different business categories and counties
    private static List<Account> createTestAccounts() {
        List<Account> accountsToInsert = new List<Account>();
        String businessRegistrationRecordTypeId = GetAccountsByBusinessCategory.getBusinessRegistrationRecordTypeId();

        // Ensure a Business Registration record type ID is available
        if (businessRegistrationRecordTypeId == null) {
        System.debug('Business Registration record type ID not found.');
        return null;
        }
    
        // Insert accounts with various business categories, counties, and descriptions
        accountsToInsert.add(new Account(
            Name='Tech Innovations', 
            Business_Category__c='Arts, Entertainment, and Recreation', 
            County__c='Salt Lake County', 
            Business_Description__c='Leading innovations in the entertainment sector.',
            RecordTypeId=businessRegistrationRecordTypeId));
            
        accountsToInsert.add(new Account(
            Name='Agri Solutions', 
            Business_Category__c='Finance and Insurance', 
            County__c='Davis County', 
            Business_Description__c='Financial solutions tailored for the agricultural industry.',
            RecordTypeId=businessRegistrationRecordTypeId));
            
        accountsToInsert.add(new Account(
            Name='Eco Friendly', 
            Business_Category__c='Retail Trade', 
            County__c='Cache County', 
            Business_Description__c='Eco-friendly products for a greener tomorrow.',
            RecordTypeId=businessRegistrationRecordTypeId));
        
        insert accountsToInsert;
        return accountsToInsert;
    }

    // Test method to verify accounts are correctly filtered by business category
    @isTest
    static void testFilterByBusinessCategory() {
        // Arrange
        createTestAccounts();
        List<String> filterCategories = new List<String>{'Arts, Entertainment, and Recreation'};
        
        // Act
        List<Account> filteredAccounts = GetAccountsByBusinessCategory.filterAccounts(filterCategories, null, null);
        
        // Assert
        System.assertEquals(1, filteredAccounts.size(), 'There should be one account with the specified category.');
        System.assertEquals('Tech Innovations', filteredAccounts[0].Name, 'The account name should match.');
    }
    
    // Test method to verify accounts are correctly filtered by county
    @isTest
    static void testFilterByCounty() {
        // Arrange
        createTestAccounts();
        List<String> filterCounties = new List<String>{'Davis County'};
        
        // Act
        List<Account> filteredAccounts = GetAccountsByBusinessCategory.filterAccounts(null, filterCounties, null);
        
        // Assert
        System.assertEquals(1, filteredAccounts.size(), 'There should be one account in Davis County.');
        System.assertEquals('Agri Solutions', filteredAccounts[0].Name, 'The account name should match.');
    }
    
    // Test method to verify filtering by both business category and county
    @isTest
    static void testFilterByCategoryAndCounty() {
        // Arrange
        createTestAccounts();
        List<String> filterCategories = new List<String>{'Retail Trade'};
        List<String> filterCounties = new List<String>{'Cache County'};
        
        // Act
        List<Account> filteredAccounts = GetAccountsByBusinessCategory.filterAccounts(filterCategories, filterCounties, null);
        
        // Assert
        System.assertEquals(1, filteredAccounts.size(), 'There should be one account matching both category and county.');
        System.assertEquals('Eco Friendly', filteredAccounts[0].Name, 'The account name should match.');
    }

    @isTest
    static void testFilterBySearchKey() {
        // Arrange: Create test accounts and define a search key that matches one of the account's Name or Business_Description__c
        createTestAccounts();
        String searchKey = 'Eco'; // Assuming 'Eco Friendly' has 'Eco' in its Name or Business_Description__c
        
        // Act: Call the filterAccounts method with the search key
        List<Account> filteredAccounts = GetAccountsByBusinessCategory.filterAccounts(null, null, searchKey);
        
        // Assert: Verify that only accounts matching the search key are returned
        System.assertEquals(1, filteredAccounts.size(), 'There should be one account matching the search key.');
        System.assertEquals('Eco Friendly', filteredAccounts[0].Name, 'The account name should match the search key.');
    }

    // Test method for handling null and empty input parameters
    @isTest
    static void testNullAndEmptyFilters() {
        // Arrange
        createTestAccounts();
        
        // Act
        List<Account> filteredAccountsNull = GetAccountsByBusinessCategory.filterAccounts(null, null, null);
        List<Account> filteredAccountsEmpty = GetAccountsByBusinessCategory.filterAccounts(new List<String>{}, new List<String>{}, '');
        
        // Assert
        System.assertNotEquals(null, filteredAccountsNull, 'The method should return an empty list instead of null.');
        System.assertEquals(filteredAccountsNull.size(), filteredAccountsEmpty.size(), 'Both null and empty filters should yield the same result.');
    }

    @isTest
    static void testInvalidBusinessCategoriesAndCounties() {
        // Arrange: Create test accounts
        createTestAccounts();
        List<String> invalidCategories = new List<String>{'Nonexistent Category'};
        List<String> invalidCounties = new List<String>{'Nonexistent County'};
        
        // Act: Call the filterAccounts method with invalid business categories and counties
        List<Account> filteredAccounts = GetAccountsByBusinessCategory.filterAccounts(invalidCategories, invalidCounties, null);
        
        // Assert: Verify that no accounts are returned for invalid filters
        System.assertEquals(0, filteredAccounts.size(), 'No accounts should be returned for invalid business categories and counties.');
    }  
}