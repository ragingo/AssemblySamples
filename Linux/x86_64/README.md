# 開発環境

## Linux x86_64

- Windows 11 WSL2 Ubuntu20.04
- NASM 2.14.02
- peda
  - https://github.com/longld/peda

## perf コマンドのセットアップ

```sh
sudo apt install flex
git clone https://github.com/microsoft/WSL2-Linux-Kernel --depth 1
cd WSL2-Linux-Kernel/tools/perf
make -j8
sudo cp perf /usr/local/bin
```

# 動作確認

## 実行

```sh
./run.sh
```

## デバッグ実行

```sh
./debug.sh
```

## 逆アセンブル

```sh
objdump -D -M intel ./build/app
```

## パフォーマンス計測

```sh
perf stat -e cycles,instructions ./build/app
```
