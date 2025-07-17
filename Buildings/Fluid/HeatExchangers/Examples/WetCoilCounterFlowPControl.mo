within Buildings.Fluid.HeatExchangers.Examples;
model WetCoilCounterFlowPControl
  "Model that demonstrates use of a heat exchanger with condensation and with feedback control"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.HeatExchangers.Examples.BaseClasses.PartialWetCoilCounterFlow;

  Buildings.Controls.Continuous.LimPID con(
    Td=1,
    reverseActing=false,
    yMin=0,
    k=0.1,
    Ti=60) "Controller"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
equation
  connect(con.u_m, temSen.T)
    annotation (Line(points={{10,88},{10,31}}, color={0,0,127}));
  connect(TSet.y, con.u_s)
    annotation (Line(points={{-59,100},{-2,100}}, color={0,0,127}));
  connect(con.y, val.y)
    annotation (Line(points={{21,100},{40,100},{40,72}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})),
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilCounterFlowPControl.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>.
The valve on the water-side is regulated to track a setpoint temperature
for the air outlet.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 14, 2023 by Jianjun Hu:<br/>
Reduced the nominal airflow rate and the water temperature.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3607\">#3607</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Added nominal pressure drop for valve as
this parameter no longer has a default value.
</li>
<li>
May 27, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetCoilCounterFlowPControl;
