within Buildings.ThermalZones.ReducedOrder.Validation.VDI6007.BaseClasses;
block VerifyDifferenceThreePeriods "Assert when condition is violated"
  extends Buildings.Utilities.Diagnostics.BaseClasses.PartialInputCheck(
    message="Inputs differ by more than threShold.\n  Check output 'satisfied' for when violation(s) happened.");
  parameter Modelica.SIunits.Time endTime = 0
    "Start time for deactivating the assert (period one)";
  parameter Modelica.SIunits.Time startTime2 = 0
    "Start time for activating the assert (period two)";
  parameter Modelica.SIunits.Time endTime2 = 0
    "Start time for deactivating the assert (period two)";
  parameter Modelica.SIunits.Time startTime3 = 0
    "Start time for activating the assert (period three)";
  parameter Modelica.SIunits.Time endTime3 = 0
    "Start time for deactivating the assert (period three)";

  Modelica.Blocks.Interfaces.BooleanOutput satisfied(start=true, fixed=true)
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

  Modelica.Blocks.Interfaces.RealOutput diff "Difference u1-u2"
    annotation (Placement(transformation(extent={{100,42},{140,82}}),
        iconTransformation(extent={{100,42},{140,82}})));
protected
  parameter Modelica.SIunits.Time t1(fixed=false)
    "Simulation end time period one";
  parameter Modelica.SIunits.Time t3(fixed=false)
    "Simulation end time period two";
  parameter Modelica.SIunits.Time t5(fixed=false)
    "Simulation end time period three";
  parameter Modelica.SIunits.Time t2(fixed=false)
    "Simulation start time period two";
  parameter Modelica.SIunits.Time t4(fixed=false)
    "Simulation start time period three";
  Integer nFai "Number of test violations";

initial equation
  t1 = time + endTime;
  t2 = time + startTime2;
  t3 = time + endTime2;
  t4 = time + startTime3;
  t5 = time + endTime3;
  nFai = 0;
equation
  if (time >= t0) and (time <= t1) or
     (time >= t2) and (time <= t3) or
     (time >= t4) and (time <= t5) then
     diff = abs(u1 - u2);
  else
    diff = 0; // Test is not needed in this time domain
  end if;
  // Output whether test is satisfied, using a small hysteresis that is scaled using threShold
  satisfied = not ( (pre(satisfied) and diff > 1.01*threShold) or (not pre(satisfied) and diff >= 0.99*threShold));

  // Count the number of failures and raise an assertion in the terminal section.
  // This ensures that if the model is in an FMU, no asserts are triggered during
  // the solver iterations.
  when not satisfied then
    nFai = pre(nFai) + 1;
  end when;

  when terminal() then
    assert(nFai == 0, message);
  end when;

annotation (
defaultComponentName="verDif",
Documentation(info="<html>
<p>
Block that outputs <code>satisfied = false</code> if
<code>abs(u1-u2) &gt; threShold</code> within the prescribed time intervals,
or <code>satisfied = true</code> otherwise.
</p>
<h4>Implementation</h4>
<p>
The test uses a hysteresis of plus/minus 1% in order to avoid
chattering if <code>abs(u1-u2)</code> is near <code>threShold</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 16, 2016, by Michael Wetter:<br/>
Reformulated model for
<a href=\"modelica://https://github.com/ibpsa/modelica-ibpsa/issues/623\">
https://github.com/ibpsa/modelica-ibpsa/issues/623</a>.
</li>
<li>
October 10, 2013, by Michael Wetter:<br/>
Reformulated model to allow scheduling of time events as opposed to state events,
and removed <code>noEvent</code> operator which is not needed as these
are only time events.
</li>
<li>
June 29, 2016, by Moritz Lauster:<br/>
First implementation.
</li>
</ul>
</html>"));
end VerifyDifferenceThreePeriods;
