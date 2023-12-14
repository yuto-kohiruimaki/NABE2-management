// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
import "controllers"


// menu
const logo = document.getElementById('logo');
const hmb = document.getElementById('hmb');
const menu = document.getElementById('menu');

hmb.addEventListener('click', () => {
    logo.classList.toggle('active');
    hmb.classList.toggle('active');
    menu.classList.toggle('active');
});

const currentUrl = new URLSearchParams(window.location.search);
let paramsYear = currentUrl.get("year");
let paramsMonth = currentUrl.get("month");

const getDay = new Date();
const thisYear = getDay.getFullYear();
const thisMonth = getDay.getMonth() + 1;
const today = getDay.getDate();

function is_year_present() {
    return paramsYear !== null && paramsYear !== undefined && paramsYear !== "";
}

function is_month_present() {
    return paramsMonth !== null && paramsMonth !== undefined && paramsMonth !== "";
}

if (!(is_year_present() && is_month_present())) {
    paramsYear = thisYear;
    paramsMonth = thisMonth;

    
    const newUrl = new URL(window.location.href);
    newUrl.searchParams.set("year", paramsYear);
    newUrl.searchParams.set("month", paramsMonth);
    
    window.location.href = newUrl.toString();
}
