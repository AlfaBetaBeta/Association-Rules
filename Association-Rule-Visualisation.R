library(readxl)
library(ggplot2)
theme_set(theme_minimal(base_size = 12))

# Path and input settings
my.path <- './'
my.file <- 'Training_courses_2019.xlsx'
sheet <- 1
my.plot.path <- paste0(my.path, 'plots/')
my.lift.path <- paste0(my.path, 'metric-lift/')
my.confratio.path <- paste0(my.path, 'metric-confidence-ratio/')

# Read original dataset into a data.frame
df <- read_excel(paste0(my.path, my.file), sheet = sheet)
df <- as.data.frame(df)
rownames(df) <- df$TICKET
df$TICKET <- NULL

# Get support of all items (courses)
support <- apply(df, 2, function(x) {sum(x)/length(x)})
metrics_df <- data.frame(support=support, instances=support*nrow(df))
metrics_df <- metrics_df[order(metrics_df$support, decreasing = TRUE), ]

# Save the support bar diagram as a png file in the appropriate directory
png(paste0(my.plot.path, 'support-distribution.png'),  width = 1500, height = 1000)
 par(mar = c(2, 4, 2, 2))
 ggplot(data = metrics_df,
        aes(x = reorder(rownames(metrics_df), -support),
            y = support)) +
    geom_bar(stat = 'Identity') +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    xlab('Courses') +
    ylab('Support') +
    theme(plot.title = element_text(hjust = 0.5, face = 'bold'),
          axis.title = element_text(face = 'bold'))
dev.off()

# Get count of itemset size and save it as a png file in the appropriate directory
df[,'Number of courses'] <- apply(df, 1, sum)
png(paste0(my.plot.path, 'courses-per-ticket.png'),  width = 700, height = 500)
 par(mar = c(2, 2, 2, 2))
 ggplot(data = df,
        aes(x = factor(`Number of courses`))) +
    geom_bar(stat = 'count') +
    scale_x_discrete(breaks = seq(1,12,1)) +
    xlab('Number of courses per ticket') +
    ylab('Count') +
    theme(axis.title = element_text(face = 'bold'))
dev.off()

# Retrieve data.frames with rules using LIFT as controlling metric
lift.df.list <- list()
for (j in 1:12) {
    j.name <- paste0(c('lift_c', j, '.csv'), collapse = '')
    lift.df.list[[j]] <- as.data.frame(read.csv(paste0(my.lift.path, j.name)))
}

# Define function for plotting purposes
plot_lift <- function(df, threshold, min.support, min.confidence) {
    p <- ggplot(data = df,
                mapping = aes(x=antecedent.s.,
                              y=consequent.s.,
                              fill=confidence,
                              size=lift)) +
         geom_point(shape = 21, color = ifelse(df$lift<1, 'red', 'black')) +
         theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
         scale_fill_gradient(low = 'grey', high = 'black') +
         ggtitle(paste0('metric = lift    min.threshold = ', threshold,
                        '    min.support = ', min.support, '    min.confidence = ',min.confidence)) +
         theme(plot.title = element_text(hjust = 0.5, face = 'bold'),
               axis.title = element_text(face = 'bold'))
    return(p)
}
# Define grid of thresholds
threshold.grid <- rep(c(1, 0.5), each = 6)
min.support.grid <- rep(rep(c(0.2, 0.1), each = 3), 2)
min.confidence.grid <- rep(c(0.5, 0.4, 0.3), 4)
lift.plot.list <- list()

# Create rule plots iteratively
for (j in 1:length(lift.df.list)) {
    lift.plot.list[[j]] <- plot_lift(lift.df.list[[j]],
                                     threshold.grid[j],
                                     min.support.grid[j],
                                     min.confidence.grid[j])
}
# Save each plot as a png file in the appropriate directory
for (j in 1:length(lift.plot.list)) {
    j.name <- paste0(c('lift_c', j, '.png'), collapse = '')
    ggsave(j.name,
           plot = lift.plot.list[[j]],
           device = 'png',
           path = my.plot.path,
           width = 30, height = 20, units = 'cm')
}

# Retrieve data.frames with rules using CONFIDENCE RATIO as controlling metric
confratio.df.list <- list()
for (j in 1:14) {
    j.name <- paste0(c('confidence_ratio_c', j, '.csv'), collapse = '')
    confratio.df.list[[j]] <- as.data.frame(read.csv(paste0(my.confratio.path, j.name)))
}

