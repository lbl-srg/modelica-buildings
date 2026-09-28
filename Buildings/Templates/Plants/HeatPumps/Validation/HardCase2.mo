within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase2 "Validation of AWHP plant template"
  // linearized=true is detrimental in this case!
  // with linearized=true: simulation fails on native amd64 Linux, succeeds on emulated amd64.
  // with linearized=false: simulation SUCCEEDS on native amd64 Linux as well.
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversibleHeatRecovery(
    pla(
      linearized=false,
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversibleHeatRecovery,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
      typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
      ctl(have_senDpHeaWatRemWir=false)));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(revisions="NL solver failures in Buildings/dslog.txt
  Reported blocks (with diagnostics)  : 2

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.98328 seconds
   CPU-time for initialization               : 0.373712 seconds
   Number of result points                   : 1987
   Number of grid points                     : 501
   Number of accepted steps                  : 16407
   Number of rejected steps                  : 566
   Number of f-evaluations (dynamics)        : 25051
   Number of non-linear iteration            : 23483
   Number of non-linear convergence failures : 819
   Number of Jacobian-evaluations            : 1405
   Number of crossing function evaluations   : 20070
   Number of model time events               : 477
   Number of state events                    : 268
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase2"));
end HardCase2;
