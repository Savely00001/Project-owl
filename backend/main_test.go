package main

import (
	"database/sql"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

func newTestServer(t *testing.T) *server {
	t.Helper()

	db, err := os.CreateTemp("", "project-owl-*.db")
	if err != nil {
		t.Fatalf("create temp db: %v", err)
	}
	t.Cleanup(func() {
		_ = os.Remove(db.Name())
	})
	_ = db.Close()

	srv := &server{}
	srv.db, err = openTestDB(db.Name())
	if err != nil {
		t.Fatalf("open test db: %v", err)
	}
	t.Cleanup(func() {
		_ = srv.db.Close()
	})

	if err := srv.init(); err != nil {
		t.Fatalf("init test db: %v", err)
	}

	return srv
}

func openTestDB(path string) (*sql.DB, error) {
	return sql.Open("sqlite", path)
}

func TestHealthEndpoint(t *testing.T) {
	srv := newTestServer(t)
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	rec := httptest.NewRecorder()

	srv.routes().ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", rec.Code)
	}
}

func TestTeachersEndpoint(t *testing.T) {
	srv := newTestServer(t)
	req := httptest.NewRequest(http.MethodGet, "/teachers", nil)
	rec := httptest.NewRecorder()

	srv.routes().ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", rec.Code)
	}

	body := rec.Body.String()
	if body == "[]\n" {
		t.Fatalf("expected seeded teachers, got empty response")
	}
}
