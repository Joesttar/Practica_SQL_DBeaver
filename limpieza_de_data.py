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

# Eliminar espacios extra
    return texto_limpio.strip().capitalize()

#----- 1. Limpieza en la tabla pordutos -------
# Corregir errores ortograficos
df_productos['categoria'] = df_productos['categoria'].replace('Hogas', 'Hogar')

# Normalizacion masiva de categorias
df_productos['categoria'] = df_productos['categoria'].apply(limpieza_texto)
df_productos['producto_nombre'] = df_productos['producto_nombre'].apply(limpieza_texto)

#----- 2. Limpieza en la tabla clientes -------
# Convertir fechas a formato datetime de Pandas
df_ventas['fecha_venta'] = pd.to_datetime(df_ventas['fecha_venta'])

# Llenas montos totales nulos (si existen) multiplicando cantidad * precio
# Para esto unimos temporamente con productos
df_ventas = df_ventas.merge(df_prodcutos[['prodcuto_id', 'precio_unitario']], on='producto_id', how='left')
df_ventas['monto total'] = df_ventas['monto_total'].fillna(df_ventas['cantidad'] * df_ventas['precio_unitario'])

# ----- 3. Limpieza en la tabla usuario -------
df_usuario['nombre'] = df_usuario['nombre'].apply(limpieza_texto)
df_usuario['rol'] = df_usuario['rol'].str.strip().str.lower()  # Normalizamos el rol a minusculas y sin espacios

print("Limpieza de datos completada exitosamente.")
print("\nCategorias unicas detectadas:", df_productos['categoria'].unique())
print(df_productos.head)

