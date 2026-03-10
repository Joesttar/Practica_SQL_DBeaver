import pandas as pd
from sqlalchemy import create_engine, text
import unicodedata
import matplotlib.pyplot as plt
import seaborn as sns

# 1. Conexión (Asegúrate de que la clave 'postgres1' sea la correcta)
engine = create_engine('postgresql://postgres:postgres1@localhost:5432/entrenamiento_database')

try:
    with engine.connect() as conn:
        # Esto nos dirá qué tablas existen en TODA la base de datos
        query_diagnostico = text("""
            SELECT table_schema, table_name 
            FROM information_schema.tables 
            WHERE table_schema NOT IN ('information_schema', 'pg_catalog');
        """)
        resultado = conn.execute(query_diagnostico).fetchall()
        
        print("🔎 Tablas encontradas en la BD:")
        for schema, table in resultado:
            print(f"Esquema: {schema} | Tabla: {table}")

        # 2. Carga Dinámica (Usando el nombre exacto que encuentre)
        # Si ves que tus tablas salen como 'Usuario' (con Mayúscula), cámbialas aquí abajo:
        df_usuario = pd.read_sql('SELECT * FROM "usuario";', conn)
        df_productos = pd.read_sql('SELECT * FROM "productos";', conn)
        df_ventas = pd.read_sql('SELECT * FROM "ventas";', conn)

    print("\n Datos cargados en DataFrames.")

except Exception as e:
    print(f"\n Seguimos con problemas: {e}")

#------------------------------------------------------------------------------------------------------------------------------------------

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
df_ventas = df_ventas.merge(df_productos[['producto_id', 'precio_unitario']], on='producto_id', how='left')
df_ventas['monto total'] = df_ventas['monto_total'].fillna(df_ventas['cantidad'] * df_ventas['precio_unitario'])

# ----- 3. Limpieza en la tabla usuario -------
df_usuario['nombre'] = df_usuario['nombre'].apply(limpieza_texto)
df_usuario['rol'] = df_usuario['rol'].str.strip().str.lower()  # Normalizamos el rol a minusculas y sin espacios

print("Limpieza de datos completada exitosamente.")
print("\nCategorias unicas detectadas:", df_productos['categoria'].unique())
print(df_productos.head)

#------------------------------------------------------------------------------------------------------------------------------------------
# Analisis y visualizacion de datos

# Estilo de las graficas
sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = (10, 6)

# Calculo de KPIs Ingreso total
ingreso_total = df_ventas['monto_total'].sum()
print(f"Ingreso Total: ${ingreso_total:,.2f}")

# KPIs Ticket promedio
ticket_promedio = df_ventas['monto_total'].mean()
print(f"Ticket Promedio: ${ticket_promedio:,.2f}")

# KPIs Tasa de conversion de usuarios
usuarios_totales = df_usuario['usuario_id'].nunique() 
usuarios_con_compra = df_ventas['usuario_id'].nunique() #
tasa_conversion = (usuarios_con_compra / usuarios_totales) * 100
print(f"Tasa de Conversión: {tasa_conversion:.1f}%")
print(f"({usuarios_con_compra} de {usuarios_totales} usuarios realizaron una compra)")

# Producto mas vendido
producto_mas_vendida =  (df_ventas.groupby('producto_id')['cantidad'].sum().reset_index().merge(df_productos[['producto_id', 'producto_nombre']], on = 'producto_id').sort_values('cantidad', ascending = False))

# Agregamos una verificaicon antes del .iloc[0] para evitar errores si el DataFrame esta vacio
if producto_mas_vendida.empty:
    print("No se encontraron ventas para determinar el producto más vendido.")  
else:
    producto_top = producto_mas_vendida.iloc[0]
    print(f"Producto más vendido: {producto_top['producto_nombre']} con {producto_top['cantidad']} unidades vendidas")                  

# agregamos una verificacion para evitar errores si el DataFrame esta vacio
if df_ventas.empty:
    print("No se encontraron ventas para visualizar el ingreso por categoría.")
# Visualizacion de Ingreso Total por Categoria
    else:
    ingreso_categoria = (df_ventas.merge(df_productos[['producto_id', 'categoria']], on='producto_id').groupby('categoria')['monto_total'].sum().reset_index()).sum().sort_values(ascending=False).reset_index()
    ifg, ax = plt.subplots()
    sns.barplot(data=ingreso_categoria, x='categoria', y='monto_total', palette='Blues_d', ax=ax)
    ax.set_title('Ingreso total por Categoria', fontsize=14, fontweight='bold')
    ax.sert_xlabel('Categoria', fontsize=12)
    ax.set_ylabel('Ingreso Total ($)', fontsize=12)
    for bar in ax.patches:
        ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height(), f'${bar.get_height():,.0f}', ha='center', va='bottom', fontsize=10)
    plt.tight_layout()
    plt.show()
    