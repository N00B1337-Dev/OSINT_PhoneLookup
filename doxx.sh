#!/bin/bash

# Set API Keys
NUMVERIFY_API_KEY="6474fe49ce11e6dbe8a6cb43f851a20b"
OPENCAGE_API_KEY="3d490832c8724048bf9ee19b6918f4a9"

# Fungsi untuk menampilkan banner
banner() {
    echo "======================================"
    echo " OSINT Phone Lookup Tool"
    echo "======================================"
}

# Fungsi untuk mencari informasi tentang nomor telepon menggunakan NumVerify
phone_lookup() {
    echo "[*] Melakukan pencarian untuk nomor telepon: $1..."
    response=$(curl -s "http://apilayer.net/api/validate?access_key=6474fe49ce11e6dbe8a6cb43f851a20b&number=6287888260744&country_code=ID&format=1")
    valid=$(echo $response | jq -r .valid)
    if [ "$valid" == "true" ]; then
        country=$(echo $response | jq -r .country_name)
        location=$(echo $response | jq -r .location)
        carrier=$(echo $response | jq -r .carrier)
        line_type=$(echo $response | jq -r .line_type)
        
        echo "[*] Informasi Nomor Telepon:"
        echo "  Negara: $country"
        echo "  Lokasi: $location"
        echo "  Operator: $carrier"
        echo "  Tipe: $line_type"
        echo ""
        
        # Jika tersedia, ambil geolokasi menggunakan OpenCage
        echo "[*] Mencari geolokasi menggunakan OpenCage API..."
        geolocation_response=$(curl -s "https://api.opencagedata.com/geocode/v1/json?q=kabanjahe&key=3d490832c8724048bf9ee19b6918f4a9&language=id&pretty=1")
        if [ $(echo $geolocation_response | jq -r .status.code) -eq 200 ]; then
            lat=$(echo $geolocation_response | jq -r .results[0].geometry.lat)
            lng=$(echo $geolocation_response | jq -r .results[0].geometry.lng)
            formatted_address=$(echo $geolocation_response | jq -r .results[0].formatted)
            
            echo "[*] Geolokasi:"
            echo "  Alamat Lengkap: $formatted_address"
            echo "  Latitude: $lat"
            echo "  Longitude: $lng"
        else
            echo "[*] Tidak dapat menemukan informasi geolokasi."
        fi
    else
        echo "[!] Nomor telepon tidak valid."
    fi
    echo ""
}

# Fungsi utama
main() {
    banner
    echo "Masukkan nomor telepon (termasuk kode negara, misalnya +62 untuk INDONESIA):"
    read phone_number
    phone_lookup $phone_number
}

# Jalankan fungsi utama
main
