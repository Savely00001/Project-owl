package main

import (
	"database/sql"
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	_ "modernc.org/sqlite"
)

type server struct {
	db *sql.DB
}

type teacher struct {
	ID         int64  `json:"id"`
	FullName   string `json:"full_name"`
	Position   string `json:"position"`
	Department string `json:"department"`
	Capacity   int    `json:"capacity"`
	Bio        string `json:"bio"`
}

type student struct {
	ID         int64  `json:"id"`
	FullName   string `json:"full_name"`
	GroupName  string `json:"group_name"`
	Department string `json:"department"`
	Topic      string `json:"topic"`
}

type application struct {
	ID              int64  `json:"id"`
	StudentID       int64  `json:"student_id"`
	TeacherID       int64  `json:"teacher_id"`
	StudentName     string `json:"student_name,omitempty"`
	TeacherName     string `json:"teacher_name,omitempty"`
	GroupName       string `json:"group_name,omitempty"`
	Department      string `json:"department,omitempty"`
	Topic           string `json:"topic"`
	Status          string `json:"status"`
	DecisionComment string `json:"decision_comment,omitempty"`
	CreatedAt       string `json:"created_at"`
	UpdatedAt       string `json:"updated_at"`
}

type chat struct {
	ID          int64  `json:"id"`
	StudentID   int64  `json:"student_id"`
	TeacherID   int64  `json:"teacher_id"`
	StudentName string `json:"student_name"`
	TeacherName string `json:"teacher_name"`
	LastMessage string `json:"last_message"`
	LastTime    string `json:"last_time"`
}

type message struct {
	ID         int64  `json:"id"`
	ChatID     int64  `json:"chat_id"`
	SenderRole string `json:"sender_role"`
	SenderID   int64  `json:"sender_id"`
	Text       string `json:"text"`
	CreatedAt  string `json:"created_at"`
}

type createStudentRequest struct {
	FullName   string `json:"full_name"`
	GroupName  string `json:"group_name"`
	Department string `json:"department"`
	Topic      string `json:"topic"`
}

type createApplicationRequest struct {
	StudentID int64  `json:"student_id"`
	TeacherID int64  `json:"teacher_id"`
	Topic     string `json:"topic"`
}

type updateApplicationStatusRequest struct {
	Status          string `json:"status"`
	DecisionComment string `json:"decision_comment"`
}

type createMessageRequest struct {
	SenderRole string `json:"sender_role"`
	SenderID   int64  `json:"sender_id"`
	Text       string `json:"text"`
}

func main() {
	dbPath := getenv("APP_DB_PATH", "owl.db")
	port := getenv("APP_PORT", "8080")

	db, err := sql.Open("sqlite", dbPath)
	if err != nil {
		log.Fatalf("open db: %v", err)
	}
	defer db.Close()

	srv := &server{db: db}
	if err := srv.init(); err != nil {
		log.Fatalf("init db: %v", err)
	}

	log.Printf("backend started on http://localhost:%s", port)
	if err := http.ListenAndServe(":"+port, srv.routes()); err != nil {
		log.Fatal(err)
	}
}

func (s *server) init() error {
	if err := s.setupSchema(); err != nil {
		return err
	}
	return s.seedData()
}

func (s *server) routes() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("/health", s.handleHealth)
	mux.HandleFunc("/teachers", s.handleTeachers)
	mux.HandleFunc("/teachers/", s.handleTeacherByID)
	mux.HandleFunc("/students", s.handleStudents)
	mux.HandleFunc("/applications", s.handleApplications)
	mux.HandleFunc("/applications/", s.handleApplicationByID)
	mux.HandleFunc("/chats", s.handleChats)
	mux.HandleFunc("/chats/", s.handleChatByID)
	return withCORS(mux)
}

