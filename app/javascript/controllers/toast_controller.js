import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  static targets = ["toast"]
  static values = {
    message: String,
    type: String
  }

  connect() {
    if (this.messageValue) {
      this.show()
    }
  }

  show() {
    const toastElement = this.toastTarget
    const toast = new bootstrap.Toast(toastElement, {
      autohide: true,
      delay: 5000
    })
    toast.show()
  }

  hide() {
    const toastElement = this.toastTarget
    const toast = bootstrap.Toast.getInstance(toastElement)
    if (toast) {
      toast.hide()
    }
  }
} 