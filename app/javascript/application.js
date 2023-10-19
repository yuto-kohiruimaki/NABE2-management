// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"

const logo = document.getElementById('logo');
const hmb = document.getElementById('hmb');
const menu = document.getElementById('menu');

hmb.addEventListener('click', () => {
    logo.classList.toggle('active');
    hmb.classList.toggle('active');
    menu.classList.toggle('active');
});

const getDay = new Date();
const thisMonth = getDay.getMonth() + 1;
const today = getDay.getDate();

const month = document.getElementById('month');
const monthOptions = month.options;
const monthArr = {};
for (let i = 0; i < monthOptions.length; i ++) {
        monthArr[i] = monthOptions[i].value;
}
const monthArrValues = Object.values(monthArr);
const findMonth = monthArrValues.find((num) => num == thisMonth);
monthOptions[findMonth - 1].selected = true;


const date = document.getElementById('date');
const dateOptions = date.options;
const dateArr ={};
for (let i = 0; i < dateOptions.length; i ++) {
    dateArr[i] = dateOptions[i].value;
}
const dateArrValues = Object.values(dateArr);
const findDate = dateArrValues.find((num) => num == today);
dateOptions[findDate - 1].selected = true;

//= require jquery_ujs