library(ggplot2)

wwtp_name <- "USF"
data <- read.csv(paste0(wwtp_name, "_cluster_label_abraham.csv"))
#USF
data$cluster <- factor(data$cluster, levels = c("Primary Clarification", "Activated Sludge", "Denitrification Filters", "Chlorination"))
#HRSD
data$cluster <- factor(data$cluster, levels = c("Primary Clarification", "Activated Sludge", "Coagulation-Sedimentation", "Ozonation", "BAF-GAC", "UV Disinfection", "Chlorination"))

data <- subset(data, subset = cluster != "Primary Clarification")
data <- subset(data, subset = cluster != "Coagulation-Sedimentation")
data <- subset(data, subset = cluster != "UV Disinfection")
data <- subset(data, subset = cluster != "Chlorination")

color_list <- c("#FDB462","#EF3B2C", "grey","#662506","#7FC97F", "#386CB0")
color_list <- c("#FDB462","#7FC97F","grey", "#386CB0")

k <- kruskal.test(L~cluster, data=data)
val <- "L"
gp <- ggplot(data, aes(x = cluster, y = L, fill = cluster)) +
  geom_boxplot(width = 0.3) +
  scale_fill_manual(values=color_list) +
  theme_bw() +
  labs(title = paste0("Abraham Descriptor: ", val,"  (p-val = ", round(k$p.value, 3),")")) +
  theme(plot.title = element_text(size=12, face = "bold", hjust = 0.5), axis.text=element_text(size=11), axis.title=element_text(size=11), legend.position = "none")

png(paste0("./figure/", wwtp_name, "_", val,".png"),width = 507*3, height = 401*3, res = 300)
plot(gp)
dev.off()

color_list <- c("#FDB462","#7FC97F","#386CB0","grey","#CCCC06" ,"#E45757", "#B279A2")
cluster_list <- c("Primary Clarification", "Activated Sludge", "Denitrification Filters", "Chlorination")
wwtp_name <- "HRSD"
cluster_list <- c("Primary Clarification", "Activated Sludge", "Coagulation-Sedimentation", "Ozonation", "BAF-GAC", "UV Disinfection", "Chlorination")
cluster_name <- cluster_list[5]
r_input <- read.csv(paste0(wwtp_name, "_r_input.csv"))
r_input$Abraham <- factor(r_input$Abraham, levels = c("E", "S", "A", "B", "V", "L", "Log Kow"))
r_input <- subset(r_input, subset = cluster == cluster_name)
gp <- ggplot(r_input, aes(x = Abraham, y = value, fill = Abraham)) +
  geom_boxplot(width = 0.4) +
  scale_fill_manual(values=color_list) +
  theme_bw() +
  labs(title = cluster_name, y = "Value", x = "Abraham Descriptor") +
  theme(plot.title = element_text(size=12, face = "bold", hjust = 0.5), axis.text=element_text(size=11), axis.title=element_text(size=11), legend.position = "none")

png(paste0("./figure/", wwtp_name, "_", cluster_name,".png"),width = 507*3, height = 401*3, res = 300)
plot(gp)
dev.off()


color_list <- c("#FDB462","#7FC97F","#386CB0","grey","#CCCC06" ,"#E45757", "#B279A2")
wwtp_name <- "USF"
K <- 3
cluster_list <- c(0:(K-1))
cluster_name <- cluster_list[3]
r_input <- read.csv(paste0(wwtp_name, "_pattern_K_",K,"_r_input.csv"))
r_input$Abraham <- factor(r_input$Abraham, levels = c("E", "S", "A", "B", "V", "L", "Log Kow"))
r_input <- subset(r_input, subset = cluster == cluster_name)
gp <- ggplot(r_input, aes(x = Abraham, y = value, fill = Abraham)) +
  geom_boxplot(width = 0.4) +
  scale_fill_manual(values=color_list) +
  theme_bw() +
  labs(title = paste0("Cluster ", cluster_name), y = "Value", x = "Abraham Descriptor") +
  theme(plot.title = element_text(size=12, face = "bold", hjust = 0.5), axis.text=element_text(size=11), axis.title=element_text(size=11), legend.position = "none")

png(paste0("./figure/", wwtp_name, "_K_",K, "_cluster", cluster_name,".png"),width = 507*3, height = 401*3, res = 300)
plot(gp)
dev.off()

#################################
wwtp_name <- "HRSD"
K <- 2
data <- read.csv(paste0(wwtp_name, "_pattern_K_", K, "_abraham.csv"))
data$cluster <- factor(data$cluster, levels = c(0, 1, 2))
color_list <- c("#FDB462","#7FC97F","grey", "#386CB0")

k <- kruskal.test(L~cluster, data=data)
val <- "L"
gp <- ggplot(data, aes(x = cluster, y = L, fill = cluster)) +
  geom_boxplot(width = 0.3) +
  scale_fill_manual(values=color_list) +
  theme_bw() +
  labs(title = paste0("Abraham Descriptor: ", val,"  (p-val = ", round(k$p.value, 3),")")) +
  theme(plot.title = element_text(size=12, face = "bold", hjust = 0.5), axis.text=element_text(size=11), axis.title=element_text(size=11), legend.position = "none")

png(paste0("./figure/", wwtp_name, "_K_", K, "_", val,".png"),width = 507*3, height = 401*3, res = 300)
plot(gp)
dev.off()
