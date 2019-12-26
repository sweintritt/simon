.PHONY = all clean docker html pdf prepare push

NAME        = simon
HTML_DOC    = index.html
PDF_DOC     = simon.pdf
STYLE_SHEET = ./css/index.css
SOURCES     = server.go
REGISTRY    = localhost:5000
BUILD_DIR   = ./build
VERSION   = $(shell cat VERSION)

all: docker

html: $(HTML_DOC)

pdf: $(PDF_DOC)

prepare:
	mkdir -p $(BUILD_DIR)/public
	cp -r public/* $(BUILD_DIR)/public

$(PDF_DOC): public/index.md prepare
	cd public
	pandoc $< --number-sections --pdf-engine=pdflatex --highlight-style=espresso -o $(BUILD_DIR)/$(PDF_DOC)
	cd ..

$(HTML_DOC): public/index.md prepare
	cd public
	pandoc $< --number-sections --highlight-style=espresso -o $(BUILD_DIR)/public/$(HTML_DOC) -t html5 --standalone --css $(STYLE_SHEET)
	cd ..

$(NAME): $(SOURCES) prepare
	go build -o $(NAME) *.go

prepare-docker: $(NAME) $(HTML_DOC)
	cp $(NAME) $(BUILD_DIR)

docker: $(NAME) prepare-docker
	sudo docker build -t $(NAME):$(VERSION) .

push: docker
	sudo docker tag $(NAME):$(VERSION) $(REGISTRY)/$(NAME):$(VERSION)
	sudo docker push $(REGISTRY)/$(NAME):$(VERSION)

clean:
	rm -f $(NAME)
	rm -f $(HTML_DOC)
	rm -f $(PDF_DOC)
	rm -rf $(BUILD_DIR)
