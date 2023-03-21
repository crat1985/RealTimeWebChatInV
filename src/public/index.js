const socket = new WebSocket("wss://"+location.hostname+":8443")
const disconnect_button = document.querySelector(".disconnect_button")

disconnect_button.addEventListener("click", e=>{
    socket.send("")
})

socket.addEventListener("open", (e) => {
    console.log("Connected to server !")
})

socket.addEventListener("message", (e) => {
    console.log("Message from server : ", e.data)
})