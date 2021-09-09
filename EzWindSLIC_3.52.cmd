<!-- : Begin batch script
@echo off
color 0f
setlocal EnableDelayedExpansion
:: Fix for special characters in file name by @abbodi1406
setlocal DisableDelayedExpansion
set "work=%~dp0"
if [%work:~-1%]==[\] set "work=%work:~0,-1%"
setlocal EnableDelayedExpansion
pushd "!work!"
%systemroot%\system32\fsutil.exe dirty query %systemdrive% >nul 2>&1 || (
    %systemroot%\System32\cscript.exe //nologo "%~nx0?.wsf" //job:ELAV /File:"!work!\%~nx0"
    exit /b
)
set "_path=!work!"
set "uiver=3.52"
title EzWindSLIC %uiver% by Exe Csrss
echo:
mode con cols=83 lines=30
:: Detect switches
set "install="
set "uninstall="
set "silent="
set "force="
set "insert="
set "norestart="
for /f "usebackq tokens=1-5 delims=-/ " %%A in ('%*') do (
    set "%%A=1" 2>nul
    set "%%B=1" 2>nul
    set "%%C=1" 2>nul
    set "%%D=1" 2>nul
    set "%%E=1" 2>nul
)
if defined force set "insert="
for %%# in (powershell.exe) do if [%%~$PATH:#]==[] if not exist "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" (
    echo ERROR:
    echo PowerShell is not installed in your system.
    echo Install PowerShell and run this script again.
    echo Press any key to exit...
    pause >nul
    exit /b
)
for %%# in (powershell.exe) do if not [%%~$PATH:#]==[] (
   set "_psc="%%~$PATH:#" -nop -c"
   set "_ps=%%~$PATH:#"
)
if not defined _psc (
   set "_psc="%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -nop -c"
   set "_ps=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
)
:: Set buffer height
%_psc% "&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.height=250;$W.buffersize=$B;}"
:: Declare some variables for convenience
set "red=0c"
set "green=0a"
set "_csc=%systemroot%\System32\cscript.exe //nologo"
set "_slm=%_csc% %systemroot%\System32\slmgr.vbs"
set "_nul=1>nul 2>nul"
set "_eline=call :colortxt %red% ERROR: /n"
set "_bcd=%systemroot%\System32\bcdedit.exe"
set "_pak=echo Press any key to exit... & pause %_nul% & goto exit"
set "_wmi=%systemroot%\System32\wbem\wmic.exe"
set "_reb=%systemroot%\System32\shutdown.exe -r -t 00 %_nul%"
set "_sht=%systemroot%\System32\shutdown.exe -s -t 00 %_nul%"
set "_slp=SoftwareLicensingProduct"
set "_sls=SoftwareLicensingService"
set "_wApp=55c92734-d682-4d71-983e-d6ec3f16059f"
if defined silent set "_pak=goto exit"
if defined norestart set "_reb=echo You selected no restart option. Windows will not be rebooted"
if not exist "!work!\bin" (
    %_eline%
    echo 'bin' folder is missing.
    echo Most likely you ran this script directly from your archiving software instead of extracting.
    %_pak%
)
call :chkvalues
if defined install (
    call :install 
    goto exit
)
if defined uninstall (
    call :uninstall 
    goto exit
)
:mainmenu
cls
if not defined install if not defined uninstall (
echo:
echo:
echo:
echo EzWindSLIC %uiver% by Exe Csrss
echo          _______________________________________________________________
echo         ^| Installation options:                                         ^|
echo         ^|                          [I] Install                          ^|
echo         ^|                                                               ^|
echo         ^|                         [U] Uninstall                         ^|
echo         ^|_______________________________________________________________^|
echo         ^| Help and support:                                             ^|
echo         ^|                          [R] Read-me                          ^|
echo         ^|                                                               ^|
echo         ^|                   [S] Support thread on MDL                   ^|
echo         ^|                                                               ^|
echo         ^|                        [G] Github repo                        ^|
echo         ^|_______________________________________________________________^|
echo         ^| Configuration:                                                ^|
if defined force (
call :colortxt 0f "        |"
call :colortxt 0e "                    [F] Forceful mode: [On]                    "
call :colortxt 0f "|" /n
) else (
echo         ^|                    [F] Forceful mode: [Off]                   ^|
)
echo         ^|_______________________________________________________________^|
echo         ^| Miscellaneous:                                                ^|
echo         ^|                 [D] Display Activation Status                 ^|
echo         ^|                                                               ^|
echo         ^|                    [C] Create $OEM$ Folder                    ^|
echo         ^|_______________________________________________________________^|
echo:
set "_errtemp="
choice /c iursgfdce /n /m "Enter your choice, or press E to exit: "
set _errtemp=!errorlevel!
if /i [!_errtemp!]==[1] call :install
if /i [!_errtemp!]==[2] call :uninstall
if /i [!_errtemp!]==[3] start "%systemroot%\notepad.exe" "!work!\bin\readme.txt"
if /i [!_errtemp!]==[4] start "" https://forums.mydigitallife.net/threads/tool-ezwindslic-easily-activate-windows-7-vista-server-2008-2019-on-uefi-gpt.83357/
if /i [!_errtemp!]==[5] start "" https://www.github.com/ExeCsrss/EzWindSLIC
if /i [!_errtemp!]==[6] call :toggleforce
if /i [!_errtemp!]==[7] call :dispstat2usr
if /i [!_errtemp!]==[8] call :createoem
if /i [!_errtemp!]==[9] goto exit
) else exit /b
goto mainmenu
:toggleforce
if defined force (
set "force="
) else (
set "force=1
)
exit /b
:install
cls
set "_missingfiles="
for %%# in (WindSLIC.efi fallbackkeys.ini keys.ini acpidump.exe key.txt sku.ini translate.ini grkeys.ini readme.txt) do (if not exist "!work!\bin\%%#" (if defined _missingfiles (set "_missingfiles=!_missingfiles!, %%#") else (set "_missingfiles=%%#")))
if defined _missingfiles (
    %_eline%
    echo The following required files are missing from 'bin' folder:
    echo %_missingfiles%
    %_pak%
)
set "_slictobeinstalled=DELL"
call :chkvalues
call :dispstat
if /i [%LicenseStatus%]==[1] if /i [%GracePeriodRemaining%]==[0] (
    call :colortxt %green% "Windows is already permanently activated." /n
    echo Running this script is unnecessary.
    if defined silent goto exit
    set "_errtemp="
    echo Choose an option:
    echo [C]ontinue
    echo [E]xit
    choice /c ce /n /m "Enter your choice: "
    set _errtemp=!errorlevel!
    if /i [!_errtemp!]==[2] (
        goto mainmenu
    )
)
%_bcd% -enum {current} | find /i ".efi" %_nul% || (
    %_eline%
    echo Your system is booted into BIOS/MBR mode.
    echo Use alternative activation exploits to activate.
    %_pak%
)
if not [%PROCESSOR_ARCHITECTURE%]==[AMD64] (
    %_eline%
    echo Your OS architecture is not AMD64.
    echo Install 64-bit Windows and try again.
    %_pak%
)
if defined _secuboot (
    %_eline%
    echo Secure boot is enabled.
    echo Disable it and then run the script again.
    %_pak%
)
for /f "usebackq eol=; delims=" %%# in ("!work!\bin\fallbackkeys.ini") do for /f "tokens=1-4 delims=:" %%A in ("%%#") do if /i [%osver%]==[%%A] if /i [%ostype%]==[%%B] if /i [%osedition%]==[%%C] set "key=%%D"
for %%# in (
    10.0:14393:Server:ServerStandard:2499N-BCGX3-FHJKF-DH9QR-8B63W
    10.0:14393:Server:ServerStorageStandard:26K68-7NBHG-XQGQG-KYYCJ-QDCGG 
    10.0:17763:Server:ServerStandard:26DHC-DN92M-DQ9YQ-4M6YJ-GVMMH
    10.0:17763:Server:ServerDatacenter:8PNQX-RF873-CXRPY-8J42B-XBWWC
    10.0:20348:Server:ServerStandard:T7DWT-NQPJX-XX62J-YG93D-49FQR
    10.0:20348:Server:ServerDatacenter:V86NK-D94TF-QXPM9-W9FRT-4M8D9
) do for /f "tokens=1-5 delims=:" %%A in ("%%#") do if /i [%osver%]==[%%A] if /i [%osbuild%]==[%%B] if /i [%ostype%]==[%%C] if /i [%osedition%]==[%%D] set "key=%%E"
echo:
if not defined key (
    %_eline%
    echo Your OS isn't supported.
    echo Please use alternative activation exploits.
    %_pak%
)
call :mntesp
if exist "%_ltr%\EFI\WindSLIC" (
    echo WindSLIC is already installed.
    echo If you are facing trouble activating your OS, choose the Uninstall option to uninstall WindSLIC before trying again.
    %_pak%
)
if defined _slicexist (
    for %%# in (
        6.0:0
        6.1:1
        6.2:2
        6.3:3
    ) do for /f "tokens=1-2 delims=:" %%A in ("%%#") do if /i [!osver!]==[%%A] set "_expctslicveroffst=%%B"
    for %%# in (
        10.0:14393:4
        10.0:17763:5
        10.0:20348:6
    ) do for /f "tokens=1-3 delims=:" %%A in ("%%#") do if /i [!osver!]==[%%A] if /i [!osbuild!]==[%%B] set "_expctslicveroffst=%%C"
    if /i !_slicveroffset! GEQ !_expctslicveroffst! if exist "!work!\bin\!_detectedslicver!\!_slicvendor!\cert.xrm-ms" if not defined force call :insert & exit /b
)
if defined _slicexist if not exist "!work!\bin\!_detectedslicver!\!_slicvendor!\cert.xrm-ms" if not defined force (
    %_eline%
    echo SLIC found, but there is no certificate present for it.
    %_pak%
)
if defined _slicexist if exist "!work!\bin\!_detectedslicver!\!_slicvendor!\cert.xrm-ms" if !_slicveroffset! LSS !_expctslicveroffst! if not defined force (
    %_eline%
    echo SLIC found, but SLIC version is too low.
    %_pak%
)
for %%# in (
    6.0:2.0
    6.1:2.1
    6.2:2.2
    6.3:2.3
) do for /f "tokens=1-2 delims=:" %%A in ("%%#") do if /i [%osver%]==[%%A] set "_slicvertobeinstalled=%%B"
for %%# in (
    10.0:14393:2.4
    10.0:17763:2.5
    10.0:20348:2.6
) do for /f "tokens=1-3 delims=:" %%A in ("%%#") do if /i [%osver%]==[%%A] if /i [%osbuild%]==[%%B] set "_slicvertobeinstalled=%%C"
if not defined _slicvertobeinstalled (
    %_eline%
    echo Your OS isn't supported.
    echo Please use alternative activation exploits.
    %_pak%
)
if exist "!work!\bin\%_slicvertobeinstalled%\%_facp%\slic.bin" if exist "!work!\bin\%_slicvertobeinstalled%\%_facp%\cert.xrm-ms" set "_slictobeinstalled=%_facp%"
echo:
echo The following profile will be installed: [%_slictobeinstalled%]
if not defined silent (
    set "_errtemp="
    echo Choose an option:
    echo [U]se this profile
    echo [C]hoose another profile
    choice /c uc /n /m "Enter your choice: "
    set "_errtemp=!errorlevel!"
    if [!_errtemp!]==[2] call :askslic
)
set "_slictobeinstalledcompany=%_slictobeinstalled%"
for /f "usebackq eol=;" %%# in ("!work!\bin\translate.ini") do for /f "tokens=1-2 eol=; delims=:" %%A in ("%%#") do if /i [%_slictobeinstalled%]==[%%A] set _slictobeinstalledcompany=%%B
if not [%_channel%]==[OEM_SLP] call :instkey
echo Installing certificate...
%_slm% -ilc "!work!\bin\%_slicvertobeinstalled%\%_slictobeinstalled%\cert.xrm-ms"
echo:
echo Copying files...
md %_ltr%\EFI\WindSLIC %_nul%
copy /y "!work!\bin\WindSLIC.efi" %_ltr%\EFI\WindSLIC %_nul%
copy /y "!work!\bin\%_slicvertobeinstalled%\%_slictobeinstalled%\slic.BIN" %_ltr%\EFI\WindSLIC %_nul%
copy /y "!work!\bin\key.txt" %_ltr%\EFI\WindSLIC %_nul%
echo:
echo Installing bootloader...
%_bcd% /store "%_ltr%\EFI\Microsoft\Boot\BCD" /set {bootmgr} PATH \EFI\WindSLIC\WindSLIC.efi %_nul%
%_bcd% /set {bootmgr} PATH \EFI\WindSLIC\WindSLIC.efi
if defined silent %_reb% & goto exit
if defined norestart goto exit
echo:
echo [R]eboot
echo [S]hutdown
echo [E]xit
set "_errtemp="
choice /c rse /n /m "Enter your choice: "
set "_errtemp=!errorlevel!"
if /i [!_errtemp!]==[1] %_reb%
if /i [!_errtemp!]==[2] %_sht%
if /i [!_errtemp!]==[3] goto mainmenu
exit /b

