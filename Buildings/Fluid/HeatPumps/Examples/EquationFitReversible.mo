within Buildings.Fluid.HeatPumps.Examples;
model EquationFitReversible
  "Test model for reverse heat pump based on performance curves"
 package Medium = Buildings.Media.Water "Medium model";

  parameter Data.EquationFitReversible.Trane_Axiom_EXW240 per
   "Reverse heat pump performance data"
   annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=per.hea.mSou_flow
   "Source heat exchanger nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=per.hea.mLoa_flow
   "Load heat exchanger nominal mass flow rate";

  Buildings.Fluid.HeatPumps.EquationFitReversible heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
  T1_start=281.4,
    per=per)
   "Water to Water heat pump"
   annotation (Placement(transformation(extent={{42,0},{62,20}})));
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
      origin={26,80})));

  Sources.MassFlowSource_T souPum(
    redeclare package Medium = Medium,
    m_flow=mSou_flow_nominal,
    nPorts=1,
    use_T_in=true)
   "Source side water pump"
   annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=180,
      origin={80,4})));
  Modelica.Fluid.Sources.FixedBoundary loaVol(
     redeclare package Medium = Medium,
     nPorts=1)
   "Volume for the load side"
   annotation (Placement(transformation(extent={{100,56},{80,76}})));
  Modelica.Fluid.Sources.FixedBoundary souVol(
     redeclare package Medium = Medium,
     nPorts=1)
   "Volume for source side"
   annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp THeaLoaSet(
    height=5,
    duration(displayUnit="h") = 14400,
  offset=55 + 273.15)
   "Heating load side setpoint water temperature"
   annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TCooLoaSet(
  height=1,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15) "Cooling load setpoint water temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(threshold=-1)
    "Integer threshold"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Controls.OBC.CDL.Logical.Switch swi "Switch for set point temperature"
    annotation (Placement(transformation(extent={{-8,0},{12,20}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TSouEntCoo(
    height=5,
    duration(displayUnit="h") = 14400,
  offset=28 + 273.15)
  "Source side entering water temperature in cooling mode"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Blocks.Sources.Ramp  uMod1(
    height=2,
    duration(displayUnit="h") = 14400,
    offset=-1)   "Heat pump operates in heating mode"
    annotation (Placement(transformation(extent={{-98,0},{-78,20}})));
  Controls.OBC.CDL.Logical.Switch swi1
                                      "Switch for set point temperature"
    annotation (Placement(transformation(extent={{-12,66},{8,86}})));
  Controls.OBC.CDL.Logical.Switch swi2
                                      "Switch for set point temperature"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TSouEntHea(
  height=2,
    duration(displayUnit="h") = 14400,
  offset=12 + 273.15)
  "Source side entering water temperature in heating mode"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TLoaEntHea(
    height=5,
    duration(displayUnit="h") = 14400,
  offset=50 + 273.15) "Load side entering water temperature  in heating mode"
    annotation (Placement(transformation(extent={{-60,74},{-40,94}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TLoaEntCoo(
    height=5,
    duration(displayUnit="h") = 14400,
    offset=10 + 273.15)
  "Load side entering water temperature in cooling mode"
    annotation (Placement(transformation(extent={{-86,58},{-66,78}})));
equation
  connect(heaPum.port_a1,loaPum. ports[1])
   annotation (Line(points={{42,16},{40,16},{40,80},{36,80}},
                                                            color={0,127,255}));
  connect(souPum.ports[1], heaPum.port_a2)
   annotation (Line(points={{70,4},{62,4}},  color={0,127,255}));
  connect(reaToInt.y, heaPum.uMod)
   annotation (Line(points={{-49,10},{-46,10},{-46,-4},{20,-4},{20,10},{41,10}},
                                            color={255,127,0}));
  connect(heaPum.port_b1, loaVol.ports[1]) annotation (Line(points={{62,16},{
        72,16},{72,66},{80,66}},
                               color={0,127,255}));
  connect(heaPum.port_b2, souVol.ports[1]) annotation (Line(points={{42,4},{
        22,4},{22,-70},{-50,-70}}, color={0,127,255}));
  connect(swi.u2,intGreThr. y)
    annotation (Line(points={{-10,10},{-18,10}}, color={255,0,255}));
  connect(intGreThr.u, reaToInt.y)
    annotation (Line(points={{-42,10},{-49,10}}, color={255,127,0}));
  connect(THeaLoaSet.y, swi.u1) annotation (Line(points={{-38,50},{-10,50},{
        -10,18}},        color={0,0,127}));
  connect(TCooLoaSet.y, swi.u3) annotation (Line(points={{-38,-30},{-14,-30},
        {-14,2},{-10,2}},
                      color={0,0,127}));
  connect(swi.y, heaPum.TSet) annotation (Line(points={{14,10},{14,19},{40.6,
        19}},  color={0,0,127}));
  connect(reaToInt.u, uMod1.y)
    annotation (Line(points={{-72,10},{-77,10}}, color={0,0,127}));
  connect(swi1.y, loaPum.T_in)
    annotation (Line(points={{10,76},{14,76}},   color={0,0,127}));
  connect(swi2.y, souPum.T_in) annotation (Line(points={{92,-50},{92,
        -2.22045e-15}},       color={0,0,127}));
  connect(swi2.u3, TSouEntCoo.y) annotation (Line(points={{68,-58},{66,-58},{66,
          -70},{62,-70}}, color={0,0,127}));
  connect(TSouEntHea.y, swi2.u1) annotation (Line(points={{62,-30},{64,-30},{64,
          -42},{68,-42}}, color={0,0,127}));
  connect(intGreThr.y, swi2.u2) annotation (Line(points={{-18,10},{-16,10},{
        -16,-50},{68,-50}},
                          color={255,0,255}));
  connect(swi1.u1, TLoaEntHea.y) annotation (Line(points={{-14,84},{-38,84}},
                         color={0,0,127}));
  connect(TLoaEntCoo.y, swi1.u3) annotation (Line(points={{-64,68},{-14,68}},
                         color={0,0,127}));
connect(intGreThr.y, swi1.u2) annotation (Line(points={{-18,10},{-16,10},{-16,
        76},{-14,76}}, color={255,0,255}));
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
