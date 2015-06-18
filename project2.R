Data Science Specialism

Module 6 - Statistical Inference (June 2015)

Length of odontoblast cells in of Cavia porcellus (guinea pig) incisor teeth with reference to Vitamin C.

Author: Fiona Young

Submission date: 11 June 2012
--------------------------------------------------
SUMMARY

				===== what is was about? =====
				===== what did I do =====
				===== what were my findings? =====

--------------------------------------------------

INTRODUCTION

Cavia porcellus or the guinea pig/cavy is a domesticated animal of Order rodentia, family Caviidae (Wikipedia 2015a). An animal can live between five to seven years and as long as nine years (Guinea Lynx 2015a).  It is a typical rodent where the top and bottom incisor teeth continually grow thoroughout the lifespan of the animal, hence the urge to constantly gnaw.  The guinea pig used to be a model organism for experiments but replaced by mice and rats (Wikipedia 2015b).

Vitamin C is "derived from glucose so many non-human animals are able to produce it, but guinea pigs lack the ability to produce ascorbic acid so it must be added to their diet as a supplement" (Wikipedia 2015c).  The average guinea pig requires 10 to 30 mg per kilogram per day.  Without Vitamin C the disease scurvy results.  The symptoms of which are lethargy, hopping instead of walking, refusal to eat, diarrhoea, discharges from eyes and nose, rough coat, poor flesh condition, tenderness to touch and internal skeletal-muscular hemorrhage (Guinea Lynx 2000b).  Without Vitamin C growth of all tissues is greatly reduced including the growth of odontoblast cells that are responsible for increasing tooth length.

In this analysis we are to revisit the data from Crampton (1947)held in the R datasets library package (CRAN 2015).

Normally our null hypothesis would state that ascorbic acid given in either as Ascorbic Acid or orange juice will have no effect on the length of odontoblast cells in Guinea pig incisor teeth however, there is no control samples i.e. guinea pigs given no Vitamin C as this would breach research experimental ethics and be seriously detrimental of guinea pig health.

Thus our null hypothesis is that ascorbic acid given in either as Ascorbic acid or orange juice supplement has the same effect on the length of odontoblast cells of guinea pig incisor teeth.

	
METHODOLOGY / DATA PROCESSING

To test the hypothesis will require the usage of a t test for matched samples using the following assumptions:

no more than 30 variables for each sample group;
sample measurements are numeric;
the samples come from a single normal population density function (e.g. matched samples);
testing for the differences between the sample means for each dosage.

Ascorbic acid in 0.5, 1 and 2 mg dosages was given to 10 guinea pigs as either as Ascorbic Acid (Group 1) or in Orange Juice (Group 2).

We shall now analyse this dataset:

##1 - loading libraries	   
library(datasets)
library(stringr)
library(stats)
library(reshape2)
library(ggplot2)
library(dplyr)

##1.1 - What hardware/software environment am I using for this analysis?
sessionInfo()

	##2 - creating a dataset for analysis
	dataset <- ToothGrowth

		##3 - explore the dataset

		##3.1 - number of rows and columns
		dim(dataset)
		
		##3.2 - what the dataset contains
		str(dataset)
		
		##3.3 - the first five and last five rows
		head(dataset)
		tail(dataset)

The dataset consists of three columns: len, supp and dose in 60 rows.  To make the dataset easier to read the column headers and supplement types will be renamed.
		
			##4 - renaming the column header for easier understanding
			names(dataset) <- gsub("len", "odontoblast.length.in.microns", names(dataset))
			names(dataset) <- gsub("supp", "supplement.type", names(dataset))
			names(dataset) <- gsub("dose", "dosage.amount.in.mg", names(dataset))

				##5 - renaming OJ and VC row variables
				dataset$supplement.type = ifelse(dataset$supplement.type == "VC", "AscorbicAcid", dataset$supplement.type)
				dataset$supplement.type = ifelse(dataset$supplement.type == "1", "OrangeJuice", dataset$supplement.type)

##statistical calculations

We shall now calculate mean, variance and standard deviation of each dosage by supplement type.

