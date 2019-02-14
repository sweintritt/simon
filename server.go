package main

import (
	"flag"
	"log"
	"net/http"
)

func main() {
	port := "8085"
	flag.StringVar(&port, "p", port, "Service port")
	flag.StringVar(&port, "port", port, "Service port")
	flag.Parse()

	server := http.FileServer(http.Dir("public"))
	http.Handle("/", server)

	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)
	log.Println("Listening on port", port)
	err := http.ListenAndServe(":"+port, logRequest(server))
	if err != nil {
		log.Fatal(err)
	}
}

func logRequest(h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s %s\n", r.RemoteAddr, r.Method, r.URL)
		h.ServeHTTP(w, r)
	})
}
