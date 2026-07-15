package main

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestApplicationRoutes(t *testing.T) {
	tests := []struct {
		name        string
		path        string
		wantStatus  int
		wantContent string
	}{
		{name: "home", path: "/home", wantStatus: http.StatusOK, wantContent: "text/html"},
		{name: "courses", path: "/courses", wantStatus: http.StatusOK, wantContent: "text/html"},
		{name: "about", path: "/about", wantStatus: http.StatusOK, wantContent: "text/html"},
		{name: "contact", path: "/contact", wantStatus: http.StatusOK, wantContent: "text/html"},
		{name: "health", path: "/healthz", wantStatus: http.StatusOK, wantContent: "text/plain"},
		{name: "missing", path: "/does-not-exist", wantStatus: http.StatusNotFound, wantContent: "text/plain"},
	}

	handler := newHandler()
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			req := httptest.NewRequest(http.MethodGet, test.path, nil)
			res := httptest.NewRecorder()

			handler.ServeHTTP(res, req)

			if res.Code != test.wantStatus {
				t.Fatalf("status = %d, want %d", res.Code, test.wantStatus)
			}
			if contentType := res.Header().Get("Content-Type"); !strings.HasPrefix(contentType, test.wantContent) {
				t.Fatalf("content type = %q, want prefix %q", contentType, test.wantContent)
			}
		})
	}
}

func TestRootRedirectsToHome(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/", nil)
	res := httptest.NewRecorder()

	newHandler().ServeHTTP(res, req)

	if res.Code != http.StatusFound {
		t.Fatalf("status = %d, want %d", res.Code, http.StatusFound)
	}
	if location := res.Header().Get("Location"); location != "/home" {
		t.Fatalf("location = %q, want /home", location)
	}
}
