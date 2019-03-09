within Buildings.Fluid.HeatPumps.Examples;
model WaterSourceHeatPump

 package Medium = Buildings.Media.Water "Medium model";
 parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=1000*0.01035
    "Nominal mass flow at Condenser";

// TConLvgMin=273.15 + 27,
// TConLvgMax=273.15 + 35,
  HeatPumps.WaterSourceHeatPump heaPum(
       redeclare package Medium1 = Medium,
       redeclare package Medium2 = Medium)
       annotation (Placement(transformation(extent={{20,-12},{40,8}})));

//     TEvaEntMin=273.15 + 5,
//     TEvaEntMax=273.15 + 15,

  Controls.OBC.CDL.Continuous.GreaterThreshold greThr(threshold=0.5)
    annotation (Placement(transformation(extent={{-18,20},{2,40}})));
  Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    width=50,
    offset=0,
    period=3600/2,
    amplitude=1.5) annotation (Placement(transformation(extent={{-54,20},{-34,40}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=8,
    duration=3600,
    offset=273.15 + 10,
    startTime=3*3600) annotation (Placement(transformation(extent={{-76,-10},{-56,
            10}})));
  Sources.FixedBoundary bou1(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,-52},{-40,-32}})));
  Sources.FixedBoundary heating_blg(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{108,-2},{88,18}})));
  Sources.MassFlowSource_T boundary(nPorts=1, use_T_in=true,
    redeclare package Medium = Medium)                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={64,-54})));
  Sources.MassFlowSource_T boundary1(
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-38,72})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    duration=3600,
    startTime=3600*3,
    height=8,
    offset=273.15 + 15) annotation (Placement(transformation(extent={{108,-62},{
            88,-42}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ram2(
    height=8,
    duration=3600,
    offset=273.15 + 10,
    startTime=3*3600) annotation (Placement(transformation(extent={{-84,66},{-64,
            86}})));
  FixedResistances.PressureDrop                 res1(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{54,-2},{74,18}})));
  FixedResistances.PressureDrop                 res2(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{-32,-52},{-12,-32}})));

  parameter Data.WSHP.Generic per annotation (Placement(transformation(extent={{56,76},
            {76,96}})));
//   Buildings.Fluid.HeatPumps.WaterSourceHeatPump heaPum1
//     annotation (Placement(transformation(extent={{32,24},{52,44}})));






equation
  connect(greThr.y, heaPum.on) annotation (Line(points={{3,30},{6,30},{6,1},{18,
          1}},   color={255,0,255}));
  connect(pul.y, greThr.u) annotation (Line(points={{-33,30},{-20,30}}, color={0,0,127}));
  connect(ram.y, heaPum.TSet) annotation (Line(points={{-55,0},{0.5,0},{0.5,-5},
          {18,-5}},    color={0,0,127}));
  connect(boundary.ports[1], heaPum.port_a2) annotation (Line(points={{54,-54},{
          50,-54},{50,-52},{40,-52},{40,-8}},         color={0,127,255}));
  connect(heaPum.port_a1, boundary1.ports[1]) annotation (Line(points={{20,4},{18,
          4},{18,76},{-28,76},{-28,72}},color={0,127,255}));
  connect(ram1.y, boundary.T_in) annotation (Line(points={{87,-52},{82,-52},{82,
          -58},{76,-58}},                                                                       color={0,0,127}));
  connect(ram2.y, boundary1.T_in) annotation (Line(points={{-63,76},{-56,76},{-56,
          68},{-50,68}},                                                                         color={0,0,127}));
  connect(heaPum.port_b1, res1.port_a)
    annotation (Line(points={{40,4},{40,6},{54,6},{54,8}},
                                             color={0,127,255}));
  connect(res1.port_b, heating_blg.ports[1])
    annotation (Line(points={{74,8},{88,8}},                                 color={0,127,255}));
  connect(heaPum.port_b2, res2.port_b) annotation (Line(points={{20,-8},{-10,-8},
          {-10,-42},{-12,-42}}, color={0,127,255}));
  connect(res2.port_a, bou1.ports[1]) annotation (Line(points={{-32,-42},{-40,-42}}, color={0,127,255}));



   annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/Carnot_TCon.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
Example that simulates a chiller whose efficiency is scaled based on the
Carnot cycle.
The chiller takes as an input the evaporator leaving water temperature.
The condenser mass flow rate is computed in such a way that it has
a temperature difference equal to <code>dTEva_nominal</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 25, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, initialScale=0.1),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-100},{120,100}}, initialScale=0.1)));
end WaterSourceHeatPump;
