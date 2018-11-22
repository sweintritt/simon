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

	log.Println("Listening on port", port)
	http.ListenAndServe(":"+port, nil)
}
