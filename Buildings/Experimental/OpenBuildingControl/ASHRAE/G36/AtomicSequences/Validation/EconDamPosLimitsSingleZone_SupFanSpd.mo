within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconDamPosLimitsSingleZone_SupFanSpd
  "Validation model for setting the min econ damper limit for single zone control"
  extends Modelica.Icons.Example;

  CDL.Continuous.Constant VOutMinSet(k=1.6) "Outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-80,44},{-60,64}})));
  CDL.Sources.Ramp uSupFanSpd(
    height=0.8,
    duration=1800,
    offset=0.1)  "Current supply fan speed"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  CDL.Logical.Constant AHUMode(k=true) "AHU is enabled"
    annotation (Placement(transformation(extent={{-80,-64},{-60,-44}})));
  EconDamperPositionLimitsSingleZone econMinOutAirDamPosLimits
    "One of the economizer control sequences, it sets the min econ damper limit and the max return air damper limit in order to maintain the minimum outdoor airflow setpoint."
    annotation (Placement(transformation(extent={{28,-12.2353},{48,7.7647}})));
equation
  connect(VOutMinSet.y, econMinOutAirDamPosLimits.uVOutMinSet) annotation (Line(
        points={{-59,54},{-38,54},{-38,4.11764},{26.8889,4.11764}},
                                                      color={0,0,127}));
  connect(uSupFanSpd.y, econMinOutAirDamPosLimits.uSupFanSpd) annotation (Line(
        points={{-59,0},{-16,0},{-16,-0.705888},{26.8889,-0.705888}}, color={0,0,
          127}));
  connect(AHUMode.y, econMinOutAirDamPosLimits.uAHUMod) annotation (Line(points={{-59,-54},
          {-38,-54},{-38,-9.88236},{26.8889,-9.88236}},           color={255,0,255}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/EconDamPosLimitsSingleZone_SupFanSpd.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1800.0),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconDamPosLimitsSingleZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconDamPosLimitsSingleZone</a>
for different control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
May 03, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconDamPosLimitsSingleZone_SupFanSpd;
