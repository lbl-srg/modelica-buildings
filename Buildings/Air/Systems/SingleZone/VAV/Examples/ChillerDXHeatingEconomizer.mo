within Buildings.Air.Systems.SingleZone.VAV.Examples;
model ChillerDXHeatingEconomizer
  "Variable air volume flow system with single themal zone and conventional control"
  extends Modelica.Icons.Example;
  extends
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop;

  package MediumA = Buildings.Media.Air "Buildings library air media package";
  package MediumW = Buildings.Media.Water "Buildings library air media package";

  parameter Modelica.SIunits.Temperature TSupChi_nominal=279.15
    "Design value for chiller leaving water temperature";

  ChillerDXHeatingEconomizerController con(
    minOAFra=0.2,
    kFan=4,
    kEco=4,
    kHea=4,
    TSupChi_nominal=TSupChi_nominal,
    TSetSupAir=286.15)
   "Controller"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Modelica.Blocks.Sources.CombiTimeTable TSetRooHea(
    table=[
      0,       15 + 273.15;
      8*3600,  20 + 273.15;
      18*3600, 15 + 273.15;
      24*3600, 15 + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooCoo(
    table=[
      0,       30 + 273.15;
      8*3600,  25 + 273.15;
      18*3600, 30 + 273.15;
      24*3600, 30 + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

equation
  connect(TSetRooHea.y[1], con.TSetRooHea)
    annotation (Line(points={{-119,50},{-110,50},{-110,10},{-102,10}},
                                                   color={0,0,127}));
  connect(TSetRooCoo.y[1], con.TSetRooCoo)
    annotation (Line(points={{-119,20},{-116,20},{-116,6},{-102,6}},   color={0,0,127}));

  connect(hvac.uFan, con.yFan) annotation (Line(points={{-42,18},{-60,18},{-60,9},
          {-79,9}}, color={0,0,127}));
  connect(hvac.uHea, con.yHea) annotation (Line(points={{-42,12},{-58,12},{-58,6},
          {-79,6}}, color={0,0,127}));
  connect(con.yCooCoiVal, hvac.uCooVal) annotation (Line(points={{-79,0},{-56,0},
          {-56,5},{-42,5}}, color={0,0,127}));
  connect(hvac.uEco, con.yOutAirFra) annotation (Line(points={{-42,-2},{-58,-2},
          {-58,3},{-79,3}}, color={0,0,127}));
  connect(con.chiOn, hvac.chiOn) annotation (Line(points={{-79,-4},{-58,-4},{-58,
          -10},{-42,-10}}, color={255,0,255}));
  connect(hvac.TSetChi, con.TSetSupChi) annotation (Line(points={{-42,-15},{-50,
          -15},{-50,-16},{-60,-16},{-60,-8},{-79,-8}}, color={0,0,127}));
  connect(hvac.TMix, con.TMix) annotation (Line(points={{1,-4},{8,-4},{8,-40},{
          -114,-40},{-114,2},{-102,2}}, color={0,0,127}));
  connect(hvac.TSup, con.TSup) annotation (Line(points={{1,-8},{6,-8},{6,-36},{
          -110,-36},{-110,-9},{-102,-9}}, color={0,0,127}));
  connect(con.TOut, weaBus.TDryBul) annotation (Line(points={{-102,-2},{-108,-2},
          {-108,60},{-30,60},{-30,80}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(zon.TRooAir, con.TRoo) annotation (Line(points={{81,0},{108,0},{108,
          -148},{-120,-148},{-120,-6},{-102,-6}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=504800,
      Interval=3600,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/ChillerDXHeatingEconomizer.mos"
        "Simulate and plot"),
     Documentation(info="<html>
<p>
Implementation of <a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop\">
Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop</a>
with conventional single-maximum control sequence.
</p>
</html>", revisions="<html>
<ul>
<li>
August 3, 2019, by David Blum:<br/>
Update to using <a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop\">
Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop</a>.
</li>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-160},{120,140}})));
end ChillerDXHeatingEconomizer;
