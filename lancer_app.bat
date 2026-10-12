@echo off
setlocal

set "PROJECT_PYTHON=%~dp0.venv\Scripts\python.exe"
if exist "%PROJECT_PYTHON%" (
    "%PROJECT_PYTHON%" -c "import numpy, pandas, streamlit, plotly, folium" >nul 2>&1
    if errorlevel 1 (
        echo L'environnement .venv est incomplet ou bloque par Windows ; recherche d'un autre Python 3.14...
        set "PROJECT_PYTHON="
    )
) else (
    set "PROJECT_PYTHON="
)

if not defined PROJECT_PYTHON (
    where py >nul 2>&1
    if errorlevel 1 goto python_missing
    py -3.14 -c "import numpy, pandas, streamlit, plotly, folium" >nul 2>&1
    if errorlevel 1 goto dependencies_missing
    for /f "delims=" %%P in ('py -3.14 -c "import sys; print(sys.executable)"') do set "PROJECT_PYTHON=%%P"
)

pushd "%~dp0"
"%PROJECT_PYTHON%" -m streamlit run app.py
set "APP_EXIT=%ERRORLEVEL%"
popd
exit /b %APP_EXIT%

:python_missing
echo Python Launcher introuvable. Installez Python 3.14 ou configurez le lanceur py de Windows.
pause
exit /b 1

:dependencies_missing
echo Python 3.14 est absent ou ses dependances (Streamlit, NumPy, Pandas, Plotly, Folium) ne sont pas disponibles.
echo Consultez README.md pour installer les dependances du projet.
pause
exit /b 1
