# Ithra Library Database (Oracle SQL)

A clean, professional Oracle SQL implementation of a Library database for the King Abdulaziz Center for World Culture (Ithra). It models branches, managers, employees, members, authors, books, visits, publishing and borrowing relations.

## What's inside
- **Cleaned schema**: fixed typos (`Manager`), normalized relationships (adds **BORROW** table, removes book FK from `MEMBER`), and polished constraints.
- **Seed data**: three rows per table for quick testing.
- **Sample queries**: meet common coursework requirements (WHERE, LIKE, DELETE, GROUP BY, HAVING, JOIN).
- **Report PDF**: original project report under `docs/`.

## Quick start
1. Open [Oracle LiveSQL](https://livesql.oracle.com) or your Oracle SQL environment.
2. Copy‑paste the contents of `sql/ithra_library.sql` and run it.
3. Try the sample queries at the bottom of the file.

> **Note:** The script safely drops tables if they exist using anonymous PL/SQL blocks, so you can re-run it anytime.

## Entities & Relationships (summary)
- `BRANCH( branch_num, branch_location )`
- `MANAGER( manager_id, manager_name )`
- `EMPLOYEE( …, branch_num FK )`
- `MANAGES( manager_id FK, employee_id FK )`
- `MEMBER( phone_number, address, member_name, branch_num FK )`
- `BOOK( book_number, title, book_price, pages )`
- `AUTHOR( author_id, author_name )`
- `PUBLISH( author_id FK, book_number FK )` — M:N
- `BORROW( phone_number FK, book_number FK )` — M:N
- `VISIT( branch_num FK, phone_number FK )`

## Project structure
```
.
├─ README.md
├─ LICENSE
├─ .gitignore
├─ sql/
│  └─ ithra_library.sql
└─ docs/
   └─ ithra-library-report.pdf
```

## Rationale for fixes
- **Spelling & naming**: Renamed `Manger` → `MANAGER`. 
- **Borrowing model**: Removed `book_number` from `MEMBER` and added `BORROW` junction table so each member can borrow many books and each book can be borrowed by many members.
- **Publish model**: Removed the unused `book_num` column from `PUBLISH` and kept a clean M:N primary key.
- **Branch membership**: Added `branch_num` to `MEMBER` as stated in the project description.
- **Safety**: All drops wrapped in `BEGIN … EXCEPTION WHEN OTHERS THEN NULL; END;` blocks, so re-running is fine.

## How to upload via the GitHub website (no installs)
1. Go to **github.com/new** → create a repo called `ithra-library-db` (Public).
2. Check **Add a README** and select **MIT License** (or add later).
3. Click **Create repository**.
4. In the repo, click **Add file → Upload files**. Drag the following **files** into the page:
   - `README.md`
   - `LICENSE`
   - `.gitignore`
   - `sql/ithra_library.sql`
   - `docs/ithra-library-report.pdf`
   > Tip: You can drag the `sql/` and `docs/` **folders** directly to keep the structure.
5. Scroll down, write a message like _"Initial commit: schema, seed, docs"_, then **Commit changes**.

## License
MIT — see `LICENSE`.
