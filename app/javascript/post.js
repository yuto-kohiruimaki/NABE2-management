const urlParams = new URLSearchParams(window.location.search);
const month = urlParams.get('month');
const date = urlParams.get('date');

const selectMonth = document.getElementById('month');
const monthOptions = selectMonth.options;
const monthArr = {};
for (let i = 0; i < monthOptions.length; i ++) {
    monthArr[i] = monthOptions[i].value;
}
const monthValuesArr = Object.values(monthArr);
const findMonth = monthValuesArr.find((num) => num == month);
monthOptions[findMonth - 1].selected = true;

const selectDate = document.getElementById('date');
const dateOptions = selectDate.options;
const dateArr = {};
for (let i = 0; i < dateOptions.length; i++) {
    dateArr[i] = dateOptions[i].value;
}
const dateValuesArr = Object.values(dateArr);
const findDate = dateValuesArr.find((num) => num == date);
dateOptions[findDate - 1].selected = true;

console.log(dateOptions[findDate - 1].value);