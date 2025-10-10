
    const preButton = document.querySelector('.go-pre');
    const nextButton = document.querySelector('.go-next');

    const urlParams = new URLSearchParams(window.location.search);
    const year = urlParams.get('year');
    const month = urlParams.get('month');

    // カレンダーのセルをクリックして打刻ページに遷移
    const calendarTable = document.querySelector('.mypage-calender');

    if (calendarTable) {
        // data属性から年月とユーザーIDを取得
        const userId = calendarTable.dataset.userId;
        const currentYear = calendarTable.dataset.year;
        const currentMonth = calendarTable.dataset.month;

        const calendarCells = calendarTable.querySelectorAll('td');

        calendarCells.forEach(cell => {
            // セルの日付を取得
            const dateSpan = cell.querySelector('span');

            if (dateSpan && dateSpan.textContent.trim()) {
                // セルをクリック可能にする
                cell.style.cursor = 'pointer';

                cell.addEventListener('click', function(event) {
                    // リンク内のクリックは除外（既存の打刻データへのリンク）
                    if (event.target.closest('a')) {
                        return;
                    }

                    // 日付を取得
                    const day = dateSpan.textContent.trim();

                    // デバッグログ
                    console.log('カレンダーセルクリック:', {
                        day: day,
                        year: currentYear,
                        month: currentMonth,
                        userId: userId,
                        url: `/times/new?year=${currentYear}&month=${currentMonth}&day=${day}&user_id=${userId}`
                    });

                    // 打刻ページに遷移（ユーザーIDも渡す）
                    window.location.href = `/times/new?year=${currentYear}&month=${currentMonth}&day=${day}&user_id=${userId}`;
                });
            }
        });
    }