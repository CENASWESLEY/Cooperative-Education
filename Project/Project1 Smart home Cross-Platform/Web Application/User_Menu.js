
var icon_menu_device = document.getElementById("user_icon_device");
var menu_device = document.getElementById("user_menu");
var menu_device_close = document.getElementById("close-button-device");

icon_menu_device.addEventListener("click",()=>{

    menu_device.style.display = "flex";

})

menu_device_close.addEventListener("click",()=>{

    menu_device.style.display = "none";

})


