# Setup guide — macOS (Apple Silicon) · Conda · VS Code

Everything below is typed in the **Terminal** app (Cmd + Space → "Terminal").
You can open the Terminal anywhere. The only step that needs the project folder is step 6.

---

## 1. Python environment (Conda)

```bash
conda create -n quant-risk python=3.12 -y
conda activate quant-risk
```

If you see `conda: command not found`, run `~/anaconda3/bin/conda init zsh`, close the Terminal, open it again and repeat.

## 2. Project packages

```bash
conda activate quant-risk
conda install -c conda-forge ecos -y
cd "/Users/davico/Main/Projects/ML - DL/FIN"
pip install -r requirements.txt
```

- **Why `ecos` first?** `scikit-survival` (used in the survival-analysis projects) depends on it, and PyPI has no ready-made Apple Silicon version. The conda-forge build installs in seconds.
- The full install downloads a few GB (PyTorch, transformers, etc.) and takes 5–15 minutes.

## 3. Register the environment as a Jupyter kernel

```bash
python -m ipykernel install --user --name quant-risk --display-name "Python (quant-risk)"
```

## 4. Credentials

**FRED + SEC + news APIs** → file `.env` in the project root. Use `.env.example` as the template:
```
FRED_API_KEY=your_32_character_fred_key
SEC_USER_AGENT=Your Name your.email@example.com
NYT_API_KEY=your_nyt_key            # only for the news-based projects
GUARDIAN_API_KEY=your_guardian_key  # only for the news-based projects
```
Write each line as `KEY=value`, with no spaces around `=` and no quotes.

**Kaggle** → in Kaggle go to *Settings → API → Create New Token*, then run the command Kaggle shows:
```bash
mkdir -p ~/.kaggle && echo YOUR_TOKEN > ~/.kaggle/access_token && chmod 600 ~/.kaggle/access_token
```
Never paste the token anywhere else.

## 5. VS Code

1. Install the extensions **Python** and **Jupyter** (Microsoft). Add **R** (REditorSupport) for the R block.
2. *File → Open Folder* → the project folder.
3. Open a notebook → **Select Kernel** (top right) → **Python (quant-risk)**.

## 6. Check every data source

Open `00_connection_check.ipynb` and run all cells (**Run All**). You get a ✅ / ❌ table with the fix for anything that fails.

---

## 7. R (only needed for the projects written in R)

1. Download the **arm64** installer from https://cran.r-project.org/bin/macosx/ (`R-4.x.x-arm64.pkg`) and install it.
2. From the project folder:
   ```bash
   conda activate quant-risk
   Rscript install_packages.R
   ```
   This installs the R packages and registers the **R** kernel for Jupyter.
3. Check that both kernels are there:
   ```bash
   jupyter kernelspec list
   ```
   You should see `quant-risk` and `ir`.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `pip` fails building `ecos` | Run `conda install -c conda-forge ecos -y` first, then repeat `pip install -r requirements.txt`. |
| Kaggle returns `403 Forbidden` | Open the competition page on kaggle.com and accept its rules. |
| Kaggle says it can't find credentials | The token file must be exactly `~/.kaggle/access_token`. |
| FRED returns `Bad Request` | Check `FRED_API_KEY` in `.env` (32 characters, no quotes or spaces). |
| SEC returns `403` | `SEC_USER_AGENT` must contain a name and a real email. |
| Yahoo Finance returns empty data | Yahoo throttles at times. Wait a minute and rerun; notebooks cache what they download. |
| Plotly static image export fails | `kaleido` uses Google Chrome. Make sure Chrome is installed. |