:uninstall
cls
call :dispstat
call :mntesp
if not exist "%_ltr%\EFI\WindSLIC" (
    echo WindSLIC is not installed.
    %_pak%
)
for /f "usebackq eol=; delims=" %%# in ("!work!\bin\grkeys.ini") do for /f "tokens=1-4 delims=:" %%A in ("%%#") do if /i [%osver%]==[%%A] if /i [%ostype%]==[%%B] if /i [%osedition%]==[%%C] set "grkey=%%D"
if defined grkey (
    echo Installing generic key [!grkey!]...
    %_wmi% path %_sls% where __CLASS='%_sls%' call InstallProductKey ProductKey="!grkey!" %_nul% && (
    call :colortxt %green% "Successful" /n
    %_wmi% path %_sls% where __CLASS='%_sls%' call RefreshLicenseStatus %_nul%
    ) || (
    call :colortxt %red% "Unsuccessful" /n
    )
)
echo Uninstalling bootloader...
%_bcd% /store "%_ltr%\EFI\Microsoft\Boot\BCD" /set {bootmgr} PATH \EFI\Microsoft\Boot\bootmgfw.efi %_nul%
%_bcd% /set {bootmgr} PATH \EFI\Microsoft\Boot\bootmgfw.efi
echo Removing WindSLIC...
rd %_ltr%\EFI\WindSLIC /s /q %_nul%
if defined silent %_reb% & goto exit
if defined norestart goto exit
echo:
echo [R]eboot
echo [S]hutdown
echo [E]xit
set "_errtemp="
choice /c rse /n /m "Enter your choice: "
set "_errtemp=!errorlevel!"
if /i [!_errtemp!]==[1] %_reb%
if /i [!_errtemp!]==[2] %_sht%
if /i [!_errtemp!]==[3] goto mainmenu
exit /b

