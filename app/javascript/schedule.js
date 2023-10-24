const index = document.getElementsByClassName('index')[0];
const dateArr = document.querySelectorAll('.content-add-schedule');

const month = index.id;
for (let i = 0; i < dateArr.length; i++) {
    dateArr[i].addEventListener('click', () => {
        dateArr.forEach((element) => {
            element.classList.remove('selected');
        });
        dateArr[i].classList.add('selected');
        const date = index.querySelector('.selected').id;
        window.location.href = `/posts/new?month=${month}&date=${date}`;
    });
}