func (s *server) setupSchema() error {
	statements := []string{
		`CREATE TABLE IF NOT EXISTS teachers (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			full_name TEXT NOT NULL,
			position TEXT NOT NULL,
			department TEXT NOT NULL,
			capacity INTEGER NOT NULL DEFAULT 5,
			bio TEXT NOT NULL DEFAULT '',
			created_at TEXT NOT NULL
		);`,
		`CREATE TABLE IF NOT EXISTS students (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			full_name TEXT NOT NULL,
			group_name TEXT NOT NULL,
			department TEXT NOT NULL,
			topic TEXT NOT NULL DEFAULT '',
			created_at TEXT NOT NULL
		);`,
		`CREATE TABLE IF NOT EXISTS applications (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			student_id INTEGER NOT NULL,
			teacher_id INTEGER NOT NULL,
			topic TEXT NOT NULL,
			status TEXT NOT NULL,
			decision_comment TEXT NOT NULL DEFAULT '',
			created_at TEXT NOT NULL,
			updated_at TEXT NOT NULL,
			FOREIGN KEY(student_id) REFERENCES students(id),
			FOREIGN KEY(teacher_id) REFERENCES teachers(id)
		);`,
		`CREATE TABLE IF NOT EXISTS chats (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			student_id INTEGER NOT NULL,
			teacher_id INTEGER NOT NULL,
			created_at TEXT NOT NULL,
			UNIQUE(student_id, teacher_id),
			FOREIGN KEY(student_id) REFERENCES students(id),
			FOREIGN KEY(teacher_id) REFERENCES teachers(id)
		);`,
		`CREATE TABLE IF NOT EXISTS messages (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			chat_id INTEGER NOT NULL,
			sender_role TEXT NOT NULL,
			sender_id INTEGER NOT NULL,
			text TEXT NOT NULL,
			created_at TEXT NOT NULL,
			FOREIGN KEY(chat_id) REFERENCES chats(id)
		);`,
	}

	for _, stmt := range statements {
		if _, err := s.db.Exec(stmt); err != nil {
			return err
		}
	}
	return nil
}

func (s *server) seedData() error {
	var teachersCount int
	if err := s.db.QueryRow(`SELECT COUNT(*) FROM teachers`).Scan(&teachersCount); err != nil {
		return err
	}
	if teachersCount > 0 {
		return nil
	}

	now := time.Now().Format(time.RFC3339)
	tx, err := s.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	teachers := []teacher{
		{FullName: "Иванов Иван Иванович", Position: "Доцент", Department: "Информационные технологии", Capacity: 5, Bio: "Помогает с темами по backend и аналитике данных."},
		{FullName: "Сергеев Сергей Сергеевич", Position: "Доктор наук", Department: "Информационные технологии", Capacity: 3, Bio: "Берет дипломы по машинному обучению и обработке данных."},
		{FullName: "Валуева Валерия Викторовна", Position: "Кандидат наук", Department: "Информационные технологии", Capacity: 4, Bio: "Сильна в мобильной разработке и UX для учебных проектов."},
	}
	for _, t := range teachers {
		if _, err := tx.Exec(
			`INSERT INTO teachers (full_name, position, department, capacity, bio, created_at)
			 VALUES (?, ?, ?, ?, ?, ?)`,
			t.FullName, t.Position, t.Department, t.Capacity, t.Bio, now,
		); err != nil {
			return err
		}
	}

	students := []student{
		{FullName: "Иванов Иван", GroupName: "251-333", Department: "Информационные технологии", Topic: "Исследование методов машинного обучения"},
		{FullName: "Сергеев Сергей", GroupName: "251-666", Department: "Информационные технологии", Topic: "Разработка мобильного сервиса для студентов"},
	}
	for _, st := range students {
		if _, err := tx.Exec(
			`INSERT INTO students (full_name, group_name, department, topic, created_at)
			 VALUES (?, ?, ?, ?, ?)`,
			st.FullName, st.GroupName, st.Department, st.Topic, now,
		); err != nil {
			return err
		}
	}

	if _, err := tx.Exec(
		`INSERT INTO applications (student_id, teacher_id, topic, status, decision_comment, created_at, updated_at)
		 VALUES (1, 1, ?, 'pending', '', ?, ?)`,
		"Исследование методов машинного обучения", now, now,
	); err != nil {
		return err
	}
	if _, err := tx.Exec(
		`INSERT INTO applications (student_id, teacher_id, topic, status, decision_comment, created_at, updated_at)
		 VALUES (2, 3, ?, 'approved', 'Можно брать в работу', ?, ?)`,
		"Разработка мобильного сервиса для студентов", now, now,
	); err != nil {
		return err
	}

	if _, err := tx.Exec(
		`INSERT INTO chats (student_id, teacher_id, created_at) VALUES (2, 3, ?)`,
		now,
	); err != nil {
		return err
	}
	if _, err := tx.Exec(
		`INSERT INTO messages (chat_id, sender_role, sender_id, text, created_at)
		 VALUES
		 (1, 'student', 2, 'Здравствуйте! Отправил исправленную версию.', ?),
		 (1, 'teacher', 3, 'Да, вижу. Вечером посмотрю и дам комментарии.', ?)`,
		now, now,
	); err != nil {
		return err
	}

	return tx.Commit()
}

func (s *server) handleHealth(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		methodNotAllowed(w)
		return
	}
	writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
}

