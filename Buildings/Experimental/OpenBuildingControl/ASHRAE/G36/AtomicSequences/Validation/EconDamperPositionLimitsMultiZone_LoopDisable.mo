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
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Modelica.Blocks.Sources.Ramp VOut(
    duration=1800,
    offset=minSenOutVolAirflow,
    height=senOutVolAirIncrease)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));

  CDL.Logical.Constant FanStatus(k=false) "Fan is off"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  CDL.Integers.Constant FreProSta(k=1) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  CDL.Integers.Constant AHUMode(k=1) "AHU System Mode (1 = Occupied)"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  EconDamperPositionLimitsMultiZone ecoDamLim annotation (Placement(transformation(extent={{-120,
            -30},{-100,-10}})));
  CDL.Continuous.Constant VOutMinSet1(
                                     k=airflowSetpoint)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Ramp VOut1(
    duration=1800,
    offset=minSenOutVolAirflow,
    height=senOutVolAirIncrease)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  CDL.Logical.Constant FanStatus1(
                                 k=false) "Fan is off"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  CDL.Integers.Constant FreProSta1(
                                  k=1) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  CDL.Integers.Constant AHUMode1(k=2) "AHU System Mode (2 != Occupied)"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  EconDamperPositionLimitsMultiZone ecoDamLim1
                                              annotation (Placement(transformation(extent={{20,-30},
            {40,-10}})));
  CDL.Continuous.Constant VOutMinSet2(
                                     k=airflowSetpoint)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Modelica.Blocks.Sources.Ramp VOut2(
    duration=1800,
    offset=minSenOutVolAirflow,
    height=senOutVolAirIncrease)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  CDL.Logical.Constant FanStatus2(
                                 k=false) "Fan is off"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  CDL.Integers.Constant FreProSta2(k=3)
    "Freeze Protection Status 2 deactivates the loop"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  CDL.Integers.Constant AHUMode2(
                                k=1) "AHU System Mode (1 = Occupied)"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  EconDamperPositionLimitsMultiZone ecoDamLim2
                                              annotation (Placement(transformation(extent={{160,-30},
            {180,-10}})));
equation
  connect(VOut.y, ecoDamLim.uVOut) annotation (Line(points={{-179,70},{-140,70},
          {-140,-12},{-121,-12}},                                                              color={0,0,127}));
  connect(VOutMinSet.y, ecoDamLim.uVOutMinSet)
    annotation (Line(points={{-179,30},{-150,30},{-150,-15},{-121,-15}},
                                                                color={0,0,127}));
  connect(FanStatus.y, ecoDamLim.uSupFan)
    annotation (Line(points={{-179,-10},{-160,-10},{-160,-20},{-121,-20}},
                                                                color={255,0,255}));
  connect(AHUMode.y, ecoDamLim.uAHUMode)
    annotation (Line(points={{-179,-50},{-160,-50},{-160,-28},{-160,-25},{-121,
          -25}},                                                                      color={255,127,0}));
  connect(FreProSta.y, ecoDamLim.uFreProSta)
    annotation (Line(points={{-179,-90},{-150,-90},{-150,-28},{-121,-28}},
                                                                    color={255,127,0}));
  connect(VOut1.y, ecoDamLim1.uVOut) annotation (Line(points={{-39,70},{0,70},{
          0,-12},{19,-12}}, color={0,0,127}));
  connect(VOutMinSet1.y, ecoDamLim1.uVOutMinSet) annotation (Line(points={{-39,
          30},{-10,30},{-10,-15},{19,-15}}, color={0,0,127}));
  connect(FanStatus1.y, ecoDamLim1.uSupFan) annotation (Line(points={{-39,-10},
          {-20,-10},{-20,-20},{19,-20}}, color={255,0,255}));
  connect(AHUMode1.y, ecoDamLim1.uAHUMode) annotation (Line(points={{-39,-50},{
          -20,-50},{-20,-28},{-20,-25},{19,-25}}, color={255,127,0}));
  connect(FreProSta1.y, ecoDamLim1.uFreProSta) annotation (Line(points={{-39,
          -90},{-10,-90},{-10,-28},{19,-28}}, color={255,127,0}));
  connect(VOut2.y, ecoDamLim2.uVOut) annotation (Line(points={{101,70},{140,70},
          {140,-12},{159,-12}}, color={0,0,127}));
  connect(VOutMinSet2.y, ecoDamLim2.uVOutMinSet) annotation (Line(points={{101,
          30},{130,30},{130,-15},{159,-15}}, color={0,0,127}));
  connect(FanStatus2.y, ecoDamLim2.uSupFan) annotation (Line(points={{101,-10},
          {120,-10},{120,-20},{159,-20}}, color={255,0,255}));
  connect(AHUMode2.y, ecoDamLim2.uAHUMode) annotation (Line(points={{101,-50},{
          120,-50},{120,-28},{120,-25},{159,-25}}, color={255,127,0}));
  connect(FreProSta2.y, ecoDamLim2.uFreProSta) annotation (Line(points={{101,
          -90},{130,-90},{130,-28},{159,-28}}, color={255,127,0}));
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
            220,120}}), graphics={
        Text(
          extent={{-200,110},{-166,98}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Fan is off",
          fontSize=16),
        Text(
          extent={{-60,118},{68,100}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="AHU Mode is other 
than \"Occupied\"",
          fontSize=16),
        Text(
          extent={{80,118},{208,100}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Freeze protection status
is higher than 1",
          fontSize=16)}),
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
