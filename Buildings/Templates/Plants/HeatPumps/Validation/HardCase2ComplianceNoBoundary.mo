within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase2ComplianceNoBoundary
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase2(
    pla(use_cpl=true, use_bouHeaWat=false, use_bouChiWat=false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(revisions="NL solver failures in Buildings/dslog.txt
  Reported blocks (with diagnostics)  : 1

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.92072 seconds
   CPU-time for initialization               : 0.345779 seconds
   Number of result points                   : 2003
   Number of grid points                     : 501
   Number of accepted steps                  : 16887
   Number of rejected steps                  : 587
   Number of f-evaluations (dynamics)        : 25915
   Number of non-linear iteration            : 24327
   Number of non-linear convergence failures : 889
   Number of Jacobian-evaluations            : 1473
   Number of crossing function evaluations   : 20581
   Number of model time events               : 478
   Number of state events                    : 275
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase2ComplianceNoBoundary"));
end HardCase2ComplianceNoBoundary;
