
# GenHydro
App written in Julia and using GTK+ 3 for an Engineering Thesis titled „Simulating the operation of a peak-load power station using hydrogen fuel cells powered by electrolysis”.<br>
Aplikacja napisana w języku Julia i korzystająca z GTK+ 3 w ramach Pracy Inżynierskiej o tytule „Symulowanie pracy elektrowni szczytowej z wykorzystaniem ogniw paliwowych zasilanych wodorem z elektrolizy”.<br>

## English

### Setup (Windows users)

- Install portable Julia version. Currently (Jan. 2024) newest Julia 1.10.0 is not recommended for this project. Confirmed latest working stable version for this application is Julia 1.9.4. You can download it in [Julia's official website](https://julialang.org/downloads/oldreleases/), or directly from [here, but do not forget to check SHA-256 control sum.](https://julialang-s3.julialang.org/bin/winnt/x64/1.9/julia-1.9.4-win64.zip) 
- Move downloaded e.g. `julia-1.9.4-win64.zip` file to the directory of imported GenHydro project;
- Unpack the .zip file: *avoid making another directory* - for example, if you downloaded Julia 1.9.4, unpacked directory should have a name `julia-1.9.4`
- open the `cmd` terminal with path of the project directory. You can do that through typing `cmd` in *Windows File Manager* when viewing GenHydro's project folder or by running the command `cd [path to GenHydro's directory]`
- asserting that julia folder is named `julia-1.9.4`, run the following commands:<br>
<br>`julia-1.9.4\bin\julia.exe run-me-first.jl`<br>
<br>and wait until Julia exits to cmd. Then type<br>
<br>`julia-1.9.4\bin\julia.exe main.jl`<br>
<br>to run GenHydro application.<br>
<br>Note: *don't exit from the terminal: the app is using Julia REPL, quitting Julia will terminate the app!*

## Polski

### Konfiguracja (Użytkownicy Windows)

- Zainstaluj przenośną wersję Julii. Obecnie (Sty. 2024) najnowsza wersja Julii 1.10.0 nie jest zalecana do tego projektu. Potwierdzoną, najnowszą stabilną wersją, zalecaną dla tej aplikacji, jest Julia 1.9.4. Możesz ją pobrać ze [oficjalnej strony Julii](https://julialang.org/downloads/oldreleases/) lub bezpośrednio [stąd, ale nie zapomnij sprawdzić sumy kontrolnej SHA-256](https://julialang-s3.julialang.org/bin/winnt/x64/1.9/julia-1.9.4-win64.zip).
- Przenieś pobrany plik np. `julia-1.9.4-win64.zip` do katalogu projektu GenHydro;
- Rozpakuj plik .zip: *unikaj tworzenia dodatkowego katalogu* - na przykład, jeśli pobrałeś Julię 1.9.4, rozpakowany katalog powinien mieć nazwę `julia-1.9.4`
- Otwórz terminal `cmd` w ścieżce katalogu projektu. Możesz to zrobić, wpisując `cmd` w *Menedżerze plików systemu Windows* przy widoku katalogu projektu GenHydro lub uruchamiając polecenie `cd [ścieżka do katalogu GenHydro]`
- Zakładając, że folder z Julią ma nazwę `julia-1.9.4`, uruchom poniższe polecenia:<br>
<br>`julia-1.9.4\bin\julia.exe run-me-first.jl`<br>
<br>i poczekaj, aż Julia zakończy działanie w terminalu. Następnie wpisz<br>
<br>`julia-1.9.4\bin\julia.exe main.jl`<br>
<br>aby uruchomić aplikację GenHydro.<br>
<br>Uwaga: *nie zamykaj terminalu: aplikacja korzysta z Julia REPL, zakończenie działania Julii zakończy również działanie aplikacji!*
