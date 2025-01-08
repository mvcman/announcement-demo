import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["btn"]
  connect() {
    console.log("connected to the request controller!");
  }

  toggle() {
    this.btnTargets.forEach((element) => {
        console.log(element.dataset.id);
        if (element.dataset.id === "approve") {
            element.classList.toggle("hidden");
        } else {
            element.classList.toggle("hidden");
        }
    });
  }
}
