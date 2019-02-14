.PHONY = all clean docker html pdf prepare push

NAME        = simon
HTML_DOC    = index.html
PDF_DOC     = simon.pdf
STYLE_SHEET = ./public/css/index.css
SOURCES     = server.go
REGISTRY    = localhost:5000
BUILD_DIR   = ./build

all: docker clean

html: $(HTML_DOC)

pdf: $(PDF_DOC)

$(PDF_DOC): public/index.md
	pandoc $< --number-sections --latex-engine=pdflatex --highlight-style=espresso -o $(PDF_DOC)

$(HTML_DOC): public/index.md
	pandoc $< --number-sections --highlight-style=espresso -o $(HTML_DOC) -t html5 --standalone --css $(STYLE_SHEET)

$(NAME): $(SOURCES)
	go build -o $(NAME) *.go

prepare: $(NAME) $(HTML_DOC)
	mkdir -p $(BUILD_DIR)/public
	cp $(NAME) $(BUILD_DIR)
	cp $(HTML_DOC) $(BUILD_DIR)/public
	cp -r public/* $(BUILD_DIR)/public

docker: $(NAME) prepare
ifndef VERSION
	$(error VERSION for docker image is not set. Example: 'make docker VERSION=1.0')
else
	sudo docker build -t $(NAME):$(VERSION) .
endif

push: docker
ifndef VERSION
	$(error VERSION for docker image is not set. Example: 'make push VERSION=1.0')
else
	sudo docker tag $(NAME):$(VERSION) $(REGISTRY)/$(NAME):$(VERSION)
	sudo docker push $(REGISTRY)/$(NAME):$(VERSION)
endif

clean:
	rm -f $(NAME)
	rm -f $(HTML_DOC)
	rm -f $(PDF_DOC)
	rm -rf $(BUILD_DIR)
