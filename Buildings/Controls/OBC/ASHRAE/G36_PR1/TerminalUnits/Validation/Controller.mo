within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Validation;
model Controller "Validate model for controlling VAV terminal box with reheat"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller
    con(
    AFlo=50,
    samplePeriod=120,
    V_flow_nominal=(50*3/3600)*6)
    "Controller for VAV terminal unit with reheat"
    annotation (Placement(transformation(extent={{60,54},{80,84}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller
    con1(
    AFlo=50,
    samplePeriod=120,
    V_flow_nominal=(50*3/3600)*6,
    have_occSen=true,
    have_winSen=true,
    have_CO2Sen=true)
    "Controller for VAV terminal unit with reheat"
    annotation (Placement(transformation(extent={{60,-6},{80,24}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCoo(k=273.15 + 24)
    "Room cooling setpoint "
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirFlo(
    offset=0.02,
    height=0.0168,
    duration=3600) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    height=6,
    offset=273.15 + 17,
    duration=3600) "Measured room temperature"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis(
    height=4,
    duration=3600,
    offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    height=4,
    duration=3600,
    offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHea(k=273.15 + 20)
    "Room heating setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ppmCO2(
    duration=3600,
    height=800,
    offset=200) "CO2 concentration"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(period=3600)
    "WIndow status"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp nOcc(
    height=5,
    duration=4800,
    offset=0) "Number of occupants"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Round rou(n=0) "Round the input"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

equation
  connect(TSetRooHea.y, con.TRooHeaSet)
    annotation (Line(points={{-59,80},{-50,80},{-50,60},{6,60},{6,76.5},
      {59,76.5}}, color={0,0,127}));
  connect(TSetRooCoo.y, con.TRooCooSet)
    annotation (Line(points={{-19,80},{-8,80},{-8,73.5},{59,73.5}},
      color={0,0,127}));
  connect(disAirFlo.y, con.VDis)
    annotation (Line(points={{-59,40},{-50,40},{-50,56},{12,56},{12,70.5},
      {59,70.5}}, color={0,0,127}));
  connect(TZon.y, con.TRoo)
    annotation (Line(points={{-19,40},{18,40},{18,67.5},{59,67.5}},
      color={0,0,127}));
  connect(TDis.y, con.TDis)
    annotation (Line(points={{-59,0},{-50,0},{-50,20},{0,20},{0,64.5},{59,64.5}},
      color={0,0,127}));
  connect(TSup.y, con.TSupAHU)
    annotation (Line(points={{-19,0},{24,0},{24,61.5},{59,61.5}},
      color={0,0,127}));
  connect(opeMod.y, con.uOpeMod)
    annotation (Line(points={{-19,-30},{30,-30},{30,58.5},{59,58.5}},
      color={255,127,0}));
  connect(nOcc.y, rou.u)
    annotation (Line(points={{-59,-60},{-42,-60}}, color={0,0,127}));
  connect(rou.y, con1.nOcc)
    annotation (Line(points={{-19,-60},{36,-60},{36,22.5},{59,22.5}},
      color={0,0,127}));
  connect(ppmCO2.y, con1.ppmCO2)
    annotation (Line(points={{21,-80},{40,-80},{40,19.5},{59,19.5}},
      color={0,0,127}));
  connect(winSta.y, con1.uWin)
    annotation (Line(points={{71,-80},{80,-80},{80,-60},{44,-60},{44,-4.5},
      {59,-4.5}}, color={255,0,255}));
  connect(TSetRooHea.y, con1.TRooHeaSet)
    annotation (Line(points={{-59,80},{-50,80},{-50,60},{6,60},{6,16.5},
      {59,16.5}}, color={0,0,127}));
  connect(TSetRooCoo.y, con1.TRooCooSet)
    annotation (Line(points={{-19,80},{-8,80},{-8,13.5},{59,13.5}},
      color={0,0,127}));
  connect(disAirFlo.y, con1.VDis)
    annotation (Line(points={{-59,40},{-50,40},{-50,56},{12,56},{12,10.5},
      {59,10.5}}, color={0,0,127}));
  connect(TZon.y, con1.TRoo)
    annotation (Line(points={{-19,40},{18,40},{18,7.5},{59,7.5}},
      color={0,0,127}));
  connect(TDis.y, con1.TDis)
    annotation (Line(points={{-59,0},{-50,0},{-50,20},{0,20},{0,4.5},{59,4.5}},
      color={0,0,127}));
  connect(TSup.y, con1.TSupAHU)
    annotation (Line(points={{-19,0},{20,0},{20,1.5},{59,1.5}},
      color={0,0,127}));
  connect(opeMod.y, con1.uOpeMod)
    annotation (Line(points={{-19,-30},{30,-30},{30,-1.5},{59,-1.5}},
      color={255,127,0}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Validation/Controller.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
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
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end Controller;
