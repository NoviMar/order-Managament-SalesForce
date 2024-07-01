import { LightningElement, wire } from 'lwc';
import getFilteredProducts from '@salesforce/apex/ProductController.getFilteredProducts';

export default class ProductList extends LightningElement {
    products;
    error;
    searchKey = '';
    typeFilter = '';
    familyFilter = '';

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
    }

    handleSearch() {
        // Perform search using the searchKey
        // For simplicity, I'll filter in-memory here
        if (this.searchKey) {
            this.products = this.products.filter(product =>
                product.Name.toLowerCase().includes(this.searchKey.toLowerCase())
            );
        } else {
            this.refreshProducts();
        }
    }

    handleTypeChange(event) {
        this.typeFilter = event.target.value;
        this.refreshProducts();
    }

    handleFamilyChange(event) {
        this.familyFilter = event.target.value;
        this.refreshProducts();
    }

    refreshProducts() {
        getFilteredProducts({
            type: this.typeFilter,
            family: this.familyFilter
        })
            .then(result => {
                this.products = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.products = undefined;
            });
    }
}