:dispstat2usr
call :dispstat
%_pak%

:createoem
cls
if exist "!_path!\$OEM$" (
    %_eline%
    echo $OEM$ folder already exists in the current directory.
    %_pak%
)
md "!_path!\$OEM$\$$\Setup\Scripts\bin" %_nul%
copy "!work!\bin" "!_path!\$OEM$\$$\Setup\Scripts\bin" %_nul%
copy "!work!\%~nx0" "!_path!\$OEM$\$$\Setup\Scripts" %_nul%
copy "!work!\bin\setupcomplete.cmd" "!_path!\$OEM$\$$\Setup\Scripts" %_nul%

if not exist "!_path!\$OEM$" (
    %_eline%
    echo Failed creating $OEM$ folder.
) else (
    echo $OEM$ was successfully created in the current directory.
    echo You can place the folder in the "sources" directory of Windows installation media/ISO to pre-activate.
)
%_pak%

:insert
echo:
set "_slictobeinstalledcompany=%_slicvendor%"
for /f "usebackq eol=;" %%# in ("!work!\bin\translate.ini") do for /f "tokens=1-2 eol=; delims=:" %%A in ("%%#") do if /i [%_slicvendor%]==[%%A] set _slictobeinstalledcompany=%%B
echo Installing certificate...
%_slm% -ilc "!work!\bin\%_detectedslicver%\%_slicvendor%\cert.xrm-ms"
call :instkey
echo Activating...
wmic path %_slp% where "ApplicationID='%_wApp%' and PartialProductKey<>null" call Activate %_nul%
wmic path %_slp% where (LicenseStatus='1' and GracePeriodRemaining='0' and PartialProductKey is not NULL) get Name 2>nul | findstr /i "Windows" 1>nul && (
    call :colortxt %green% "Product activation successful." /n
) || (
    call :colortxt %red% "Product activation failed." /n
)
%_pak%