##1 - calculating by supplement and dosage
melted <- melt(dataset, id.vars = c("supplement.type", "dosage.amount.in.mg"))
calculatedmeans <- dcast(melted, supplement.type ~ dosage.amount.in.mg, mean)
colnames(calculatedmeans) <- c("supplement type", "0.5 mg dose", "1 mg dose", "2 mg dose")

		##3 - variance by supplement and dosage
		calculatedvariance <- dcast(melted, supplement.type ~ dosage.amount.in.mg, var)
		colnames(calculatedvariance) <- c("supplement.type", "0.5 mg dose", "1 mg dose", "2 mg dose")

			##4 - standard deviation by supplement and dosage
			calculatedsd <- dcast(melted, supplement.type ~ dosage.amount.in.mg, sd)
			colnames(calculatedsd) <- c("supplement type", "0.5 mg dose", "1 mg dose", "2 mg dose")

RESULTS

##1 - mean, variance and standard deviation

##1.1 - mean by supplement and dosage
Table 1. Mean of odontoblast cell length by supplement and dosage regime

calculatedmeans

As you can see the as the dosage increases the odontoblast cell length increases for both supplement types (table 1).  Although both peak at 26 microns at the 2 mg dose the Ascorbic Acid values have risen faster than orange juice.

	##1.2 - variance by supplement and dosage
	Table 2. Variance of odontoblast cell length by supplement and dosage regime
		
	calculatedvariance

	The variance reduces as the orange juice dose increases but rises for Ascorbic Acid.

		##1.3 - standard deviation by supplement and dosage
		Table 3. Standard deviation of odontoblast cell length by supplement and dosage regime

		calculatedstandarddeviation

		The standard deviation decreases in as orange juice dosage increases and remains approximately the same for Ascorbic acid.

##GRAPH

##1 - Boxplot of odontoblast cell length vs Vitamin C supplement and dosage
boxy <- ggplot(data = dataset) +
geom_boxplot(aes(y = odontoblast.length.in.microns, x = dosage.amount.in.mg)) +
facet_grid(dosage.amount.in.mg ~ supplement.type,  
scales = "free") + 
theme_bw() +
labs(list(title = "Odontoblast cell length of guinea pig incisor teeth\nby Vitamin C supplement and dosage\n", x = "Dosage (mg)", y = "Odontoblast cell length (microns)\n"))
boxy

##HYPOTHESIS TESTING USING T-TEST - between the means of each group for each dosage level

##1 - t-test for matched pairs - dosage 0.5mg
t.test(dataset$odontoblast.length.in.microns[c(1:10)] - dataset$odontoblast.length.in.microns[c(31:40)])



	##2 - t-test for matched pairs - dosage 1.0 mg
	t.test(dataset$odontoblast.length.in.microns[c(11:20)] - dataset$odontoblast.length.in.microns[c(41:50)])

		##3 - t-test for matched pairs - dosage 2.0 mg
		t.test(dataset$odontoblast.length.in.microns[c(21:30)] - dataset$odontoblast.length.in.microns[c(51:60)])
	
CONCLUSION






REFERENCES

http://cran.r-project.org/ (2015) Tooth Growth from the R library(datasets), R Documentation accessed at 15:16 on 7 June 2015 from  http://127.0.0.1:27055/library/datasets/html/ToothGrowth.html

C. I. Bliss (1952) The Statistics of Bioassay. Academic Press.

McNeil D R (1977) Interactive Data Analysis. New York: Wiley.
Examples

Wikipedia (2015c) Ascorbic acid accessed at 14:45 on 12 June 2015 from https://en.wikipedia.org/wiki/Ascorbic_acid

Crampton E W (1947) The growth of the odontoblasts of the incisor tooth as a criterion of the Vitamin C intake of the Guinea Pig, Journal of Nutrition, pp 491 - 504

Guinea Lynx (2000a) Raising a healthy guinea pig accessed at 11:00 on 13 June 2015 from http://www.guinealynx.info/healthycavy.html

Guinea Lynx (2000b) Vitamin C deficiency accessed at 14:50 on 12 June 2015 from http://www.guinealynx.info/scurvy.html

Wikipedia (2015a) Guinea pig accessed at 11:08 on 13 June 2015 from https://en.wikipedia.org/wiki/Guinea_pig

Wikipedia (2015b) Rodent accessed at 11:05 on 13 June 2015 from https://en.wikipedia.org/wiki/Rodent


APPENDICES

