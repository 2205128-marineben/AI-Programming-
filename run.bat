@echo off
REM M-Float AI Chatbot launcher (requires SBCL)
set "SBCL=sbcl"
where sbcl >nul 2>&1
if errorlevel 1 (
  if exist "C:\Program Files\Steel Bank Common Lisp\sbcl.exe" (
    set "SBCL=C:\Program Files\Steel Bank Common Lisp\sbcl.exe"
  ) else (
    echo SBCL not found. Install from https://www.sbcl.org/ or restart your terminal after installing.
    exit /b 1
  )
)
cd /d "%~dp0src"
"%SBCL%" --script main.lisp %*
