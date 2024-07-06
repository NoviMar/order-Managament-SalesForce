# order-Managament-SalesForce



## Order Management


You need to implement a simple one-page application to allow the user to create an order.
Requirements:

You need to create Custom Objects according to the Data Model
All requirements represent as User Stories with useful links
You can use only LWC components and Apex classes, Aura component you can use only as a container for LWC components if you need
Cover Apex code by Unit Tests
Create a repo on GitHub, try to commit the changes more often
Create Admin user for sergey@truesolv.com on Salesforce Dev Instance when the task was done
Create an unmanaged package - Create and Upload an Unmanaged Package
More information and links to documentation you can find in Tools Section
Get started Salesforce development and useful links

## Data Model:



### Order__c - new custom object
Name - String
AccountId - Lookup to Account object
TotalProductCount - Number
TotalPrice - Number


### OrderItem__c - new custom object
OrderId - Master-Detail to Order
ProductId - Master-Detail to Product
Quantity - Number
Price - Number


### Product__c -  new custom object
Name - String
Description - String
Type - Picklist
Family - Picklist
Image - Url - link to image
Price - Number


### User - standard object
IsManager - Boolean new custom field
How to create Custom Object and Fields



## User stories:
As a user, I can open an Order Management page from Account layout (You need to put a button to Account layout that will open an Order Management page in separate tab)
As a user, I can see Account Name and Number on the page
Data Binding in a Template
As a user, I can filter the displayed product by Family and Type
Call Apex Method from LWC
Render Lists in LWC
Run code on load (ConnectedCallback)
As a user, I can search for the product by Name and Description
As a user, I can see product details in modal window (Details button on Product Tile)
Modal Window
LWC Record Edit Form
LWC Record View Form
As a user, I can select a product and add it to Cart (Add button on Product Tile)
Show Toast message
As a user, I can see products in the Cart (Cart button will open a modal with selected products in table view)
As a user, I can check out a Cart (Checkout button on Cart Modal) This action will create Order and Order Item records. 
TotalProductCount__c and TotalPrice__c on Order__c object should be calculated automatically in a Trigger based on Order Items records.
Apex Trigger
As a user, after checking out the cart I should be redirected to the standard Order layout to see created Order and Order Items
As a manager, I should have the ability to create a new product in the modal window. (Create a Product button. The button should be available only for users with IsManager__c = true)
Render DOM Elements Conditionally
If the Image field on the Product object is empty. You need to send a request to http://www.glyffix.com/api/Image?word={PRODUCT_NAME}, where {PRODUCT_NAME} is the name of the created product and put the link to the Image field. More information about the API you can find here. Example of the request below:



## Tools:
Salesforce Dev Org - Salesforce Developer Portal
IDE - IntelliJ IDEA + JetForcer
Backend - Apex - Apex Developer Guide
Client-Side - LWC - LWC Docs
Styles - Lightning Design System - SLDS
UI Mockup

