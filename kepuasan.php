<?php
session_start();
require_once "config.php";

/* =========================
   FIX TIMEZONE (WIB)
   ========================= */
date_default_timezone_set('Asia/Jakarta');

/* =========================
   KONEKSI DATABASE
   ========================= */
$conn = pg_connect("host=$db_host port=$db_port dbname=$db_name user=$db_user password=$db_pass");
if (!$conn) {
  die("Koneksi PostgreSQL gagal: " . htmlspecialchars(pg_last_error()));
}

$_SESSION['tipe_form'] = 'kepuasan';

/* =========================
   LOCK SERVICE VIA URL ?service=...
   ========================= */
$allowed_services = [
  'admisi','igd','lab','farmasi','radiologi','gizi','icu','operasi','rawat_jalan',
  'rawat_inap','laboratorium'
];

// Ambil semua pelayanan dari DB untuk mapping slug -> id
$pelayanan_rows = [];
$service_slug_to_id = [];

$pelayananQ = pg_query($conn, "SELECT id, nama FROM pelayanan ORDER BY id ASC");
if (!$pelayananQ) {
  die("Gagal mengambil data pelayanan: " . htmlspecialchars(pg_last_error($conn)));
}

while ($r = pg_fetch_assoc($pelayananQ)) {
  $pelayanan_rows[] = $r;

  $nama = strtolower(trim((string)$r['nama']));
  $slug = preg_replace('/[^a-z0-9]+/', '_', $nama);
  $slug = trim($slug, '_');

  $service_slug_to_id[$slug] = (int)$r['id'];
}

// Status lock
$service_locked = false;
$service_from_url_id = null;

if (isset($_GET['service'])) {
  $candidate = strtolower(trim((string)$_GET['service']));
  if (in_array($candidate, $allowed_services, true) && isset($service_slug_to_id[$candidate])) {
    $service_locked = true;
    $service_from_url_id = (int)$service_slug_to_id[$candidate];
  }
}

/* =========================
   TANGGAL/JAM REAL TIME (SAAT HALAMAN DIBUKA)
   (TAMPILAN SAJA)
   ========================= */
$serverDate_open  = date('Y-m-d');
$serverClock_open = date('H:i'); // WIB (contoh: 10:08)

/* =========================
   AMBIL MASTER DATA
   ========================= */
$jenisKelamin = pg_query($conn, "SELECT * FROM jenis_kelamin ORDER BY id ASC");
$pendidikan   = pg_query($conn, "SELECT * FROM pendidikan ORDER BY id ASC");
$pekerjaan    = pg_query($conn, "SELECT * FROM pekerjaan ORDER BY id ASC");
$penjaminQ    = pg_query($conn, "SELECT * FROM penjamin ORDER BY id ASC");
$pertanyaanQ  = pg_query($conn, "SELECT * FROM pertanyaan ORDER BY id ASC");

if (!$jenisKelamin || !$pendidikan || !$pekerjaan || !$penjaminQ || !$pertanyaanQ) {
  die("Gagal mengambil master data: " . htmlspecialchars(pg_last_error($conn)));
}

/* =========================
   CARI ID BPJS
   ========================= */
$bpjs_id = null;
$penjamin_rows = [];
while ($row = pg_fetch_assoc($penjaminQ)) {
  $penjamin_rows[] = $row;
  if (strtoupper(trim((string)$row['nama'])) === 'BPJS') {
    $bpjs_id = (int)$row['id'];
  }
}

/* =========================
   CARI ID PERTANYAAN BIAYA/TARIF (Q4)
   ========================= */