func (s *server) handleTeachers(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		methodNotAllowed(w)
		return
	}

	query := strings.TrimSpace(r.URL.Query().Get("q"))
	rows, err := s.db.Query(
		`SELECT id, full_name, position, department, capacity, bio
		 FROM teachers
		 WHERE ? = '' OR lower(full_name) LIKE '%' || lower(?) || '%' OR lower(department) LIKE '%' || lower(?) || '%'
		 ORDER BY full_name`,
		query, query, query,
	)
	if err != nil {
		internalError(w, err)
		return
	}
	defer rows.Close()

	var items []teacher
	for rows.Next() {
		var item teacher
		if err := rows.Scan(&item.ID, &item.FullName, &item.Position, &item.Department, &item.Capacity, &item.Bio); err != nil {
			internalError(w, err)
			return
		}
		items = append(items, item)
	}
	writeJSON(w, http.StatusOK, items)
}

func (s *server) handleTeacherByID(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		methodNotAllowed(w)
		return
	}

	id, tail, err := parseIDPath(r.URL.Path, "/teachers/")
	if err != nil || tail != "" {
		notFound(w)
		return
	}

	var item teacher
	err = s.db.QueryRow(
		`SELECT id, full_name, position, department, capacity, bio
		 FROM teachers WHERE id = ?`,
		id,
	).Scan(&item.ID, &item.FullName, &item.Position, &item.Department, &item.Capacity, &item.Bio)
	if errors.Is(err, sql.ErrNoRows) {
		notFound(w)
		return
	}
	if err != nil {
		internalError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, item)
}

func (s *server) handleStudents(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodGet:
		rows, err := s.db.Query(
			`SELECT id, full_name, group_name, department, topic
			 FROM students
			 ORDER BY full_name`,
		)
		if err != nil {
			internalError(w, err)
			return
		}
		defer rows.Close()

		var items []student
		for rows.Next() {
			var item student
			if err := rows.Scan(&item.ID, &item.FullName, &item.GroupName, &item.Department, &item.Topic); err != nil {
				internalError(w, err)
				return
			}
			items = append(items, item)
		}
		writeJSON(w, http.StatusOK, items)
	case http.MethodPost:
		var req createStudentRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			badRequest(w, "invalid json")
			return
		}
		if strings.TrimSpace(req.FullName) == "" || strings.TrimSpace(req.GroupName) == "" || strings.TrimSpace(req.Department) == "" {
			badRequest(w, "full_name, group_name and department are required")
			return
		}

		now := time.Now().Format(time.RFC3339)
		res, err := s.db.Exec(
			`INSERT INTO students (full_name, group_name, department, topic, created_at)
			 VALUES (?, ?, ?, ?, ?)`,
			req.FullName, req.GroupName, req.Department, req.Topic, now,
		)
		if err != nil {
			internalError(w, err)
			return
		}
		id, _ := res.LastInsertId()
		writeJSON(w, http.StatusCreated, student{
			ID:         id,
			FullName:   req.FullName,
			GroupName:  req.GroupName,
			Department: req.Department,
			Topic:      req.Topic,
		})
	default:
		methodNotAllowed(w)
	}
}

func (s *server) handleApplications(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodGet:
		status := strings.TrimSpace(r.URL.Query().Get("status"))
		teacherID := parseInt64(r.URL.Query().Get("teacher_id"))
		studentID := parseInt64(r.URL.Query().Get("student_id"))

		rows, err := s.db.Query(
			`SELECT a.id, a.student_id, a.teacher_id, s.full_name, t.full_name, s.group_name, s.department,
			        a.topic, a.status, a.decision_comment, a.created_at, a.updated_at
			 FROM applications a
			 JOIN students s ON s.id = a.student_id
			 JOIN teachers t ON t.id = a.teacher_id
			 WHERE (? = '' OR a.status = ?)
			   AND (? = 0 OR a.teacher_id = ?)
			   AND (? = 0 OR a.student_id = ?)
			 ORDER BY a.updated_at DESC`,
			status, status, teacherID, teacherID, studentID, studentID,
		)
		if err != nil {
			internalError(w, err)
			return
		}
		defer rows.Close()

		var items []application
		for rows.Next() {
			var item application
			if err := rows.Scan(
				&item.ID, &item.StudentID, &item.TeacherID, &item.StudentName, &item.TeacherName,
				&item.GroupName, &item.Department, &item.Topic, &item.Status, &item.DecisionComment,
				&item.CreatedAt, &item.UpdatedAt,
			); err != nil {
				internalError(w, err)
				return
			}
			items = append(items, item)
		}
		writeJSON(w, http.StatusOK, items)
	case http.MethodPost:
		var req createApplicationRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			badRequest(w, "invalid json")
			return
		}
		if req.StudentID == 0 || req.TeacherID == 0 || strings.TrimSpace(req.Topic) == "" {
			badRequest(w, "student_id, teacher_id and topic are required")
			return
		}

		now := time.Now().Format(time.RFC3339)
		res, err := s.db.Exec(
			`INSERT INTO applications (student_id, teacher_id, topic, status, decision_comment, created_at, updated_at)
			 VALUES (?, ?, ?, 'pending', '', ?, ?)`,
			req.StudentID, req.TeacherID, req.Topic, now, now,
		)
		if err != nil {
			internalError(w, err)
			return
		}
		id, _ := res.LastInsertId()
		writeJSON(w, http.StatusCreated, map[string]any{
			"id":         id,
			"student_id": req.StudentID,
			"teacher_id": req.TeacherID,
			"topic":      req.Topic,
			"status":     "pending",
		})
	default:
		methodNotAllowed(w)
	}
}

