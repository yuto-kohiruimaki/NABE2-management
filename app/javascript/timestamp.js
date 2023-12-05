document.addEventListener("turbo:load", () => {
    const getDay = new Date();
    const thisMonth = getDay.getMonth() + 1;
    const today = getDay.getDate();
    
    const month = document.getElementById('month');
    const monthOptions = month.options;
    const monthArr = {};
    for (let i = 0; i < monthOptions.length; i ++) {
            monthArr[i] = monthOptions[i].value;
    }
    const monthValuesArr = Object.values(monthArr);
    const findMonth = monthValuesArr.find((num) => num == thisMonth);
    monthOptions[findMonth - 1].selected = true;
    
    const date = document.getElementById('date');
    const dateOptions = date.options;
    const dateArr ={};
    for (let i = 0; i < dateOptions.length; i ++) {
        dateArr[i] = dateOptions[i].value;
    }
    const dateValuesArr = Object.values(dateArr);
    const findDate = dateValuesArr.find((num) => num == today);
    dateOptions[findDate - 1].selected = true;
})