let port = 8080

if(location.protocol=="https:") {
    port = 8443
}

const socket = new WebSocket("wss://"+location.hostname+":"+port);
const disconnect_link = document.querySelector(".disconnect_link");

socket.addEventListener("open", (e) => {
    console.log("Connected to server !");
});

socket.addEventListener("message", (e) => {
    console.log("Message from server : ", e.data);
});