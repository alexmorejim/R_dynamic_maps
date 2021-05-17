
### Como hacer mapas dinámicos en R 

## definimos wd 

setwd("/Users/alexmoreno/Library/Mobile Documents/com~apple~CloudDocs/R_Scripts")

## librerías

library(tmap) #Dibujar el mapa
library(sf) #Para leer el shapefile y reducir el tamaño del archivo
library(pryr) #Calcular el tamaño del archivo
library("readr") #para cargar csv
library(base) # para merge
library(reshape2) # para hacer dcast
library(plyr) # para mineria en csv 
library(dplyr) # para inner join

# importamos shp de municipios 
# el shp lo descargamos del marco geoestadistico del INEGI https://www.inegi.org.mx/app/biblioteca/ficha.html?upc=889463776079

shp_municipios <- st_read("mg_sep2019_integrado/conjunto_de_datos/00mun.shp")

### cargamos la base 

# podemos descargar esta carpeta de https://www.inegi.org.mx/programas/ccpv/2020/#Datos_abiertos

iter_00_cpv2020 <- read_csv("iter_00_cpv2020/conjunto_de_datos/conjunto_de_datos_iter_00_cpv2020.csv", 
)

iter_00_cpv2020[, 10:230] <- sapply(iter_00_cpv2020[, 10:230], as.numeric)

#creamos clave edomun

iter_00_cpv2020$ENTIDAD <- ifelse(iter_00_cpv2020$ENTIDAD<10, paste(0,iter_00_cpv2020$ENTIDAD,sep=""), iter_00_cpv2020$ENTIDAD)

iter_00_cpv2020$MUN <- ifelse(iter_00_cpv2020$MUN<10, paste("00",iter_00_cpv2020$MUN,sep=""), ifelse(iter_00_cpv2020$MUN>=10 & iter_00_cpv2020$MUN<100  , paste("0",iter_00_cpv2020$MUN,sep=""), iter_00_cpv2020$MUN  )  )


iter_00_cpv2020$CVEGEO <- paste(iter_00_cpv2020$ENTIDAD,iter_00_cpv2020$MUN, sep="")

# base dejando solo municipios 

iter_00_cpv2020_mun <- iter_00_cpv2020[iter_00_cpv2020$NOM_LOC=="Total del Municipio",]

# hacemos merge del shp y el df 

shp_municipios <- inner_join(shp_municipios,iter_00_cpv2020_mun,by="CVEGEO")
object_size(shp_municipios)

# mapeamos distintas variables 

tmap_mode("view")

#mapeamos población total 

tm_shape(shp_municipios) +
  tm_fill("POBTOT", id="NOM_MUN", palette = "Oranges", style="quantile", title="pob total") +
  tm_borders("grey25", alpha=.05) + 
  tm_layout("Población total por municipio en 2020",
            main.title.position = "center") + tm_view(view.legend.position = c("left","bottom") #esto sirve para bajar la leyenda y que no estorbe con el t?tulo 
            )

tmap_last <- tmap_last()

# cambiamos la vista a una donde se muestre un mapa dinámico 
tmap_mode("view")