# Define function for plotting purposes
plot_conf_ratio <- function(df, threshold, min.support, min.confidence, min.rulesupport) {
    p <- ggplot(data = df,
                mapping = aes(x=antecedent.s.,
                              y=consequent.s.,
                              fill=confidence,
                              size=confidence.ratio)) +
         geom_point(shape = 21, color = ifelse(df$lift<1, 'red', 'black')) +
         theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
         scale_fill_gradient(low = 'grey', high = 'black') +
         ggtitle(paste0('metric = conf.ratio    min.threshold = ', threshold,
                        '    min.support = ', min.support, '    min.confidence = ',min.confidence,
                        '    min.rulesupport = ', min.rulesupport)) +
         theme(plot.title = element_text(hjust = 0.5, face = 'bold'),
               axis.title = element_text(face = 'bold'))
    return(p)
}
# Define grid of thresholds
threshold.grid <- c(0.9, 0.9, 0.9, 0.7, 0.7)
min.support.grid <- rep(0, 5)
min.confidence.grid <- c(0.5, 0.4, 0.3, 0.6, 0.6)
min.rulesupport.grid <- c(0.01, 0.01, 0.01, 0.02, 0.03)
confratio.plot.list <- list()

# Create rule plots iteratively (only five can be feasibly visualised)
for (j in (10:14)) {
    confratio.plot.list[[j]] <- plot_conf_ratio(confratio.df.list[[j]],
                                                threshold.grid[j-9],
                                                min.support.grid[j-9],
                                                min.confidence.grid[j-9],
                                                min.rulesupport.grid[j-9])
}
# Save each plot as a png file in the appropriate directory
for (j in 1:length(confratio.plot.list)) {
    j.name <- paste0(c('confidence_ratio_c', j, '.png'), collapse = '')
    ggsave(j.name,
           plot = confratio.plot.list[[j]],
           device = 'png',
           path = my.plot.path,
           width = 50, height = 30, units = 'cm')
}

# Aggregate data.frames in `confratio.df.list` to see the number of unique consequents
confratio.df.agg.list <- list()
for (j in 1:length(confratio.df.list)) {
    confratio.df.agg.list[[j]] <- aggregate(confratio.df.list[[j]]$antecedent.s.,
                                            by = list(consequent=confratio.df.list[[j]]$consequent.s.),
                                            FUN = length)
    colnames(confratio.df.agg.list[[j]])[2] <- 'count'
}

# Aggregate data.frames in `confratio.df.list` to see avg.confidence vs avg.lift per unique consequent
confratio.df.agg.lvscr <- list()
for (j in 1:length(confratio.df.list)) {
    confratio.df.agg.lvscr[[j]] <- aggregate(confratio.df.list[[j]][,c('confidence','lift')],
                                             by = list(consequent=confratio.df.list[[j]]$consequent.s.),
                                             FUN = mean)
    confratio.df.agg.lvscr[[j]] <- cbind(confratio.df.agg.lvscr[[j]],
                                         confratio.df.agg.list[[j]]$count)
    colnames(confratio.df.agg.lvscr[[j]])[4] <- 'Rule count'
}

# Define function for plotting purposes
plot_avglift_vs_avgcr <- function(df, threshold, min.support, min.confidence, min.rulesupport) {
    p <- ggplot(data = df,
                aes(x = confidence,
                    y = lift,
                    color = `Rule count`,
                    label = consequent,
                    size = 15)) +
        geom_point(size = df$`Rule count`, alpha = 0.5) +
        xlab('Avg.confidence for given consequent') +
        ylab('Avg.lift for given consequent') +
        theme(plot.title = element_text(hjust = 0.5, face = 'bold'),
              axis.title = element_text(face = 'bold')) +
        ggtitle(paste0('metric = conf.ratio    min.threshold = ', threshold,
                       '    min.support = ', min.support, '    min.confidence = ', min.confidence,
                       '    min.rulesupport = ', min.rulesupport)) +
        geom_text(aes(label=consequent), hjust=0.4, vjust=-0.4) +
        guides(size = FALSE)
}
# Define grid of thresholds
threshold.grid <- c(rep(c(0.5, 0.7, 0.8, 0.9), each = 3), rep(0.7, 2))
min.support.grid <- rep(0, 14)
min.confidence.grid <- c(rep(c(0.5, 0.4, 0.3), 4), rep(0.6, 2))
min.rulesupport.grid <- c(rep(0.01, 12), 0.02, 0.03)
avg.liftvscr.plot.list <- list()

