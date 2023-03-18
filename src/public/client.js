const socket = new WebSocket("ws://"+location.hostname+":8080")

socket.addEventListener("open", (e) => {
    console.log("Connected to server !")
})

socket.addEventListener("message", (e) => {
    console.log("Message from server : ", e.data)
})

let err = location.search.substring(5)
if (err.length != 0) {
    alert(err.replaceAll("%20", " "))
    location.search = ""
}