:dispstat
cls
echo Operating System: [%fullosname%]
echo OS Version: [%osver%]
echo OS Type: [%ostype%]
echo Architecture: [%PROCESSOR_ARCHITECTURE%]
echo OS Edition: [%osedition%]
echo OS Build: [%osbuildstr%]
if defined _channel echo Channel: [%_channel%]
call :colortxt 0f "License Status: ["
call :colortxt %_clr% "%_licstat%"
echo ]
if not [%LicenseStatusReason%]==[0] (
echo License Status Reason: [%_licreas%]
)
if defined _licstatmsg echo %_licstatmsg:}= %.
if not [%GracePeriodRemaining%]==[0] (
if not [%LicenseStatus%]==[1] (
echo Grace Period Remaining: [%GracePeriodRemaining% minute^(s^)/%_gprdays% day^(s^)]
) else (
echo Activation Expiration: [%GracePeriodRemaining% minute^(s^)/%_gprdays% day^(s^)]
)
)
echo SKU Value: [%OperatingSystemSKU%]
echo Partial Product Key: [%_ppk%]
if [%_eval%]==[1] (
echo Evaluation: [Yes]
) else (
    echo Evaluation: [No]
)
if defined _slicexist echo SLIC: [%_slicvendor% - v%_detectedslicver%]
echo Motherboard: [%_mobo%]
if defined _secuboot (
    call :colortxt 0f "Secure Boot: ["
    call :colortxt 0c "Enabled"
    echo ]
)
echo:
exit /b

