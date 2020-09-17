within Buildings.Air.Systems.SingleZone.VAV.BaseClasses.Validation;
model ControllerHeatingFan "Validate the block ControllerHeatingFan"
  extends Modelica.Icons.Example;

  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerHeatingFan
    conHeaFan(minAirFlo=0.6)
    "Controller for heating and cooling"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Sine zonHeaSet(
    freqHz=1/86400,
    offset=20 + 273.15,
    amplitude=1)
    "Zone heating setpoint"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Sine zonCooSet(
    freqHz=1/86400,
    amplitude=2,
    offset=25 + 273.15)
    "Zone cooling setpoint"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Sine zonTem(
    amplitude=4,
    freqHz=1/86400,
    offset=21 + 273.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(zonHeaSet.y, conHeaFan.TSetRooHea) annotation (Line(points={{-39,30},{
          -20,30},{0,30},{0,6},{19,6}}, color={0,0,127}));
  connect(zonCooSet.y, conHeaFan.TSetRooCoo)    annotation (Line(points={{-39,0},{19,0}},        color={0,0,127}));
  connect(zonTem.y, conHeaFan.TRoo) annotation (Line(points={{-39,-30},{-20,-30},
          {0,-30},{0,-6},{19,-6}}, color={0,0,127}));

  annotation (
  experiment(StopTime=604800,  Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/BaseClasses/Validation/ControllerHeatingFan.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerHeatingFan\">
Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerHeatingFan</a>.
</p>
The sine inputs include:
<ul>
<li>
Zone heating setpoint <code>zonHeaSet</code>, varying from <i>19.0</i> &deg;C
to <i>21.0</i> &deg;C
</li>
<li>
Zone cooling setpoint <code>zonCooSet</code>, varying from <i>23.0</i> &deg;C
to <i>27.0</i> &deg;C
</li>
<li>
Zone temperature <code>zonTem</code>, varying from <i>17.0 </i> &deg;C to
<i>25.0</i> &deg;C
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 3, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControllerHeatingFan;
