import { LightningElement, wire } from 'lwc';
import getAllProducts from '@salesforce/apex/ProductController.getAllProducts';

export default class ProductList extends LightningElement {
    products;
    error;
    searchKey = '';
    showModal = false;
    selectedProduct = {};
    cartItems = [];
    showCartModal = false;

    @wire(getAllProducts)
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.products = undefined;
        }
    }

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
    }

    handleSearch() {
        // Perform search using the searchKey
        // For simplicity, I'll filter products based on the search key in-memory
        if (this.searchKey) {
            this.products = this.products.filter(product =>
                product.Name.toLowerCase().includes(this.searchKey.toLowerCase())
            );
        } else {
            // Reset to show all products when searchKey is empty
            getAllProducts().then(result => {
                this.products = result;
            }).catch(error => {
                this.error = error;
                this.products = undefined;
            });
        }
    }

    handleShowDetails(event) {
        const productId = event.target.dataset.id;
        this.selectedProduct = this.products.find(product => product.Id === productId);
        this.showModal = true;
    }

    handleAddToCart(event) {
        const productId = event.target.dataset.id;
        const productToAdd = this.products.find(product => product.Id === productId);
        this.cartItems.push(productToAdd);
        // Optionally, you can show a toast message or update UI to indicate product added to cart
    }

    handleAddToCartFromModal() {
        this.cartItems.push(this.selectedProduct);
        this.closeModal();
        // Optionally, you can show a toast message or update UI to indicate product added to cart
    }

    openCartModal() {
        this.showCartModal = true;
    }

    closeCartModal() {
        this.showCartModal = false;
    }
    handleOrder() {
        // Calculate total product count and total price
        let totalProductCount = 0;
        let totalPrice = 0;
        this.cartItems.forEach(item => {
            totalProductCount += 1; // Assuming each item adds 1 to the count
            totalPrice += item.Price__c;
        });

        // Get Account Id (you need to implement this part based on your context)
        const accountId = '001XXXXXXXXXXXXXXX'; // Replace with actual Account Id retrieval logic

        // Prepare order data
        const orderData = {
            Name: 'New Order', // Example name
            AccountId: accountId,
            TotalProductCount: totalProductCount,
            TotalPrice: totalPrice,
            OrderItems: this.cartItems.map(item => {
                return {
                    ProductId: item.Id,
                    Quantity: 1, // Assuming each item quantity is 1
                    Price: item.Price__c
                };
            })
        };

        // Call Apex method to create order
        createOrder({ orderData: orderData })
            .then(result => {
                // Handle success
                console.log('Order created successfully:', result);
                // Optionally, clear cartItems or show success message
            })
            .catch(error => {
                // Handle error
                console.error('Error creating order:', error);
                // Optionally, show error message
            });
    }
}