$Q4_ID = null;
$q4Find = pg_query($conn, "
  SELECT id
  FROM pertanyaan
  WHERE LOWER(deskripsi) LIKE '%biaya%'
     OR LOWER(deskripsi) LIKE '%tarif%'
  ORDER BY id ASC
  LIMIT 1
");
if ($q4Find && ($r = pg_fetch_assoc($q4Find))) {
  $Q4_ID = (int)$r['id'];
}
if (!$Q4_ID) $Q4_ID = 4; // fallback

/* =========================
   PROSES SUBMIT
   ========================= */
$error = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

  // Kunci tanggal & jam berdasarkan server SAAT SUBMIT (bukan dari user)
  $surveyDateFinal = date('Y-m-d');
  $surveyTimeFinal = date('H:i'); // ✅ JAM SERVER REAL (WIB)

  // ========= VALIDASI DASAR =========
  $valid = true;

  $required = ['jenis_kelamin','pendidikan','pekerjaan','penjamin'];
  foreach ($required as $f) {
    if (!isset($_POST[$f]) || trim((string)$_POST[$f]) === '') {
      $valid = false;
      break;
    }
  }

  // Pelayanan: kalau locked ambil dari URL, kalau tidak locked dari POST
  if ($service_locked) {
    $pelayanan_id = (int)$service_from_url_id;
  } else {
    $pelayanan_id = isset($_POST['pelayanan']) ? (int)$_POST['pelayanan'] : 0;
    if (!$pelayanan_id) $valid = false;
  }

  $penjamin_id = isset($_POST['penjamin']) ? (int)$_POST['penjamin'] : 0;
  if (!$penjamin_id) $valid = false;

  $is_bpjs = ($bpjs_id !== null && $penjamin_id === (int)$bpjs_id);

  // ========= VALIDASI PERTANYAAN =========
  $pertanyaanIds = [];
  $tmpQ = pg_query($conn, "SELECT id FROM pertanyaan ORDER BY id ASC");
  if (!$tmpQ) {
    $valid = false;
  } else {
    while ($r = pg_fetch_assoc($tmpQ)) {
      $pertanyaanIds[] = (int)$r['id'];
    }
  }

  foreach ($pertanyaanIds as $pid) {
    $field = 'nilai' . $pid;

    if ($pid === $Q4_ID && $is_bpjs) {
      continue; // q4 tidak wajib jika BPJS
    }

    if (!isset($_POST[$field]) || (string)$_POST[$field] === '') {
      $valid = false;
      break;
    }
  }

  if (!$valid) {
    $error = "Mohon lengkapi semua isian yang wajib diisi.";
  } else {

    // ========= INSERT PROFIL =========
    $sqlProfil = "
      INSERT INTO profil (
        jenis_kelamin_id, pendidikan_id, pekerjaan_id, pelayanan_id, penjamin_id
      ) VALUES ($1, $2, $3, $4, $5)
      RETURNING id
    ";

    $resultProfil = pg_query_params($conn, $sqlProfil, [
      (int)$_POST['jenis_kelamin'],
      (int)$_POST['pendidikan'],
      (int)$_POST['pekerjaan'],
      (int)$pelayanan_id,
      (int)$penjamin_id
    ]);

    if (!$resultProfil) {
      $error = "Gagal menyimpan profil: " . pg_last_error($conn);
    } else {
      $profilRow = pg_fetch_assoc($resultProfil);
      $profil_id = (int)$profilRow['id'];

      // ========= INSERT KUISIONER =========
      foreach ($pertanyaanIds as $pid) {
        $field = 'nilai' . $pid;

        // q4: jika BPJS -> 0
        $nilai = ($pid === $Q4_ID && $is_bpjs) ? 0 : (int)$_POST[$field];

        $ins = pg_query_params($conn, "
          INSERT INTO kuisioner (
            pertanyaan_id, nilai, profil_id, survey_date, survey_time
          ) VALUES ($1, $2, $3, $4, $5)
        ", [
          (int)$pid,
          (int)$nilai,
          (int)$profil_id,
          $surveyDateFinal,
          $surveyTimeFinal
        ]);

        if (!$ins) {
          $error = "Gagal menyimpan jawaban kuisioner: " . pg_last_error($conn);
          break;
        }
      }

      if (!$error) {
        header("Location: thank-you.php");
        exit;
      }
    }
  }
}
?>

<?php
$pageTitle = "KUESIONER SURVEI KEPUASAN PASIEN";
include 'layout/header.php';
?>

