within Buildings.Air.Systems.SingleZone.VAV.BaseClasses.Validation;
model ControllerChillerDXHeatingEconomizer
  "Validate the block ControllerChillerDXHeatingEconomizer"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Sine mixAirTem(
    amplitude=7.5,
    freqHz=1/86400,
    offset=20 + 273.15) "Mixed air temperature"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.Sine retAirTem(
    amplitude=10,
    freqHz=1/86400,
    offset=21 + 273.15) "Return air temperature"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Modelica.Blocks.Sources.Sine outAirTem(
    freqHz=1/86400,
    amplitude=6,
    offset=18 + 273.15) "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerChillerDXHeatingEconomizer
    con(
    TSupChi_nominal=279.15,
    minAirFlo=0.1,
    minOAFra=0.4,
    TSetSupAir=286.15) "Controller"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable  TSetRooHea(
    table=[
      0,      15 + 273.15;
      8*3600, 20 + 273.15;
      18*3600,15 + 273.15;
      24*3600,15 + 273.15],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable TSetRooCoo(
    table=[
       0,      30 + 273.15;
       8*3600, 25 + 273.15;
      18*3600, 30 + 273.15;
      24*3600, 30 + 273.15],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.Sine supAirTem(
    amplitude=7,
    freqHz=1/86400,
    offset=13 + 273.15) "Supply air temperature"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(con.TSetRooHea, TSetRooHea.y[1])
    annotation (Line(points={{38,6},{2,6},{2,60},{-78,60}}, color={0,0,127}));
  connect(con.TSetRooCoo, TSetRooCoo.y[1]) annotation (Line(points={{38,3},{20,3},
          {20,2},{0,2},{0,30},{-78,30}}, color={0,0,127}));
  connect(con.uOcc, occSch.occupied) annotation (Line(points={{38,0},{0,0},{0,-6},
          {-79,-6}}, color={255,0,255}));
  connect(con.TOut, outAirTem.y) annotation (Line(points={{38,-3},{2,-3},{2,-30},
          {-79,-30}}, color={0,0,127}));
  connect(con.TRoo, retAirTem.y) annotation (Line(points={{38,-6},{4,-6},{4,-60},
          {-79,-60}}, color={0,0,127}));
  connect(mixAirTem.y, con.TMix)
    annotation (Line(points={{-79,90},{4,90},{4,9},{38,9}}, color={0,0,127}));
  connect(supAirTem.y, con.TSup) annotation (Line(points={{-79,-90},{6,-90},{6,-9},
          {38,-9}}, color={0,0,127}));
   annotation (
  experiment(
      StopTime=172800,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/BaseClasses/Validation/ControllerChillerDXHeatingEconomizer.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerChillerDXHeatingEconomizer\">
Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerChillerDXHeatingEconomizer</a>.
</p>
<p>
The inputs include:
</p>
<ul>
<li>
Mixed air temperature <code>mixAirTem</code>, varying from <i>12.5</i> &deg;C
to <i>27.5</i> &deg;C
</li>
<li>
Return air temperature <code>retAirTem</code>, varying from <i>11.0</i> &deg;C
to <i>31.0</i> &deg;C
</li>
<li>
Outdoor air temperature <code>outAirTem</code>, varying from <i>12.0</i>
&deg;C to <i>24.0</i> &deg;C
</li>
<li>
Zone air temperature heating setpoint <code>TSetRooHea</code>, varying from <i>15.0</i>
&deg;C to <i>18.0</i> &deg;C according to occupancy.
</li>
<li>
Zone air temperature cooling setpoint <code>occSch</code>, with occupied hours
between 08:00 and 18:00.
</li>
<li>
Occupancy schedule <code>supAirTem</code>, varying from <i>20</i> &deg;C
to <i>6</i> &deg;C
</li>
<li>
Supply air temperature <code>supAirTem</code>, varying from <i>20</i> &deg;C
to <i>6</i> &deg;C
</li>
</ul>

</html>", revisions="<html>
<ul>
<li>
November 20, 2020, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControllerChillerDXHeatingEconomizer;
