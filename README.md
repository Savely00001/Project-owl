# Project-owl

Мобильное приложение для выбора научного руководителя. Сейчас в репозитории есть Flutter-клиент и простой Go-бэкенд для:

- списка преподавателей;
- хранения студентов;
- отправки заявок на научного руководителя;
- принятия или отклонения заявок преподавателем;
- чата между студентом и преподавателем после одобрения заявки.

## Бэкенд

Бэкенд лежит в папке [backend](/Users/dmitriytogocheev/Documents/New project 4/backend).

### Стек

- Go
- `net/http`
- SQLite

### Запуск

```bash
cd backend
go mod tidy
go run .
```

По умолчанию сервер стартует на `http://localhost:8080`, а база создается в файле `backend/owl.db`.

Можно переопределить:

```bash
APP_PORT=8090 APP_DB_PATH=./dev.db go run .
```

### Что есть в API

- `GET /health` - проверка, что сервер жив.
- `GET /teachers?q=иванов` - список преподавателей и поиск.
- `GET /teachers/{id}` - карточка преподавателя.
- `GET /students` - список студентов.
- `POST /students` - создать студента.
- `GET /applications` - список заявок с фильтрами `teacher_id`, `student_id`, `status`.
- `GET /applications/{id}` - детали заявки.
- `POST /applications` - отправить заявку преподавателю.
- `PATCH /applications/{id}/status` - принять или отклонить заявку.
- `GET /chats?teacher_id=3` - список чатов преподавателя или студента.
- `GET /chats/{id}/messages` - сообщения в чате.
- `POST /chats/{id}/messages` - отправить сообщение.

### Примеры запросов

Создать студента:

```bash
curl -X POST http://localhost:8080/students \
  -H "Content-Type: application/json" \
  -d '{
    "full_name": "Петров Петр Петрович",
    "group_name": "251-777",
    "department": "Информационные технологии",
    "topic": "Сервис выбора научного руководителя"
  }'
```

Создать заявку:

```bash
curl -X POST http://localhost:8080/applications \
  -H "Content-Type: application/json" \
  -d '{
    "student_id": 1,
    "teacher_id": 2,
    "topic": "Исследование рекомендательных систем"
  }'
```

Одобрить заявку:

```bash
curl -X PATCH http://localhost:8080/applications/1/status \
  -H "Content-Type: application/json" \
  -d '{
    "status": "approved",
    "decision_comment": "Берем в работу"
  }'
```

После одобрения автоматически создается чат между студентом и преподавателем.
