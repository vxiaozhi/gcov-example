ifdef CLANG
	CC  = clang
	CFLAG = -fPIC -fprofile-arcs -ftest-coverage
	GCOV = llvm-cov gcov
	LCOV_FLAG = --gcov-tool llvm-gcov.sh
else
	CC	= gcc
	CFLAG = -fPIC -fprofile-arcs -ftest-coverage
	GCOV = gcov
	LCOV_FLAG = 
endif

#LFLAG = -L /usr/lib64/clang/14.0.6/lib/linux/ -lclang_rt.profile-x86_64
RM	= rm -rf

help: ## Makefile help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

main.o: main.c
	$(CC) $(CFLAG) -c -Wall -Werror main.c

foo.o: foo.c
	$(CC) $(CFLAG) -c -Wall -Werror foo.c

source_subdir/bar.o: source_subdir/bar.c
	$(CC) $(CFLAG) -c -Wall -Werror $^ -o $@

test.o: test.c
	$(CC) $(CFLAG) -c -Wall -Werror test.c

build: main.o foo.o test.o source_subdir/bar.o ## Make build
	$(CC) $(CFLAG) -c -Wall -Werror main.c
	$(CC) $(CFLAG) $(LFLAG) -o main main.o foo.o test.o source_subdir/bar.o

coverage: ## Run code coverage
	$(GCOV) main.c foo.c test.c

lcov-report: coverage ## Generate lcov report
	mkdir lcov-report
	lcov $(LCOV_FLAG) --capture --directory . --output-file lcov-report/coverage.info
	genhtml lcov-report/coverage.info --output-directory lcov-report

gcovr-report: coverage ## Generate gcovr report
	mkdir gcovr-report
	gcovr --root . --html --html-details --output gcovr-report/coverage.html

deps: ## Install dependencies
	sudo apt-get install lcov clang-format
	pip install gcovr

clean: ## Clean all generate files
	$(RM) main *.out *.o *.so *.gcno *.gcda *.gcov lcov-report gcovr-report
	$(RM) source_subdir/*.o source_subdir/*.gcno source_subdir/*.gcda


lint: ## Lint code with clang-format
	clang-format -i --style=LLVM *.c *.h