:chkvalues
:: Detect OS version
for /f "tokens=4,5 delims=[]. " %%G in ('ver') do set osver=%%G.%%H
:: Detect OS build
for /f "tokens=6 delims=[]. " %%L in ('ver') do set osbuild=%%L
if %osbuild% LSS 6000 (
    %_eline%
    echo You must be running minimum Windows Vista {build 6000} or Server 2008 RTM {build 6001} to use this script.
    %_pak%
)
:: Detect if SLIC is already present (thanks to @Tito for great tip)
"!work!\bin\acpidump.exe" -s 2>nul | find /i "ACPI: SLIC" %_nul% && set _slicexist=1
cd /d "!work!\bin"
if defined _slicexist (
    for /f "usebackq tokens=6 delims=(): " %%A in (`acpidump.exe -s 2^>nul ^| find "ACPI: SLIC"`) do set _slicvendor=%%A
)
if defined _slicexist (
    for /f "tokens=4 delims=: " %%A in ('acpidump.exe -n SLIC 2^>nul ^| find /i "00E0:"') do set _slicveroffset=%%A
    set _detectedslicver=2.!_slicveroffset:~-1!
)
for /f "usebackq tokens=6 delims=(): " %%A in (`acpidump.exe -s 2^>nul ^| find "ACPI: FACP"`) do set _facp=%%A
if /i [%_facp%]==[MSI] set "_facp=MSI_NB"
:: Detect OS edition
for /f "skip=2 tokens=2*" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID 2^>nul') do set "oseditionreg=%%H"
:: Detect OS name
for /f "skip=2 tokens=2*" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul') do set "fullosname=%%H"
:: Detect full build string
for /f "skip=2 tokens=2*" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v BuildLabEx 2^>nul') do set "osbuildstr=%%H"
:: Detect OS type by @abbodi1406
if exist "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*Edition~*.mum" (
set ostype=Server
)
if not defined ostype set ostype=Client
:: Check if OS is evaluation by @abbodi1406
if exist "%SystemRoot%\Servicing\Packages\Microsoft-Windows-*EvalEdition~*.mum" (
set _eval=1
)
if exist "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*EvalEdition~*.mum" (
set _eval=1
)
if exist "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*EvalCorEdition~*.mum" (
set _eval=1
)
(for /f "tokens=2 delims==" %%# in ('"wmic path %_slp% where (ApplicationID='%_wApp%' and PartialProductKey is not null) get ID /value"') do set ID=%%#) %_nul%
if not defined ID (
    set "LicenseStatus=0"
    set "PartialProductKey=N/A"
    set "_ppk=N/A"
    set "LicenseStatusReason=3221549076"
    set "GracePeriodRemaining=0"
    set "Description=N/A"
)
for %%# in (LicenseStatus PartialProductKey LicenseStatusReason GracePeriodRemaining Description) do (
if not defined %%# (
for /f "tokens=* delims=" %%a in ('"wmic path %_slp% where (ID='%ID%') get %%# /value" 2^>nul ^| findstr ^=') do set "%%a"
)
)
for /f "tokens=* delims=" %%a in ('"wmic os get OperatingSystemSKU /value" 2^>nul ^| findstr ^=') do set "%%a"
for /f "tokens=* delims=" %%a in ('"wmic os get Caption /value" 2^>nul ^| findstr ^=') do set "%%a"
if defined Caption set "fullosname=%Caption%"
if %osbuild% LSS 7600 (
    set "fullosname=!fullosname:Microsoftr=Microsoft!"
    set "fullosname=!fullosname:VistaT=Vista!"
    set "fullosname=!fullosname:Serverr=Server!"
)
set "space= "
if [!fullosname:~-1!]==[!space!] set "fullosname=!fullosname:~0,-1!"
for /f "usebackq eol=; delims=" %%# in ("!work!\bin\sku.ini") do for /f "tokens=1-2 delims=:" %%A in ("%%#") do if /i [%OperatingSystemSKU%]==[%%A] set "osedition=%%B"
if %osbuild% LSS 7600 if /i [%OperatingSystemSKU%]==[33] set "osedition=ServerSBSPrime"
for /f "delims=" %%# in ('dir /b %systemroot%\System32\??-??') do if exist "%systemroot%\System32\%%#\Licenses\_Default" set "locale=%%#"
if [%LicenseStatus%]==[0] (
set "_licstat=Unlicensed"
set "_clr=0c"
)
if [%LicenseStatus%]==[1] (
set "_licstat=Licensed"
set "_clr=0a"
)
if [%LicenseStatus%]==[2] (
set "_licstat=Initial grace period"
set "_clr=0e"
)
if [%LicenseStatus%]==[3] (
set "_licstat=Additional grace period"
set "_clr=0e"
)
if [%LicenseStatus%]==[4] (
set "_licstat=Non-genuine grace period"
set "_clr=0e"
)
if [%LicenseStatus%]==[5] (
set "_licstat=Notification"
set "_clr=0e"
)
if [%LicenseStatus%]==[6] (
set "_licstat=Extended grace period"
set "_clr=0e"
)
if not defined _licstat (
    set "_licstat=Unavailable"
    set "_clr=08"
)
set /a _gprdays=%GracePeriodRemaining%/1440
cmd /c exit /b %LicenseStatusReason%
set _licreas=0x%=ExitCode%
for %%# in (
0x4004F00C:The}Software}Licensing}Service}reported}that}the}application}is}running}within}the}valid}grace}period
0x4004F00D:The}Software}Licensing}Service}reported}that}the}application}is}running}within}the}valid}out}of}tolerance}grace}period
0x4004F040:The}Software}Licensing}Service}reported}that}the}product}was}activated}but}the}owner}should}verify}the}Product}Use}Rights
0x4004F401:The}Software}Licensing}Service}reported}that}the}application}has}a}store}license
0xC004F001:The}Software}Licensing}Service}reported}an}internal}error
0xC004F007:The}Software}Licensing}Service}reported}that}the}license}could}not}be}found
0xC004F008:The}Software}Licensing}Service}reported}that}the}license}could}not}be}found
0xC004F009:The}Software}Licensing}Service}reported}that}the}grace}period}has}expired
0xC004F014:The}Software}Licensing}Service}reported}that}the}product}key}is}not}available
0xC004F035:The}Software}Licensing}Service}reported}that}the}computer}could}not}be}activated}with}a}Volume}license}product}key
0xC004F057:The}Software}Licensing}Service}reported}that}the}computer}BIOS}is}missing}a}required}license
0xC004F058:The}Software}Licensing}Service}reported}that}the}computer}BIOS}is}missing}a}required}license
0xC004F059:The}Software}Licensing}Service}reported}that}a}license}in}the}computer}BIOS}is}invalid
0xC004F200:The}Software}Licensing}Service}reported}that}current}state}is}not}genuine
) do for /f "delims=: tokens=1-2" %%A in ("%%#") do if /i [%_licreas%]==[%%A] set "_licstatmsg=%%B"
if not defined _ppk set _ppk=*****-*****-*****-*****-%PartialProductKey%
for /f "tokens=2 delims=," %%A in ("%Description%") do set "_channel=%%A"
for /f "tokens=1 delims= " %%A in ("%_channel%") do set "_channel=%%A"
if [%LicenseStatus%]==[0] set "_channel="
:: Detect motherboard
for /f "tokens=2 delims==" %%A in ('wmic baseboard get manufacturer /value 2^>nul') do set "_mobo=%%A"
for /f "tokens=2 delims==" %%A in ('wmic baseboard get product /value 2^>nul') do set "_mobo=%_mobo% %%A"
if !osbuild! GEQ 9200 (
    %_psc% Confirm-SecureBootUEFI 2>nul | find /i "True" %_nul% && (
        set "_secuboot=1"
    )
)
exit /b
:mntesp
echo:
for /f %%# in ('mountvol /? ^| find ":\"') do if exist %%#EFI\Microsoft\Boot\en-US\*.mui set _espalreadymount=%%#
if defined _espalreadymount (
    echo EFI System Partition already mounted at %_espalreadymount%:
    set _ltr=%_espalreadymount%
)
if not defined _espalreadymount for %%# in (Q W E R T Y U I O P A S D F G H J K L Z X C V B N M) do (mountvol /? | find /i "%%#:" %_nul% || set "_ltr=%%#:")
if not defined _espalreadymount (
    mountvol %_ltr% /s %_nul%
    if exist %_ltr%\EFI (
        echo EFI System Partition successfully mounted at %_ltr%.
    ) else (
        %_eline%
        echo Failed to mount EFI System Partition at %_ltr%.
        %_pak%
    )
)
exit /b
:askslic
echo:
echo Available profiles:
for /f %%# in ('dir /b "!work!\bin\%_slicvertobeinstalled%" /o:N') do echo [%%#]
echo:
echo Refer to read-me to know which profile belongs to which brand.
echo:
set /p "_slicchc=Enter your choice, without brackets; for instance type ACRSYS to access the Acer profile: "
if [%_slicchc%]==[] set "_slicchc=blank"
if exist "!work!\bin\%_slicvertobeinstalled%\%_slicchc%" (
    set "_slictobeinstalled=!_slicchc!"
) else (
    echo Invalid selection; falling back to %_slictobeinstalled% profile.
)
echo:
exit /b
:instkey
for /f "usebackq eol=; delims=" %%# in ("!work!\bin\fallbackkeys.ini") do for /f "tokens=1-4 delims=:" %%A in ("%%#") do if /i [%osver%]==[%%A] if /i [%ostype%]==[%%B] if /i [%osedition%]==[%%C] set "key=%%D"
for /f "usebackq eol=; delims=" %%# in ("!work!\bin\keys.ini") do for /f "tokens=1-5 delims=:" %%A in ("%%#") do if /i [%_slictobeinstalledcompany%]==[%%A] if /i [%osver%]==[%%B] if /i [%ostype%]==[%%C] if /i [%osedition%]==[%%D] set "key=%%E"
for %%# in (
    10.0:14393:Server:ServerStandard:2499N-BCGX3-FHJKF-DH9QR-8B63W
    10.0:14393:Server:ServerStorageStandard:26K68-7NBHG-XQGQG-KYYCJ-QDCGG 
    10.0:17763:Server:ServerStandard:26DHC-DN92M-DQ9YQ-4M6YJ-GVMMH
    10.0:17763:Server:ServerDatacenter:8PNQX-RF873-CXRPY-8J42B-XBWWC
    10.0:20348:Server:ServerStandard:T7DWT-NQPJX-XX62J-YG93D-49FQR
    10.0:20348:Server:ServerDatacenter:V86NK-D94TF-QXPM9-W9FRT-4M8D9
) do for /f "tokens=1-5 delims=:" %%A in ("%%#") do if /i [%osver%]==[%%A] if /i [%osbuild%]==[%%B] if /i [%ostype%]==[%%C] if /i [%osedition%]==[%%D] set "key=%%E"
echo Installing OEM:SLP key [%key%]...
%_wmi% path %_sls% where __CLASS='%_sls%' call InstallProductKey ProductKey="%key%" %_nul% && (
call :colortxt %green% "Successful" /n
%_wmi% path %_sls% where __CLASS='%_sls%' call RefreshLicenseStatus %_nul%
) || (
call :colortxt %red% "Unsuccessful" /n
%_pak%
)
exit /b
:colortxt
setlocal enableDelayedExpansion
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:colorPrint Color  Str  [/n]
setlocal
set "s=%~2"
call :colorPrintVar %1 s %3
exit /b

