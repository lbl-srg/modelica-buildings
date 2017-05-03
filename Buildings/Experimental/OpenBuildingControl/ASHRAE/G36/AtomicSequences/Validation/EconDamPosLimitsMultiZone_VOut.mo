within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconDamPosLimitsMultiZone_VOut
  "Validation model for setting the min econ damper limit and max return air damper limit."
  extends Modelica.Icons.Example;

  CDL.Logical.Constant FanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Continuous.Constant VOutMinSet(k=0.5) "Outdoor airflow rate setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp VOut(
    duration=1800,
    height=0.2,
    offset=0.4)
    "TSup falls below 38 F and remains there for longer than 5 min. "
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Logical.Constant AHUMode(k=true) "AHU is enabled"
    annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));
  EconDamperPositionLimitsMultiZone econMinOutAirDamPosLimits
    "One of the economizer control sequences, it sets the min econ damper limit and the max return air damper limit in order to maintain the minimum outdoor airflow setpoint."
    annotation (Placement(transformation(extent={{-20,18},{0,38}})));
equation
  connect(VOutMinSet.y, econMinOutAirDamPosLimits.uVOutMinSet) annotation (Line(
        points={{-59,70},{-42,70},{-42,34.375},{-21.1111,34.375}},
                                                      color={0,0,127}));
  connect(VOut.y, econMinOutAirDamPosLimits.uVOut) annotation (Line(points={{-59,30},
          {-42,30},{-42,30.5},{-21.1111,30.5}},
                                           color={0,0,127}));
  connect(FanStatus.y, econMinOutAirDamPosLimits.uSupFan) annotation (Line(
        points={{-59,-10},{-36,-10},{-36,26.375},{-21.1111,26.375}},
                                                        color={255,0,255}));
  connect(AHUMode.y, econMinOutAirDamPosLimits.uAHUMod) annotation (Line(points={{-59,-44},
          {-30,-44},{-30,22.375},{-21.1111,22.375}},
                                                  color={255,0,255}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/EconDamPosLimitsMultiZone_VOut.mos"
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
March 31, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconDamPosLimitsMultiZone_VOut;
