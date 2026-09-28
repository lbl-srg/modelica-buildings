within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase2BoundaryHPOutlet "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase2(
    pla(locBou=Buildings.Templates.Plants.HeatPumps.Types.LocationBoundary.HeatPumpOutlet));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(revisions="NL solver failures in Buildings/dslog.txt
  Reported blocks (with diagnostics)  : 1

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.8595 seconds
   CPU-time for initialization               : 0.35376 seconds
   Number of result points                   : 1973
   Number of grid points                     : 501
   Number of accepted steps                  : 16631
   Number of rejected steps                  : 569
   Number of f-evaluations (dynamics)        : 25598
   Number of non-linear iteration            : 24048
   Number of non-linear convergence failures : 889
   Number of Jacobian-evaluations            : 1466
   Number of crossing function evaluations   : 20172
   Number of model time events               : 477
   Number of state events                    : 261
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase2BoundaryHPOutlet"));
end HardCase2BoundaryHPOutlet;
