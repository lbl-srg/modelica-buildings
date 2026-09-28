within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1Linearized "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1(
    pla(linearized=true))
      annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
    Documentation(info="Sizes after manipulation of the nonlinear systems: {8, 1, 1, 1, 1, 1}
Number of numerical Jacobians: 2

SUNDIALS: CVODE CVode At t = 39784.6, mxstep steps taken before reaching tout.
SUNDIALS: CVODE CVode At t = 47296.5, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 3.95661 seconds
   CPU-time for initialization               : 0.320199 seconds
   Number of result points                   : 1595
   Number of grid points                     : 501
   Number of accepted steps                  : 16895
   Number of rejected steps                  : 575
   Number of f-evaluations (dynamics)        : 25737
   Number of non-linear iteration            : 24582
   Number of non-linear convergence failures : 926
   Number of Jacobian-evaluations            : 1388
   Number of crossing function evaluations   : 19720
   Number of model time events               : 415
   Number of state events                    : 134
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1Linearized"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end HardCase1Linearized;
