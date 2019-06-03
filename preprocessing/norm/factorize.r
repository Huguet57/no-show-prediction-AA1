dd$PatientId <- factor(dd$PatientId,
                       levels = unique(dd$PatientId))
dd$Gender <- factor(dd$Gender,
                    levels = unique(dd$Gender))

dd$No.show <- factor(dd$No.show,
                     levels = unique(dd$No.show),
                     labels = c("Show", "NoShow"))

dd$Scholarship <- factor(dd$Scholarship,
                         levels = unique(dd$Scholarship),
                         labels = c("No", "Yes"))

dd$Hipertension <- factor(dd$Hipertension,
                          levels = unique(dd$Hipertension),
                          labels = c("Yes", "No"))

dd$Diabetes <- factor(dd$Diabetes,
                      levels = unique(dd$Diabetes),
                      labels = c("No", "Yes"))

dd$Alcoholism <- factor(dd$Alcoholism,
                        levels = unique(dd$Alcoholism),
                        labels = c("No", "Yes"))

dd$Handcap <- dd$Handcap > 0
dd$Handcap <- factor(dd$Handcap,
                     levels = unique(dd$Handcap),
                     labels = c("No", "Yes"))

dd$SMS_received <- factor(dd$SMS_received,
                          levels = unique(dd$SMS_received),
                          labels = c("No", "Yes"))