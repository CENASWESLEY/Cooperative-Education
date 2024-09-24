
/*============ menu ===============*/
const navMenu = document.getElementById('menu-text'),
      navToggle = document.getElementById('menu-toggle'),
      navClose = document.getElementById('menu-close')

      if(navToggle){
          navToggle.addEventListener('click',() =>{

            navMenu.classList.add('show-menu'),
            navClose.classList.add('show-close')
            
          })
      }

      if(navClose){

        navClose.addEventListener('click',() => {

            navMenu.classList.remove('show-menu'),
            navClose.classList.remove('show-close')

        })
      }



/*============ search ===============*/


let Keywords =['Web Development','Finance and Tax','English','Programming','Economy'];

const resultbox = document.querySelector(".home__resultbox");
const inputbox = document.getElementById("searchbar");

inputbox.onkeyup = function(){

  let result = [];
  let input = inputbox.value;
  if(input.length){
    result = Keywords.filter((Keywords)=>{
      return Keywords.toLowerCase().includes(input.toLowerCase());
    });
    console.log(result)
  }
  display(result);
  if(!result.length){

    resultbox.innerHTML = '';

  }
}

function display(result){

  const content = result.map((list) =>{
    return '<li onclick=selectInput(this)>' + list + '</li>';
  });

  resultbox.innerHTML = '<ul>' + content.join('') +'</ul>';
}

function selectInput(list) {
  inputbox.value = list.innerHTML;
  resultbox.innerHTML ='';
  
}


/*============ home ===============*/


var slideIndex = 1;
showSlides(slideIndex);

function plusSlides(n) {
  showSlides(slideIndex += n);
}

function currentSlide(n) {
  showSlides(slideIndex = n);
}

function showSlides(n) {
  var i;
  var slides = document.getElementsByClassName("home__maincontent");
  var dots = document.getElementsByClassName("home__point");
  if (n > slides.length) {slideIndex = 1}    
  if (n < 1) {slideIndex = slides.length}
  for (i = 0; i < slides.length; i++) {
      slides[i].style.display = "none";  
  }
  for (i = 0; i < dots.length; i++) {
      dots[i].className = dots[i].className.replace(" active", "");
  }
  slides[slideIndex-1].style.display = "flex";  
  dots[slideIndex-1].className += " active";
}


/*============ course ===============*/


var slideIndex = 1;
showDivs(slideIndex);

function plusDivs(n) {
  showDivs(slideIndex += n);
}

function showDivs(n) {
  var i;
  var x = document.getElementsByClassName("course__mainbox");
  if (n > x.length) {slideIndex = 1}
  if (n < 1) {slideIndex = x.length}
  for (i = 0; i < x.length; i++) {
    x[i].style.display = "none";  
  }
  x[slideIndex-1].style.display = "flex";  
}

/*============ new ===============*/

var slideIndex = 1;
showDivs2(slideIndex);

function plusDivs2(n) {
  showDivs2(slideIndex += n);
}

function showDivs2(n) {
  var i;
  var y = document.getElementsByClassName("new__submainbox");
  if (n > y.length) {slideIndex = 1}
  if (n < 1) {slideIndex = y.length}
  for (i = 0; i < y.length; i++) {
    y[i].style.display = "none";  
  }
  y[slideIndex-1].style.display = "flex";  
}
