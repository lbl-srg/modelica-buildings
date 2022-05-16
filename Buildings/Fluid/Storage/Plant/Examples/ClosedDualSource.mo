within Buildings.Fluid.Storage.Plant.Examples;
model ClosedDualSource
  "(Draft) District system model with two sources and three users"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource;

  parameter Modelica.Units.SI.AbsolutePressure p_Pressurisation(
    final displayUnit="Pa")=
     300000
    "Pressurisation point";

  Buildings.Fluid.Sources.Boundary_pT sou_p1(
    redeclare final package Medium = MediumCHW,
    final p=p_Pressurisation,
    final T=T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,20})));
equation

  connect(sou_p1.ports[1], pumSup1.port_a) annotation (Line(points={{-160,20},{-54,
          20},{-54,40},{-60,40}}, color={0,127,255}));
    annotation (
              __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/ClosedDualSource.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-06, StopTime=3600,__Dymola_Algorithm="Dassl"),
        Diagram(coordinateSystem(extent={{-180,-120},{140,140}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
(Draft)
This is a district system model with two CHW sources and three users
as described in
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</p>
<p>
The first source is a simplified CHW plant with only a chiller,
a single supply pump, and a check valve (with series resistance built in).
This supply pump is controlled to ensure that all users have enough pressure head.
The system is pressurised before this supply pump.
</p>
<p>
The second source has a chiller and a stratified CHW tank. Its piping is arranged
in a way that allows the tank to be charged remotely by the other source.
Its supply pump is controlled to maintain the flow rate setpoint of the tank.
This plant is disconnected (set to be unavailable) when the largest position of
user control valves less than 5% open. It is set back to be available when
this value is higher than 10%.
</p>
<p>
The timetables give the system the following behaviour:
</p>
<table summary= \"system modes\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Time slots</th>
    <th>1</th>
    <th>2</th>
    <th>3</th>
    <th>4</th>
    <th>5</th>
    <th>6</th>
    <th>7</th>
    <th>8</th>
    <th>9</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>User 1</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>User 2</td>
    <td>-</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>User 3</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Tank <br>(being charged)</td>
    <td>Local</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Remote</td>
    <td>Remote</td>
    <td>-</td>
  </tr>
</tbody>
</table>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end ClosedDualSource;