# Create avg.lift-vs-avg.confratio plots iteratively
for (j in 1:length(confratio.df.list)) {
    avg.liftvscr.plot.list[[j]] <- plot_avglift_vs_avgcr(confratio.df.agg.lvscr[[j]],
                                                         threshold.grid[j],
                                                         min.support.grid[j],
                                                         min.confidence.grid[j],
                                                         min.rulesupport.grid[j])
}
# Save each plot as a png file in the appropriate directory
for (j in 1:length(avg.liftvscr.plot.list)) {
    j.name <- paste0(c('confidence_ratio_lift_vs_confidence_c', j, '.png'), collapse = '')
    ggsave(j.name,
           plot = avg.liftvscr.plot.list[[j]],
           device = 'png',
           path = my.plot.path,
           width = 50, height = 30, units = 'cm')
}


# Visualisation of rule frequency in terms of threshold values
lift.thresholds <- data.frame(metric = 'lift',
                              threshold = rep(c(1, 0.5), each = 6),
                              min.rulesupport = rep(0, 12),
                              min.support = rep(rep(c(0.2, 0.1), each = 3), 2),
                              min.confidence = rep(c(0.5, 0.4, 0.3), 4),
                              no.rules = sapply(lift.df.list, nrow))

confratio.thresholds <- data.frame(metric = 'conf.ratio',
                                   threshold = c(rep(c(0.5, 0.7, 0.8, 0.9), each=3), rep(0.7, 2)),
                                   min.rulesupport = c(rep(0.01, 12), 0.02, 0.03),
                                   min.support = rep(0, 14),
                                   min.confidence = c(rep(c(0.5, 0.4, 0.3), 4), rep(0.6, 2)),
                                   no.rules = sapply(confratio.df.list, nrow))

p.lift.pos <- ggplot(data = lift.thresholds[1:6,],
                     mapping = aes(x = factor(min.support),
                                   y = factor(min.confidence),
                                   size = no.rules)) +
              geom_point() +
              ggtitle('Number of rules per threshold setting (min.lift = 1)') +
              theme(plot.title = element_text(hjust = 0.5, face = 'bold'),
                    axis.title = element_text(face = 'bold')) +
              scale_x_discrete(breaks = c(0.1, 0.2)) +
              scale_y_discrete(breaks = c(0.3, 0.4, 0.5)) +
              xlab('Minimum support') +
              ylab('Minimum confidence')

p.lift.neg <- ggplot(data = lift.thresholds[7:12,],
                     mapping = aes(x = factor(min.support),
                                   y = factor(min.confidence),
                                   size = no.rules)) +
              geom_point() +
              ggtitle('Number of rules per threshold setting (min.lift = 0.5)') +
              theme(plot.title = element_text(hjust = 0.5, face = 'bold'),
                    axis.title = element_text(face = 'bold')) +
              scale_x_discrete(breaks = c(0.1, 0.2)) +
              scale_y_discrete(breaks = c(0.3, 0.4, 0.5)) +
              xlab('Minimum support') +
              ylab('Minimum confidence')

p.confratio <- ggplot(data = confratio.thresholds,
                      mapping = aes(x = factor(threshold),
                                    y = factor(min.confidence),
                                    size = no.rules)) +
               geom_point() +
               ggtitle('Number of rules per threshold setting') +
               theme(plot.title = element_text(hjust = 0.5, face = 'bold'),
                     axis.title = element_text(face = 'bold')) +
               scale_x_discrete(breaks = c(0.5, 0.7, 0.8, 0.9)) +
               scale_y_discrete(breaks = c(0.3, 0.4, 0.5, 0.6)) +
               xlab('Minimum confidence ratio') +
               ylab('Minimum confidence')
            
# Save the plots as png files in the appropriate directory
ggsave('rules_vs_thresholds1_metric_lift.png',
       plot = p.lift.pos,
       device = 'png',
       path = my.plot.path,
       width = 17, height = 10, units = 'cm')

ggsave('rules_vs_thresholds2_metric_lift.png',
       plot = p.lift.neg,
       device = 'png',
       path = my.plot.path,
       width = 17, height = 10, units = 'cm')

ggsave('rules_vs_thresholds_metric_confratio.png',
       plot = p.confratio,
       device = 'png',
       path = my.plot.path,
       width = 14, height = 10, units = 'cm')

