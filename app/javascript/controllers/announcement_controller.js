import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["toggleable", "recipient"]
    
  connect() {
    console.log("connected to the announcement controller!");
    console.log("recipient type", this.recipientTarget.value);
    this.toggleFields();
    this.toggleCheckboxes();
  }

  toggleFields() {
    const type = this.recipientTarget.value;
    this.resetCheckboxes();
    this.toggleableTargets.forEach((element) => {
        console.log("my value", element.dataset.id, type.toLowerCase());
        if (element.dataset.id === type.toLowerCase()) {
            element.classList.remove("hidden");
        } else {
            element.classList.add("hidden");
        }
    })
  }

  resetCheckboxes() {
    let checkboxes = this.element.querySelectorAll(".checkbox");
    console.log("my reseted checkboxes", checkboxes);
    checkboxes.forEach((checkbox) => {
        checkbox.checked = false;
    });
  }

  toggleCheckboxes() {
    let checkboxes = this.element.querySelectorAll(".checkbox");
    checkboxes.forEach((checkbox) => {
        if (this.element.dataset.recipientIds.includes(checkbox.value)) {
            checkbox.checked = true;
        }  else {
            checkbox.checked = false;
        }
    });
  }
}