<div class="form-container">
  <?php if (!empty($error)): ?>
    <div class="error-message" style="background:#fee;color:#c00;padding:15px;border-radius:8px;margin-bottom:20px;border-left:4px solid #c00;font-weight:500;">
      ⚠️ <?php echo htmlspecialchars($error); ?>
    </div>
  <?php endif; ?>

  <form method="POST" action="">

    <!-- TANGGAL & JAM TERKUNCI -->
    <div class="date-time-section" style="display:flex; gap:20px; align-items:flex-end; justify-content:space-between; flex-wrap:wrap;">
      <div class="input-group" style="flex:1; min-width:240px;">
        <label style="font-weight:600; margin-bottom:8px; display:block;">Tanggal Survei</label>
        <input
          type="text"
          value="<?= htmlspecialchars($serverDate_open) ?>"
          readonly
          style="
            width:100%;
            padding:12px 14px;
            border:1px solid rgba(0,0,0,.15);
            border-radius:10px;
            background:#f7f9fb;
            color:#111;
            font-weight:600;
            letter-spacing:.3px;
            box-shadow:0 2px 8px rgba(0,0,0,.06);
            cursor:not-allowed;
            outline:none;
          "
        >
        <input type="hidden" name="surveyDate" value="<?= htmlspecialchars($serverDate_open) ?>"> 
      </div>

      <div class="input-group" style="flex:1; min-width:240px;">
        <label style="font-weight:600; margin-bottom:8px; display:block;">Jam Survei</label>
        <input
          type="text"
          value="<?= htmlspecialchars($serverClock_open . ' WIB') ?>"
          readonly
          style="
            width:100%;
            padding:12px 14px;
            border:1px solid rgba(0,0,0,.15);
            border-radius:10px;
            background:#f7f9fb;
            color:#111;
            font-weight:600;
            letter-spacing:.3px;
            box-shadow:0 2px 8px rgba(0,0,0,.06);
            cursor:not-allowed;
            outline:none;
          "
        >
        <input type="hidden" name="surveyTime" value="<?= htmlspecialchars($serverClock_open) ?>">
      </div>
    </div>

    <h2 class="section-title">Profil Pasien</h2>
    <div class="profile-section">

      <div class="form-row">
        <div class="form-field">
          <label>Jenis Kelamin * <span style="color:#e74c3c;">(Pilih salah satu)</span></label>
          <div class="radio-group">
            <?php while ($row = pg_fetch_assoc($jenisKelamin)): ?>
              <?php
                $genderLabel = ($row['nama'] === 'L') ? 'Laki-laki' : 'Perempuan';
                $id = strtolower(str_replace(' ', '_', $genderLabel));
              ?>
              <div class="radio-option">
                <input type="radio" id="<?= $id ?>" name="jenis_kelamin" value="<?= (int)$row['id'] ?>" required>
                <label for="<?= $id ?>"><?= htmlspecialchars($genderLabel) ?></label>
              </div>
            <?php endwhile; ?>
          </div>
        </div>
      </div>

      <div class="form-row">
        <div class="form-field">
          <label>Pendidikan * <span style="color:#e74c3c;">(Pilih salah satu)</span></label>
          <div class="radio-group">
            <?php while ($row = pg_fetch_assoc($pendidikan)): ?>
              <?php $edu = (string)$row['nama']; $id = strtolower(str_replace(' ', '_', $edu)); ?>
              <div class="radio-option">
                <input type="radio" id="<?= $id ?>" name="pendidikan" value="<?= (int)$row['id'] ?>" required>
                <label for="<?= $id ?>"><?= htmlspecialchars($edu) ?></label>
              </div>
            <?php endwhile; ?>
          </div>
        </div>
      </div>

      <div class="form-row">
        <div class="form-field">
          <label>Pekerjaan * <span style="color:#e74c3c;">(Pilih salah satu)</span></label>
          <div class="radio-group">
            <?php while ($row = pg_fetch_assoc($pekerjaan)): ?>
              <?php $job = (string)$row['nama']; $id = strtolower(str_replace(' ', '_', $job)); ?>
              <div class="radio-option">
                <input type="radio" id="<?= $id ?>" name="pekerjaan" value="<?= (int)$row['id'] ?>" required>
                <label for="<?= $id ?>"><?= htmlspecialchars($job) ?></label>
              </div>
            <?php endwhile; ?>
          </div>
        </div>
      </div>

      <!-- =========================
           JENIS LAYANAN (RADIO) + LOCK
           ========================= -->
      <div class="form-row">
        <div class="form-field">
          <label>Jenis Layanan * <span style="color:#e74c3c;">(Pilih salah satu)</span></label>

          <?php if ($service_locked): ?>
            <div class="complaint-note" style="margin-top:10px;">
              Jenis layanan sudah ditentukan oleh link dan tidak bisa diubah.
            </div>
            <input type="hidden" name="pelayanan" value="<?= (int)$service_from_url_id ?>">
          <?php endif; ?>

          <div class="radio-group">
            <?php foreach ($pelayanan_rows as $row): ?>
              <?php
                $serviceName = (string)$row['nama'];
                $serviceId   = (int)$row['id'];
                $slug = preg_replace('/[^a-z0-9]+/', '_', strtolower(trim($serviceName)));
                $slug = trim($slug, '_');

                $inputId = 'svc_' . $serviceId;
                $checked = ($service_locked && $serviceId === (int)$service_from_url_id) ? 'checked' : '';
                $disabled = $service_locked ? 'disabled' : '';
                $required = $service_locked ? '' : 'required';
              ?>
              <div class="radio-option">
                <input
                  type="radio"
                  id="<?= $inputId ?>"
                  name="pelayanan"
                  value="<?= $serviceId ?>"
                  data-slug="<?= htmlspecialchars($slug) ?>"
                  <?= $checked ?>
                  <?= $disabled ?>
                  <?= $required ?>
                >
                <label for="<?= $inputId ?>"><?= htmlspecialchars($serviceName) ?></label>
              </div>
            <?php endforeach; ?>
          </div>
        </div>
      </div>

      <div class="form-row">
        <div class="form-field">
          <label>Penjamin * <span style="color:#e74c3c;">(Pilih salah satu)</span></label>
          <div class="radio-group">
            <?php foreach ($penjamin_rows as $row): ?>
              <?php
                $pjm = (string)$row['nama'];
                $pid = (int)$row['id'];
                $inputId = 'penjamin_' . $pid;
              ?>
              <div class="radio-option">
                <input type="radio" id="<?= $inputId ?>" name="penjamin" value="<?= $pid ?>" required>
                <label for="<?= $inputId ?>"><?= htmlspecialchars($pjm) ?></label>
              </div>
            <?php endforeach; ?>
          </div>
        </div>
      </div>

    </div>

    <h2 class="section-title">Pertanyaan Kepuasan Layanan</h2>
    <div class="scale-note">Skala Penilaian: 1 = Tidak Sesuai | 2 = Kurang Sesuai | 3 = Sesuai | 4 = Sangat Sesuai</div>

    <div class="questions-section">
      <?php
      $qnum = 1;
      while ($row = pg_fetch_assoc($pertanyaanQ)) {
        $pid  = (int)$row['id'];
        $desc = htmlspecialchars((string)$row['deskripsi']);
        $nilai_name = 'nilai' . $pid;
        $wrapId = ($pid === $Q4_ID) ? 'question-q4' : '';
      ?>
        <div class="question-card" <?= $wrapId ? 'id="'.$wrapId.'"' : '' ?>>
          <div class="question-text"><?= $qnum . '. ' . $desc ?></div>
          <div class="question-options">
            <?php for ($i = 1; $i <= 4; $i++): ?>
              <div class="option">
                <input type="radio" name="<?= $nilai_name ?>" value="<?= $i ?>" <?= ($pid !== $Q4_ID && $i === 1) ? 'required' : '' ?>>
                <label><?= $i ?></label>
              </div>
            <?php endfor; ?>
          </div>
        </div>
      <?php $qnum++; } ?>
    </div>

    <div class="complaint-note">Masukan Anda sangat berarti bagi kami untuk meningkatkan kualitas layanan</div>
    <button type="submit" class="submit-btn">Kirim Kuesioner</button>
  </form>
