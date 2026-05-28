#!/bin/bash
# Yusuf AKDEMIR
# 2420171019
# https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=BozfxjWneX
# https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=lK1hwqEXbq
# https://credsverse.com/credentials/8ea58af3-0c21-4dd9-9f59-94566740db42

LOG_FILE="report.log"

if [ -f "$LOG_FILE" ]; then
    rm -f "$LOG_FILE"
fi

echo "=========================================" >> "$LOG_FILE"
echo "Script Baslangic Zamani (ISO 8601): $(date -Iseconds)" >> "$LOG_FILE"
echo "=========================================" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "########## DONANIM BILGILERI ##########" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "----- ISLEMCI (CPU) BILGISI -----" >> "$LOG_FILE"
wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed /format:list >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "----- RAM BILGISI -----" >> "$LOG_FILE"
wmic memorychip get Capacity,Manufacturer,Speed,PartNumber /format:list >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "----- ANAKART BILGISI -----" >> "$LOG_FILE"
wmic baseboard get Manufacturer,Product,SerialNumber,Version /format:list >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "----- DISK BILGISI -----" >> "$LOG_FILE"
wmic diskdrive get Model,SerialNumber,Size,InterfaceType /format:list >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "----- SISTEM UUID -----" >> "$LOG_FILE"
wmic csproduct get UUID,Name,Vendor /format:list >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "----- MAC ADRES BILGISI -----" >> "$LOG_FILE"
getmac /v /fo list >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE"

echo "########## DONANIM BILGILERI SONU ##########" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "Lutfen sifreleme icin parolayi giriniz (Beklenen: MYO+202):"
read -s -p "Parola: " PAROLA
echo ""
echo ""

if [ "$PAROLA" != "MYO+202" ]; then
    echo "UYARI: Beklenen parola girilmedi, yine de bu parola ile devam ediliyor..."
fi

echo "report.log dosyasi AES256 ile sifreleniyor..."

gpg --batch --yes --passphrase "$PAROLA" \
    --symmetric --cipher-algo AES256 \
    --output "${LOG_FILE}.gpg" "$LOG_FILE"

if [ -f "${LOG_FILE}.gpg" ]; then
    rm -f "$LOG_FILE"
    echo "Sifreleme tamamlandi: ${LOG_FILE}.gpg olusturuldu."
    echo "Orijinal ${LOG_FILE} dosyasi silindi."
else
    echo "HATA: Sifreleme basarisiz oldu. Orijinal dosya korundu."
    exit 1
fi

echo ""
echo "Islem basariyla tamamlandi."
exit 0
