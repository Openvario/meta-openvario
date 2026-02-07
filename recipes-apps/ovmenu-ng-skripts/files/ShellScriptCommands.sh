echo "Shell Commands used in OpenVario Project"
echo "-------------------------------------------------------------------------"

echo "Date Time"
echo "========="
echo "reinterpret unix timestamp to date time"
echo "date -u -d @1692282364"
date -u -d @1692282364

echo "currently timestamp"
echo "date +%c"
date +%c
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"

echo "if-Statement"
echo "============"
if 3 && 4; then echo "3 && 4 = true"; else echo "3 && 4 = false"; fi 
if 0 && 4; then echo "0 && 4 = true"; else echo "0 && 4 = false"; fi 
if 3 && 0; then echo "3 && 0 = true"; else echo "3 && 0 = false"; fi 

echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"

# remove a yocto project to make a new build:
find . -type f -name "*Name*.*" -delete
# find only:
find . -type f -name "*Name*.*" 
find . -type f -name "/opensoar*.*" 

# kernel values
## temperature:
cat /sys/class/thermal/thermal_zone*/temp
## frequency:
cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_cur_freq

# set datetime: this is setting the software clock only, the hardware clock
# is untouched (and set the system clock at next boot
date -s "2024-10-06 10:21"

=============================================================
So kann man Zeichen oder Strings von hinten, bzw. rechts abschneiden:

VALUE=textpart.txt.dat
echo ${VALUE%.*}

#Ausgabe:
textpart.txt

So kann man den längst möglichen String von rechts entfernen:

VALUE=textpart.txt.dat.gz
echo ${VALUE%%.*}

# Ausgabe:
textpart

Beides umgedreht geht mit #. Möchte man also den kürzest möglichen String von links abschneiden:

VALUE="/path/filename.dat.txt"
echo ${VALUE#*/}

# Ausgabe:
path/filename.dat

# oder:
VALUE="/path/filename.dat.txt"
echo ${VALUE#*.}

#Ausgabe:
dat.txt

für den längsmöglichen String von links:
VALUE="/path/filename.dat.txt"
echo ${VALUE##*/}

# Ausgabe:
filename.dat.txt


# oder
VALUE="/path/filename.dat.txt"
echo ${VALUE##*.}

# Ausgabe:
txt
=============================================================
# Search and Replace
[[ das muss ich noch ergaenzen...]]
siehe https://www.data2type.de/xml-xslt-xslfo/regulaere-ausdruecke/regex-methoden-aus-der-praxis/einige-kleine-beispiele/verschachtelte-klammerpaare

Search(1):      \([^()]*\)
Search(2):      \([^()]*(\([^()]*\)[^()]*)*\)
*** Ersetzen klappt noch gar nicht!
(Ersetzen:       $1 oder \1)

Search(1):      _T\([^()]*.\)
_T\([^()]*(\([^()]*\)[^()]*)*\)

=============================================================
# Recursives Löschen:
# Nur mit echo
  find $DIR -name $ENDUNG -exec echo rm -rv {} \;
  #oder
  find $DIR -name $ENDUNG -delete
# jetzt in echt:
  find $DIR -name $ENDUNG -exec rm -rv {} \;
# Beispiel (mit Zone.Identifier):
  find ./ -name *Zone.Identifier -exec rm -rv {} \;
  #oder
  find ./ -name *Zone.Identifier -delete
=============================================================
Zip bzw Unzip
-------------
... als Teil einer C++-Datei (SkysightAPI.cpp) zum Unzippen über die Commandozeile (am 24.02.2025 beseitigt mit zlib)
1. Löschen der tmp-Dateien im Tempordner
#if ZIP_TEST 
    char zip_buffer[0x10000];
    /* Test:*/  filepath = Path("D:/Data/OpenSoarData/skysight/Test.zip");
    Unzip(filepath, zip_buffer, sizeof(zip_buffer));
#else 
    [[maybe_unused]] char zip_buffer[] = "Das ist ein Test!!!";
#endif
    char console_cmd[0x4000];
    char tmp_dir[MAX_PATH];
    std::string dir = filepath.GetParent().ToUTF8();
#ifdef _WIN32
    std::replace(dir.begin(), dir.end(), '/', '\\');
    snprintf(tmp_dir, sizeof(tmp_dir), "%s\\tmp", dir.c_str());
  else
    snprintf(tmp_dir, sizeof(tmp_dir), "%s/tmp", dir.c_str());
#endif

#ifdef _WIN32
    snprintf(console_cmd, sizeof(console_cmd), "rd %s /S /Q", dir.c_str());
#else  // _WIN32
    snprintf(console_cmd, sizeof(console_cmd), "rm -rf %s", dir.c_str());
#endif
    printf("Delete-Command: ", console_cmd);
    system(console_cmd);
2. Unzip mit 7z.exe (Windows) bzw. gzip (Unix)
#ifdef _WIN32
    snprintf(console_cmd, sizeof(console_cmd), "D:\\Programs\\7-Zip\\7z.exe e -o%s  %s",
      tmp_dir, filepath.c_str());
#else  // _WIN32
    snprintf(console_cmd, sizeof(console_cmd), "gzip -cdf  %s > %s",
      filepath.c_str(), tmp_dir);
#endif
    printf("Zip-Command: ", console_cmd);
    system(console_cmd);
3. Umbenennen (Kopieren) der entpackten Datei in ihren Zielort - xcopy (Windows) bzw. cp (Unix)
    std::string file = filepath.ToUTF8();
#ifdef _WIN32
    std::replace(file.begin(), file.end(), '/', '\\');
    snprintf(console_cmd, sizeof(console_cmd), "xcopy %s\\tmp* %s /Y /-I", tmp_dir, file.c_str());
#else  // _WIN32
    snprintf(console_cmd, sizeof(console_cmd), "cp -rf %s/tmp* %s", tmp_dir, file.c_str());
#endif
    printf("Copy-Command: ", console_cmd);
    system(console_cmd);
