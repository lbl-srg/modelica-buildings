within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconDamperPositionLimitsMultiZone_LoopDisable
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
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  Modelica.Blocks.Sources.Ramp VOut(
    duration=1800,
    offset=minSenOutVolAirflow,
    height=senOutVolAirIncrease)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));

  CDL.Logical.Constant FanStatus(k=false) "Fan is off"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));
  CDL.Integers.Constant FreProSta(k=1) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  CDL.Integers.Constant AHUMode(k=1) "AHU System Mode (1 = Occupied)"
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));
  EconDamperPositionLimitsMultiZone ecoDamLim annotation (Placement(transformation(extent={{-120,
            -10},{-100,10}})));
  CDL.Continuous.Constant VOutMinSet1(
                                     k=airflowSetpoint)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Ramp VOut1(
    duration=1800,
    offset=minSenOutVolAirflow,
    height=senOutVolAirIncrease)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  CDL.Logical.Constant FanStatus1(
                                 k=false) "Fan is off"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Integers.Constant FreProSta1(
                                  k=1) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  CDL.Integers.Constant AHUMode1(k=2) "AHU System Mode (2 != Occupied)"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  EconDamperPositionLimitsMultiZone ecoDamLim1
                                              annotation (Placement(transformation(extent={{20,-10},
            {40,10}})));
  CDL.Continuous.Constant VOutMinSet2(
                                     k=airflowSetpoint)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Modelica.Blocks.Sources.Ramp VOut2(
    duration=1800,
    offset=minSenOutVolAirflow,
    height=senOutVolAirIncrease)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  CDL.Logical.Constant FanStatus2(
                                 k=false) "Fan is off"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  CDL.Integers.Constant FreProSta2(k=3)
    "Freeze Protection Status 2 deactivates the loop"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  CDL.Integers.Constant AHUMode2(
                                k=1) "AHU System Mode (1 = Occupied)"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  EconDamperPositionLimitsMultiZone ecoDamLim2
                                              annotation (Placement(transformation(extent={{160,-10},
            {180,10}})));
equation
  connect(VOut.y, ecoDamLim.uVOut) annotation (Line(points={{-179,90},{-140,90},
          {-140,8},{-121,8}},                                                                  color={0,0,127}));
  connect(VOutMinSet.y, ecoDamLim.uVOutMinSet)
    annotation (Line(points={{-179,50},{-150,50},{-150,5},{-121,5}},
                                                                color={0,0,127}));
  connect(FanStatus.y, ecoDamLim.uSupFan)
    annotation (Line(points={{-179,10},{-160,10},{-160,0},{-121,0}},
                                                                color={255,0,255}));
  connect(AHUMode.y, ecoDamLim.uAHUMode)
    annotation (Line(points={{-179,-30},{-160,-30},{-160,-8},{-160,-5},{-121,-5}},    color={255,127,0}));
  connect(FreProSta.y, ecoDamLim.uFreProSta)
    annotation (Line(points={{-179,-70},{-150,-70},{-150,-8},{-121,-8}},
                                                                    color={255,127,0}));
  connect(VOut1.y, ecoDamLim1.uVOut)
    annotation (Line(points={{-39,90},{0,90},{0,8},{19,8}}, color={0,0,127}));
  connect(VOutMinSet1.y, ecoDamLim1.uVOutMinSet) annotation (Line(points={{-39,
          50},{-10,50},{-10,5},{19,5}}, color={0,0,127}));
  connect(FanStatus1.y, ecoDamLim1.uSupFan) annotation (Line(points={{-39,10},{
          -20,10},{-20,0},{19,0}}, color={255,0,255}));
  connect(AHUMode1.y, ecoDamLim1.uAHUMode) annotation (Line(points={{-39,-30},{
          -20,-30},{-20,-8},{-20,-5},{19,-5}}, color={255,127,0}));
  connect(FreProSta1.y, ecoDamLim1.uFreProSta) annotation (Line(points={{-39,
          -70},{-10,-70},{-10,-8},{19,-8}}, color={255,127,0}));
  connect(VOut2.y, ecoDamLim2.uVOut) annotation (Line(points={{101,90},{140,90},
          {140,8},{159,8}}, color={0,0,127}));
  connect(VOutMinSet2.y, ecoDamLim2.uVOutMinSet) annotation (Line(points={{101,
          50},{130,50},{130,5},{159,5}}, color={0,0,127}));
  connect(FanStatus2.y, ecoDamLim2.uSupFan) annotation (Line(points={{101,10},{
          120,10},{120,0},{159,0}}, color={255,0,255}));
  connect(AHUMode2.y, ecoDamLim2.uAHUMode) annotation (Line(points={{101,-30},{
          120,-30},{120,-8},{120,-5},{159,-5}}, color={255,127,0}));
  connect(FreProSta2.y, ecoDamLim2.uFreProSta) annotation (Line(points={{101,
          -70},{130,-70},{130,-8},{159,-8}}, color={255,127,0}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/EconDamperPositionLimitsMultiZone_LoopDisable.mos"
    "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{
            220,120}})),
    experiment(StopTime=1800.0),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconDamperPositionLimitsMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconDamperPositionLimitsMultiZone</a>
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
end EconDamperPositionLimitsMultiZone_LoopDisable;
