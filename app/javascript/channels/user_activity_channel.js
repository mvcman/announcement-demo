import consumer from "channels/consumer"

consumer.subscriptions.create("UserActivityChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected to the user channel!");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("received data", data);
    // Called when there's incoming data on the websocket for this channel
    const userElement = document.querySelector(`[data-user-id="${data.user_id}"]`);
    if (userElement) {
      userElement.classList.toggle("active", data.status);
    }
  },
});

const notifySever = (status) => {
  fetch("/users/update_status", {
    method: "PATCH",
    credentials: "same-origin",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
    },
    body: JSON.stringify({ status })
  });
};

document.addEventListener("visibilitychange", () => {
    notifySever(document.visibilityState == "visible" ? "active" : "inactive");
});

document.addEventListener("DOMContentLoaded", () => {
  notifySever("active");
});