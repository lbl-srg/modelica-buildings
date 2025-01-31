within Buildings.Fluid.Actuators.Valves.Examples;
model TwoWayValveTable
  "Two way valve with nonlinear opening characteristics based on a table"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium";

    Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 306000,
    T=293.15,
    nPorts=1) "Boundary condition for flow source"
    annotation (Placement(
        transformation(extent={{-90,10},{-70,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 3E5,
    T=293.15,
    nPorts=1) "Boundary condition for flow sink"
    annotation (Placement(
        transformation(extent={{72,10},{52,30}})));
  Valves.TwoWayTable valTab(
    redeclare package Medium = Medium,
    use_strokeTime=false,
    from_dp=true,
    flowCharacteristics=datVal,
    CvData=Buildings.Fluid.Types.CvTypes.Kv,
    Kv=0.65,
    m_flow_nominal=0.04)
    "Valve model with opening characteristics based on a table"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  parameter Data.Generic datVal(
    y={0,0.1667,0.3333,0.5,0.6667,1},
    phi={0, 0.19, 0.35, 0.45, 0.5, 0.65}/0.65) "Valve characteristics"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Math.UnitConversions.To_bar to_bar
    annotation (Placement(transformation(extent={{0,-46},{20,-26}})));
  Sensors.RelativePressure senRelPre(redeclare package Medium = Medium)
    "Pressure differential sensor"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Sensors.VolumeFlowRate senVolFlo(redeclare package Medium = Medium,
      m_flow_nominal=0.04) "Volume flow rate sensor"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Math.Sqrt sqrt1
    annotation (Placement(transformation(extent={{28,-46},{48,-26}})));
  Modelica.Blocks.Math.Gain to_m3_h(k=3600) "Conversion to m3/h"
    annotation (Placement(transformation(extent={{-10,-74},{10,-54}})));
  Modelica.Blocks.Math.Division kv "Kv-value"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
equation
  connect(y.y,valTab. y) annotation (Line(
      points={{-19,60},{-19,60},{-10,60},{-10,32}},
      color={0,0,127}));
  connect(sou.ports[1], senVolFlo.port_a) annotation (Line(
      points={{-70,20},{-60,20}},
      color={0,127,255}));
  connect(senVolFlo.port_b, valTab.port_a) annotation (Line(
      points={{-40,20},{-20,20}},
      color={0,127,255}));
  connect(valTab.port_a, senRelPre.port_a) annotation (Line(
      points={{-20,20},{-20,-10}},
      color={0,127,255}));
  connect(valTab.port_b, senRelPre.port_b) annotation (Line(
      points={{4.44089e-16,20},{4.44089e-16,-10}},
      color={0,127,255}));
  connect(valTab.port_b, sin.ports[1]) annotation (Line(
      points={{4.44089e-16,20},{52,20}},
      color={0,127,255}));
  connect(to_bar.u, senRelPre.p_rel) annotation (Line(
      points={{-2,-36},{-10,-36},{-10,-19}},
      color={0,0,127}));
  connect(sqrt1.u, to_bar.y) annotation (Line(
      points={{26,-36},{21,-36}},
      color={0,0,127}));
  connect(senVolFlo.V_flow, to_m3_h.u) annotation (Line(
      points={{-50,31},{-50,36},{-30,36},{-30,-64},{-12,-64}},
      color={0,0,127}));
  connect(to_m3_h.y,kv. u1) annotation (Line(
      points={{11,-64},{58,-64}},
      color={0,0,127}));
  connect(sqrt1.y,kv. u2) annotation (Line(
      points={{49,-36},{54,-36},{54,-76},{58,-76}},
      color={0,0,127}));
    annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/TwoWayValveTable.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for a two way valve in which a table is used to specify the
opening characteristics.
The valve has the following opening characteristics, which is taken from a test case
of the IEA EBC Annex 60 project.
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td><i>y</i></td>
  <td>0</td>  <td>0.1667</td>  <td>0.3333</td>  <td>0.5</td>  <td>0.6667</td>  <td>1</td>
</tr>
<tr><td><i>K<sub>v</sub></i></td>
  <td>0</td>  <td>0.19</td>  <td>0.35</td>  <td>0.45</td>  <td>0.5</td>  <td>0.65</td>       </tr>
</table>
<p>
The <i>K<sub>v</sub></i> value is the volume flow rate in m<sup>3</sup>/h at a pressure difference
of 1 bar.
Hence, the <i>K<sub>v</sub></i> value of the fully open valve is <i>K<sub>v</sub>=0.65</i>.
</p>
<p>
Plotting the variables <code>kv.y</code> versus <code>y.y</code> shows that the valve
reproduces the <i>K<sub>v</sub></i> values shown in the above table.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Actuators/Valves/Examples/TwoWayValveTable_kv.png\"/>
</p>
<p>
The parameter <code>filterOpening</code> is set to <code>false</code>,
as this model is used to plot the flow at different opening signals
without taking into account the travel time of the actuator.
</p>
</html>", revisions="<html>
<ul>
<li>
August 12, 2014 by Michael Wetter:<br/>
Added <code>parameter</code> keyword to <code>datVal</code>,
as this is needed to asssign <code>datVal</code> to a parameter
in the instance <code>valTab</code>.
This also avoids an error in OpenModelica.
</li>
<li>
April 2, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayValveTable;
