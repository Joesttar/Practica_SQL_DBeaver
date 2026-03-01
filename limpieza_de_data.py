# Codigo de limpieza profunda de datos 
# Asumimos que ya tenemos nuestros DATAFRAMES ya que se hicieron en el archivo conexion_postgres.py
import pandas as pd
import unicodedata

# Funcion de apoyo para eliminar acentos, espacios extra y mejorar el formato
def limpieza_texto(texto):
    if texto is None or not isinstance(texto, str):
        return texto  # Si no es un string, lo devolvemos tal cual

# Eliminar acentos
    texto = unicodedata.normalize('NFD', texto).encode ('ascii', 'ignore').decode('utf-8')

# Eliminar espacios extra y aparte agregamos Capitalize 