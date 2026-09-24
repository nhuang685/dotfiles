. "$HOME/.cargo/env"

render() {
  ffmpeg -i $1 -vf tblend=average -c:v libx264 -pix_fmt yuv420p -b:v 20M -r 60 output.mp4
}

guarantee() {
  if [ ! -d $1 ]; then
    mkdir $1
  fi
}

trans() {
  cwd=$(pwd)
  cd ~/Competitive-Programming-Files/
  ./AutoIns/autoins $cwd/$1.cpp submit/main.cpp
  cd $cwd
}

co() {
  guarantee out || return

  local main="$1"
  shift

  clang++ \
    -fcolor-diagnostics \
    -g \
    -std=c++23 \
    -fsanitize=undefined \
    -fsanitize=address \
    -DLOCAL \
    -Wall \
    -Wextra \
    -Wshadow \
    -Wconversion \
    -Wfloat-equal \
    -Wshift-overflow \
    -Wformat=2 \
    -Wno-sign-conversion \
    -ferror-limit=0 \
    -pedantic \
    -fstack-protector \
    -Wno-gnu-statement-expression-from-macro-expansion \
    -I/Users/nelsonhuang/Competitive-Programming-Files/include/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/include/ac-library/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/include/testlib/ \
    -Wl,-stack_size,0x10000000 \
    -o \
    out/$main \
    $main.cpp \
    "$@" \
}

fast() {
  guarantee out || return

  local main="$1"
  shift

  clang++ \
    -fcolor-diagnostics \
    -O2 \
    -std=c++23 \
    -DLOCAL \
    -Wall \
    -Wextra \
    -Wshadow \
    -Wconversion \
    -Wfloat-equal \
    -Wshift-overflow \
    -Wformat=2 \
    -Wno-sign-conversion \
    -ferror-limit=0 \
    -pedantic \
    -I/Users/nelsonhuang/Competitive-Programming-Files/include/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/ac-library/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/testlib/ \
    -Wl,-stack_size,0x10000000 \
    -o \
    out/$main \
    $main.cpp \
    "$@" \
}

corun() {
  co "$@" && ./out/$1
}

frun() {
  fast "$@" && ./out/$1
}

coruni() {
  co "$@" && ./out/$1 < int
}

runtc() {
  for ((i = $3; i <= $4; i++)); do
    echo "test case" $i
    echo "-----"
    ./out/$1/$2 < $1/0$i.in > oup
    echo "-----"
    echo "Expected Output:"
    cat $1/0$i.out
    echo "-----"
    echo "Received Output:"
    cat oup
    echo "-----"
    echo "Difference:"
    diff -w oup $1/0$i.out
    echo "--------"
  done
}
oruntc() {
  for ((i = $2; i <= $3; i++)); do
    echo "test case" $i
    echo "-----"
    ./out/$1 < 0$i.in > oup
    echo "-----"
    echo "Expected Output:"
    cat 0$i.out
    echo "-----"
    echo "Received Output:"
    cat oup
    echo "-----"
    echo "Difference:"
    diff -w oup 0$i.out
    echo "--------"
  done
}

run() {
  guarantee out || return
  guarantee out/$1 || return
  co $1/$2
  runtc $1 $2 $3 $4
}
orun() {
  guarantee out || return
  co $1
  oruntc $1 $2 $3
}

runf() {
  guarantee out || return
  guarantee out/$1 || return
  fast $1/$2
  runtc $1 $2 $3 $4
}
orunf() {
  guarantee out || return
  fast $1
  oruntc $1 $2 $3
}

rrun() {
  cargo build
  for ((i = $3; i <= $4; i++)); do
    echo "test case" $i
    echo "-----"
    cargo run --bin $2 < $1/0$i.in > oup
    echo "-----"
    echo "Expected Output:"
    cat $1/0$i.out
    echo "-----"
    echo "Received Output:"
    cat oup
    echo "-----"
    echo "Difference:"
    diff -w oup $1/0$i.out
    echo "--------"
  done
}

rustinit() {
  cargo init --name $1
  cargo add --path ~/Competitive-Programming-Files/algo_lib/
  mkdir src/bin
}

