part of 'l10n.dart';

// Urutan kolom: id, en, ja, zh, de, ru, pt, ar (sama dengan [AppLanguage]).
const Map<String, List<String>> _strings = {
  // ── Umum ──
  'appTitle': [
    'Catatan Pengeluaran',
    'Expense Tracker',
    '支出メモ',
    '支出记录',
    'Ausgabenbuch',
    'Учёт расходов',
    'Controle de Despesas',
    'دفتر المصروفات'
  ],
  'cancel': [
    'Batal',
    'Cancel',
    'キャンセル',
    '取消',
    'Abbrechen',
    'Отмена',
    'Cancelar',
    'إلغاء'
  ],
  'delete': [
    'Hapus',
    'Delete',
    '削除',
    '删除',
    'Löschen',
    'Удалить',
    'Excluir',
    'حذف'
  ],
  'save': [
    'Simpan',
    'Save',
    '保存',
    '保存',
    'Speichern',
    'Сохранить',
    'Salvar',
    'حفظ'
  ],
  'close': [
    'Tutup',
    'Close',
    '閉じる',
    '关闭',
    'Schließen',
    'Закрыть',
    'Fechar',
    'إغلاق'
  ],
  'expense': [
    'Pengeluaran',
    'Expense',
    '支出',
    '支出',
    'Ausgabe',
    'Расход',
    'Despesa',
    'مصروف'
  ],
  'amount': [
    'Nominal',
    'Amount',
    '金額',
    '金额',
    'Betrag',
    'Сумма',
    'Valor',
    'المبلغ'
  ],
  'category': [
    'Kategori',
    'Category',
    'カテゴリ',
    '类别',
    'Kategorie',
    'Категория',
    'Categoria',
    'الفئة'
  ],
  'date': ['Tanggal', 'Date', '日付', '日期', 'Datum', 'Дата', 'Data', 'التاريخ'],
  'note': [
    'Catatan',
    'Note',
    'メモ',
    '备注',
    'Notiz',
    'Заметка',
    'Observação',
    'ملاحظة'
  ],
  'total': [
    'Total',
    'Total',
    '合計',
    '合计',
    'Gesamt',
    'Итого',
    'Total',
    'الإجمالي'
  ],
  'totalUpper': [
    'TOTAL',
    'TOTAL',
    '合計',
    '合计',
    'GESAMT',
    'ИТОГО',
    'TOTAL',
    'الإجمالي'
  ],
  'month': ['Bulan', 'Month', '月', '月份', 'Monat', 'Месяц', 'Mês', 'الشهر'],
  'payment': [
    'Pembayaran',
    'Payment',
    '支払い方法',
    '支付方式',
    'Zahlung',
    'Оплата',
    'Pagamento',
    'الدفع'
  ],
  'transactions': [
    'Transaksi',
    'Transactions',
    '取引',
    '交易',
    'Transaktionen',
    'Операции',
    'Transações',
    'المعاملات'
  ],
  'nTransactions': [
    '{n} transaksi',
    '{n} transactions',
    '{n} 件',
    '{n} 笔交易',
    '{n} Transaktionen',
    'Операций: {n}',
    '{n} transações',
    '{n} معاملة'
  ],
  'vsLastMonth': [
    '{p}% vs bln lalu',
    '{p}% vs last month',
    '先月比 {p}%',
    '较上月 {p}%',
    '{p}% ggü. Vormonat',
    '{p}% к прошлому месяцу',
    '{p}% vs mês anterior',
    '{p}% مقارنة بالشهر الماضي'
  ],
  'noData': [
    'Belum ada data',
    'No data yet',
    'データがありません',
    '暂无数据',
    'Noch keine Daten',
    'Пока нет данных',
    'Sem dados ainda',
    'لا توجد بيانات بعد'
  ],
  'noRecords': [
    'Belum ada catatan',
    'No records yet',
    '記録がありません',
    '暂无记录',
    'Noch keine Einträge',
    'Пока нет записей',
    'Nenhum registro ainda',
    'لا توجد سجلات بعد'
  ],
  'noExpenses': [
    'Belum ada pengeluaran',
    'No expenses yet',
    '支出がありません',
    '暂无支出',
    'Noch keine Ausgaben',
    'Пока нет расходов',
    'Nenhuma despesa ainda',
    'لا توجد مصروفات بعد'
  ],
  'compactMillion': [
    '{v}jt',
    '{v}M',
    '{v}M',
    '{v}M',
    '{v} Mio.',
    '{v} млн',
    '{v} mi',
    '{v} مليون'
  ],
  'compactThousand': [
    '{v}rb',
    '{v}K',
    '{v}K',
    '{v}K',
    '{v} Tsd.',
    '{v} тыс.',
    '{v} mil',
    '{v} ألف'
  ],

  // ── Menu / shell ──
  'navDashboard': [
    'Dashboard',
    'Dashboard',
    'ダッシュボード',
    '仪表板',
    'Dashboard',
    'Панель',
    'Painel',
    'لوحة التحكم'
  ],
  'navRecords': [
    'Pencatatan',
    'Records',
    '記録',
    '记录',
    'Einträge',
    'Записи',
    'Registros',
    'السجلات'
  ],
  'navHome': [
    'Home',
    'Home',
    'ホーム',
    '首页',
    'Start',
    'Главная',
    'Início',
    'الرئيسية'
  ],
  'navHistory': [
    'Riwayat',
    'History',
    '履歴',
    '历史',
    'Verlauf',
    'История',
    'Histórico',
    'السجل'
  ],
  'navRecap': [
    'Rekap Bulanan',
    'Monthly Recap',
    '月次まとめ',
    '月度汇总',
    'Monatsübersicht',
    'Итоги по месяцам',
    'Resumo Mensal',
    'الملخص الشهري'
  ],
  'navUpdate': [
    'Cek Update',
    'Check for Updates',
    'アップデート確認',
    '检查更新',
    'Nach Updates suchen',
    'Проверить обновления',
    'Verificar atualizações',
    'التحقق من التحديثات'
  ],
  'navClearCache': [
    'Bersihkan Cache',
    'Clear Cache',
    'キャッシュを消去',
    '清除缓存',
    'Cache leeren',
    'Очистить кэш',
    'Limpar cache',
    'مسح ذاكرة التخزين المؤقت'
  ],
  'navSettings': [
    'Pengaturan',
    'Settings',
    '設定',
    '设置',
    'Einstellungen',
    'Настройки',
    'Configurações',
    'الإعدادات'
  ],
  'menu': ['Menu', 'Menu', 'メニュー', '菜单', 'Menü', 'Меню', 'Menu', 'القائمة'],
  'lightMode': [
    'Mode terang',
    'Light mode',
    'ライトモード',
    '浅色模式',
    'Heller Modus',
    'Светлая тема',
    'Modo claro',
    'الوضع الفاتح'
  ],
  'darkMode': [
    'Mode gelap',
    'Dark mode',
    'ダークモード',
    '深色模式',
    'Dunkler Modus',
    'Тёмная тема',
    'Modo escuro',
    'الوضع الداكن'
  ],
  'cacheTitle': [
    'Bersihkan cache?',
    'Clear cache?',
    'キャッシュを消去しますか?',
    '清除缓存?',
    'Cache leeren?',
    'Очистить кэш?',
    'Limpar cache?',
    'مسح ذاكرة التخزين المؤقت؟'
  ],
  'cacheBody': [
    'Cache sebesar {size} akan dihapus. Data pengeluaran dan pengaturan tidak terhapus.',
    '{size} of cache will be cleared. Your expenses and settings will not be deleted.',
    '{size} のキャッシュを消去します。支出データと設定は削除されません。',
    '将清除 {size} 缓存。支出数据和设置不会被删除。',
    '{size} Cache werden gelöscht. Ausgaben und Einstellungen bleiben erhalten.',
    'Будет удалено {size} кэша. Расходы и настройки не удаляются.',
    '{size} de cache serão apagados. Suas despesas e configurações não serão excluídas.',
    'سيتم مسح {size} من ذاكرة التخزين المؤقت. لن تُحذف المصروفات والإعدادات.'
  ],
  'cacheClear': [
    'Bersihkan',
    'Clear',
    '消去',
    '清除',
    'Leeren',
    'Очистить',
    'Limpar',
    'مسح'
  ],
  'cacheDone': [
    'Cache dibersihkan ({size})',
    'Cache cleared ({size})',
    'キャッシュを消去しました ({size})',
    '缓存已清除 ({size})',
    'Cache geleert ({size})',
    'Кэш очищен ({size})',
    'Cache limpo ({size})',
    'تم مسح ذاكرة التخزين المؤقت ({size})'
  ],
  'cacheFailed': [
    'Gagal membersihkan cache: {e}',
    'Failed to clear cache: {e}',
    'キャッシュを消去できませんでした: {e}',
    '清除缓存失败: {e}',
    'Cache konnte nicht geleert werden: {e}',
    'Не удалось очистить кэш: {e}',
    'Falha ao limpar o cache: {e}',
    'تعذّر مسح ذاكرة التخزين المؤقت: {e}'
  ],

  // ── Pengaturan ──
  'language': [
    'Bahasa',
    'Language',
    '言語',
    '语言',
    'Sprache',
    'Язык',
    'Idioma',
    'اللغة'
  ],
  'languageHint': [
    'Semua teks di aplikasi memakai bahasa ini.',
    'All text in the app uses this language.',
    'アプリ内のすべてのテキストがこの言語で表示されます。',
    '应用中的所有文字都将使用此语言。',
    'Alle Texte in der App erscheinen in dieser Sprache.',
    'Весь текст в приложении будет на этом языке.',
    'Todo o texto do app usará este idioma.',
    'ستظهر جميع نصوص التطبيق بهذه اللغة.'
  ],

  // ── Dashboard ──
  'byCategory': [
    'Per kategori',
    'By category',
    'カテゴリ別',
    '按类别',
    'Nach Kategorie',
    'По категориям',
    'Por categoria',
    'حسب الفئة'
  ],
  'byPayment': [
    'Per pembayaran',
    'By payment',
    '支払い方法別',
    '按支付方式',
    'Nach Zahlungsart',
    'По способу оплаты',
    'Por pagamento',
    'حسب طريقة الدفع'
  ],
  'dailyExpense': [
    'Pengeluaran harian',
    'Daily spending',
    '日別の支出',
    '每日支出',
    'Tägliche Ausgaben',
    'Расходы по дням',
    'Gastos diários',
    'المصروفات اليومية'
  ],
  'heroTitle': [
    'Yuk, lihat\npengeluaranmu',
    "Let's check\nyour spending",
    'あなたの支出を\nチェックしよう',
    '来看看\n你的支出',
    'Schau dir\ndeine Ausgaben an',
    'Посмотрим\nваши расходы',
    'Vamos ver\nseus gastos',
    'هيا نلقي نظرة\nعلى مصروفاتك'
  ],
  'totalMonth': [
    'Total\n{month}',
    'Total\n{month}',
    '合計\n{month}',
    '合计\n{month}',
    'Gesamt\n{month}',
    'Итого\n{month}',
    'Total\n{month}',
    'الإجمالي\n{month}'
  ],
  'morning': [
    'Selamat pagi!',
    'Good morning!',
    'おはようございます!',
    '早上好!',
    'Guten Morgen!',
    'Доброе утро!',
    'Bom dia!',
    'صباح الخير!'
  ],
  'afternoon': [
    'Selamat siang!',
    'Good afternoon!',
    'こんにちは!',
    '中午好!',
    'Guten Tag!',
    'Добрый день!',
    'Boa tarde!',
    'نهارك سعيد!'
  ],
  'evening': [
    'Selamat sore!',
    'Good evening!',
    'こんにちは!',
    '下午好!',
    'Schönen Nachmittag!',
    'Добрый день!',
    'Boa tarde!',
    'مساء الخير!'
  ],
  'night': [
    'Selamat malam!',
    'Good night!',
    'こんばんは!',
    '晚上好!',
    'Guten Abend!',
    'Добрый вечер!',
    'Boa noite!',
    'مساء الخير!'
  ],
  'avgPerDay': [
    'Rata-rata / hari',
    'Average / day',
    '1日平均',
    '日均',
    'Ø pro Tag',
    'В среднем / день',
    'Média / dia',
    'المتوسط / يوم'
  ],
  'trendMonths': [
    'Tren {n} bulan',
    '{n}-month trend',
    '{n}か月の推移',
    '{n} 个月趋势',
    'Trend {n} Monate',
    'Динамика за {n} мес.',
    'Tendência de {n} meses',
    'اتجاه {n} أشهر'
  ],
  'categorySheetSub': [
    '{n} transaksi · {p}% bulan ini',
    '{n} transactions · {p}% this month',
    '{n} 件 · 今月の {p}%',
    '{n} 笔交易 · 占本月 {p}%',
    '{n} Transaktionen · {p}% diesen Monat',
    'Операций: {n} · {p}% за месяц',
    '{n} transações · {p}% neste mês',
    '{n} معاملة · {p}% هذا الشهر'
  ],
  'noCategoryExpense': [
    'Belum ada pengeluaran di kategori ini.',
    'No expenses in this category yet.',
    'このカテゴリの支出はまだありません。',
    '该类别暂无支出。',
    'Noch keine Ausgaben in dieser Kategorie.',
    'В этой категории пока нет расходов.',
    'Nenhuma despesa nesta categoria ainda.',
    'لا توجد مصروفات في هذه الفئة بعد.'
  ],
  'tooltipDay': [
    'Tgl {d}\n{amount}',
    'Day {d}\n{amount}',
    '{d}日\n{amount}',
    '{d}日\n{amount}',
    'Tag {d}\n{amount}',
    '{d} число\n{amount}',
    'Dia {d}\n{amount}',
    'يوم {d}\n{amount}'
  ],
  'mapOpenFailed': [
    'Tidak bisa membuka aplikasi peta',
    'Cannot open the maps app',
    '地図アプリを開けません',
    '无法打开地图应用',
    'Karten-App kann nicht geöffnet werden',
    'Не удалось открыть карты',
    'Não foi possível abrir o app de mapas',
    'تعذّر فتح تطبيق الخرائط'
  ],
  'locationHistory': [
    'Riwayat lokasi',
    'Location history',
    '位置履歴',
    '位置记录',
    'Standortverlauf',
    'История мест',
    'Histórico de locais',
    'سجل المواقع'
  ],
  'collapse': [
    'Ringkas',
    'Collapse',
    '折りたたむ',
    '收起',
    'Einklappen',
    'Свернуть',
    'Recolher',
    'طيّ'
  ],
  'seeAll': [
    'Lihat semua',
    'See all',
    'すべて表示',
    '查看全部',
    'Alle anzeigen',
    'Показать все',
    'Ver tudo',
    'عرض الكل'
  ],
  'noLocation': [
    'Belum ada pengeluaran dengan lokasi.\nTambahkan lokasi saat mencatat pengeluaran.',
    'No expenses with a location yet.\nAdd a location when recording an expense.',
    '位置情報付きの支出はまだありません。\n支出を記録するときに位置を追加してください。',
    '暂无带位置的支出。\n记录支出时可添加位置。',
    'Noch keine Ausgaben mit Standort.\nFüge beim Erfassen einen Standort hinzu.',
    'Пока нет расходов с местом.\nДобавьте место при записи расхода.',
    'Nenhuma despesa com local ainda.\nAdicione um local ao registrar uma despesa.',
    'لا توجد مصروفات بموقع بعد.\nأضف موقعًا عند تسجيل مصروف.'
  ],
  'mostFrequent': [
    'Tersering: {place} ({n}x)',
    'Most frequent: {place} ({n}x)',
    '最多: {place} ({n}回)',
    '最常去: {place} ({n} 次)',
    'Am häufigsten: {place} ({n}x)',
    'Чаще всего: {place} ({n} раз)',
    'Mais frequente: {place} ({n}x)',
    'الأكثر تكرارًا: {place} ({n} مرة)'
  ],
  'placesTx': [
    'Tempat & transaksi',
    'Places & transactions',
    '場所と取引',
    '地点与交易',
    'Orte & Transaktionen',
    'Места и операции',
    'Locais e transações',
    'الأماكن والمعاملات'
  ],
  'openInMap': [
    'Buka di peta',
    'Open in maps',
    '地図で開く',
    '在地图中打开',
    'In Karten öffnen',
    'Открыть на карте',
    'Abrir no mapa',
    'فتح في الخريطة'
  ],

  // ── Form ──
  'addExpense': [
    'Tambah Pengeluaran',
    'Add Expense',
    '支出を追加',
    '添加支出',
    'Ausgabe hinzufügen',
    'Добавить расход',
    'Adicionar Despesa',
    'إضافة مصروف'
  ],
  'editExpense': [
    'Ubah Pengeluaran',
    'Edit Expense',
    '支出を編集',
    '编辑支出',
    'Ausgabe bearbeiten',
    'Изменить расход',
    'Editar Despesa',
    'تعديل المصروف'
  ],
  'saveChanges': [
    'Simpan Perubahan',
    'Save Changes',
    '変更を保存',
    '保存更改',
    'Änderungen speichern',
    'Сохранить изменения',
    'Salvar alterações',
    'حفظ التغييرات'
  ],
  'chooseCategory': [
    'Pilih kategori',
    'Choose a category',
    'カテゴリを選択',
    '请选择类别',
    'Kategorie wählen',
    'Выберите категорию',
    'Escolha uma categoria',
    'اختر فئة'
  ],
  'amountInvalid': [
    'Masukkan nominal lebih dari 0',
    'Enter an amount greater than 0',
    '0より大きい金額を入力してください',
    '请输入大于 0 的金额',
    'Betrag größer als 0 eingeben',
    'Введите сумму больше 0',
    'Informe um valor maior que 0',
    'أدخل مبلغًا أكبر من 0'
  ],
  'noteOptional': [
    'Catatan (opsional)',
    'Note (optional)',
    'メモ(任意)',
    '备注(可选)',
    'Notiz (optional)',
    'Заметка (необязательно)',
    'Observação (opcional)',
    'ملاحظة (اختياري)'
  ],
  'locationOptional': [
    'Lokasi (opsional)',
    'Location (optional)',
    '位置(任意)',
    '位置(可选)',
    'Standort (optional)',
    'Место (необязательно)',
    'Local (opcional)',
    'الموقع (اختياري)'
  ],
  'addressUnknown': [
    'Alamat tidak diketahui',
    'Unknown address',
    '住所不明',
    '地址未知',
    'Unbekannte Adresse',
    'Адрес неизвестен',
    'Endereço desconhecido',
    'عنوان غير معروف'
  ],
  'locating': [
    'Mencari lokasi...',
    'Finding location...',
    '位置を取得中...',
    '正在定位...',
    'Standort wird gesucht...',
    'Поиск места...',
    'Buscando local...',
    'جارٍ تحديد الموقع...'
  ],
  'updateLocation': [
    'Perbarui lokasi',
    'Update location',
    '位置を更新',
    '更新位置',
    'Standort aktualisieren',
    'Обновить место',
    'Atualizar local',
    'تحديث الموقع'
  ],
  'getLocation': [
    'Ambil lokasi saat ini',
    'Use current location',
    '現在地を取得',
    '获取当前位置',
    'Aktuellen Standort verwenden',
    'Текущее место',
    'Usar local atual',
    'استخدام الموقع الحالي'
  ],
  'map': ['Peta', 'Map', '地図', '地图', 'Karte', 'Карта', 'Mapa', 'الخريطة'],
  'locationFailed': [
    'Gagal mengambil lokasi: {e}',
    'Failed to get location: {e}',
    '位置を取得できませんでした: {e}',
    '获取位置失败: {e}',
    'Standort konnte nicht ermittelt werden: {e}',
    'Не удалось получить место: {e}',
    'Falha ao obter o local: {e}',
    'تعذّر الحصول على الموقع: {e}'
  ],
  'expenseDeleted': [
    'Pengeluaran dihapus',
    'Expense deleted',
    '支出を削除しました',
    '支出已删除',
    'Ausgabe gelöscht',
    'Расход удалён',
    'Despesa excluída',
    'تم حذف المصروف'
  ],
  'deleteTitle': [
    'Hapus pengeluaran?',
    'Delete expense?',
    '支出を削除しますか?',
    '删除该支出?',
    'Ausgabe löschen?',
    'Удалить расход?',
    'Excluir despesa?',
    'حذف المصروف؟'
  ],
  'deleteBody': [
    '"{t}" akan dihapus permanen.',
    '"{t}" will be permanently deleted.',
    '「{t}」は完全に削除されます。',
    '"{t}" 将被永久删除。',
    '„{t}" wird dauerhaft gelöscht.',
    '«{t}» будет удалён безвозвратно.',
    '"{t}" será excluída permanentemente.',
    'سيتم حذف "{t}" نهائيًا.'
  ],

  // ── Riwayat / pencatatan ──
  'historyTitle': [
    'Riwayat {month}',
    'History {month}',
    '履歴 {month}',
    '{month} 历史',
    'Verlauf {month}',
    'История: {month}',
    'Histórico {month}',
    'السجل {month}'
  ],
  'allCategories': [
    'Semua kategori',
    'All categories',
    'すべてのカテゴリ',
    '所有类别',
    'Alle Kategorien',
    'Все категории',
    'Todas as categorias',
    'كل الفئات'
  ],
  'noExpensesThisMonth': [
    'Belum ada pengeluaran bulan ini',
    'No expenses this month yet',
    '今月の支出はまだありません',
    '本月暂无支出',
    'Diesen Monat noch keine Ausgaben',
    'В этом месяце пока нет расходов',
    'Nenhuma despesa neste mês ainda',
    'لا توجد مصروفات هذا الشهر بعد'
  ],
  'totalExpense': [
    'Total pengeluaran',
    'Total spending',
    '支出合計',
    '支出总额',
    'Ausgaben gesamt',
    'Всего расходов',
    'Total de gastos',
    'إجمالي المصروفات'
  ],
  'seeMonthHistory': [
    'Lihat riwayat bulan ini',
    "See this month's history",
    '今月の履歴を見る',
    '查看本月历史',
    'Verlauf dieses Monats ansehen',
    'История за этот месяц',
    'Ver histórico do mês',
    'عرض سجل هذا الشهر'
  ],

  // ── Pemilih bulan ──
  'prevMonth': [
    'Bulan sebelumnya',
    'Previous month',
    '前の月',
    '上个月',
    'Vorheriger Monat',
    'Предыдущий месяц',
    'Mês anterior',
    'الشهر السابق'
  ],
  'nextMonth': [
    'Bulan berikutnya',
    'Next month',
    '次の月',
    '下个月',
    'Nächster Monat',
    'Следующий месяц',
    'Próximo mês',
    'الشهر التالي'
  ],
  'pickMonth': [
    'Pilih bulan',
    'Choose month',
    '月を選択',
    '选择月份',
    'Monat wählen',
    'Выбрать месяц',
    'Escolher mês',
    'اختر الشهر'
  ],
  'pickYear': [
    'Pilih tahun',
    'Choose year',
    '年を選択',
    '选择年份',
    'Jahr wählen',
    'Выбрать год',
    'Escolher ano',
    'اختر السنة'
  ],
  'pickMonthOfYear': [
    'Pilih bulan ({y})',
    'Choose month ({y})',
    '月を選択 ({y})',
    '选择月份 ({y})',
    'Monat wählen ({y})',
    'Выбрать месяц ({y})',
    'Escolher mês ({y})',
    'اختر الشهر ({y})'
  ],

  // ── Rekap ──
  'saveExcelDialog': [
    'Simpan rekap Excel',
    'Save Excel recap',
    'Excelまとめを保存',
    '保存 Excel 汇总',
    'Excel-Übersicht speichern',
    'Сохранить отчёт Excel',
    'Salvar resumo em Excel',
    'حفظ ملخص Excel'
  ],
  'savedFile': [
    '{name} tersimpan',
    '{name} saved',
    '{name} を保存しました',
    '{name} 已保存',
    '{name} gespeichert',
    '{name} сохранён',
    '{name} salvo',
    'تم حفظ {name}'
  ],
  'excelFailed': [
    'Gagal membuat Excel: {e}',
    'Failed to create Excel: {e}',
    'Excelを作成できませんでした: {e}',
    '创建 Excel 失败: {e}',
    'Excel konnte nicht erstellt werden: {e}',
    'Не удалось создать Excel: {e}',
    'Falha ao criar o Excel: {e}',
    'تعذّر إنشاء ملف Excel: {e}'
  ],
  'downloadExcel': [
    'Download Excel',
    'Download Excel',
    'Excelをダウンロード',
    '下载 Excel',
    'Excel herunterladen',
    'Скачать Excel',
    'Baixar Excel',
    'تنزيل Excel'
  ],
  'downloadExcelMonth': [
    'Download Excel {month}',
    'Download Excel {month}',
    'Excelをダウンロード ({month})',
    '下载 Excel ({month})',
    'Excel herunterladen ({month})',
    'Скачать Excel ({month})',
    'Baixar Excel ({month})',
    'تنزيل Excel ({month})'
  ],
  'prevYear': [
    'Tahun sebelumnya',
    'Previous year',
    '前の年',
    '上一年',
    'Vorheriges Jahr',
    'Предыдущий год',
    'Ano anterior',
    'السنة السابقة'
  ],
  'nextYear': [
    'Tahun berikutnya',
    'Next year',
    '次の年',
    '下一年',
    'Nächstes Jahr',
    'Следующий год',
    'Próximo ano',
    'السنة التالية'
  ],
  'recapLoadFailed': [
    'Gagal memuat rekap: {e}',
    'Failed to load recap: {e}',
    'まとめを読み込めませんでした: {e}',
    '加载汇总失败: {e}',
    'Übersicht konnte nicht geladen werden: {e}',
    'Не удалось загрузить итоги: {e}',
    'Falha ao carregar o resumo: {e}',
    'تعذّر تحميل الملخص: {e}'
  ],
  'yearTotal': [
    'Total tahun {y}',
    'Total for {y}',
    '{y}年の合計',
    '{y} 年合计',
    'Gesamt {y}',
    'Итого за {y}',
    'Total de {y}',
    'إجمالي سنة {y}'
  ],
  'pickMonthsDownload': [
    'Pilih bulan untuk diunduh ({y})',
    'Choose months to download ({y})',
    'ダウンロードする月を選択 ({y})',
    '选择要下载的月份 ({y})',
    'Monate zum Herunterladen wählen ({y})',
    'Выберите месяцы для скачивания ({y})',
    'Escolha os meses para baixar ({y})',
    'اختر الأشهر للتنزيل ({y})'
  ],
  'selectAll': [
    'Pilih semua',
    'Select all',
    'すべて選択',
    '全选',
    'Alle auswählen',
    'Выбрать все',
    'Selecionar tudo',
    'تحديد الكل'
  ],
  'monthRow': [
    '{n} transaksi · {amount}',
    '{n} transactions · {amount}',
    '{n} 件 · {amount}',
    '{n} 笔交易 · {amount}',
    '{n} Transaktionen · {amount}',
    'Операций: {n} · {amount}',
    '{n} transações · {amount}',
    '{n} معاملة · {amount}'
  ],
  'pickAtLeastOne': [
    'Pilih minimal 1 bulan',
    'Choose at least 1 month',
    '1か月以上選択してください',
    '请至少选择 1 个月',
    'Mindestens 1 Monat wählen',
    'Выберите хотя бы 1 месяц',
    'Escolha pelo menos 1 mês',
    'اختر شهرًا واحدًا على الأقل'
  ],
  'downloadNMonths': [
    'Download {n} bulan',
    'Download {n} months',
    '{n}か月分をダウンロード',
    '下载 {n} 个月',
    '{n} Monate herunterladen',
    'Скачать месяцев: {n}',
    'Baixar {n} meses',
    'تنزيل {n} أشهر'
  ],

  // ── Excel ──
  'sheetRecap': [
    'Rekap',
    'Recap',
    'まとめ',
    '汇总',
    'Übersicht',
    'Итоги',
    'Resumo',
    'الملخص'
  ],
  'sheetByCategory': [
    'Per Kategori',
    'By Category',
    'カテゴリ別',
    '按类别',
    'Nach Kategorie',
    'По категориям',
    'Por Categoria',
    'حسب الفئة'
  ],
  'sheetDetail': [
    'Detail',
    'Details',
    '明細',
    '明细',
    'Details',
    'Подробно',
    'Detalhes',
    'التفاصيل'
  ],
  'recapTitle': [
    'Rekap Pengeluaran {p}',
    'Expense Recap {p}',
    '支出まとめ {p}',
    '支出汇总 {p}',
    'Ausgabenübersicht {p}',
    'Итоги расходов {p}',
    'Resumo de Despesas {p}',
    'ملخص المصروفات {p}'
  ],
  'byCategoryTitle': [
    'Pengeluaran per Kategori {p}',
    'Expenses by Category {p}',
    'カテゴリ別支出 {p}',
    '按类别支出 {p}',
    'Ausgaben nach Kategorie {p}',
    'Расходы по категориям {p}',
    'Despesas por Categoria {p}',
    'المصروفات حسب الفئة {p}'
  ],
  'txCount': [
    'Jumlah Transaksi',
    'Transactions',
    '取引数',
    '交易笔数',
    'Anzahl Transaktionen',
    'Кол-во операций',
    'Nº de transações',
    'عدد المعاملات'
  ],
  'changeVsLast': [
    'Perubahan vs Bulan Lalu',
    'Change vs Last Month',
    '先月比',
    '较上月变化',
    'Änderung ggü. Vormonat',
    'Изменение к прошлому месяцу',
    'Variação vs mês anterior',
    'التغير مقارنة بالشهر الماضي'
  ],
  'share': [
    'Porsi',
    'Share',
    '割合',
    '占比',
    'Anteil',
    'Доля',
    'Participação',
    'النسبة'
  ],
  'yearLabel': [
    'Tahun {y}',
    'Year {y}',
    '{y}年',
    '{y} 年',
    'Jahr {y}',
    '{y} год',
    'Ano {y}',
    'سنة {y}'
  ],
  'fileRecap': [
    'Rekap_Pengeluaran',
    'Expense_Recap',
    'Expense_Recap',
    'Expense_Recap',
    'Ausgabenuebersicht',
    'Expense_Recap',
    'Resumo_Despesas',
    'Expense_Recap'
  ],

  // ── Update ──
  'updateTitle': [
    'Update Aplikasi',
    'App Update',
    'アプリのアップデート',
    '应用更新',
    'App-Update',
    'Обновление приложения',
    'Atualização do app',
    'تحديث التطبيق'
  ],
  'update': [
    'Update',
    'Update',
    'アップデート',
    '更新',
    'Aktualisieren',
    'Обновить',
    'Atualizar',
    'تحديث'
  ],
  'checkingVersion': [
    'Mengecek versi terbaru...',
    'Checking for the latest version...',
    '最新バージョンを確認中...',
    '正在检查最新版本...',
    'Neueste Version wird geprüft...',
    'Проверка последней версии...',
    'Verificando a versão mais recente...',
    'جارٍ التحقق من أحدث إصدار...'
  ],
  'upToDate': [
    'Aplikasi sudah versi terbaru ({v}).',
    'The app is up to date ({v}).',
    'アプリは最新です ({v})。',
    '应用已是最新版本 ({v})。',
    'Die App ist aktuell ({v}).',
    'Установлена последняя версия ({v}).',
    'O app está atualizado ({v}).',
    'التطبيق محدَّث ({v}).'
  ],
  'newVersion': [
    'Versi baru tersedia: {v}',
    'New version available: {v}',
    '新しいバージョンがあります: {v}',
    '有新版本: {v}',
    'Neue Version verfügbar: {v}',
    'Доступна новая версия: {v}',
    'Nova versão disponível: {v}',
    'يتوفر إصدار جديد: {v}'
  ],
  'installedVersion': [
    'Versi terpasang: {v}',
    'Installed version: {v}',
    'インストール済み: {v}',
    '当前版本: {v}',
    'Installierte Version: {v}',
    'Установленная версия: {v}',
    'Versão instalada: {v}',
    'الإصدار المثبت: {v}'
  ],
  'changes': [
    'Perubahan:',
    'Changes:',
    '変更点:',
    '更新内容:',
    'Änderungen:',
    'Изменения:',
    'Alterações:',
    'التغييرات:'
  ],
  'dataSafe': [
    'Data catatan tidak akan hilang.',
    'Your records will not be lost.',
    '記録データは失われません。',
    '记录数据不会丢失。',
    'Deine Einträge bleiben erhalten.',
    'Ваши записи не пропадут.',
    'Seus registros não serão perdidos.',
    'لن تفقد سجلاتك.'
  ],
  'downloading': [
    'Mengunduh...',
    'Downloading...',
    'ダウンロード中...',
    '正在下载...',
    'Wird heruntergeladen...',
    'Загрузка...',
    'Baixando...',
    'جارٍ التنزيل...'
  ],
  'downloadingP': [
    'Mengunduh {p}%',
    'Downloading {p}%',
    'ダウンロード中 {p}%',
    '正在下载 {p}%',
    'Wird heruntergeladen {p}%',
    'Загрузка {p}%',
    'Baixando {p}%',
    'جارٍ التنزيل {p}%'
  ],
  'downloadDone': [
    'Unduhan selesai. Ikuti layar pemasangan Android.',
    'Download complete. Follow the Android install screen.',
    'ダウンロード完了。Androidのインストール画面に従ってください。',
    '下载完成。请按照 Android 安装界面操作。',
    'Download abgeschlossen. Folge dem Android-Installationsbildschirm.',
    'Загрузка завершена. Следуйте экрану установки Android.',
    'Download concluído. Siga a tela de instalação do Android.',
    'اكتمل التنزيل. اتبع شاشة التثبيت في Android.'
  ],
  'errorOccurred': [
    'Terjadi kesalahan.',
    'An error occurred.',
    'エラーが発生しました。',
    '发生错误。',
    'Ein Fehler ist aufgetreten.',
    'Произошла ошибка.',
    'Ocorreu um erro.',
    'حدث خطأ.'
  ],
  'skipVersion': [
    'Lewati versi ini',
    'Skip this version',
    'このバージョンをスキップ',
    '跳过此版本',
    'Diese Version überspringen',
    'Пропустить эту версию',
    'Pular esta versão',
    'تخطي هذا الإصدار'
  ],
  'later': [
    'Nanti',
    'Later',
    '後で',
    '稍后',
    'Später',
    'Позже',
    'Depois',
    'لاحقًا'
  ],
  'retry': [
    'Coba lagi',
    'Try again',
    '再試行',
    '重试',
    'Erneut versuchen',
    'Повторить',
    'Tentar novamente',
    'إعادة المحاولة'
  ],
  'updateFailed': [
    'Gagal update: {e}',
    'Update failed: {e}',
    'アップデートに失敗しました: {e}',
    '更新失败: {e}',
    'Update fehlgeschlagen: {e}',
    'Ошибка обновления: {e}',
    'Falha na atualização: {e}',
    'فشل التحديث: {e}'
  ],
  'installPermission': [
    'Izin "Instal aplikasi tidak dikenal" belum diberikan. Aktifkan di pengaturan lalu coba lagi.',
    'The "Install unknown apps" permission is not granted. Enable it in settings and try again.',
    '「不明なアプリのインストール」が許可されていません。設定で有効にしてから再試行してください。',
    '尚未授予"安装未知应用"权限。请在设置中开启后重试。',
    'Die Berechtigung „Unbekannte Apps installieren" fehlt. Aktiviere sie in den Einstellungen und versuche es erneut.',
    'Нет разрешения «Установка неизвестных приложений». Включите его в настройках и повторите.',
    'A permissão "Instalar apps desconhecidos" não foi concedida. Ative-a nas configurações e tente novamente.',
    'لم يتم منح إذن "تثبيت التطبيقات غير المعروفة". فعّله من الإعدادات ثم حاول مرة أخرى.'
  ],
  'updateNoSource': [
    'Sumber update belum diatur.',
    'Update source is not configured.',
    'アップデート元が設定されていません。',
    '未配置更新来源。',
    'Update-Quelle ist nicht eingerichtet.',
    'Источник обновлений не настроен.',
    'A fonte de atualização não está configurada.',
    'مصدر التحديث غير مُعدّ.'
  ],
  'updateNoConnection': [
    'Tidak bisa terhubung. Periksa koneksi internet.',
    'Cannot connect. Check your internet connection.',
    '接続できません。インターネット接続を確認してください。',
    '无法连接。请检查网络连接。',
    'Keine Verbindung. Prüfe deine Internetverbindung.',
    'Нет соединения. Проверьте интернет.',
    'Não foi possível conectar. Verifique sua internet.',
    'تعذّر الاتصال. تحقق من اتصال الإنترنت.'
  ],
  'updateNoRelease': [
    'Belum ada rilis yang dipublikasikan.',
    'No release has been published yet.',
    '公開されたリリースはまだありません。',
    '尚未发布任何版本。',
    'Noch keine Version veröffentlicht.',
    'Пока нет опубликованных версий.',
    'Nenhuma versão publicada ainda.',
    'لم يتم نشر أي إصدار بعد.'
  ],
  'updateHttpFailed': [
    'Gagal cek update (HTTP {code}).',
    'Update check failed (HTTP {code}).',
    'アップデート確認に失敗しました (HTTP {code})。',
    '检查更新失败 (HTTP {code})。',
    'Update-Prüfung fehlgeschlagen (HTTP {code}).',
    'Ошибка проверки обновлений (HTTP {code}).',
    'Falha ao verificar atualização (HTTP {code}).',
    'فشل التحقق من التحديث (HTTP {code}).'
  ],
  'updateNoApk': [
    'Rilis terbaru tidak berisi file APK.',
    'The latest release has no APK file.',
    '最新リリースにAPKファイルがありません。',
    '最新版本不包含 APK 文件。',
    'Die neueste Version enthält keine APK-Datei.',
    'В последней версии нет APK-файла.',
    'A versão mais recente não contém arquivo APK.',
    'أحدث إصدار لا يحتوي على ملف APK.'
  ],

  // ── Layanan ──
  'loadDataFailed': [
    'Gagal memuat data: {e}',
    'Failed to load data: {e}',
    'データを読み込めませんでした: {e}',
    '加载数据失败: {e}',
    'Daten konnten nicht geladen werden: {e}',
    'Не удалось загрузить данные: {e}',
    'Falha ao carregar os dados: {e}',
    'تعذّر تحميل البيانات: {e}'
  ],
  'loadExpensesFailed': [
    'Gagal memuat pengeluaran: {e}',
    'Failed to load expenses: {e}',
    '支出を読み込めませんでした: {e}',
    '加载支出失败: {e}',
    'Ausgaben konnten nicht geladen werden: {e}',
    'Не удалось загрузить расходы: {e}',
    'Falha ao carregar as despesas: {e}',
    'تعذّر تحميل المصروفات: {e}'
  ],
  'gpsOff': [
    'GPS tidak aktif. Nyalakan lokasi di pengaturan HP.',
    'GPS is off. Turn on location in your phone settings.',
    'GPSがオフです。端末の設定で位置情報をオンにしてください。',
    'GPS 未开启。请在手机设置中打开定位。',
    'GPS ist aus. Aktiviere den Standort in den Handy-Einstellungen.',
    'GPS выключен. Включите геолокацию в настройках.',
    'GPS desligado. Ative a localização nas configurações do celular.',
    'نظام GPS متوقف. فعّل الموقع من إعدادات الهاتف.'
  ],
  'locationDenied': [
    'Izin lokasi ditolak.',
    'Location permission denied.',
    '位置情報の許可が拒否されました。',
    '位置权限被拒绝。',
    'Standortberechtigung verweigert.',
    'Доступ к геолокации запрещён.',
    'Permissão de localização negada.',
    'تم رفض إذن الموقع.'
  ],
  'locationDeniedForever': [
    'Izin lokasi ditolak permanen. Aktifkan di pengaturan aplikasi.',
    'Location permission permanently denied. Enable it in app settings.',
    '位置情報の許可が永続的に拒否されています。アプリ設定で有効にしてください。',
    '位置权限被永久拒绝。请在应用设置中开启。',
    'Standortberechtigung dauerhaft verweigert. Aktiviere sie in den App-Einstellungen.',
    'Доступ к геолокации запрещён навсегда. Включите его в настройках приложения.',
    'Permissão de localização negada permanentemente. Ative-a nas configurações do app.',
    'تم رفض إذن الموقع نهائيًا. فعّله من إعدادات التطبيق.'
  ],
  'locationUnavailable': [
    'Gagal mendapatkan lokasi. Coba lagi di tempat terbuka.',
    'Could not get location. Try again in an open area.',
    '位置を取得できませんでした。屋外で再試行してください。',
    '无法获取位置。请到开阔处重试。',
    'Standort nicht verfügbar. Versuche es im Freien erneut.',
    'Не удалось определить место. Попробуйте на открытом месте.',
    'Não foi possível obter o local. Tente em um lugar aberto.',
    'تعذّر تحديد الموقع. حاول مرة أخرى في مكان مفتوح.'
  ],
  'reminderChannel': [
    'Pengingat Harian',
    'Daily Reminder',
    '毎日のリマインダー',
    '每日提醒',
    'Tägliche Erinnerung',
    'Ежедневное напоминание',
    'Lembrete diário',
    'تذكير يومي'
  ],
  'reminderChannelDesc': [
    'Pengingat jika belum mencatat pengeluaran selama 1 hari',
    'Reminds you if no expense was recorded for 1 day',
    '1日支出を記録していないときに通知します',
    '1 天未记录支出时提醒',
    'Erinnert, wenn 1 Tag lang keine Ausgabe erfasst wurde',
    'Напоминание, если расходы не записывались 1 день',
    'Lembra se nenhuma despesa foi registrada por 1 dia',
    'تذكير إذا لم تسجّل أي مصروف لمدة يوم واحد'
  ],
  'reminderTitle': [
    'Jangan lupa catat pengeluaran',
    "Don't forget to record your expenses",
    '支出の記録を忘れずに',
    '别忘了记录支出',
    'Vergiss nicht, deine Ausgaben zu erfassen',
    'Не забудьте записать расходы',
    'Não esqueça de registrar suas despesas',
    'لا تنسَ تسجيل مصروفاتك'
  ],
  'reminderBody': [
    'Kamu belum mencatat pengeluaran selama 1 hari terakhir.',
    "You haven't recorded any expenses in the last day.",
    'この1日、支出が記録されていません。',
    '过去 1 天你还没有记录支出。',
    'Du hast seit einem Tag keine Ausgaben erfasst.',
    'Вы не записывали расходы последние сутки.',
    'Você não registrou despesas no último dia.',
    'لم تسجّل أي مصروفات خلال اليوم الأخير.'
  ],
  'balance': [
    'Saldo',
    'Balance',
    '残高',
    '余额',
    'Guthaben',
    'Баланс',
    'Saldo',
    'الرصيد',
  ],
  'income': [
    'Pemasukan',
    'Income',
    '収入',
    '收入',
    'Einnahmen',
    'Доход',
    'Receita',
    'الدخل',
  ],
  'addIncome': [
    'Tambah pemasukan',
    'Add income',
    '収入を追加',
    '添加收入',
    'Einnahme hinzufügen',
    'Добавить доход',
    'Adicionar receita',
    'إضافة دخل',
  ],
  'incomeAdded': [
    'Pemasukan ditambahkan',
    'Income added',
    '収入を追加しました',
    '已添加收入',
    'Einnahme hinzugefügt',
    'Доход добавлен',
    'Receita adicionada',
    'تمت إضافة الدخل',
  ],
  'incomeDeleted': [
    'Pemasukan dihapus',
    'Income deleted',
    '収入を削除しました',
    '收入已删除',
    'Einnahme gelöscht',
    'Доход удалён',
    'Receita excluída',
    'تم حذف الدخل',
  ],
  'deleteIncomeTitle': [
    'Hapus pemasukan?',
    'Delete income?',
    '収入を削除しますか?',
    '删除收入?',
    'Einnahme löschen?',
    'Удалить доход?',
    'Excluir receita?',
    'حذف الدخل؟',
  ],
  'deleteIncomeBody': [
    'Pemasukan {amount} akan dihapus permanen.',
    'Income of {amount} will be deleted permanently.',
    '{amount} の収入は完全に削除されます。',
    '收入 {amount} 将被永久删除。',
    'Die Einnahme von {amount} wird endgültig gelöscht.',
    'Доход {amount} будет удалён навсегда.',
    'A receita de {amount} será excluída permanentemente.',
    'سيتم حذف الدخل {amount} نهائيًا.',
  ],
  'show': [
    'Tampilkan',
    'Show',
    '表示',
    '显示',
    'Anzeigen',
    'Показать',
    'Mostrar',
    'إظهار',
  ],
  'hide': [
    'Sembunyikan',
    'Hide',
    '非表示',
    '隐藏',
    'Ausblenden',
    'Скрыть',
    'Ocultar',
    'إخفاء',
  ],
  'monthlyIncome': [
    'Pemasukan tetap per bulan',
    'Fixed monthly income',
    '毎月の固定収入',
    '每月固定收入',
    'Feste monatliche Einnahmen',
    'Постоянный доход в месяц',
    'Receita fixa mensal',
    'الدخل الشهري الثابت',
  ],
  'monthlyIncomeHint': [
    'Dihitung otomatis setiap bulan. Isi 0 untuk menonaktifkan.',
    'Counted automatically every month. Enter 0 to turn it off.',
    '毎月自動的に計上されます。0 を入力すると無効になります。',
    '每月自动计入。输入 0 可关闭。',
    'Wird jeden Monat automatisch gezählt. 0 eingeben zum Deaktivieren.',
    'Учитывается автоматически каждый месяц. Введите 0, чтобы отключить.',
    'Contabilizada automaticamente todo mês. Informe 0 para desativar.',
    'يُحتسب تلقائيًا كل شهر. أدخل 0 لإيقافه.',
  ],
  'amountNonNegative': [
    'Masukkan nominal 0 atau lebih',
    'Enter an amount of 0 or more',
    '0 以上の金額を入力してください',
    '请输入 0 或以上的金额',
    'Betrag von 0 oder mehr eingeben',
    'Введите сумму 0 или больше',
    'Informe um valor de 0 ou mais',
    'أدخل مبلغًا يساوي 0 أو أكثر',
  ],
  'extraIncome': [
    'Pemasukan tambahan',
    'Extra income',
    '追加収入',
    '额外收入',
    'Zusätzliche Einnahmen',
    'Дополнительный доход',
    'Receita extra',
    'دخل إضافي',
  ],
  'noExtraIncome': [
    'Belum ada pemasukan tambahan bulan ini',
    'No extra income this month',
    '今月の追加収入はまだありません',
    '本月暂无额外收入',
    'Keine zusätzlichen Einnahmen in diesem Monat',
    'В этом месяце дополнительного дохода нет',
    'Nenhuma receita extra neste mês',
    'لا يوجد دخل إضافي هذا الشهر',
  ],
  'balanceOfMonth': [
    'Saldo {month}',
    'Balance {month}',
    '{month}の残高',
    '{month}余额',
    'Guthaben {month}',
    'Баланс за {month}',
    'Saldo de {month}',
    'رصيد {month}',
  ],
  'balanceMinus': [
    'Saldo Anda minus {amount}',
    'Your balance is minus {amount}',
    '残高は {amount} のマイナスです',
    '您的余额为负 {amount}',
    'Ihr Guthaben liegt {amount} im Minus',
    'Ваш баланс в минусе на {amount}',
    'Seu saldo está negativo em {amount}',
    'رصيدك بالسالب {amount}',
  ],
  'balanceSurplus': [
    'Saldo Anda sisa {amount}',
    'You have {amount} left',
    '残高は {amount} 残っています',
    '您还剩 {amount}',
    'Ihnen bleiben {amount}',
    'У вас осталось {amount}',
    'Você ainda tem {amount}',
    'تبقّى لديك {amount}',
  ],
  'balanceZero': [
    'Saldo Anda pas, tidak bersisa',
    'Your balance is exactly zero',
    '残高はちょうどゼロです',
    '您的余额刚好为零',
    'Ihr Guthaben ist genau null',
    'Ваш баланс ровно ноль',
    'Seu saldo está exatamente zerado',
    'رصيدك صفر تمامًا',
  ],
  'incomeVsExpense': [
    'Pemasukan vs pengeluaran',
    'Income vs expenses',
    '収入と支出',
    '收入与支出',
    'Einnahmen vs. Ausgaben',
    'Доходы и расходы',
    'Receitas x despesas',
    'الدخل مقابل المصروفات',
  ],
  'spentOfIncome': [
    'Terpakai {p}% dari pemasukan',
    '{p}% of income spent',
    '収入の {p}% を使用',
    '已用收入的 {p}%',
    '{p} % der Einnahmen ausgegeben',
    'Потрачено {p}% дохода',
    '{p}% da receita gasta',
    'تم إنفاق {p}% من الدخل',
  ],
  'noIncomeSet': [
    'Pemasukan bulan ini belum diisi',
    'No income set for this month',
    '今月の収入が未設定です',
    '本月尚未设置收入',
    'Für diesen Monat sind keine Einnahmen erfasst',
    'Доход за этот месяц не указан',
    'Nenhuma receita definida para este mês',
    'لم يُحدَّد دخل لهذا الشهر',
  ],
};