:colorPrintVar  Color  StrVar  [/n]
if not defined DEL call :initColorPrint
setlocal enableDelayedExpansion
pushd .
':
cd \
set "s=!%~2!"
:: The single blank line within the following IN() clause is critical - DO NOT REMOVE
for %%n in (^"^

^") do (
  set "s=!s:\=%%~n\%%~n!"
  set "s=!s:/=%%~n/%%~n!"
  set "s=!s::=%%~n:%%~n!"
)
for /f delims^=^ eol^= %%s in ("!s!") do (
  if "!" equ "" setlocal disableDelayedExpansion
  if %%s==\ (
    findstr /a:%~1 "." "\'" nul
    <nul set /p "=%DEL%%DEL%%DEL%"
  ) else if %%s==/ (
    findstr /a:%~1 "." "/.\'" nul
    <nul set /p "=%DEL%%DEL%%DEL%%DEL%%DEL%"
  ) else (
    >colorPrint.txt (echo %%s\..\')
    findstr /a:%~1 /f:colorPrint.txt "."
    <nul set /p "=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
  )
)
if /i "%~3"=="/n" echo(
popd
exit /b


:initColorPrint
for /f %%A in ('"prompt $H&for %%B in (1) do rem"') do set "DEL=%%A %%A"
<nul >"%temp%\'" set /p "=."
subst ': "%temp%" >nul
exit /b


:cleanupColorPrint
2>nul del "%temp%\'"
2>nul del "%temp%\colorPrint.txt"
>nul subst ': /d
exit /b

:exit
if not defined _espalreadymount (
    cd /d %systemroot% >nul 2>&1
    mountvol %_ltr% /d >nul 2>&1
)
exit /b
----- Begin wsf script --->
<package>
   <job id="ELAV">
       <script language="VBScript">
           Set strArg=WScript.Arguments.Named

           If Not strArg.Exists("File") Then
               Wscript.Echo "Switch /File:<File> is missing."
               WScript.Quit 1
           End If

           Set strRdlproc = CreateObject("WScript.Shell").Exec("rundll32 kernel32,Sleep")
           With GetObject("winmgmts:\\.\root\CIMV2:Win32_Process.Handle='" & strRdlproc.ProcessId & "'")
               With GetObject("winmgmts:\\.\root\CIMV2:Win32_Process.Handle='" & .ParentProcessId & "'")
                   If InStr (.CommandLine, WScript.ScriptName) <> 0 Then
                       strLine = Mid(.CommandLine, InStr(.CommandLine , "/File:") + Len(strArg("File")) + 8)
                   End If
               End With
               .Terminate
           End With

          CreateObject("Shell.Application").ShellExecute "cmd", "/c " & chr(34) & chr(34) & strArg("File") & chr(34) & " " & strLine & chr(34), "", "runas", 1
       </script>
   </job>
</package>