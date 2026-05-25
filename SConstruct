import os
import sys

# 1. Cargamos la configuración base de godot-cpp
env = SConscript("godot-cpp/SConstruct")

# 2. Le decimos dónde buscar tus archivos de cabecera (.hpp)
env.Append(CPPPATH=["src/"])

# 3. Buscamos todos los archivos de código (.cpp) en tu carpeta src
sources = Glob("src/*.cpp")

# 4. Configuramos la salida de la librería (.dll)
# Se guardará en godot/bin/ con un nombre que Godot reconozca
library = env.SharedLibrary(
"bin/libecosort.{}.{}.x86_64.dll".format(env["platform"], env["target"]),    source=sources,
)

Default(library)