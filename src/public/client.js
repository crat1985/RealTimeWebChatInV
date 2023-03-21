let err = location.search.substring(5)
if (err.length != 0) {
    alert(err.replaceAll("%20", " "))
    location.search = ""
}
