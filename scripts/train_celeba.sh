#!/bin/bash
rm datasets/celeba -rf
mkdir datasets/celeba -p
wget -N https://www.dropbox.com/s/3e5cmqgplchz85o/CelebA_nocrop.zip?dl=0 -O datasets/celeba/celeba.zip
wget -N https://www.dropbox.com/s/auexdy98c6g7y25/list_attr_celeba.zip?dl=0 -O datasets/celeba/list_attr_celeba.zip
unzip datasets/celeba/celeba.zip -d datasets/celeba
unzip datasets/celeba/list_attr_celeba.zip -d datasets/celeba
rm -v datasets/celeba/celeba.zip
rm -v datasets/celeba/list_attr_celeba.zip
mv datasets/celeba/CelebA_nocrop/images datasets/celeba/images
mkdir datasets/celeba/trainA -p
mkdir datasets/celeba/trainB -p
mkdir datasets/celeba/testA -p
mkdir datasets/celeba/testB -p
awk 'NR>2 && $11 == 1 { print $1 }' datasets/celeba/list_attr_celeba.txt > datasets/celeba/list_blond_hair.txt
awk 'NR>2 && $10 == 1 { print $1 }' datasets/celeba/list_attr_celeba.txt > datasets/celeba/list_black_hair.txt
NUM_IMAGES=$( cat datasets/celeba/list_blond_hair.txt | wc -l )
NUM_TESTS=200
shuf -n $NUM_IMAGES datasets/celeba/list_blond_hair.txt > datasets/celeba/list_attr_celeba.txt
mv datasets/celeba/shuffled.txt datasets/celeba/list_blond_hair.txt
shuf -n $NUM_IMAGES datasets/celeba/list_black_hair.txt > datasets/celeba/list_attr_celeba.txt
mv datasets/celeba/shuffled.txt datasets/celeba/list_black_hair.txt
head -n -$NUM_TESTS datasets/celeba/list_blond_hair.txt | xargs -I % mv -v datasets/celeba/images/% datasets/celeba/trainA/
head -n -$NUM_TESTS datasets/celeba/list_black_hair.txt | xargs -I % mv -v datasets/celeba/images/% datasets/celeba/trainB/
tail -n $NUM_TESTS datasets/celeba/list_blond_hair.txt | xargs -I % mv -v datasets/celeba/images/% datasets/celeba/testA/
tail -n $NUM_TESTS datasets/celeba/list_black_hair.txt | xargs -I % mv -v datasets/celeba/images/% datasets/celeba/testB/
rm datasets/celeba/CelebA_nocrop -rf
rm datasets/celeba/images -rf
rm datasets/celeba/list_blond_hair.txt
rm datasets/celeba/list_black_hair.txt
