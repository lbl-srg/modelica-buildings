within Buildings.Examples.VAVReheat.Controls;
block RoomVAVGuideline36
  "Controller for room VAV box according to ASHRAE Guideline 36"

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Mass flow rate of this thermal zone";
  parameter Modelica.SIunits.Area zonAre "Area of the zone";

  final parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal = m_flow_nominal / 1.2
    "Volume flow rate of this thermal zone";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-140,110},{-100,150}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooCooSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,70},{-100,110}})));

  Modelica.Blocks.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));

  Modelica.Blocks.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealOutput yVal "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput yDam "Signal for VAV damper"
    annotation (Placement(transformation(extent={{100,88},{120,108}})));


  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests
    sysReqRehBox(have_heaPla=false)
    annotation (Placement(transformation(extent={{50,0},{70,20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValve
    damVal_RehBox
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDisAir
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupAHU
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.Valves.HeatingAndCooling coiCon
    annotation (Placement(transformation(extent={{-70,120},{-50,140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
    actAirSet(
    occSen=false,
    winSen=false,
    co2Sen=false,
    VCooMax=V_flow_nominal,
    VMin=0.1*V_flow_nominal,
    VHeaMax=V_flow_nominal,
    VMinCon=V_flow_nominal,
    zonAre=zonAre) "Active airflow rate setpoint"
    annotation (Placement(transformation(extent={{-32,90},{-12,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}})));

equation
  connect(sysReqRehBox.TCooSet, TRooCooSet) annotation (Line(points={{49,19},{
          -78,19},{-78,22},{-78,22},{-78,90},{-120,90}},
                                  color={0,0,127}));
  connect(sysReqRehBox.TRoo, TRoo) annotation (Line(points={{49,17},{-40,17},{
          -40,10},{-120,10}},
                            color={0,0,127}));
  connect(sysReqRehBox.VDisAirSet, damVal_RehBox.VDisAirSet)
    annotation (Line(points={{49,12},{44,12},{44,78},{31,78}},
                                                             color={0,0,127}));
  connect(sysReqRehBox.VDisAir, VDisAir)
    annotation (Line(points={{49,10},{-20,10},{-20,50},{-120,50}},
                                               color={0,0,127}));
  connect(sysReqRehBox.TDisAirSet, damVal_RehBox.TDisAirSet)
    annotation (Line(points={{49,5},{42,5},{42,62},{31,62}}, color={0,0,127}));
  connect(damVal_RehBox.yDam, yDam) annotation (Line(points={{31,74},{80,74},{
          80,98},{110,98}},
                         color={0,0,127}));
  connect(damVal_RehBox.yHeaVal, yVal) annotation (Line(points={{31,66},{80,66},
          {80,0},{110,0}},                     color={0,0,127}));
  connect(damVal_RehBox.VDisAir, VDisAir)
    annotation (Line(points={{24,59},{24,50},{-120,50}}, color={0,0,127}));
  connect(damVal_RehBox.TDisAir, TDis)
    annotation (Line(points={{16,59},{16,-30},{-120,-30}}, color={0,0,127}));
  connect(sysReqRehBox.TDisAir, TDis) annotation (Line(points={{49,3},{-24,3},{
          -24,-30},{-120,-30}},  color={0,0,127}));
  connect(sysReqRehBox.uDam, damVal_RehBox.yDam) annotation (Line(points={{49,8},{
          46,8},{46,74},{31,74}},       color={0,0,127}));
  connect(damVal_RehBox.yHeaVal, sysReqRehBox.uHeaVal) annotation (Line(points={{31,66},
          {40,66},{40,1},{49,1}},            color={0,0,127}));
  connect(TRoo, damVal_RehBox.TRoo) annotation (Line(points={{-120,10},{-40,10},
          {-40,61},{9,61}}, color={0,0,127}));
  connect(damVal_RehBox.TSup, TSupAHU) annotation (Line(points={{9,63},{-80,63},
          {-80,-70},{-120,-70}}, color={0,0,127}));
  connect(damVal_RehBox.THeaSet, TRooHeaSet) annotation (Line(points={{9,65},{
          -80,65},{-80,130},{-120,130}}, color={0,0,127}));
  connect(damVal_RehBox.uHea, coiCon.yHea) annotation (Line(points={{9,67},{-40,
          67},{-40,134},{-49,134}}, color={0,0,127}));
  connect(damVal_RehBox.uCoo, coiCon.yCoo) annotation (Line(points={{9,69},{-42,
          69},{-42,126},{-49,126}}, color={0,0,127}));
  connect(actAirSet.VActCooMax, damVal_RehBox.VActCooMax) annotation (Line(
        points={{-11,108},{0,108},{0,79},{9,79}}, color={0,0,127}));
  connect(actAirSet.VActCooMin, damVal_RehBox.VActCooMin) annotation (Line(
        points={{-11,105},{-2,105},{-2,77},{9,77}}, color={0,0,127}));
  connect(actAirSet.VActMin, damVal_RehBox.VActMin) annotation (Line(points={{-11,
          102},{-4,102},{-4,71},{9,71}}, color={0,0,127}));
  connect(actAirSet.VActHeaMin, damVal_RehBox.VActHeaMin) annotation (Line(
        points={{-11,99},{-6,99},{-6,73},{9,73}}, color={0,0,127}));
  connect(actAirSet.VActHeaMax, damVal_RehBox.VActHeaMax) annotation (Line(
        points={{-11,96},{-8,96},{-8,75},{9,75}}, color={0,0,127}));
  connect(coiCon.TRooHeaSet, TRooHeaSet) annotation (Line(points={{-71,136},{
          -80,136},{-80,130},{-120,130}}, color={0,0,127}));
  connect(coiCon.TRooCooSet, TRooCooSet) annotation (Line(points={{-71,130},{
          -78,130},{-78,90},{-120,90}}, color={0,0,127}));
  connect(coiCon.TRoo, TRoo) annotation (Line(points={{-71,124},{-76,124},{-76,
          10},{-120,10}}, color={0,0,127}));
  connect(actAirSet.uOpeMod, uOpeMod) annotation (Line(points={{-33,97},{-54,97},
          {-54,-110},{-120,-110}}, color={255,127,0}));
  annotation ( Icon(coordinateSystem(extent={{-100,-140},{100,160}}),
                    graphics={  Rectangle(
        extent={{-100,-140},{100,160}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-92,-16},{-44,-40}},
          lineColor={0,0,127},
          textString="TDis"),
        Text(
          extent={{-94,-56},{-46,-80}},
          lineColor={0,0,127},
          textString="TSup"),
        Text(
          extent={{40,16},{88,-8}},
          lineColor={0,0,127},
          textString="yVal"),
        Text(
          extent={{40,112},{88,88}},
          lineColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-92,142},{-44,118}},
          lineColor={0,0,127},
          textString="TRooHeaSet"),
        Text(
          extent={{-90,64},{-42,40}},
          lineColor={0,0,127},
          textString="VDisAir"),        Text(
        extent={{-154,204},{146,164}},
        textString="%name",
        lineColor={0,0,255}),
        Text(
          extent={{-92,22},{-44,-2}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{-92,102},{-44,78}},
          lineColor={0,0,127},
          textString="TRooCooSet"),
        Text(
          extent={{-92,-96},{-44,-120}},
          lineColor={0,0,127},
          textString="uOpeMod")}),
                                Documentation(info="<html>
<p>
Controller for terminal box of VAV system with reheat
according to ASHRAE Guideline 36.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-140},{100,160}})));
end RoomVAVGuideline36;
