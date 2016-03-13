library(dplyr, warn.conflicts = FALSE)

# Download raw file (date assessed: March 8, 2016) ------------------------

url = "http://scholar.princeton.edu/sites/default/files/dalexand/files/obgyn_medicaid_fee_schedules_clean_1.xlsx"
lcl = "data-raw/obgyn_medicaid_fee_schedules_clean_1.xlsx"
if (!file.exists(lcl)) downloader::download(url, lcl)

readxl::read_excel(lcl) %>%
        tidyr::gather(CPT, fee, -State, -Postal, -Year, -Month) %>%
        tidyr::unite(yearmon, Year, Month, sep = "-", remove = FALSE) %>%
        rename(state = State,
               usps = Postal,
               year = Year,
               month = Month,
               cpt = CPT) %>%
        mutate(cpt = stringr::str_sub(cpt, 5L) %>% factor,
               yearmon = zoo::as.yearmon(yearmon)) -> csfee

# Save it! ----------------------------------------------------------------

devtools::use_data(csfee, overwrite = TRUE)
