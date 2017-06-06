within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconDamperPositionLimitsMultiZone_VOut
  "Validation model for setting the min econ damper limit and max return air damper limit."
  extends Modelica.Icons.Example;

  parameter Real airflowSetpoint(unit="m3/s", displayUnit="m3/h")=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  parameter Real minSenOutVolAirflow(unit="m3/s", displayUnit="m3/h")=0.61
    "Volumetric airflow sensor output, minimum value in the example";
  parameter Real senOutVolAirIncrease(unit="m3/s", displayUnit="m3/h")=0.2
    "Maximum increase in airflow volume during the example simulation";

  CDL.Continuous.Constant VOutMinSet(k=airflowSetpoint)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Ramp VOut(
    duration=1800,
    offset=minSenOutVolAirflow,
    height=senOutVolAirIncrease)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  CDL.Logical.Constant FanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  CDL.Integers.Constant FreProSta(k=1) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Integers.Constant AHUMode(k=1) "AHU System Mode (1 = Occupied)"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  EconDamperPositionLimitsMultiZone ecoDamLim
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(VOut.y, ecoDamLim.uVOut) annotation (Line(points={{-59,90},{-20,90},{
          -20,8},{-1,8}}, color={0,0,127}));
  connect(VOutMinSet.y, ecoDamLim.uVOutMinSet) annotation (Line(points={{-59,50},
          {-30,50},{-30,5},{-1,5}}, color={0,0,127}));
  connect(FanStatus.y, ecoDamLim.uSupFan) annotation (Line(points={{-59,10},{
          -40,10},{-40,0},{-1,0}}, color={255,0,255}));
  connect(AHUMode.y, ecoDamLim.uAHUMode) annotation (Line(points={{-59,-30},{
          -40,-30},{-40,-8},{-40,-8},{-40,-5},{-1,-5}}, color={255,127,0}));
  connect(FreProSta.y, ecoDamLim.uFreProSta) annotation (Line(points={{-59,-70},
          {-30,-70},{-30,-8},{-1,-8}}, color={255,127,0}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/EconDamPosLimitsMultiZone_VOut.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-120},{100,120}}),
         graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,
            120}})),
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
June 06, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconDamperPositionLimitsMultiZone_VOut;