func (s *server) handleApplicationByID(w http.ResponseWriter, r *http.Request) {
	id, tail, err := parseIDPath(r.URL.Path, "/applications/")
	if err != nil {
		notFound(w)
		return
	}

	if tail == "" && r.Method == http.MethodGet {
		s.getApplication(w, id)
		return
	}
	if tail == "/status" && r.Method == http.MethodPatch {
		s.updateApplicationStatus(w, id, r)
		return
	}

	methodNotAllowed(w)
}

func (s *server) getApplication(w http.ResponseWriter, id int64) {
	var item application
	err := s.db.QueryRow(
		`SELECT a.id, a.student_id, a.teacher_id, s.full_name, t.full_name, s.group_name, s.department,
		        a.topic, a.status, a.decision_comment, a.created_at, a.updated_at
		 FROM applications a
		 JOIN students s ON s.id = a.student_id
		 JOIN teachers t ON t.id = a.teacher_id
		 WHERE a.id = ?`,
		id,
	).Scan(
		&item.ID, &item.StudentID, &item.TeacherID, &item.StudentName, &item.TeacherName,
		&item.GroupName, &item.Department, &item.Topic, &item.Status, &item.DecisionComment,
		&item.CreatedAt, &item.UpdatedAt,
	)
	if errors.Is(err, sql.ErrNoRows) {
		notFound(w)
		return
	}
	if err != nil {
		internalError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, item)
}

func (s *server) updateApplicationStatus(w http.ResponseWriter, id int64, r *http.Request) {
	var req updateApplicationStatusRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		badRequest(w, "invalid json")
		return
	}
	if req.Status != "approved" && req.Status != "rejected" {
		badRequest(w, "status must be approved or rejected")
		return
	}

	now := time.Now().Format(time.RFC3339)
	res, err := s.db.Exec(
		`UPDATE applications
		 SET status = ?, decision_comment = ?, updated_at = ?
		 WHERE id = ?`,
		req.Status, req.DecisionComment, now, id,
	)
	if err != nil {
		internalError(w, err)
		return
	}
	affected, _ := res.RowsAffected()
	if affected == 0 {
		notFound(w)
		return
	}

	if req.Status == "approved" {
		if err := s.ensureChatForApplication(id, now); err != nil {
			internalError(w, err)
			return
		}
	}

	s.getApplication(w, id)
}

func (s *server) ensureChatForApplication(applicationID int64, now string) error {
	var studentID, teacherID int64
	if err := s.db.QueryRow(
		`SELECT student_id, teacher_id FROM applications WHERE id = ?`,
		applicationID,
	).Scan(&studentID, &teacherID); err != nil {
		return err
	}

	_, err := s.db.Exec(
		`INSERT OR IGNORE INTO chats (student_id, teacher_id, created_at)
		 VALUES (?, ?, ?)`,
		studentID, teacherID, now,
	)
	return err
}

