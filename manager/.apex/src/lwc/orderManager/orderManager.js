import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAllProducts from '@salesforce/apex/ProductController.getAllProducts';
import saveProduct from '@salesforce/apex/ProductController.saveProduct';
import createOrder from '@salesforce/apex/OrdersController.createOrder';
import getUserInfo from '@salesforce/apex/AccountController.getUserInfo';
import createOrderItem from '@salesforce/apex/OrderItemsController.createOrderItem';

export default class OrderManager extends NavigationMixin(LightningElement) {
    @track products;
    @track originalProducts;
    @track error;
    @track searchKey = '';
    @track showModal = false;
    @track selectedProduct = {};
    @track cartItems = [];
    @track showCartModal = false;
    @track typeFilter = '';
    @track familyFilter = '';
    @track showNotification = false;
    @track showSearch = true;
    @track showSidebar = true;
    @track showCartButton = true;
    @track showCreateProductModal = false;
    @track productName = '';
    @track productDescription = '';
    @track productType = '';
    @track productFamily = '';
    @track productImage = '';
    @track productPrice = '';
    userDetails;
    isManager;
    @track typeOptions = [
        { label: 'first Example', value: 'first Example' },
        { label: 'second Example', value: 'second Example' },
        { label: 'third Example', value: 'third Example' }
    ];
    @track familyOptions = [
        { label: 'first Example', value: 'first Example' },
        { label: 'second Example', value: 'second Example' },
        { label: 'third Example', value: 'third Example' }
    ];
    @track product = {};

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this.product[field] = event.target.value;
    }

    closeCreateProductModal() {
        this.showCreateProductModal = false;
    }

    handleSaveProduct() {
        const { name, description, type, family, image, price } = this.product;
        // Validate the product image URL
        if (!this.isValidURL(image)) {
            alert('Недействительный URL изображения. Пожалуйста, введите правильный URL.');
            return;
        }
        alert(name + description + type + family + image + price);
        saveProduct({ name, description, type, family, image, price })
            .then(() => {
                this.closeCreateProductModal();
                // Handle success (e.g., show a success message)
            })
            .catch(error => {
                // Handle error (e.g., show an error message)
                console.error('Error saving product:', error);
            });
    }

    handleProductCreated(event) {}

    handleProductError(event) {}

    @wire(getAllProducts)
    wiredProducts({ error, data }) {
        if (data) {
            this.originalProducts = data;
            this.products = data;
            this.error = undefined;
            this.updateProductDescriptions();
        } else if (error) {
            this.error = error;
            this.products = undefined;
        }
    }

    @wire(getUserInfo)
    wiredUserInfo({ error, data }) {
        if (data) {
            this.userDetails = data;
            this.isManager = data.IsManager__c;
            console.log('User Details:', this.userDetails);
        } else if (error) {
            console.error('Error loading user info:', error);
        }
    }

    connectedCallback() {
        this.loadProducts();
    }

    loadProducts() {
        getAllProducts()
            .then(result => {
                this.originalProducts = result;
                this.products = result;
                this.filterProducts();
                this.updateProductDescriptions();
            })
            .catch(error => {
                this.error = error;
                this.products = undefined;
            });
    }

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
        this.filterProducts();
    }

    handleTypeFilterChange(event) {
        this.typeFilter = event.target.dataset.type;
        this.filterProducts();
    }

    handleFamilyFilterChange(event) {
        this.familyFilter = event.target.dataset.family;
        this.filterProducts();
    }

    filterProducts() {
        this.products = this.originalProducts.filter(product => {
            const searchKeyLower = this.searchKey.toLowerCase();
            const nameMatches = product.Name.toLowerCase().includes(searchKeyLower);
            const descriptionMatches = product.Description__c && product.Description__c.toLowerCase().includes(searchKeyLower);
            return (!this.typeFilter || product.Type__c === this.typeFilter) &&
                (!this.familyFilter || product.Family__c === this.familyFilter) &&
                (!this.searchKey || nameMatches || descriptionMatches);
        });
    }

    handleAddToCart(event) {
        const productId = event.target.dataset.id;
        const productToAdd = this.products.find(product => product.Id === productId);
        const existingCartItem = this.cartItems.find(item => item.Id === productId);
        if (existingCartItem) {
            existingCartItem.quantity += 1;
        } else {
            this.cartItems = [...this.cartItems, { ...productToAdd, quantity: 1, price: productToAdd.Price__c }];
        }
        console.log('Product added to cart:', productToAdd);
        console.log('Current cart items:', this.cartItems);
        this.showNotificationPopup();
    }

    openCartModal() {
        this.showCartModal = true;
    }

    closeCartModal() {
        this.showCartModal = false;
    }

    closeModal() {
        this.showModal = false;
    }

    openCreateProductModal() {
        if (this.isManager) {
            this.showCreateProductModal = true;
        } else {
            alert('У вас нет прав для создания продукта.');
        }
    }

    closeCreateProductModal() {
        this.showCreateProductModal = false;
    }

    showNotificationPopup() {
        this.showNotification = true;
        setTimeout(() => {
            this.showNotification = false;
        }, 3000);
    }

    updateProductDescriptions() {
        this.products = this.products.map(product => {
            return {
                ...product,
                strippedDescription: this.stripHTML(product.Description__c)
            };
        });
    }


    handleShowDetails(event) {
        const productId = event.target.dataset.id;
        this.selectedProduct = this.products.find(product => product.Id === productId);
        console.log('Selected Product:', this.selectedProduct);
        this.showModal = true;
        // Check image URL
        if (!this.isValidURL(this.selectedProduct.Image__c)) {
            this.selectedProduct.Image__c = 'https://example.com/default-image.jpg';
        }
        const descriptionElement = this.template.querySelector('.modal-content .product-description');
        if (descriptionElement) {
            descriptionElement.textContent = this.stripHTML(this.selectedProduct.Description__c);
        }
    }

    async handleSaveOrder() {
        try {
            // Extract quantities and prices from cart items
            let quantities = this.cartItems.map(item => item.quantity);
            let prices = this.cartItems.map(item => parseFloat(item.Price__c));
            let totalProductCount = quantities.reduce((acc, quantity) => acc + quantity, 0);
            let totalPrice = this.cartItems.reduce((acc, item) => acc + (item.quantity * parseFloat(item.Price__c)), 0);
            let productName = this.cartItems.length > 0 ? this.cartItems[0].Name : 'Default Product Name';
            if (quantities.length === 0 || prices.length === 0) {
                totalProductCount = 0;
                totalPrice = 0;
            }
            const orderId = await createOrder({ productName: productName, totalProductCount: totalProductCount, totalPrice: totalPrice });
            for (let item of this.cartItems) {
                const orderItem = { orderId: orderId, productId: item.Id, quantity: parseInt(item.quantity), price: parseInt(item.Price__c) };
                await createOrderItem(orderItem);
            }
            alert('Order items successfully created!');
            this.closeCartModal();
            // Redirect to the Order detail page
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: orderId,
                    objectApiName: 'Order',
                    actionName: 'view'
                }
            });
        } catch (error) {
            console.error('Error creating order:', error);
            alert('An error occurred while creating the order. Please try again.');
        }
    }

    get productCardClass() {
        return (index) => `product-card ${index === this.products.length - 1 ? 'last-card' : ''}`;
    }

    isValidURL(url) {
        const regex = /^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([\/\w .-]*)*\/?$/;
        return regex.test(url);
    }

    stripHTML(html) {
        const div = document.createElement('div');
        div.innerHTML = html;
        return div.textContent || div.innerText || '';
    }
}