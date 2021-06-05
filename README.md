# EzWindSLIC
An activator for Windows 7 for UEFI-GPT systems, based on WindSLIC but this one is more user friendly.
[Overview]  
Easy to use script that defeats activation on Windows Vista/7 and Server 2008(R2)/2012(R2)/2016/2019 on UEFI-GPT systems using SLIC emulation technique.  
  
[How to]  
Run the script. Press [I]nstall to activate and wait for a few seconds.  
If prompted, reboot or shutdown.  
If everything went well you should be activated!  
  
Run script again and choose [U]ninstall option to uninstall.  
  
Switches:  
/install: Start installation process and skip main menu.  
/uninstall: Start installation process and skip main menu.  
/silent: Used with /install or /uninstall. Don't prompt user for anything and reboot automatically if required.  
/norestart: Meant to be used with /silent. Quit script at the end instead of rebooting automatically.  
/force: Similar to Daz' loader's "Ignore existing SLIC". Install bootloader even if SLIC is present.  
  
Q: Which profile belongs to which company?  
A:   
_ASUS_ - Asus  
_IFSA_ - Positivo  
1B72 - AOC  
268565 - Gericom  
ACRSYS - Acer  
ALWARE - Alienware  
AQUARI - Aquarius  
ATComp - AT-Computers  
bc_OEM - Bluechip  
BCKHFF - Beckhoff  
BEKOPC - Beko  
BGH-SA - BGH  
BYTSPD - Bytespeed  
cceCCE - CCE  
CCEInf - CCE  
cgwall - Greatwall  
chili1 - Chiligreen  
cmscom - Zoostorm  
CREAAS - Crea  
CZC011 - CZC  
datate - Exper  
DSGLTD - Advent  
DTRINC - Tangent  
Exc - Excimer  
extra - Exone  
FOUNDR - Founder  
FSC - Fujitsu-Siemens  
FUJ - Fujitsu  
GATEWA - Gateway  
GBT - Gigabyte  
GENSYS - Genuine  
Getac_ - Getac  
HCLINF - HCL  
HEDY06 - Hedy  
higrad - Higraded  
HONHPS - Honeywell  
HPQOEM - HP  
HSPW07 - Hannspree  
HTCLTD - Hitachi  
HYRSLP - Hyrican  
IECOEM - Kohjinsha  
INFORL - Insys  
iQonIE - iQon  
ITINFO - Itautec  
KrFtWy - Kraftway  
K-Syst - K-Systems  
LANIX1 - Lanix  
LGE - LG  
MATBIO - Panasonic  
MaxDat - Maxdata  
MESHPC - Mesh  
MGWOEM - Megaware  
MITAC_ - Mitac  
MOUSEC - Mouse  
MSI_NB - MSI  
NATI - National-Instruments  
NAVIHB - Impression  
NECCAP - NEC  
OEGROU - Stone  
oem - Proline  
OLIPRO - Olidata  
OLISLP - Olidata  
OlvOEM - Olivetti  
PacBel - Packard-Bell  
PDSINC - Paragon  
POSITI - Positivo  
PRDGT - Paradigit  
PROLNK - Prolink  
QUANMX - Quanmax  
RoverC - Rover  
SECCSD - Samsung  
SGOA21 - Siragon  
Shuttl - Shuttle  
stinfo - Semp  
SYSMAX - Systemax  
Tarox1 - Tarox  
TGAOEM - Targa  
THOA21 - Twinhead  
THTFPC - Tongfang  
TOSASU - Toshiba  
TOSBYD - Toshiba  
TOSCPL - Toshiba  
TOSHIB - Toshiba  
TOSINV - Toshiba  
TOSQCI - Toshiba  
TOSTNI - Toshiba  
VELOCI - Velocity  
VSCAIO - Viewsonic  
WDCorp - WD  
WORTMA - Wortmann  
YUTC - Viliv  
  
Q: I get error "PowerShell is not installed in your system". How to fix?  
A: If you are not running Vista, enable powershell using optional features control panel. If you are using Vista, install PowerShell from here: https://www.catalog.update.microsoft.com/Search.aspx?q=KB968930  
Alternatively, use an older version.  
  
Q: Does it support multi-boot?  
A: Sometimes. If you can't get it to work try using something like rEFInd.  
  
Q: Help! My PC won't boot!  
A: Boot into Windows Installation media in EFI mode and press Shift+F10 to launch cmd. Then type diskpart and then type:  
lis dis  
  
Identify your system disk and then type: (where * is the number of your system disk)  
sel dis *  
  
Then type:  
lis par  
  
Identify the partition labelled as System and type: (where ? is the number of the system parition)  
sel par ?  
  
Then type:  
for fs=fat32 quick  
  
Then type:  
exi  
  
After that is done, exit cmd and press 'Next' on the setup screen, and then press 'Repair your computer'  
After a while you should see 'Corrupt boot configuration is detected bla bla bla'. Press 'Repair and restart'.  
  
Your PC should be able to boot again.
