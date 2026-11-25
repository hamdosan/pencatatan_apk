# Catatan Pengeluaran (Flutter + MVC + SQLite)

## Cara menjalankan
```bash
flutter create --platforms=android --project-name expense_tracker .
# timpa pubspec.yaml dan folder lib/ dengan isi proyek ini
flutter pub get
flutter run
```

## Arsitektur MVC
| Lapisan | Folder | Tanggung jawab |
|---|---|---|
| Model | `lib/models`, `lib/database` | Struktur data + akses SQLite |
| View | `lib/views` | Tampilan UI, tanpa logika bisnis/DB |
| Controller | `lib/controllers` | State (ChangeNotifier), logika, memanggil Model |

Alur: View -> Controller -> Model (DB) -> Controller notifyListeners() -> View rebuild.

## Skema database (SQLite)
```sql
categories(id PK, name UNIQUE, icon, color)
expenses(id PK, title, amount > 0, category_id FK -> categories.id,
         date 'yyyy-MM-dd', note, created_at)
INDEX idx_expenses_date ON expenses(date)
```
