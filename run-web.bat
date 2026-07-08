@echo off
REM M-Float AI Chatbot — Web Interface
set "SBCL=sbcl"
where sbcl >nul 2>&1
if errorlevel 1 (
  if exist "C:\Program Files\Steel Bank Common Lisp\sbcl.exe" (
    set "SBCL=C:\Program Files\Steel Bank Common Lisp\sbcl.exe"
  ) else (
    echo SBCL not found. Install from https://www.sbcl.org/
    exit /b 1
  )
)
cd /d "%~dp0src"
echo.
echo Starting M-Float AI API for the website...
echo Website: npm run dev  ^(http://localhost:8080^)
echo API:     http://localhost:8766/api/chat
echo Press Ctrl+C to stop the server.
echo.
"%SBCL%" --script main.lisp --web %*
