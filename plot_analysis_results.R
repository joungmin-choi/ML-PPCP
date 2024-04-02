library(ggplot2)
wwtp <- "HRSD"
cluster_info_first <- read.csv(paste0("./barplot/", wwtp, "_cluster_info_first.csv"))

#USF
usf_level <- c("Primary Clarification", "Activated Sludge", "Denitrification Filters", "Chlorination")
cluster_info_first$cluster <- factor(cluster_info_first$cluster, levels = usf_level)
title_name <- "Non-potable Reuse Facility"

#HRSD
#hrsd_level <- c("Primary Clarification", "Activated Sludge", "Coagulation-Sedimentation", "Ozonation", "BAF-GAC", "UV Disinfection", "Chlorination")
hrsd_level <- c("Primary Clarification", "Activated Sludge", "Coagulation-Sedimentation", "Ozonation", "BAF-GAC", "UV Disinfection")
cluster_info_first$cluster <- factor(cluster_info_first$cluster, levels = hrsd_level)
title_name <- "Potable Reuse Facility"

gp <- ggplot(cluster_info_first, aes(x = cluster, y = PPCP, fill = cluster)) +
  geom_bar(stat = "identity", width = 0.8, position = position_dodge()) + #0.8
  geom_text(aes(label=PPCP), vjust=-0.3, color="black",
            position = position_dodge(0.9), size=3.5)+
  labs(x = "Cluster", y = "# of PPCPs Most Efficiently Removed by the Treatment Process", title = title_name) +
  #scale_y_continuous(breaks=seq(0,90,10)) +
  #scale_fill_manual(values=c("grey","#7FC97F","#FDB462","#386CB0", "#662506","#EF3B2C", "#C3B3D7")) +
  scale_fill_manual(values=c("grey","#7FC97F","#A4CDE2","#C3B3D7")) +
  theme_bw() +
  theme(plot.title = element_text(size=11, face = "bold", hjust = 0.5), 
        axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
        axis.title = element_text(size = 9),
        legend.position = "none") 

png(paste0("./barplot_v2/barplot_",wwtp,"_first.png"),width = 320*3, height = 518*3, res = 300) #460
#png(paste0("./barplot_v2/barplot_",wwtp,"_first.png"),width = 460*3, height = 518*3, res = 300) #460

plot(gp)
dev.off()


wwtp <- "USF"
wwtp_title <- "Non-potable Reuse Facility"

wwtp <- "HRSD"
wwtp_title <- "Potable Reuse Facility" #HRSD
cluster_info_second <- read.csv(paste0("./barplot_v2/", wwtp, "_cluster_info_second.csv"))

gp <- ggplot(cluster_info_second, aes(x = cluster, y = PPCP, fill = cluster)) +
  geom_bar(stat = "identity", width = 0.8, position = position_dodge()) + #0.8
  geom_text(aes(label=PPCP), vjust=-0.3, color="black",
            position = position_dodge(0.9), size=5) +
  labs(x = "", y = "Number of PPCPs", title = wwtp_title) +
  scale_fill_manual(values=c("#7FC97F","#386CB0","#C3B3D7")) +
  theme_bw() +
  theme(plot.title = element_text(size=16, face = "bold", hjust = 0.5), 
         legend.position = "none",
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 14))

png(paste0("./barplot_v2/barplot_",wwtp,"_second.png"),width = 370*3, height = 550*3, res = 300) #460, 320
plot(gp)
dev.off()

test$unit <- factor(test$unit, levels = c("Primary Clarification", "Activated Sludge", "Denitrification Filters", "Chlorination"))
ggplot(test, aes(x = unit, y = avg, group = 1)) +
  geom_errorbar(aes(ymin=avg-sd, ymax=avg+sd), width=.1, position=position_dodge(0.05)) +
  geom_line() +
  geom_point() +
  theme_bw()

#################################
###### Stacked bar plot #########
#################################
wwtp <- "usf"
data <- read.csv(paste0("./", wwtp, ".csv"))

