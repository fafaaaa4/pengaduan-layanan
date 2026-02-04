<?php
session_start();

require_once __DIR__ . "/config/config.php";
require_once __DIR__ . "/config/db.php";

$_SESSION['tipe_form'] = 'keluhan';

/* =========================
   TANGGAL & JAM SERVER (SAAT HALAMAN DIBUKA)
   (untuk tampilan saja)
   ========================= */
$serverDate_open  = date('Y-m-d'); // contoh: 2026-02-04
$serverTime_open  = date('H:i');   // contoh: 10:32

/* =========================
   PROSES SUBMIT
   ========================= */
$error_message = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

  $alamat  = trim((string)($_POST['alamat'] ?? ''));
  $no_hp   = trim((string)($_POST['no_hp'] ?? ''));
  $masukan = trim((string)($_POST['masukan'] ?? ''));

  if ($alamat === '' || $no_hp === '' || $masukan === '') {
    $error_message = "Alamat, nomor HP, dan keluhan wajib diisi.";
  } else {

    // KUNCI WAKTU SAAT SUBMIT (ANTI MANIPULASI)
    $tanggalFinal = date('Y-m-d');
    $pukulFinal   = date('H:i');

    try {
      $sql = "
        INSERT INTO keluhan (
          alamat, no_hp, masukan, pukul, tanggal
        ) VALUES (
          :alamat, :no_hp, :masukan, :pukul, :tanggal
        )
      ";

      $stmt = $pdo->prepare($sql);
      $stmt->execute([
        ':alamat'  => $alamat,
        ':no_hp'   => $no_hp,
        ':masukan' => $masukan,
        ':pukul'   => $pukulFinal,
        ':tanggal' => $tanggalFinal
      ]);

      header("Location: thank-you.php");
      exit;

    } catch (Throwable $e) {
      error_log($e->getMessage(), 3, __DIR__ . "/logs/error.log");
      $error_message = "Gagal menyimpan data ke database.";
    }
  }
}
?>

<?php
$pageTitle = "FORMULIR KELUHAN & SARAN";
include 'layout/header.php';
?>

<div class="form-container">

  <?php if (!empty($error_message)): ?>
    <div class="error-message">
      ⚠️ <?= htmlspecialchars($error_message) ?>
    </div>
  <?php endif; ?>

  <form method="POST">

    <h2 class="section-title">Identitas Pasien</h2>

    <!-- =========================
         TANGGAL & PUKUL (STYLE SAMA SEPERTI KEPUASAN)
         ========================= -->
    <div class="date-time-section" style="display:flex; gap:20px; align-items:flex-end; justify-content:space-between; flex-wrap:wrap;">

      <!-- TANGGAL -->
      <div class="input-group" style="flex:1; min-width:240px;">
        <label style="font-weight:600; margin-bottom:8px; display:block;">Tanggal *</label>

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
        <!-- hidden hanya formalitas (yang dipakai tetap waktu server saat submit) -->
        <input type="hidden" name="tanggal" value="<?= htmlspecialchars($serverDate_open) ?>">
      </div>

      <!-- PUKUL -->
      <div class="input-group" style="flex:1; min-width:240px;">
        <label style="font-weight:600; margin-bottom:8px; display:block;">Pukul *</label>

        <input
          type="text"
          value="<?= htmlspecialchars($serverTime_open . ' WIB') ?>"
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
        <input type="hidden" name="pukul" value="<?= htmlspecialchars($serverTime_open) ?>">
      </div>

    </div>

    <!-- ALAMAT -->
    <div class="form-row">
      <div class="form-field">
        <label>Alamat *</label>
        <input
          class="form-profil"
          name="alamat"
          required
          placeholder="Contoh: Jl. Merdeka No. 123"
        >
      </div>
    </div>

    <!-- NO HP -->
    <div class="form-row">
      <div class="form-field">
        <label>Nomor HP *</label>
        <input
          class="form-profil"
          type="text"
          name="no_hp"
          required
          placeholder="Contoh: 081234567890"
          inputmode="numeric"
          pattern="[0-9]{12,}"
          minlength="12"
          maxlength="15"
          oninput="this.value = this.value.replace(/[^0-9]/g, '')"
        >
      </div>
    </div>

    <h2 class="section-title">Keluhan / Saran</h2>

    <div class="form-row">
      <div class="form-field">
        <label>Uraian Keluhan / Saran *</label>
        <textarea
          name="masukan"
          required
          placeholder="Tuliskan keluhan atau saran Anda..."
        ></textarea>
      </div>
    </div>

    <button type="submit" class="submit-btn">Kirim & Selesai</button>

  </form>
</div>

<?php include 'layout/footer.php'; ?>
