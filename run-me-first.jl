using Pkg
Pkg.activate(".")

Pkg.add(name="adwaita_icon_theme_jll", version="3.33.92"; preserve=Pkg.PRESERVE_ALL)

# ---- IF NEWER VERSIONS WON'T MAKE GENHYDRO WORK, UNCOMMENT THIS BLOCK ----
# ---- AND REMOVE FILES "Manifest.toml" AND "Project.toml" 		----
#Pkg.add(name="Pango_jll", version="1.42.4"; preserve=Pkg.PRESERVE_ALL)
#Pkg.add(name="AbstractPlotting", version="0.18.3"; preserve=Pkg.PRESERVE_ALL)
#Pkg.add(name="Cairo", version="1.0.5"; preserve=Pkg.PRESERVE_ALL)
#Pkg.add(name="CairoMakie", version="0.6.4"; preserve=Pkg.PRESERVE_ALL)
#Pkg.add(name="Graphics", version="1.1.2"; preserve=Pkg.PRESERVE_ALL)
#Pkg.add(name="Gtk", version="1.3.0"; preserve=Pkg.PRESERVE_ALL)
#Pkg.add(name="GtkObservables", version="1.2.9"; preserve=Pkg.PRESERVE_ALL)
#Pkg.add(name="Plots", version="1.32.0"; preserve=Pkg.PRESERVE_ALL)
# --------------------------------------------------------------------------

Pkg.instantiate()