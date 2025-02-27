within Buildings.Fluid.HeatExchangers.Examples;
model WetCoilCounterFlowPIControlAutoTuning
  "Model that demonstrates the use of a heat exchanger with condensation and with autotuning PI feedback control"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.HeatExchangers.Examples.BaseClasses.PartialWetCoilCounterFlow;

  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.FirstOrderAMIGO
    con(
    r=5,
    yHig=0.91,
    yLow=0.1,
    deaBan=0.1,
    yRef=0.5,
    reverseActing=false)
    "Controller"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant resSig(k=false)
    "Reset signal"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse autTunSig(
    width=0.2,
    period=2000,
    shift=100)
    "Signal for enabling the autotuning"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
equation
  connect(resSig.y, con.triRes) annotation (Line(points={{-58,170},{-20,170},{-20,
          80},{4,80},{4,88}}, color={255,0,255}));
  connect(autTunSig.y, con.triTun) annotation (Line(points={{-58,140},{-28,140},
          {-28,76},{16,76},{16,88}},
                                color={255,0,255}));
  connect(TSet.y, con.u_s)
    annotation (Line(points={{-59,100},{-2,100}}, color={0,0,127}));
  connect(temSen.T, con.u_m)
    annotation (Line(points={{10,31},{10,88}}, color={0,0,127}));
  connect(con.y, val.y)
    annotation (Line(points={{22,100},{40,100},{40,72}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})),
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilCounterFlowPIControlAutoTuning.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example is identical to 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.WetCoilCounterFlowPControl\">
Buildings.Fluid.HeatExchangers.Examples.WetCoilCounterFlowPControl</a> except that the PI controller
is replaced with an autotuning PI controller.
</p>
The autotuning is triggered twice.
<ul>
<li>
The first one occurs at <i>100</i> seconds and it completes successfully,
with the tuned PI parameters taking effect at <i>215</i> seconds.
</li>
<li>
The second one occurs at <i>2100</i> seconds and it fails because the setpoint
changes at <i>2400</i> seconds.
Thus, the PI input gains remain the same as the one from previous tuning.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
March 8, 2024, by Michael Wetter:<br/>
Removed wrong normalization.
</li>
<li>
November 28, 2023, by Sen Huang:<br/>
Replaced the PI controller with an autotuning PI controller.
</li>
</ul>
</html>"));
end WetCoilCounterFlowPIControlAutoTuning;