#USF
usf_level <- c("Primary Clarification", "Activated Sludge", "Denitrification Filters", "Chlorination")
data$Cluster <- factor(data$Cluster, levels = usf_level)
title_name <- "Non-potable Reuse Facility"

#HRSD
#hrsd_level <- c("Primary Clarification", "Activated Sludge", "Coagulation-Sedimentation", "Ozonation", "BAF-GAC", "UV Disinfection", "Chlorination")
hrsd_level <- c("Primary Clarification", "Activated Sludge", "Coagulation-Sedimentation", "Ozonation", "BAC-GAC", "UV Disinfection")
data$Cluster <- factor(data$Cluster, levels = hrsd_level)
title_name <- "Potable Reuse Facility"


gp <- ggplot(data, aes(x = Cluster, fill = Category)) + 
  geom_bar() +
  labs(x = "Cluster", y = "# of PPCPs Most Efficiently Removed by the Treatment Process", title = title_name) +
  scale_fill_manual(values=c("#4E72BF", "#DE8344", "#A5A5A5", "#F5C242", "#6A99D0", "#7EAB55", "#2D4374")) +
  scale_y_continuous(breaks=seq(0,90,10)) +
  theme_bw() +
  theme(plot.title = element_text(size=11, face = "bold", hjust = 0.5), 
        axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
        axis.title = element_text(size = 9)) 

png(paste0("./barplot_",wwtp,"_first_v3.png"),width = 520*3, height = 518*3, res = 300) #460 600
#png(paste0("./barplot_",wwtp,"_second.png"),width = 520*3, height = 518*3, res = 300) #460
#png(paste0("./barplot_v2/barplot_",wwtp,"_first.png"),width = 460*3, height = 518*3, res = 300) #460

plot(gp)
dev.off()

#############################
###### Distribution #########
#############################
library(ggplot2)

wwtp <- "HRSD"
cluster_info_first <- read.csv(paste0("./barplot/", wwtp, "_cluster_info_first.csv"))

wwtp <- "usf"
#usf
color_theme <- c("grey","#7FC97F","#A4CDE2","#C3B3D7")
unit_level <- usf_level
count_list <- cluster_info_first$PPCP

# hrsd
wwtp <- "hrsd"
color_theme <- c("grey","#7FC97F","#FDB462","#386CB0", "#662506","#EF3B2C", "#C3B3D7")
#unit_level <- c("Activated Sludge", "Coagulation-Sedimentation", "Ozonation", "BAF-GAC")
unit_level <- c("Activated Sludge", "Coagulation-Sedimentation", "Ozonation", "BAC-GAC")

count_list <- c(28, 5, 83, 15)

i <- 2
tr_unit <- unit_level[i]
for (tr_unit in unit_level){
  USF <- read.csv(paste0("./distribution_normalized_v2/HRSD_", tr_unit, ".csv"))
  USF$unit <- factor(USF$unit, levels = hrsd_level)
  gp <- ggplot(USF, aes(x=unit, y=efficiency, fill=unit)) +
    geom_boxplot(width = 0.5) + #, outlier.shape = NA
    scale_y_continuous(limits = c(-10, 10)) +
    scale_fill_manual(values=color_theme) +
    labs(title = paste0("'", tr_unit, "' cluster  (n = ", count_list[i], " PPCPs)"), y = "Removal Efficiency", x= "") +
    theme_bw() +
    theme(plot.title = element_text(size=14, face = "bold", hjust = 0.5),
          axis.title.y = element_text(size = 12),
          #axis.text.x = element_blank(),
          axis.text.x = element_text(size = 12, angle = 45, hjust = 1), #
          legend.position = "none")
  i <- i + 1
  
  #png(paste0("./distribution_normalized/boxplot_",wwtp, "_", tr_unit,".png"),width = 557*3, height = 207*3, res = 300) #460, 320
  png(paste0("./distribution_normalized_v2/boxplot_",wwtp, "_", tr_unit,".png"),width = 900*3, height = 360*3, res = 300) #460, 320
  plot(gp)
  dev.off()
}

