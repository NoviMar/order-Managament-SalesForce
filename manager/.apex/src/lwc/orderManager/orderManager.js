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
}
