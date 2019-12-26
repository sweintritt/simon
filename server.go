package main

import (
	"flag"
	"log"
	"net/http"
)

func main() {
	port := "8080"
	flag.StringVar(&port, "p", port, "Service port")
	flag.StringVar(&port, "port", port, "Service port")
	flag.Parse()

	server := http.FileServer(http.Dir("./public/"))
	http.Handle("/", server)
	log.Printf("running on port %s\n", port)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatal(err)
	}
}
