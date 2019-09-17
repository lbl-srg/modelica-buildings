within Buildings.Fluid.HeatPumps.Examples;
model ReverseWaterToWater "Test model for reverse heat pump based on performance curves"
 package Medium = Buildings.Media.Water "Medium model";

  parameter Data.ReverseWaterToWater.Trane_Axiom_EXW240 per
   "Reverse heat pump performance data"
   annotation (Placement(transformation(extent={{28,68},{48,88}})));
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=per.hea.mSou_flow
   "Source heat exchanger nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=per.hea.mLoa_flow
   "Load heat exchanger nominal mass flow rate";

  Buildings.Fluid.HeatPumps.ReverseWaterToWater heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T1_start=281.4,
    per=per)
   "Water to Water heat pump"
   annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
    "Real to integer conversion"
   annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  Sources.MassFlowSource_T loaPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=mLoa_flow_nominal,
    nPorts=1,
    use_T_in=true)
   "Load Side water pump"
   annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-30,80})));

  Sources.MassFlowSource_T souPum(
    redeclare package Medium = Medium,
    m_flow=mSou_flow_nominal,
    nPorts=1,
    use_T_in=true)
   "Source side water pump"
   annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=180,
      origin={70,-6})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TLoaEnt(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=20 + 273.15,
    startTime=0)
   "Load side entering water temperature"
   annotation (Placement(transformation(extent={{-80,66},{-60,86}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TSouEnt(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15,
    startTime=0)
   "Source side entering water temperature"
   annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Fluid.Sources.FixedBoundary loaVol(
     redeclare package Medium = Medium,
     nPorts=1)
   "Volume for the load side"
   annotation (Placement(transformation(extent={{100,60},{80,80}})));
  Modelica.Fluid.Sources.FixedBoundary souVol(
     redeclare package Medium = Medium,
     nPorts=1)
   "Volume for source side"
   annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp THeaLoaSet(
  height=20,
  duration(displayUnit="h") = 14400,
  offset=40 + 273.15,
  startTime=0)
   "Heating load side setpoint water temperature"
   annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp uMod(
    height=2,
    duration(displayUnit="h") = 14400,
    offset=-1,
    startTime=0)
   "heat pump operational mode input signal"
   annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TCooSet(
  height=4,
  duration(displayUnit="h") = 14400,
  offset=6 + 273.15,
  startTime=0)
   "Cooling load setpoint water temperature"
   annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(threshold=-1)
    "Integer threshold"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Controls.OBC.CDL.Logical.Switch swi "Switch for set point temperature"
    annotation (Placement(transformation(extent={{-8,0},{12,20}})));
equation
  connect(heaPum.port_a1,loaPum. ports[1])
   annotation (Line(points={{30,6},{22,6},{22,80},{-20,80}},color={0,127,255}));
  connect(TSouEnt.y,souPum. T_in)
   annotation (Line(points={{82,-70},{92,-70},{92,-10},{82,-10}},color={0,0,127}));
  connect(souPum.ports[1], heaPum.port_a2)
   annotation (Line(points={{60,-6},{50,-6}},color={0,127,255}));
  connect(uMod.y, reaToInt.u)
   annotation (Line(points={{-78,10},{-72,10}},
                                             color={0,0,127}));
  connect(reaToInt.y, heaPum.uMod)
   annotation (Line(points={{-49,10},{-46,10},{-46,-40},{20,-40},{20,0},{29,0}},
                                            color={255,127,0}));
  connect(loaPum.T_in,TLoaEnt. y)
   annotation (Line(points={{-42,76},{-58,76}},color={0,0,127}));
  connect(heaPum.port_b1, loaVol.ports[1]) annotation (Line(points={{50,6},{60,
          6},{60,70},{80,70}}, color={0,127,255}));
  connect(heaPum.port_b2, souVol.ports[1]) annotation (Line(points={{30,-6},{22,
          -6},{22,-70},{-50,-70}}, color={0,127,255}));
  connect(swi.u2,intGreThr. y)
    annotation (Line(points={{-10,10},{-18,10}}, color={255,0,255}));
  connect(intGreThr.u, reaToInt.y)
    annotation (Line(points={{-42,10},{-49,10}}, color={255,127,0}));
  connect(THeaLoaSet.y, swi.u1) annotation (Line(points={{-18,40},{-14,40},{-14,
          18},{-10,18}}, color={0,0,127}));
  connect(TCooSet.y, swi.u3) annotation (Line(points={{-18,-20},{-14,-20},{-14,2},
          {-10,2}}, color={0,0,127}));
  connect(swi.y, heaPum.TSet) annotation (Line(points={{14,10},{20,10},{20,9},{28.6,
          9}}, color={0,0,127}));
     annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{120,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
              Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
             __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/ReverseWaterToWater.mos"
        "Simulate and plot"),
         experiment(Tolerance=1e-6, StopTime=14400),
Documentation(info="<html>
<p>
Example that simulates the performance of
<a href=\"modelica://Buildings.Fluid.HeatPumps.ReverseWaterToWater\">
Buildings.Fluid.HeatPumps.ReverseWaterToWater</a> based on the equation fit method.
The heat pump takes as an input the set point for the heating or the chilled leaving
water temperature and an integer input to
specify the heat pump operational mode.
</p>
</html>", revisions="<html>
<ul>
<li>
September 17, 2019, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
June 18, 2019, by Hagar Elarga:<br/>
First implementation.
 </li>
 </ul>
 </html>"));
end ReverseWaterToWater;
