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
awk 'NR>2 && ($10 != 1 && $11 == 1 && $13 != 1) { print $1 }' datasets/celeba/list_attr_celeba.txt > datasets/celeba/list_blond.txt
awk 'NR>2 && ($10 == 1 && $11 != 1 && $13 != 1) { print $1 }' datasets/celeba/list_attr_celeba.txt > datasets/celeba/list_black.txt
awk -F. '$1 <= 10000 { print }' datasets/celeba/list_blond.txt | xargs -I % mv -v datasets/celeba/images/% datasets/celeba/testA/
awk -F. '$1 <= 10000 { print }' datasets/celeba/list_black.txt | xargs -I % mv -v datasets/celeba/images/% datasets/celeba/testB/
awk -F. '$1 > 10000 { print }' datasets/celeba/list_blond.txt | shuf | xargs -I % mv -v datasets/celeba/images/% datasets/celeba/trainA/
awk -F. '$1 > 10000 { print }' datasets/celeba/list_black.txt | shuf | xargs -I % mv -v datasets/celeba/images/% datasets/celeba/trainB/
rm datasets/celeba/CelebA_nocrop -rf
rm datasets/celeba/images -rf
rm datasets/celeba/list_blond.txt
rm datasets/celeba/list_black.txt
python train.py --config configs/celeba_folder.yaml
