
    console.log("test");

    // URLパラメータから年月日を取得
    const urlParams = new URLSearchParams(window.location.search);
    const paramYear = urlParams.get('year');
    const paramMonth = urlParams.get('month');
    const paramDay = urlParams.get('day');

    // URLパラメータがある場合はそれを使用、ない場合は現在の日付を使用
    const getDay = new Date();
    const thisMonth = paramMonth ? parseInt(paramMonth) : getDay.getMonth() + 1;
    const today = paramDay ? parseInt(paramDay) : getDay.getDate();

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