rnp() {
  mkdir $1
  touch src/bin/$1.rs
}

transr() {
  cwd=$(pwd)
  source-builder src/bin/$1.rs --library algo_lib --path ~/Competitive-Programming-Files/algo_lib/ --output ~/Competitive-Programming-Files/submit/src/main.rs
  cd ~/Competitive-Programming-Files/submit/
  cargo build
  cd $cwd
}

build_debug() {
  guarantee out
  clang++ \
    -fcolor-diagnostics \
    -fmessage-length=0 \
    -g \
    -std=c++$2 \
    -fsanitize=undefined \
    -fsanitize=address \
    -D_LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_DEBUG \
    -DLOCAL \
    -Wall \
    -Wextra \
    -Wshadow \
    -Wconversion \
    -Wfloat-equal \
    -Wshift-overflow \
    -Wformat=2 \
    -Wno-sign-conversion \
    -Wno-missing-braces \
    -ferror-limit=0 \
    -pedantic \
    -fstack-protector \
    -I/Users/nelsonhuang/Competitive-Programming-Files/include/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/ \
    -Wl,-stack_size,0x10000000 \
    $1 \
    -o \
    out/${1%.*} \
}

build_gppdebug() {
  guarantee out
  g++-14 \
    -fdiagnostics-color=always \
    -fmessage-length=0 \
    -g \
    -std=c++$2 \
    -DLOCAL \
    -Wall \
    -Wextra \
    -Wshadow \
    -Wconversion \
    -Wfloat-equal \
    -Wduplicated-cond \
    -Wlogical-op \
    -pedantic \
    -I/Users/nelsonhuang/Competitive-Programming-Files/include/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/ \
    -Wl,-stack_size,0x10000000 \
    $1 \
    -o \
    out/${1%.*} \
}

build_nosanitizers() {
  guarantee out
  clang++ \
    -fcolor-diagnostics \
    -fmessage-length=0 \
    -g \
    -std=c++$2 \
    -D_LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_FAST \
    -DLOCAL \
    -Wall \
    -Wextra \
    -Wshadow \
    -Wconversion \
    -Wfloat-equal \
    -Wshift-overflow \
    -Wformat=2 \
    -Wno-sign-conversion \
    -Wno-missing-braces \
    -ferror-limit=0 \
    -pedantic \
    -I/Users/nelsonhuang/Competitive-Programming-Files/include/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/ \
    -Wl,-stack_size,0x10000000 \
    $1 \
    -o \
    out/${1%.*} \
}

build_fast() {
  guarantee out
  g++-14 \
    -fdiagnostics-color=always \
    -fmessage-length=0 \
    -O2 \
    -std=c++$2 \
    -DLOCAL \
    -Wall \
    -Wextra \
    -Wshadow \
    -Wconversion \
    -Wfloat-equal \
    -Wduplicated-cond \
    -Wlogical-op \
    -pedantic \
    -I/Users/nelsonhuang/Competitive-Programming-Files/include/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/ \
    -Wl,-stack_size,0x10000000 \
    $1 \
    -o \
    out/${1%.*} \
}
build_nolocal() {
  guarantee out
  g++-14 \
    -fdiagnostics-color=always \
    -fmessage-length=0 \
    -O2 \
    -std=c++$2 \
    -Wall \
    -Wextra \
    -Wshadow \
    -Wconversion \
    -Wfloat-equal \
    -Wduplicated-cond \
    -Wlogical-op \
    -pedantic \
    -I/Users/nelsonhuang/Competitive-Programming-Files/include/ \
    -I/Users/nelsonhuang/Competitive-Programming-Files/ \
    -Wl,-stack_size,0x10000000 \
    $1 \
    -o \
    out/${1%.*} \
}

mdtopdf() {
  # pandoc $1 --template eisvogel -V linkcolor=blue -V header-includes:'\usepackage[export]{adjustbox} \let\includegraphicsbak\includegraphics \renewcommand*{\includegraphics}[2][]{\includegraphicsbak[frame,#1]{#2}}' -o $2
    pandoc -s -V geometry:margin=1in -V linkcolor=blue -f markdown-implicit_figures $1 -o $2
}
