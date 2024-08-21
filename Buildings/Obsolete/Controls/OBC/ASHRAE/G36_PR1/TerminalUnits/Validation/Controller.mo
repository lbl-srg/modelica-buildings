within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Validation;
model Controller "Validate model for controlling VAV terminal box with reheat"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller con(
    AFlo=50,
    samplePeriod=120,
    V_flow_nominal=(50*3/3600)*6)
    "Controller for VAV terminal unit with reheat"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller con1(
    AFlo=50,
    samplePeriod=120,
    V_flow_nominal=(50*3/3600)*6,
    have_occSen=true,
    have_winSen=true,
    have_CO2Sen=true) "Controller for VAV terminal unit with reheat"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetRooCoo(k=273.15 + 24)
    "Room cooling setpoint "
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp disAirFlo(
    offset=0.02,
    height=0.0168,
    duration=3600) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TZon(
    height=6,
    offset=273.15 + 17,
    duration=3600) "Measured room temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TDis(
    height=4,
    duration=3600,
    offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSup(
    height=4,
    duration=3600,
    offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetRooHea(k=273.15 + 20)
    "Room heating setpoint"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ppmCO2(
    duration=3600,
    height=800,
    offset=200) "CO2 concentration"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(period=3600)
    "WIndow status"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp nOcc(
    height=5,
    duration=4800,
    offset=0) "Number of occupants"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Round rou(n=0) "Round the input"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=2) "Mimic damper position"
    annotation (Placement(transformation(extent={{80,58},{100,78}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=2) "Mimic damper position"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));

equation
  connect(TSetRooHea.y,con.TZonHeaSet)
    annotation (Line(points={{-78,100},{-70,100},{-70,74},{-14,74},{-14,80},{38,
          80}},   color={0,0,127}));
  connect(TSetRooCoo.y, con.TZonCooSet)
    annotation (Line(points={{-38,100},{-28,100},{-28,78},{38,78}},
      color={0,0,127}));
  connect(disAirFlo.y, con.VDis_flow)
    annotation (Line(points={{-78,60},{-8,60},{-8,68},{38,68}},
                  color={0,0,127}));
  connect(TZon.y, con.TZon)
    annotation (Line(points={{-38,30},{-2,30},{-2,70},{38,70}},
      color={0,0,127}));
  connect(TDis.y, con.TDis)
    annotation (Line(points={{-78,0},{-20,0},{-20,64},{38,64}},
      color={0,0,127}));
  connect(TSup.y, con.TSupAHU)
    annotation (Line(points={{-38,-20},{4,-20},{4,62},{38,62}},
      color={0,0,127}));
  connect(opeMod.y, con.uOpeMod)
    annotation (Line(points={{2,-50},{10,-50},{10,60},{38,60}},
      color={255,127,0}));
  connect(nOcc.y, rou.u)
    annotation (Line(points={{-78,-70},{-62,-70}}, color={0,0,127}));
  connect(rou.y, con1.nOcc)
    annotation (Line(points={{-38,-70},{16,-70},{16,14},{38,14}},
      color={0,0,127}));
  connect(ppmCO2.y, con1.ppmCO2)
    annotation (Line(points={{2,-90},{20,-90},{20,16},{38,16}},
      color={0,0,127}));
  connect(winSta.y, con1.uWin)
    annotation (Line(points={{62,-90},{80,-90},{80,-50},{26,-50},{26,12},{38,12}},
                  color={255,0,255}));
  connect(TSetRooHea.y,con1.TZonHeaSet)
    annotation (Line(points={{-78,100},{-70,100},{-70,74},{-14,74},{-14,20},{38,
          20}},   color={0,0,127}));
  connect(TSetRooCoo.y, con1.TZonCooSet)
    annotation (Line(points={{-38,100},{-28,100},{-28,18},{38,18}},
      color={0,0,127}));
  connect(disAirFlo.y, con1.VDis_flow)
    annotation (Line(points={{-78,60},{-8,60},{-8,8},{38,8}},
                  color={0,0,127}));
  connect(TZon.y, con1.TZon)
    annotation (Line(points={{-38,30},{-2,30},{-2,10},{38,10}},
      color={0,0,127}));
  connect(TDis.y, con1.TDis)
    annotation (Line(points={{-78,0},{-20,0},{-20,4},{38,4}},
      color={0,0,127}));
  connect(TSup.y, con1.TSupAHU)
    annotation (Line(points={{-38,-20},{4,-20},{4,2},{38,2}},
      color={0,0,127}));
  connect(opeMod.y, con1.uOpeMod)
    annotation (Line(points={{2,-50},{10,-50},{10,0},{38,0}},
      color={255,127,0}));
  connect(con.yDam, zerOrdHol.u) annotation (Line(points={{62,76},{70,76},{70,68},
          {78,68}}, color={0,0,127}));
  connect(con1.yDam, zerOrdHol1.u) annotation (Line(points={{62,16},{70,16},{70,
          10},{78,10}}, color={0,0,127}));
  connect(zerOrdHol.y,con.yDam_actual)  annotation (Line(points={{102,68},{110,
          68},{110,100},{20,100},{20,66},{38,66}}, color={0,0,127}));
  connect(zerOrdHol1.y,con1.yDam_actual)  annotation (Line(points={{102,10},{
          110,10},{110,40},{30,40},{30,6},{38,6}}, color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Validation/Controller.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end Controller;
