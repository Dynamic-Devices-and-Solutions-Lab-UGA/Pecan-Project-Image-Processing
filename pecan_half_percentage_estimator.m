est_total = convex_area_estimator('Pecan Test Images/20220315_124252.jpg');
est_half = convex_area_estimator('Pecan Test Images/20220315_125505.jpg');

perc = 100*(est_half/est_total)