func (s *server) handleChats(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		methodNotAllowed(w)
		return
	}

	teacherID := parseInt64(r.URL.Query().Get("teacher_id"))
	studentID := parseInt64(r.URL.Query().Get("student_id"))
	rows, err := s.db.Query(
		`SELECT c.id, c.student_id, c.teacher_id, s.full_name, t.full_name,
		        COALESCE(m.text, ''), COALESCE(m.created_at, c.created_at)
		 FROM chats c
		 JOIN students s ON s.id = c.student_id
		 JOIN teachers t ON t.id = c.teacher_id
		 LEFT JOIN messages m ON m.id = (
		    SELECT id FROM messages WHERE chat_id = c.id ORDER BY created_at DESC, id DESC LIMIT 1
		 )
		 WHERE (? = 0 OR c.teacher_id = ?)
		   AND (? = 0 OR c.student_id = ?)
		 ORDER BY COALESCE(m.created_at, c.created_at) DESC`,
		teacherID, teacherID, studentID, studentID,
	)
	if err != nil {
		internalError(w, err)
		return
	}
	defer rows.Close()

	var items []chat
	for rows.Next() {
		var item chat
		if err := rows.Scan(
			&item.ID, &item.StudentID, &item.TeacherID, &item.StudentName,
			&item.TeacherName, &item.LastMessage, &item.LastTime,
		); err != nil {
			internalError(w, err)
			return
		}
		items = append(items, item)
	}
	writeJSON(w, http.StatusOK, items)
}

func (s *server) handleChatByID(w http.ResponseWriter, r *http.Request) {
	id, tail, err := parseIDPath(r.URL.Path, "/chats/")
	if err != nil {
		notFound(w)
		return
	}
	if tail != "/messages" {
		notFound(w)
		return
	}

	switch r.Method {
	case http.MethodGet:
		rows, err := s.db.Query(
			`SELECT id, chat_id, sender_role, sender_id, text, created_at
			 FROM messages
			 WHERE chat_id = ?
			 ORDER BY created_at, id`,
			id,
		)
		if err != nil {
			internalError(w, err)
			return
		}
		defer rows.Close()

		var items []message
		for rows.Next() {
			var item message
			if err := rows.Scan(&item.ID, &item.ChatID, &item.SenderRole, &item.SenderID, &item.Text, &item.CreatedAt); err != nil {
				internalError(w, err)
				return
			}
			items = append(items, item)
		}
		writeJSON(w, http.StatusOK, items)
	case http.MethodPost:
		var req createMessageRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			badRequest(w, "invalid json")
			return
		}
		if (req.SenderRole != "student" && req.SenderRole != "teacher") || req.SenderID == 0 || strings.TrimSpace(req.Text) == "" {
			badRequest(w, "sender_role, sender_id and text are required")
			return
		}

		now := time.Now().Format(time.RFC3339)
		res, err := s.db.Exec(
			`INSERT INTO messages (chat_id, sender_role, sender_id, text, created_at)
			 VALUES (?, ?, ?, ?, ?)`,
			id, req.SenderRole, req.SenderID, req.Text, now,
		)
		if err != nil {
			internalError(w, err)
			return
		}
		messageID, _ := res.LastInsertId()
		writeJSON(w, http.StatusCreated, message{
			ID:         messageID,
			ChatID:     id,
			SenderRole: req.SenderRole,
			SenderID:   req.SenderID,
			Text:       req.Text,
			CreatedAt:  now,
		})
	default:
		methodNotAllowed(w)
	}
}

func parseIDPath(path, prefix string) (int64, string, error) {
	trimmed := strings.TrimPrefix(path, prefix)
	if trimmed == path || trimmed == "" {
		return 0, "", errors.New("missing id")
	}

	parts := strings.SplitN(trimmed, "/", 2)
	id, err := strconv.ParseInt(parts[0], 10, 64)
	if err != nil {
		return 0, "", err
	}
	if len(parts) == 1 {
		return id, "", nil
	}
	return id, "/" + parts[1], nil
}

func withCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PATCH, OPTIONS")
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func writeJSON(w http.ResponseWriter, status int, value any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(value); err != nil {
		log.Printf("write json: %v", err)
	}
}

func badRequest(w http.ResponseWriter, message string) {
	writeJSON(w, http.StatusBadRequest, map[string]string{"error": message})
}

func notFound(w http.ResponseWriter) {
	writeJSON(w, http.StatusNotFound, map[string]string{"error": "not found"})
}

func methodNotAllowed(w http.ResponseWriter) {
	writeJSON(w, http.StatusMethodNotAllowed, map[string]string{"error": "method not allowed"})
}

func internalError(w http.ResponseWriter, err error) {
	log.Printf("internal error: %v", err)
	writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal server error"})
}

func parseInt64(raw string) int64 {
	value, err := strconv.ParseInt(raw, 10, 64)
	if err != nil {
		return 0
	}
	return value
}

func getenv(key, fallback string) string {
	value := strings.TrimSpace(os.Getenv(key))
	if value == "" {
		return fallback
	}
	return value
}