const Map<String, List<String>> _categoryNames = {
  'Makanan': [
    'Makanan',
    'Food',
    '食費',
    '餐饮',
    'Essen',
    'Еда',
    'Alimentação',
    'الطعام'
  ],
  'Transportasi': [
    'Transportasi',
    'Transport',
    '交通',
    '交通',
    'Transport',
    'Транспорт',
    'Transporte',
    'المواصلات'
  ],
  'Minum': [
    'Minum',
    'Drinks',
    '飲み物',
    '饮品',
    'Getränke',
    'Напитки',
    'Bebidas',
    'مشروبات'
  ],
  'Biaya Admin': [
    'Biaya Admin',
    'Admin Fee',
    '手数料',
    '手续费',
    'Gebühren',
    'Комиссия',
    'Taxa administrativa',
    'رسوم إدارية'
  ],
  'Top-Up': [
    'Top-Up',
    'Top-Up',
    'チャージ',
    '充值',
    'Aufladen',
    'Пополнение',
    'Recarga',
    'شحن رصيد'
  ],
  'Shopee': [
    'Shopee',
    'Shopee',
    'Shopee',
    'Shopee',
    'Shopee',
    'Shopee',
    'Shopee',
    'Shopee'
  ],
  'Tagihan': [
    'Tagihan',
    'Bills',
    '請求書',
    '账单',
    'Rechnungen',
    'Счета',
    'Contas',
    'الفواتير'
  ],
  'Hiburan': [
    'Hiburan',
    'Entertainment',
    '娯楽',
    '娱乐',
    'Unterhaltung',
    'Развлечения',
    'Lazer',
    'الترفيه'
  ],
  'Kesehatan': [
    'Kesehatan',
    'Health',
    '医療',
    '医疗',
    'Gesundheit',
    'Здоровье',
    'Saúde',
    'الصحة'
  ],
  'Pendidikan': [
    'Pendidikan',
    'Education',
    '教育',
    '教育',
    'Bildung',
    'Образование',
    'Educação',
    'التعليم'
  ],
  'Lainnya': [
    'Lainnya',
    'Other',
    'その他',
    '其他',
    'Sonstiges',
    'Другое',
    'Outros',
    'أخرى'
  ],
};
