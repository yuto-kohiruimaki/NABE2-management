// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
    // menu
    const logo = document.getElementById('logo');
    const hmb = document.getElementById('hmb');
    const menu = document.getElementById('menu');

    hmb.addEventListener('click', () => {
        logo.classList.toggle('active');
        hmb.classList.toggle('active');
        menu.classList.toggle('active');
    });
})