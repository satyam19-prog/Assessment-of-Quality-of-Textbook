/**
 * renderer.js — NCISM Textbook Assessment Logic
 * Handles score extraction, validation, averaging, pass/fail verdict,
 * report population, and seamless view toggling.
 */

/* ── Helpers ──────────────────────────────────────────────── */

/** Clamp a number input to its min/max bounds in real-time */
function clamp(input) {
  const val = parseFloat(input.value);
  const min = parseFloat(input.min);
  const max = parseFloat(input.max);
  if (!isNaN(val)) {
    if (val < min) input.value = min;
    if (val > max) input.value = max;
  }
}

/** Read a numeric field and return its float value (0 if empty/invalid) */
function getVal(id) {
  return parseFloat(document.getElementById(id).value) || 0;
}

/** Average three values, rounded to 1 decimal place */
function avg3(a, b, c) {
  return parseFloat(((a + b + c) / 3).toFixed(1));
}

/** Format a float to 1 decimal place */
function fmt(n) {
  return Number(n).toFixed(1);
}

/** Calculate percentage from a score and its maximum */
function pct(score, max) {
  return ((score / max) * 100).toFixed(0) + '%';
}

/** Set inner text safely */
function setText(id, val) {
  const el = document.getElementById(id);
  if (el) el.innerText = val;
}

/** Return formatted date e.g. "22 Oct 2026" */
function todayFormatted() {
  return new Date().toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'short',
    year: 'numeric'
  });
}

/** Generate a persistent session reference number */
let cachedRef = null;
function getReportRef() {
  if (!cachedRef) {
    const randomSuffix = Math.floor(1000 + Math.random() * 9000);
    cachedRef = `NCISM/QA/2026/${randomSuffix}`;
  }
  return cachedRef;
}

/* ── Main Logic ───────────────────────────────────────────── */

function generateReport() {
  // 1. Validate book metadata
  const title  = document.getElementById('bookTitle').value.trim();
  const author = document.getElementById('bookAuthor').value.trim();

  if (!title || !author) {
    alert('Please enter both the Book Title and Author before generating the report.');
    return;
  }

  // 2. Read individual reviewer scores
  const r1Syl = getVal('r1-syl'), r2Syl = getVal('r2-syl'), r3Syl = getVal('r3-syl');
  const r1Acc = getVal('r1-acc'), r2Acc = getVal('r2-acc'), r3Acc = getVal('r3-acc');
  const r1Dia = getVal('r1-dia'), r2Dia = getVal('r2-dia'), r3Dia = getVal('r3-dia');
  const r1Lan = getVal('r1-lan'), r2Lan = getVal('r2-lan'), r3Lan = getVal('r3-lan');

  // 3. Calculate per-metric averages
  const avgSyl = avg3(r1Syl, r2Syl, r3Syl);
  const avgAcc = avg3(r1Acc, r2Acc, r3Acc);
  const avgDia = avg3(r1Dia, r2Dia, r3Dia);
  const avgLan = avg3(r1Lan, r2Lan, r3Lan);

  // 4. Calculate total score out of 40
  const totalScore = parseFloat((avgSyl + avgAcc + avgDia + avgLan).toFixed(1));
  const totalPctVal = ((totalScore / 40) * 100).toFixed(1);

  // 5. Populate book metadata & document headers
  setText('rep-ref',    getReportRef());
  setText('rep-title',  title);
  setText('rep-author', author);
  setText('rep-isbn',   document.getElementById('bookIsbn').value.trim() || 'Not Provided');
  setText('rep-date',   todayFormatted());

  // 6. Populate individual reviewer scores in table
  setText('r1-syl-disp', fmt(r1Syl)); setText('r2-syl-disp', fmt(r2Syl)); setText('r3-syl-disp', fmt(r3Syl));
  setText('r1-acc-disp', fmt(r1Acc)); setText('r2-acc-disp', fmt(r2Acc)); setText('r3-acc-disp', fmt(r3Acc));
  setText('r1-dia-disp', fmt(r1Dia)); setText('r2-dia-disp', fmt(r2Dia)); setText('r3-dia-disp', fmt(r3Dia));
  setText('r1-lan-disp', fmt(r1Lan)); setText('r2-lan-disp', fmt(r2Lan)); setText('r3-lan-disp', fmt(r3Lan));

  // 7. Populate averages and percentage columns
  setText('avg-syl', fmt(avgSyl)); setText('pct-syl', pct(avgSyl, 10));
  setText('avg-acc', fmt(avgAcc)); setText('pct-acc', pct(avgAcc, 10));
  setText('avg-dia', fmt(avgDia)); setText('pct-dia', pct(avgDia, 10));
  setText('avg-lan', fmt(avgLan)); setText('pct-lan', pct(avgLan, 10));

  setText('avg-total', fmt(totalScore));
  setText('pct-total', totalPctVal + '%');

  // 8. Determine APPROVED / REJECTED (Threshold: 28.0 / 40 = 70.0%)
  const badge        = document.getElementById('final-badge');
  const headline     = document.getElementById('verdict-headline');
  const notes        = document.getElementById('final-notes');
  const banner       = document.getElementById('verdict-banner');

  if (totalScore >= 28.0) {
    badge.innerText    = 'APPROVED';
    badge.className    = 'badge pass';
    if (banner) banner.className = 'verdict-banner pass';
    if (headline) headline.innerText = 'Textbook Recommended for Syllabus Inclusion';
    notes.innerText    = `This textbook secured ${fmt(totalScore)} / 40.0 (${totalPctVal}%), successfully fulfilling the NCISM benchmark criteria (≥70.0%). The Expert Committee approves this edition for ASU medical institutions.`;
  } else {
    badge.innerText    = 'REJECTED';
    badge.className    = 'badge fail';
    if (banner) banner.className = 'verdict-banner fail';
    if (headline) headline.innerText = 'Quality Threshold Not Met — Revision Mandated';
    notes.innerText    = `This textbook scored ${fmt(totalScore)} / 40.0 (${totalPctVal}%), which is below the mandatory 70.0% standard (28.0 points). Significant revisions across the deficient metrics are required prior to resubmission.`;
  }

  // 9. Switch views
  document.getElementById('form-section').style.display   = 'none';
  document.getElementById('report-section').style.display = 'block';

  window.scrollTo({ top: 0, behavior: 'smooth' });
}

function resetForm() {
  document.getElementById('form-section').style.display   = 'block';
  document.getElementById('report-section').style.display = 'none';
  window.scrollTo({ top: 0, behavior: 'smooth' });
}