default:
	@echo "make install, or update"
	@echo "install to copy this repos' files over to HOME"
	@echo "update to copy HOME's files here"

install:
	cp -fv .vimrc ~/
	if [ ! -d ~/.vim ]; then mkdir ~/.vim; fi;
	cp -Rfv .vim/* ~/.vim/

update:
	cp -Rfv ~/.vimrc ~/.vim .


