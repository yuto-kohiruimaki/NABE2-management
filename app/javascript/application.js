// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
import "controllers"
import "admin-users"


// menu
const logo = document.getElementById('logo');
const hmb = document.getElementById('hmb');
const menu = document.getElementById('menu');

hmb.addEventListener('click', () => {
    logo.classList.toggle('active');
    hmb.classList.toggle('active');
    menu.classList.toggle('active');
});

const signOutButton = document.getElementById('menu-signout');
const signOutModal = document.getElementById('signout-modal');
const signOutForm = document.getElementById('sign-out-form');

if (signOutButton && signOutModal && signOutForm) {
    const dismissTriggers = signOutModal.querySelectorAll('[data-signout-dismiss]');
    const confirmTrigger = signOutModal.querySelector('[data-signout-confirm]');

    const openSignOutModal = () => {
        signOutModal.classList.add('is-open');
        signOutModal.setAttribute('aria-hidden', 'false');
    };

    const closeSignOutModal = () => {
        signOutModal.classList.remove('is-open');
        signOutModal.setAttribute('aria-hidden', 'true');
    };

    signOutButton.addEventListener('click', openSignOutModal);

    dismissTriggers.forEach((trigger) => {
        trigger.addEventListener('click', closeSignOutModal);
    });

    confirmTrigger?.addEventListener('click', () => {
        signOutForm.requestSubmit();
    });

    window.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && signOutModal.classList.contains('is-open')) {
            closeSignOutModal();
        }
    });
}

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