#################################
####### Boxplot accuracy ########
#################################
library(ggplot2)
#results$wwtp <- factor(results$wwtp, levels = c("USF", "HRSD"))
results$wwtp <- factor(results$wwtp, levels = c("Non-potable Reuse Facility", "Potable Reuse Facility"))
results$method <- factor(results$method, levels = c("SVM", "RF", "LR"))

gp <- ggplot(results, aes(x=wwtp, y=acc, fill=method)) +
  geom_boxplot() +
  scale_y_continuous(breaks=seq(0.0,1.0,0.2), limits = c(0.0, 0.8)) +
  scale_fill_manual(values=c("#7FC97F","#FDB462","#386CB0")) +
  labs(x = "", y = "Accuracy", fill = "ML classification methods") +
  theme_bw() +
  theme(axis.title = element_text(size = 10, face = "bold"), 
        legend.title = element_text(size = 10, face = "bold"))

png("./accuracy_boxplot/boxplot_acc_second_v2.png",width = 488*3, height = 290*3, res = 300) #460, 320
plot(gp)
dev.off()


#####################
### Sankey ##########
#####################
library(ggsankey)
library(ggplot2)
library(dplyr)

TotalCount = nrow(kmeans_ppcp)

df <- kmeans_ppcp %>%
  make_long(cluster, cluster_ab)

dagg <- df%>%
  dplyr::group_by(node)%>%
  tally()

dagg <- dagg%>%
  dplyr::group_by(node)%>%
  dplyr::mutate(pct = n/TotalCount)

df2 <- merge(df, dagg, by.x = 'node', by.y = 'node', all.x = TRUE)

gp <- ggplot(df2, aes(x = x, next_x = next_x, node = node, next_node = next_node, 
               fill = factor(node), 
               label = paste0(node,"  n=", n, ' (',  round(pct* 100,1), '%)' )))+
  geom_sankey(flow.alpha = 0.5, node.color = "black",show.legend = F) +
  geom_sankey_label(size = 5, color = "black", fill= "white") +
  theme_bw() +
  theme(legend.position = "none") +
  theme(axis.title = element_blank()
        , axis.text = element_blank()
        , axis.ticks = element_blank()  
        , panel.grid = element_blank()) 
  #scale_fill_viridis_d(option = "inferno")

png("./sankey_v2/sankey_second_hrsd.png",width = 817*3, height = 467*3, res = 300) #460, 320
plot(gp)
dev.off()

###################
##### Fig 2 ######
##################
library(ggplot2)
color_scheme <- c("#4E72BF", "#DE8344", "#A5A5A5", "#F5C242", "#6A99D0", "#7EAB55", "#2D4374")

gp <- ggplot(input_fig2_a, aes(x="", y = num, fill = Category)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  scale_fill_manual(values = color_scheme) + 
  #theme_bw() +
  #theme_classic() +
  theme_minimal() +
  theme(plot.title = element_blank(), 
        axis.text.x = element_blank(),
        axis.title = element_blank()) 

png("./fig2_a.png",width = 517*3, height = 407*3, res = 300) #460, 320
plot(gp)
dev.off()


gp <- ggplot(input_fig2_b, aes(x=reorder(ppcp, -occur), y = occur)) +
  geom_bar(stat = "identity", fill = "#324270") +
  scale_y_continuous(breaks=seq(0,18,2)) +
  labs(y = "Category Occurance") +
  theme_classic() +
  theme(plot.title = element_text(size=14, face = "bold", hjust = 0.5),
        #axis.title.y = element_text(size = 12),
        axis.title.x = element_blank(),
        #axis.text.x = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1), #
        legend.position = "none")

png("./fig2_b.png",width = 635*3, height = 407*3, res = 300) #460, 320
plot(gp)
dev.off()
