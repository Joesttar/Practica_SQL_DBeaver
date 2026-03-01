import pandas as pd
from sqlalchemy import create_engine, text

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

    print("\n✅ ¡LOGRADO! Datos cargados en DataFrames.")

except Exception as e:
    print(f"\n❌ Seguimos con problemas: {e}")