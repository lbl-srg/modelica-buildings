within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase4NoInverse "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase4(
        pla(
      valIso(
        valHeaWatUniOutIso(lin(each use_inv=false)),
        valHeaWatUniInlIso(lin(each use_inv=false)),
        valChiWatUniOutIso(lin(each use_inv=false)),
             valChiWatUniInlIso(lin(each use_inv=false)))))
     annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Final Run Statistics: ---

 Number of steps                                 : 19961
 Number of function evaluations                  : 31887
 Number of Jacobian evaluations                  : 1767
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 682
 Number of nonlinear iterations                  : 28575
 Number of nonlinear convergence failures        : 456
 Number of state function evaluations            : 24267
 Number of state events                          : 351
 Number of time events                           : 475

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-06 1.e-06
 1.e-01 1.e-01 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06
 1.e-01 1.e-06 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-01 1.e-01 1.e-06 1.e-01
 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08
 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04
 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 32.69266726800015 seconds."),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase4NoInverse;
