within Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.Validation;
model ZoneTSet "Validate block for zone set point"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.ZoneTSet zonSetpoint(
    occSen=true,
    sinAdj=false,
    cooAdj=true,
    winStaSen=true) "Block determined thermal zone setpoints"
    annotation (Placement(transformation(extent={{60,40},{100,80}})));

  CDL.Continuous.Sources.Constant occCooSet(k=297.15)
    "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  CDL.Continuous.Sources.Constant occHeaSet(k=293.15)
    "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  CDL.Continuous.Sources.Constant unoCooSet(k=303.15)
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  CDL.Continuous.Sources.Constant unoHeaSet(k=287.15)
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Sine cooSetAdj(freqHz=1/28800)
    "Cooling setpoint adjustment"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Sources.Sine heaSetAdj(freqHz=1/28800, amplitude=0.5)
    "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  CDL.Integers.Sources.Constant cooDemLimLev(k=0)
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  CDL.Integers.Sources.Constant heaDemLimLev(k=0)
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  CDL.Continuous.Sources.Ramp ram(duration=28800)
    "Generate ramp output"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  CDL.Continuous.GreaterThreshold greThr(threshold=0.75)
    "Check if input is greater than 0.75"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  CDL.Conversions.BooleanToInteger booToInt(integerTrue=1, integerFalse=7)
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  CDL.Logical.Sources.Pulse winSta(period=14400, startTime=1200)
    "Generate signal indicating window status"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  CDL.Logical.Sources.Pulse occSta(period=14400, width=0.95)
    "Generate signal indicating occupancy status"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  CDL.Continuous.Sources.Constant zerAdj(k=0) "Zero adjustment"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  CDL.Logical.Switch swi1 "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  CDL.Logical.Switch swi2 "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

equation
  connect(ram.y, greThr.u)
    annotation (Line(points={{-119,-90},{-102,-90}}, color={0,0,127}));
  connect(greThr.y, not1.u)
    annotation (Line(points={{-79,-90},{-62,-90}}, color={255,0,255}));
  connect(not1.y, booToInt.u)
    annotation (Line(points={{-39,-90},{-22,-90}}, color={255,0,255}));
  connect(occCooSet.y, zonSetpoint.occCooSet)
    annotation (Line(points={{-79,90},{-72,90},{-72,108},{30,108},{30,78},{58,78}},
      color={0,0,127}));
  connect(occHeaSet.y, zonSetpoint.occHeaSet)
    annotation (Line(points={{-39,90},{26,90},{26,74},{58,74}},
      color={0,0,127}));
  connect(unoCooSet.y, zonSetpoint.unoCooSet)
    annotation (Line(points={{-79,50},{-72,50},{-72,70},{58,70}}, color={0,0,127}));
  connect(unoHeaSet.y, zonSetpoint.unoHeaSet)
    annotation (Line(points={{-39,50},{-32,50},{-32,66},{58,66}},
      color={0,0,127}));
  connect(cooDemLimLev.y, zonSetpoint.uCooDemLimLev)
    annotation (Line(points={{-119,-60},{-100,-60},{-100,-40},{22,-40},
      {22,46},{58,46}}, color={255,127,0}));
  connect(heaDemLimLev.y, zonSetpoint.uHeaDemLimLev)
    annotation (Line(points={{-39,-60},{26,-60},{26,42},{58,42}},
      color={255,127,0}));
  connect(booToInt.y, zonSetpoint.uOpeMod)
    annotation (Line(points={{1,-90},{18,-90},{18,50},{58,50}},
      color={255,127,0}));
  connect(occSta.y, zonSetpoint.uOccSen)
    annotation (Line(points={{61,20},{74,20},{74,38}},
      color={255,0,255}));
  connect(winSta.y, zonSetpoint.uWinSta)
    annotation (Line(points={{61,-20},{86,-20},{86,38}}, color={255,0,255}));
  connect(winSta.y, swi2.u2)
    annotation (Line(points={{61,-20},{86,-20},{86,0},{-60,0},{-60,20},
      {-42,20}}, color={255,0,255}));
  connect(winSta.y, swi1.u2)
    annotation (Line(points={{61,-20},{86,-20},{86,0},{-60,0},{-60,-20},
      {-42,-20}}, color={255,0,255}));
  connect(zerAdj.y, swi2.u1)
    annotation (Line(points={{-119,0},{-64,0},{-64,28},{-42,28}},
      color={0,0,127}));
  connect(zerAdj.y, swi1.u1)
    annotation (Line(points={{-119,0},{-64,0},{-64,-12},{-42,-12}},
      color={0,0,127}));
  connect(cooSetAdj.y, swi2.u3)
    annotation (Line(points={{-79,20},{-68,20},{-68,12},{-42,12}},
      color={0,0,127}));
  connect(heaSetAdj.y, swi1.u3)
    annotation (Line(points={{-79,-20},{-68,-20},{-68,-28},{-42,-28}},
      color={0,0,127}));
  connect(swi2.y, zonSetpoint.setAdj)
    annotation (Line(points={{-19,20},{-2,20},{-2,62},{58,62}},
      color={0,0,127}));
  connect(swi1.y, zonSetpoint.heaSetAdj)
    annotation (Line(points={{-19,-20},{2,-20},{2,58},{58,58}},
      color={0,0,127}));
  annotation (
  experiment(StopTime=28800, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHU/SetPoints/Validation/ZoneTSet.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.ZoneTSet\">
Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.ZoneTSet</a>
for a change of zone setpoint temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
August 19, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-120},{120,120}})));
end ZoneTSet;
