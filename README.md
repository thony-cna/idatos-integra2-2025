# BookLens - Integración de Datos 2025-2

Este proyecto fue desarrollado para el curso de Integración de Datos en el segundo semestre del 2025. Consiste en la integración de dos conjuntos de datos relacionados con libros y sus reseñas, creando una aplicación web interactiva para explorar esta información.

## Fuentes de Datos

El proyecto integra datos de dos fuentes principales de Kaggle:

1. [Books Dataset](https://www.kaggle.com/datasets/saurabhbagchi/books-dataset) - Conjunto de datos con información general de libros
2. [Amazon Books Reviews](https://www.kaggle.com/datasets/mohamedbakhet/amazon-books-reviews) - Colección de reseñas de libros de Amazon

## Características

- Integración de datos de múltiples fuentes
- Análisis de calidad de datos
- Documentación de procedencia de datos en PROV-XML
- Publicación de datos en formato RDF (Nivel 4)
- Interfaz web interactiva para explorar los datos

## Estructura del Proyecto

### `/BookLens`

Aplicación web completa con:

- **Backend**: API REST desarrollada en Django
- **Frontend**: Interfaz de usuario moderna desarrollada con React y TypeScript

### `/calidad`

Contiene queries SQL para el análisis de la calidad de los datos integrados.

### `/csv`

Archivos CSV con los datos integrados finales:

- `lnbooks.csv` - Información de libros
- `lnreviews.csv` - Reseñas de usuarios
- `lnusers.csv` - Información de usuarios

### `/data_provenance`

Documentación completa de la procedencia de datos en formato PROV-XML, incluyendo:

- Datos originales
- Etapas de transformación
- Datos finales integrados

### `/publicacion`

Contiene el archivo RDF que representa los datos integrados según el nivel 4 de datos enlazados.

### `/scripts`

Colección de scripts SQL utilizados en el proceso de integración y transformación de datos.

## Tecnologías Utilizadas

- **Backend**: Django + Django REST Framework
- **Frontend**: React + TypeScript + Vite
- **Estilos**: TailwindCSS + ShadcnUI
- **Base de Datos**: PostgreSQL
- **Formatos de Datos**: CSV, XML, RDF

## Autores

- Anthony Cuña
- Matías Fregueiro
- Sofia Torres
- Pablo Alvarez