</div>

<script>
  const SERVICE_LOCKED = <?= $service_locked ? 'true' : 'false'; ?>;

  // Update URL service ketika pilih layanan (kalau tidak locked)
  if (!SERVICE_LOCKED) {
    document.querySelectorAll('input[name="pelayanan"]').forEach(radio => {
      radio.addEventListener('change', () => {
        const slug = radio.dataset.slug;
        if (!slug) return;
        const url = new URL(window.location.href);
        url.searchParams.set('service', slug);
        window.location.href = url.toString();
      });
    });
  }

  // Q4 disable untuk BPJS
  const BPJS_ID = <?= ($bpjs_id === null ? 'null' : (int)$bpjs_id) ?>;
  const q4Section = document.getElementById('question-q4');
  const q4Radios = document.querySelectorAll('input[name="nilai<?= (int)$Q4_ID ?>"]');

  function setQ4Required(isRequired) {
    if (q4Radios.length > 0) q4Radios[0].required = !!isRequired;
  }

  function disableQ4() {
    if (!q4Section) return;
    q4Section.style.opacity = '0.5';
    q4Radios.forEach(r => { r.checked = false; r.disabled = true; });
    setQ4Required(false);
  }

  function enableQ4() {
    if (!q4Section) return;
    q4Section.style.opacity = '1';
    q4Radios.forEach(r => { r.disabled = false; });
    setQ4Required(true);
  }

  function syncQ4ByPenjamin() {
    if (BPJS_ID === null) return;
    const selected = document.querySelector('input[name="penjamin"]:checked');
    if (!selected) return;
    const isBpjs = parseInt(selected.value, 10) === parseInt(BPJS_ID, 10);
    if (isBpjs) disableQ4(); else enableQ4();
  }

  document.querySelectorAll('input[name="penjamin"]').forEach(r => {
    r.addEventListener('change', syncQ4ByPenjamin);
  });

  syncQ4ByPenjamin();
</script>

<?php include 'layout/footer.php'; ?>
