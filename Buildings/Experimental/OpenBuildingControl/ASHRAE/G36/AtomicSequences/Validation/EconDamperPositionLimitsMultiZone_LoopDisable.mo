within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconDamperPositionLimitsMultiZone_LoopDisable
  "Validation model for setting the min econ damper limit and max return air damper limit."
  extends Modelica.Icons.Example;

  CDL.Logical.Constant FanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Continuous.Constant VOutMinSet(k=0.5) "Outdoor airflow rate setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Sources.Ramp        VOut(
    height=0.2,
    duration=1800,
    offset=0.4) "Outdoor flow rate"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Sources.BooleanPulse AHUMode(period=1800, width=0.6)
    "AHU Mode changes from True to False"
    annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));
  EconDamperPositionLimitsMultiZone econMinOutAirDamPosLimits
    "One of the economizer control sequences, it sets the min econ damper limit and the max return air damper limit in order to maintain the minimum outdoor airflow setpoint."
    annotation (Placement(transformation(extent={{-20,18},{0,38}})));
equation
  connect(VOutMinSet.y, econMinOutAirDamPosLimits.uVOutMinSet) annotation (Line(
        points={{-59,70},{-42,70},{-42,33},{-21,33}}, color={0,0,127}));
  connect(VOut.y, econMinOutAirDamPosLimits.uVOut) annotation (Line(points={{-59,30},
          {-42,30},{-42,36},{-21,36}},     color={0,0,127}));
  connect(FanStatus.y, econMinOutAirDamPosLimits.uSupFan) annotation (Line(
        points={{-59,-10},{-36,-10},{-36,28},{-21,28}}, color={255,0,255}));
  connect(AHUMode.y, econMinOutAirDamPosLimits.uAHUMod) annotation (Line(points={{-59,-44},
          {-30,-44},{-30,22.375},{-21.1111,22.375}},
                                                  color={255,0,255}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/EconDamPosLimitsMultiZone_AHU.mos"
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
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconDamPosLimitsMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconDamPosLimitsMultiZone</a>
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
end EconDamperPositionLimitsMultiZone_LoopDisable;
