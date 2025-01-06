import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["toggleDiv"]
  connect() {
    console.log("connected to the toggle controller!");

  }

  toggleSidebar() {
    if (this.toggleDivTarget.classList.contains("w-56")) {
        this.toggleDivTarget.classList.remove("w-56");
        this.toggleDivTarget.classList.add("w-16");
    } else {
        this.toggleDivTarget.classList.add("w-56");
        this.toggleDivTarget.classList.remove("w-16");
    }
  }
}
