# Codigo de limpieza profunda de datos 
# Asumimos que ya tenemos nuestros DATAFRAMES ya que se hicieron en el archivo conexion_postgres.py
import pandas as pd
import unicodedata

# Funcion de apoyo para eliminar acentos, espacios extra y mejorar el formato
def limpieza_texto(texto):
    if texto is None or not isinstance(texto, str):
        return texto  # Si no es un string, lo devolvemos tal cual

# Eliminar acentos
texto_limpio = unicodedata.normalize('NFD', texto).encode ('ascii', 'ignore').decode('utf-8')

# Eliminar espacios extra y aparte agregamos Capitalize 
return texto_limpio.strip().capitalize()

#----- 1. Limpieza en la tabla pordutos -------
# Corregir errores ortograficos
df_prodcutos['categoria'] = df_prodcutos['categoria'].replace('Hogas', 'Hogar')

# Normalizacion masiva de categorias
df_prodcutos['categoria'] = df_prodcutos['categoria'].apply(limpieza_texto)
df_prdocutos['producto_nombre'] = df_prdocutos['producto_nombre'].apply(limpieza_texto)

#----- 2. Limpieza en la tabla clientes -------
# Convertir fechas a formato datetime de Pandas
df_ventas['fecha_venta'] = pd.to_datetime(df_ventas['fecha_ventas'])

# Llenas montos totales nulos (si existen) multiplicando cantidad * precio

