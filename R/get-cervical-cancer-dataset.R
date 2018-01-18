#==============================================================================
# Preparing dataset for cervical cancer classification
#==============================================================================
# Source:
# http://archive.ics.uci.edu/ml/datasets/Cervical+cancer+%28Risk+Factors%29
# Paper: http://www.inescporto.pt/~jsc/publications/conferences/2017KelwinIBPRIA.pdf

get.cervical.data = memoise(function(){
  cervical = read.csv(sprintf('%s/risk_factors_cervical_cancer.csv', data_dir), na.strings = c('?'), stringsAsFactors = FALSE)
  cervical = select(cervical, -Citology, -Schiller, -Hinselmann)
  cervical$Biopsy = factor(cervical$Biopsy, levels = c(1, 0), labels=c('Cancer', 'Healthy'))

  ## subset variables to the ones that should be used in the book
  cervical = dplyr::select(cervical, Age, Number.of.sexual.partners, First.sexual.intercourse,
  Num.of.pregnancies, Smokes, Smokes..years., Hormonal.Contraceptives, Hormonal.Contraceptives..years.,
  IUD, IUD..years., STDs, STDs..number., STDs..Number.of.diagnosis, STDs..Time.since.first.diagnosis,
  STDs..Time.since.last.diagnosis, Biopsy)

  # NA imputation
  imputer = mlr::imputeMode()


  cervical_impute = mlr::impute(cervical, classes = list(numeric = imputeMode()))
  cervical = cervical_impute$data
})

get.cervical.task = memoise(function(){
  cervical = get.cervical.data()
  mlr::makeClassifTask(id='cervical', data = cervical, target = 'Biopsy')
})