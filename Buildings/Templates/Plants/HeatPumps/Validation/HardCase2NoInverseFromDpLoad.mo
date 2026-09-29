within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase2NoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase2NoInverse(
    loaCoo(con(val(from_dp=true, valEqu(use_inv=false)))),
    loaHea(con(val(from_dp=true, valEqu(use_inv=false)))))
  annotation(IconMap(primitivesVisible = false));

annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(revisions="",
        info="----------------- OCT 118 NonlinearBlockConvergenceError

Final Run Statistics: ---

 Number of steps                                 : 17606
 Number of function evaluations                  : 28065
 Number of Jacobian evaluations                  : 1606
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 613
 Number of nonlinear iterations                  : 25082
 Number of nonlinear convergence failures        : 403
 Number of state function evaluations            : 21237
 Number of state events                          : 269
 Number of time events                           : 473

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-08 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-06 1.e-06 1.e-06 1.e-01 1.e-01 1.e-01 1.e-01 1.e-01 1.e-06 1.e-01
 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-06
 1.e-01 3.e-04 1.e-01 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01
 1.e-01 3.e-04 3.e-04 1.e-01 1.e-06 1.e-01 3.e-04 1.e-01 1.e-01 1.e-01
 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01 1.e-01 1.e-01 3.e-04 3.e-04 1.e-06
 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04
 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01
 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 43.294151974998385 seconds."),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={244,125,35},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase2NoInverseFromDpLoad;
