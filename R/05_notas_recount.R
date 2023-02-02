## ----'start', message=FALSE-------------------------
## Load recount3 R package
library("recount3")



## ----'quick_example'--------------------------------
## Primero vemos el URL actual
getOption(
  "recount3_url",
  "http://duffel.rail.bio/recount3"
)
## Ahora si lo cambiamos
options(recount3_url = "https://recount-opendata.s3.amazonaws.com/recount3/release")
## Y vemos que ya funcionó el cambio.
getOption(
  "recount3_url",
  "http://duffel.rail.bio/recount3"
)
## Revisemos todos los proyectos con datos de humano en recount3
human_projects <- available_projects()
## Encuentra tu proyecto de interés. Aquí usaremos
## SRP009615 de ejemplo
proj_info <- subset(
  human_projects,
  project == "SRP009615" & project_type == "data_sources"
)
## Crea un objetio de tipo RangedSummarizedExperiment (RSE)
## con la información a nivel de genes
rse_gene_SRP009615 <- create_rse(proj_info)
## Explora el objeto RSE
rse_gene_SRP009615
```

De forma interactiva también podemos escoger nuestro estudio de interés usando el siguiente código o vía [el explorar de estudios](http://rna.recount.bio/docs/index.html#study-explorer) que creamos.

```{r "interactive_display", eval = FALSE}
## Explora los proyectos disponibles de forma interactiva
proj_info_interactive <- interactiveDisplayBase::display(human_projects)
## Selecciona un solo renglón en la tabla y da click en "send".
## Aquí verificamos que solo seleccionaste un solo renglón.
stopifnot(nrow(proj_info_interactive) == 1)
## Crea el objeto RSE
rse_gene_interactive <- create_rse(proj_info_interactive)
```
Una vez que tenemos las cuentas, podemos usar `transform_counts()` o `compute_read_counts()` para convertir en los formatos esperados por otras herramientas. Revisen el artículo de 2017 del `recountWorkflow` para [más detalles](https://f1000research.com/articles/6-1558/v1).
```{r "tranform_counts"}
## Convirtamos las cuentas por nucleotido a cuentas por lectura
## usando compute_read_counts().
## Para otras transformaciones como RPKM y TPM, revisa transform_counts().
assay(rse_gene_SRP009615, "counts") <- compute_read_counts(rse_gene_SRP009615)
```

```{r "expand_attributes"}
## Para este estudio en específico, hagamos más fácil de usar la
## información del experimento
rse_gene_SRP009615 <- expand_sra_attributes(rse_gene_SRP009615)
  colData(rse_gene_SRP009615)[
  ,
  grepl("^sra_attribute", colnames(colData(rse_gene_SRP009615)))
]
```
