within Buildings.Fluid.HeatPumps.Examples;
model EquationFitReversible
  "Test model for reverse heat pump based on performance curves"
 package Medium = Buildings.Media.Water "Medium model";

  parameter Data.EquationFitReversible.Trane_Axiom_EXW240 per
   "Reverse heat pump performance data"
   annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Modelica.Units.SI.MassFlowRate mSou_flow_nominal=per.hea.mSou_flow
    "Source heat exchanger nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mLoa_flow_nominal=per.hea.mLoa_flow
    "Load heat exchanger nominal mass flow rate";

  Buildings.Fluid.HeatPumps.EquationFitReversible heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T1_start=281.4,
    per=per)
   "Water to Water heat pump"
   annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
   "Real to integer conversion"
   annotation (Placement(transformation(extent={{-88,0},{-68,20}})));
  Sources.MassFlowSource_T loaPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=mLoa_flow_nominal,
    use_T_in=true,
    nPorts=1)
   "Load Side water pump"
   annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={70,70})));
  Sources.MassFlowSource_T souPum(
    redeclare package Medium = Medium,
    m_flow=mSou_flow_nominal,
    nPorts=1,
    use_T_in=true)
   "Source side water pump"
   annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=180,
      origin={90,-8})));
  Modelica.Fluid.Sources.FixedBoundary loaVol(
     redeclare package Medium = Medium,
     nPorts=1)
   "Volume for the load side"
   annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Modelica.Fluid.Sources.FixedBoundary souVol(
     redeclare package Medium = Medium,
     nPorts=1)
   "Volume for source side"
   annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Controls.OBC.CDL.Reals.Sources.Ramp THeaLoaSet(
    height=5,
    duration(displayUnit="h") = 14400,
    offset=55 + 273.15)
   "Heating load side setpoint water temperature"
   annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Controls.OBC.CDL.Reals.Sources.Ramp TCooLoaSet(
    height=1,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15) "Cooling load setpoint water temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(t=-1)
    "Integer threshold"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Controls.OBC.CDL.Reals.Switch swi "Switch for set point temperature"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Controls.OBC.CDL.Reals.Sources.Ramp TSouEntCoo(
    height=5,
    duration(displayUnit="h") = 14400,
    offset=28 + 273.15)
  "Source side entering water temperature in cooling mode"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Blocks.Sources.Ramp uMod(
    height=2,
    duration(displayUnit="h") = 14400,
    offset=-1) "Heat pump operates in heating mode"
    annotation (Placement(transformation(extent={{-118,0},{-98,20}})));
  Controls.OBC.CDL.Reals.Switch swi1
   "Switch for set point temperature"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Controls.OBC.CDL.Reals.Switch swi2
   "Switch for set point temperature"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Controls.OBC.CDL.Reals.Sources.Ramp TSouEntHea(
    height=2,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15)
   "Source side entering water temperature in heating mode"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Controls.OBC.CDL.Reals.Sources.Ramp TLoaEntHea(
    height=5,
    duration(displayUnit="h") = 14400,
    offset=50 + 273.15)
   "Load side entering water temperature  in heating mode"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Controls.OBC.CDL.Reals.Sources.Ramp TLoaEntCoo(
    height=5,
    duration(displayUnit="h") = 14400,
    offset=10 + 273.15)
   "Load side entering water temperature in cooling mode"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
equation
  connect(souPum.ports[1], heaPum.port_a2)
    annotation (Line(points={{80,-8},{70,-8},{70,4},{60,4}},
                                             color={0,127,255}));
  connect(heaPum.port_b1, loaVol.ports[1]) annotation (Line(points={{60,16},
            {72,16},{72,30},{80,30}},color={0,127,255}));
  connect(heaPum.port_b2, souVol.ports[1])
    annotation (Line(points={{40,4},{24,4},{24,-70},{-40,-70}},color={0,127,255}));
  connect(swi.u2,intGreThr. y)
    annotation (Line(points={{-22,10},{-38,10}}, color={255,0,255}));
  connect(intGreThr.u, reaToInt.y)
    annotation (Line(points={{-62,10},{-67,10}}, color={255,127,0}));
  connect(reaToInt.u, uMod.y)
    annotation (Line(points={{-90,10},{-97,10}}, color={0,0,127}));
  connect(swi2.u3, TSouEntCoo.y)
    annotation (Line(points={{78,-58},{66,-58},{66,-70},{62,-70}}, color={0,0,127}));
  connect(TSouEntHea.y, swi2.u1)
    annotation (Line(points={{62,-30},{64,-30},{64,-42},{78,-42}}, color={0,0,127}));
  connect(intGreThr.y, swi2.u2)
    annotation (Line(points={{-38,10},{-30,10},{-30,-50},{78,-50}}, color={255,0,255}));
  connect(swi1.y, loaPum.T_in)
    annotation (Line(points={{42,70},{50,70},{50,66},{58,66}}, color={0,0,127}));
  connect(intGreThr.y, swi1.u2) annotation (Line(points={{-38,10},{-30,10},{-30,
          70},{18,70}}, color={255,0,255}));
  connect(TLoaEntCoo.y, swi1.u3)
    annotation (Line(points={{2,50},{8,50},{8,62},{18,62}}, color={0,0,127}));
  connect(TLoaEntHea.y, swi1.u1)
    annotation (Line(points={{2,90},{12,90},{12,78},{18,78}}, color={0,0,127}));
  connect(swi.y, heaPum.TSet)
    annotation (Line(points={{2,10},{16,10},{16,19},{38.6,19}}, color={0,0,127}));
  connect(swi2.y, souPum.T_in)
    annotation (Line(points={{102,-50},{108,-50},{108,-12},{102,-12}}, color={0,0,127}));
  connect(loaPum.ports[1], heaPum.port_a1)
    annotation (Line(
      points={{80,70},{80,40},{24,40},{24,16},{40,16}},
      color={0,127,255},pattern=LinePattern.Dash));
  connect(THeaLoaSet.y, swi.u1)
    annotation (Line(
      points={{-38,50},{-34,50},{-34,18},{-22,18}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TCooLoaSet.y, swi.u3)
    annotation (Line(
      points={{-38,-30},{-34,-30},{-34,2},{-22,2}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(reaToInt.y, heaPum.uMod)
    annotation (Line(
      points={{-67,10},{-64,10},{-64,-8},{20,-8},{20,10},{39,10}},
      color={255,127,0}));
     annotation (Icon(coordinateSystem(preserveAspectRatio=false),
                               graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,
            120}}), graphics={Line(points={{-14,-8}}, color={28,108,200})}),
             __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/EquationFitReversible.mos"
        "Simulate and plot"),
         experiment(Tolerance=1e-6, StopTime=14400),
Documentation(info="<html>
<p>
Example that simulates the performance of
<a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a> based on the equation fit method.
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
end EquationFitReversible;
