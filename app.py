from flask import Flask, render_template, request, redirect, url_for, session
import psycopg2
import os

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Konfigurasi koneksi database
DATABASE_CONFIG = {
    "database": "db_lbh",
    "user": "postgres",
    "password": "ikanbakar",
    "host": "localhost",
    "port": "5432"
}

upload_folder = 'static/uploads'
if not os.path.exists(upload_folder):
    os.makedirs(upload_folder)

# Halaman LBH UTY
@app.route('/')
def lbh():
    return render_template('lbh.html', title='LBH UTY')

@app.route('/pengaduan')
def pengaduan():
    return render_template('pengaduan.html', title='Pengaduan')

@app.route('/submit_pengaduan', methods=['POST'])
def submit_pengaduan():
    if request.method == 'POST':
        nama = request.form['nama']
        jenis_kelamin = request.form['jenis_kelamin']
        tipe_identitas = request.form['tipe_identitas']
        unggah_identitas = request.files['unggah_identitas']
        alamat = request.form['alamat']
        nomor_telepon = request.form['nomor_telepon']
        email = request.form['email']
        perihal = request.form['perihal']

        # Menyimpan file unggah_identitas
        file_path = f'static/uploads/{unggah_identitas.filename}'
        unggah_identitas.save(file_path)

        try:
            # Koneksi ke database
            conn = psycopg2.connect(**DATABASE_CONFIG)
            cur = conn.cursor()

            # Untuk memasukkan data pengaduan ke dalam tabel kasus
            cur.execute("""
                INSERT INTO kasus (nama, jenis_kelamin, tipe_identitas, unggah_identitas, alamat, nomor_telepon, email, perihal)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (nama, jenis_kelamin, tipe_identitas, file_path, alamat, nomor_telepon, email, perihal))

            # Menyimpan perubahan
            conn.commit()

            # Menutup koneksi
            cur.close()
            conn.close()

            return redirect(url_for('lbh'))  # Mengarahkan kembali ke halaman utama
        except Exception as e:
            print(f"Terjadi kesalahan: {e}")
            return "Terjadi kesalahan saat mengirim pengaduan", 500

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return "No file part"
    file = request.files['file']
    
    if file.filename == '':
        return "No selected file"
    
    upload_folder = 'static/uploads'
    if not os.path.exists(upload_folder):
        os.makedirs(upload_folder)
    
    filename = file.filename
    file_path = os.path.join(upload_folder, filename)
    
    file.save(file_path)
    
    return f"File saved at {file_path}"

@app.route('/team')
def team():
    return render_template('team.html', title='Team')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        try:
            # Periksa database untuk validasi login
            conn = psycopg2.connect(**DATABASE_CONFIG)
            cur = conn.cursor()
            cur.execute('SELECT advokat_id FROM advokat WHERE username = %s AND password = %s', (username, password))
            result = cur.fetchone()
            
            if result:
                session['logged_in'] = True
                session['advokat_id'] = result[0]  # Simpan ID advokat di session
                return redirect(url_for('laporan'))
            else:
                return "Login gagal. Periksa username atau password."
        except Exception as e:
            print(f"Terjadi kesalahan: {e}")
            return "Terjadi kesalahan saat login."
    return render_template('login.html', title='Login')


@app.route('/logout')
def logout():
    session.pop('logged_in', None) 
    return redirect(url_for('lbh'))

@app.route('/laporan')
def laporan():
    try:
        # Koneksi database
        conn = psycopg2.connect(**DATABASE_CONFIG)
        cur = conn.cursor()

        # Data
        # cur.execute('SELECT * FROM kasus')
        cur.execute("""
            SELECT 
                k.kasus_id, k.nama, k.alamat, k.email, k.tanggal_pengaduan,
                COALESCE(ak.status, 'Open') AS status 
            FROM kasus k
            LEFT JOIN advokat_kasus ak ON k.kasus_id = ak.kasus_id;
        """)
        data = cur.fetchall()

        cur.close()
    except Exception as e:
        print(f"Terjadi kesalahan: {e}")
        data = []
    finally:
        # Menutup koneksi database
        if conn:
            conn.close()

    # Mengirim data ke template
    return render_template('laporan.html', title='Laporan', data=data)

@app.route('/laporan/<int:id_kasus>')
def detail_kasus(id_kasus):
    try:
        # Koneksi ke database
        conn = psycopg2.connect(**DATABASE_CONFIG)
        cur = conn.cursor()

        # Mendapatkan data detail kasus berdasarkan id
        cur.execute('SELECT * FROM kasus WHERE kasus_id = %s', (id_kasus,))
        kasus = cur.fetchone()

        cur.close()
    except Exception as e:
        print(f"Terjadi kesalahan: {e}")
        kasus = None
    finally:
        if conn:
            conn.close()

    return render_template('detail_laporan.html', title='Detail Kasus', kasus=kasus)

@app.route('/kasus')
def kasus():
    if not session.get('logged_in'):
        return redirect(url_for('login'))

    advokat_id = session['advokat_id']

    try:
        # Koneksi ke database
        conn = psycopg2.connect(**DATABASE_CONFIG)
        cur = conn.cursor()

        # Mendapatkan kasus yang ditambahkan ke advokat
        cur.execute("""
            SELECT k.* FROM kasus k
            JOIN advokat_kasus ak ON k.kasus_id = ak.kasus_id
            WHERE ak.advokat_id = %s AND ak.status = 'Assigned'
        """, (advokat_id,))
        data = cur.fetchall()

        cur.close()
    except Exception as e:
        print(f"Terjadi kesalahan: {e}")
        data = []
    finally:
        if conn:
            conn.close()

    return render_template('kasus.html', title='Kasus Saya', data=data)

@app.route('/update_status/<int:id_kasus>', methods=['POST'])
def update_status(id_kasus):
    if not session.get('logged_in'):
        return redirect(url_for('login'))

    advokat_id = session['advokat_id']
    new_status = request.form['status']

    try:
        # Koneksi ke database
        conn = psycopg2.connect(**DATABASE_CONFIG)
        cur = conn.cursor()

        # Periksa apakah kasus sudah ada di tabel advokat_kasus
        cur.execute("""
            SELECT advokat_id 
            FROM advokat_kasus 
            WHERE kasus_id = %s
        """, (id_kasus,))
        result = cur.fetchone()

        if result:
            # Jika ada record, update statusnya
            cur.execute("""
                UPDATE advokat_kasus 
                SET status = %s 
                WHERE kasus_id = %s AND advokat_id = %s
            """, (new_status, id_kasus, advokat_id))
        else:
            # Jika belum ada record, tambahkan
            cur.execute("""
                INSERT INTO advokat_kasus (advokat_id, kasus_id, status)
                VALUES (%s, %s, %s)
            """, (advokat_id, id_kasus, new_status))

        # Commit perubahan
        conn.commit()
    except Exception as e:
        print(f"Terjadi kesalahan: {e}")
    finally:
        if conn:
            conn.close()

    return redirect(url_for('laporan'))

if __name__ == '__main__':
    app.run(debug=True)
