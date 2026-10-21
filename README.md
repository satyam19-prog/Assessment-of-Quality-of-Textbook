# NCISM Textbook Quality Assessment Tool (Desktop Application)

> **Problem Statement #242:** Application for Assessment of Quality of Textbook / Reference Books / E-Book  
> **Domain:** Smart Education — Ministry of AYUSH & NCISM  
> **Target Platform:** Desktop Application (macOS `.dmg`)  
> **Tech Stack:** Electron.js, HTML5, CSS3, Vanilla JavaScript, Node.js

---

## 📌 Problem Overview
In the Indian Systems of Medicine (Ayurveda, Siddha, Unani - ASU), medical students often encounter substandard books falsely claiming adherence to the NCISM syllabus. To enforce high academic and medical standards, the Ministry of AYUSH constituted an expert evaluation framework based on a **3-Reviewer Multi-Blind Assessment System**.

This desktop application digitizes the assessment process, aggregates reviewer scores, validates quality thresholds, and produces a tamper-evident, standardized 1-page official assessment certificate and report.

---

## 🚀 Key Features
- **3-Reviewer Assessment Framework:** Multi-column score input for Subject Matter Expert, Clinical Practitioner, and Academic Assessor.
- **Automated Metric Averaging:** Real-time computation across 4 core dimensions:
  1. *Syllabus Coverage (1–10)*
  2. *Factual Accuracy (1–10)*
  3. *Quality of Diagrams (1–10)*
  4. *Clarity of Language (1–10)*
- **Passing Threshold Validation:** Automatically computes total aggregate out of 40 points. If $\ge 28.0$ (70.0%), the book is granted **APPROVED** status; otherwise, **REJECTED** with revision guidelines.
- **Official Committee PDF Export:** Native, pixel-perfect 1-page A4 print engine with formal Ministry of AYUSH letterhead, reference numbering, score matrix, and 4-party committee sign-off.
- **Offline & Zero Database Dependency:** Lightweight desktop MVP holding state in the DOM without external database overhead.

---

## 🛠️ Project Structure
```
Desktop_Application/
├── main.js          # Electron main process & window configuration
├── index.html       # Semantic UI (Assessment Form & Official Report)
├── styles.css       # Dark Dashboard aesthetics & strict 1-page @media print stylesheet
├── renderer.js     # Form validation, averaging formulas, UI transitions
├── package.json     # Project config & electron-builder packaging rules
└── .gitignore       # Build output and node_modules exclusions
```

---

## 💻 Installation & Local Setup

### Prerequisites
- [Node.js](https://nodejs.org/) (v18 or higher recommended)
- `npm`

### Steps
1. **Clone the repository:**
   ```bash
   git clone https://github.com/satyam19-prog/Assessment-of-Quality-of-Textbook.git
   cd Assessment-of-Quality-of-Textbook
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Launch the desktop application:**
   ```bash
   npm start
   ```

---

## 📦 Building the Executable (.dmg)

To package the desktop application into a standalone macOS installer:
```bash
npm run build:mac
```
The output `.dmg` file will be generated in the `dist/` directory.
