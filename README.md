
# GenHydro
App written in Julia and using GTK+ 3 for an Engineering Thesis titled „Simulating the operation of a peak-load power station using hydrogen fuel cells powered by electrolysis”.

## Setup (Windows users)

- Install portable Julia version. You can download it in [Julia's official website](https://julialang.org/downloads/), or directly from here: [Julia 1.10.0 64-bit](https://julialang-s3.julialang.org/bin/winnt/x64/1.10/julia-1.10.0-win64.zip), [Julia 1.10.0 32-bit](https://julialang-s3.julialang.org/bin/winnt/x86/1.10/julia-1.10.0-win32.zip)
- Move downloaded .zip file to the directory of this project;
- Unpack the .zip file: *avoid making another directory* - for example, if you downloaded Julia 1.10.0, unpacked directory should have a name `julia-1.10.0`
- open the `cmd` terminal with path of the project directory. You can do that through typing `cmd` in Windows Explorer's current path or by running the command `cd [path to project's directory]`
- asserting that julia folder is named `julia-1.10.0`, run the following commands:<br>
<br>`julia-1.10.0\bin\julia.exe run-me-first.jl`<br>
<br>and wait until Julia exits to cmd. Then type<br>
<br>`julia-1.10.0\bin\julia.exe main.jl`<br>
<br>to run GenHydro application.<br>
<br>Note: *don't exit from the terminal: the app is using Julia REPL, quitting Julia will terminate the app!*
