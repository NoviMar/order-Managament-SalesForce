import { LightningElement } from 'lwc';

export default class ConditionalRenderingExample extends LightningElement {
    showDetails = false; // Начальное состояние

    // Метод для переключения состояния
    toggleDetails() {
        this.showDetails = !this.showDetails;
    }
}
