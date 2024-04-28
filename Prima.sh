#!/bin/bash

# Membaca input bilangan dari pengguna
read -p "Masukkan bilangan: " bilangan

# Mengecek apakah bilangan kurang dari 2
if [ $bilangan -lt 2 ]; then
    echo "$bilangan bukan bilangan prima"
    exit
fi

# Inisialisasi variabel untuk menandai apakah bilangan adalah prima
is_prima=1

# Loop untuk memeriksa pembagi bilangan dari 2 hingga bilangan - 1
for (( i = 2; i < $bilangan; i++ )); do
    if (( $bilangan % $i == 0 )); then
        is_prima=0  # Set is_prima menjadi 0 jika ditemukan pembagi selain 1 dan bilangan itu sendiri
        break
    fi
done

# Menampilkan hasil
if [ $is_prima -eq 1 ]; then
    echo "$bilangan adalah bilangan prima"
else
    echo "$bilangan bukan bilangan prima"
fi
