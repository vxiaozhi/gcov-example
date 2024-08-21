# Gcov Example

**Use [Gcov](https://gcc.gnu.org/onlinedocs/gcc/Gcov.html) + [LCOV](https://github.com/linux-test-project/lcov) / [gcovr](https://github.com/gcovr/gcovr) to show C/C++ projects code coverage results.**

[![pages-build-deployment](https://github.com/shenxianpeng/gcov-example/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/shenxianpeng/gcov-example/actions/workflows/pages/pages-build-deployment) [![Build](https://github.com/shenxianpeng/gcov-example/actions/workflows/build.yml/badge.svg)](https://github.com/shenxianpeng/gcov-example/actions/workflows/build.yml)

This repo shows how to use Gcov to create lcov/gcovr coverage reports for C/C++ projects.

**Code coverage reports online**

* 📄 [LCOV - code coverage report](https://shenxianpeng.github.io/gcov-example/lcov-report/index.html)
* 📄 [gcovr - code coverage report](https://shenxianpeng.github.io/gcov-example/gcovr-report/coverage.html)

Note: The source code is under the `master` branch, and code coverage report under branch `coverage`.

## What problem does Gcov solve

The problem I encountered: A C/C++ project from decades ago has no unit tests, only regression tests. But I want to know:

* What code is tested by regression tests? 
* Which code is untested?
* What is the code coverage? 
* Where do I need to improve automated test cases in the future?

Can code coverage be measured without unit tests? The answer is Yes.

There are some tools on the market that can measure the code coverage of black-box testing, such as Squish Coco, Bullseye, etc but need to be charged. their principle is to insert instrumentation during build.

I tried Squish Coco but I have some build issues are not resolved.

## How Gcov works

Gcov workflow diagram

![flow](img/gcov-flow.jpg)

There are three main steps:

1. Adding special compile options to the GCC compilation to generate the executable, and `*.gcno`.
2. Running (testing) the generated executable, which generates the `*.gcda` data file.
3. With `*.gcno` and `*.gcda`, generate the `gcov` file from the source code, and finally generate the code coverage report.

Here's how each of these steps is done exactly.

## 详解 gcov

使用 llvm gcov/gcov 命令，可以将 gcno gcda 文件生成 gcda， gcda是文本文件。主要包括两种格式, 以maic.c 为例：

**1. 完全解析的 gcda 文件：**

可通过如下命令生成：

```
llvm-gcov.sh main.gcda foo.gcda --branch-counts --branch-probabilities --all-blocks --demangled-names --hash-filenames --object-directory .
```

```
          -:    0:Source:main.c
        -:    0:Graph:./main.gcno
        -:    0:Data:./main.gcda
        -:    0:Runs:1
        -:    0:Programs:1
        -:    1:#include <stdio.h>
        -:    2:
        -:    3:#include "foo.h"
        -:    4:#include "source_subdir/bar.h"
        -:    5:
        -:    6:int g_a = 555;
        -:    7:
function main called 1 returned 100% blocks executed 100%
        1:    8:int main(void) {
        -:    9:
        1:   10:  printf("print global: %d \n", g_a);
        1:   11:  printf("Start calling foo() ...\n");
        1:   12:  foo(1);
        1:   13:  foo(2);
        1:   14:  bar(3);
        1:   15:  return 0;
        1:   15-block  0
        -:   16:}
```

**2. 中间格式的 gcda 文件：**

可通过如下命令生成(增加了 -i 参数)：

```
	llvm-gcov.sh main.gcda foo.gcda -i --branch-counts --branch-probabilities --all-blocks --demangled-names --hash-filenames --object-directory .
```

```
  file:main.c
function:8,1,main
lcount:8,1
lcount:10,1
lcount:11,1
lcount:12,1
lcount:13,1
lcount:14,1
lcount:15,1
```



## gcov -> report 生成


## Getting started

You can clone this repository and run `make help` to see how to use it.

```bash
$ git clone https://github.com/shenxianpeng/gcov-example.git
cd gcov-example

$ make help
help                           Makefile help
build                          Make build
coverage                       Run code coverage
lcov-report                    Generate lcov report
gcovr-report                   Generate gcovr report
deps                           Install dependencies
clean                          Clean all generate files
lint                           Lint code with clang-format
```

Steps to generate code coverage reports

```bash
# 1. compile
make build

# 2. run executable
./main

# 3. run code coverage
make coverage

# 4. generate report
# support lcov and gcovr reports
# to make report need to install dependencies first
make deps
# then
make lcov-report
# or
make gcovr-report
```
