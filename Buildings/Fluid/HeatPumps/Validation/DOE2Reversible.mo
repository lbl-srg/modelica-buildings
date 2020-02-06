within Buildings.Fluid.HeatPumps.Validation;
model DOE2Reversible
  "Test model for reverse heat pump based on performance curves"
 package Medium = Buildings.Media.Water "Medium model";

  parameter Data.DOE2Reversible.EnergyPlus per "Performance data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  parameter Real scaling_factor=1
   "Scaling factor for heat pump capacity";

  Buildings.Fluid.HeatPumps.DOE2Reversible chiDOE2(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per=per,
    scaling_factor=scaling_factor) "Chiller model with DOE2 method"
    annotation (Placement(transformation(extent={{40,-2},{60,18}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
   "Real to integer conversion"
   annotation (Placement(transformation(extent={{-86,0},{-66,20}})));
  Sources.MassFlowSource_T loaPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=per.m2_flow_nominal,
    use_T_in=true,
    nPorts=1) "Load Side water pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={70,70})));
  Sources.MassFlowSource_T souPum(
    redeclare package Medium = Medium,
    m_flow=per.m2_flow_nominal,
    nPorts=1,
    use_T_in=true) "Source side water pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={92,-8})));
  Modelica.Fluid.Sources.FixedBoundary loaVol(
     redeclare package Medium = Medium,
     nPorts=1)
   "Volume for the load side"
   annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Modelica.Fluid.Sources.FixedBoundary souVol(
     redeclare package Medium = Medium, nPorts=1)
   "Volume for source side"
   annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Controls.OBC.CDL.Continuous.Sources.Constant THeaLoaSet(k=35 + 273.15)
   "Heating load side setpoint water temperature"
   annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TCooLoaSet(k=7 + 273.15)
                       "Cooling load setpoint water temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(threshold=1)
   "Integer threshold"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Controls.OBC.CDL.Logical.Switch swi "Switch for set point temperature"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TSouEntCoo(
    height=1,
    duration(displayUnit="s") = 2600,
    offset=28 + 273.15)
  "Source side entering water temperature in cooling mode"
    annotation (Placement(transformation(extent={{52,-80},{72,-60}})));
  Modelica.Blocks.Sources.Ramp uMod(
    height=2,
    duration=2600,
    offset=-1) "Heat pump operation ramp."
    annotation (Placement(transformation(extent={{-112,0},{-92,20}})));
  Controls.OBC.CDL.Logical.Switch swi1
   "Switch for set point temperature"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Controls.OBC.CDL.Logical.Switch swi2
   "Switch for set point temperature"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TSouEntHea(
    height=0,
    duration(displayUnit="s") = 2600,
    offset=12 + 273.15)
   "Source side entering water temperature in heating mode"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TLoaEntHea(
    height=1,
    duration(displayUnit="s") = 2600,
    offset=33 + 273.15)
   "Load side entering water temperature  in heating mode"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TLoaEntCoo(
    height=1,
    duration(displayUnit="s") = 2000,
    offset=11 + 273.15)
   "Load side entering water temperature in cooling mode"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Constant TSouLvgMin(k=6 + 273.15)
    "Minimum source side leaving temperature in case of heating mode"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Modelica.Blocks.Sources.Constant TSouLvgMax(k=20 + 273.15)
    "Maximum source side leaving temperature in case of heating mode "
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  connect(souPum.ports[1], chiDOE2.port_a2) annotation (Line(points={{82,-8},{
          72,-8},{72,2},{60,2}}, color={0,127,255}));
  connect(chiDOE2.port_b1, loaVol.ports[1]) annotation (Line(points={{60,14},{
          74,14},{74,30},{80,30}}, color={0,127,255}));
  connect(swi.u2, intGreEquThr.y)
    annotation (Line(points={{-22,10},{-38,10}}, color={255,0,255}));
  connect(intGreEquThr.u, reaToInt.y)
    annotation (Line(points={{-62,10},{-65,10}}, color={255,127,0}));
  connect(reaToInt.u, uMod.y)
    annotation (Line(points={{-88,10},{-91,10}}, color={0,0,127}));
  connect(swi2.u3, TSouEntCoo.y)
    annotation (Line(points={{78,-58},{78,-70},{74,-70}},          color={0,0,127}));
  connect(TSouEntHea.y, swi2.u1)
    annotation (Line(points={{72,-30},{76,-30},{76,-42},{78,-42}}, color={0,0,127}));
  connect(intGreEquThr.y, swi2.u2) annotation (Line(points={{-38,10},{-28,10},{
          -28,-50},{78,-50}}, color={255,0,255}));
  connect(swi1.y, loaPum.T_in)
    annotation (Line(points={{42,70},{52,70},{52,66},{58,66}}, color={0,0,127}));
  connect(intGreEquThr.y, swi1.u2) annotation (Line(points={{-38,10},{-28,10},{
          -28,70},{18,70}}, color={255,0,255}));
  connect(TLoaEntCoo.y, swi1.u3)
    annotation (Line(points={{2,50},{10,50},{10,62},{18,62}},
                                                            color={0,0,127}));
  connect(TLoaEntHea.y, swi1.u1)
    annotation (Line(points={{2,90},{14,90},{14,78},{18,78}}, color={0,0,127}));
  connect(swi.y, chiDOE2.TSet) annotation (Line(points={{2,10},{4,10},{4,20},{
          22,20},{22,17},{39,17}}, color={0,0,127}));
  connect(swi2.y, souPum.T_in)
    annotation (Line(points={{102,-50},{110,-50},{110,-12},{104,-12}}, color={0,0,127}));
  connect(THeaLoaSet.y, swi.u1)
    annotation (Line(
      points={{-38,50},{-32,50},{-32,18},{-22,18}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TCooLoaSet.y, swi.u3)
    annotation (Line(
      points={{-38,-30},{-32,-30},{-32,2},{-22,2}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(reaToInt.y, chiDOE2.uMod) annotation (Line(points={{-65,10},{-62,10},{
          -62,-6},{6,-6},{6,11},{39,11}},  color={255,127,0}));
  connect(TSouLvgMin.y,chiDOE2.TSouMinLvg)  annotation (Line(points={{1,-80},{26,
          -80},{26,5},{39,5}},    color={0,0,127}));
  connect(TSouLvgMax.y,chiDOE2.TSouMaxLvg)  annotation (Line(points={{1,-30},{8,
          -30},{8,8},{39,8}},   color={0,0,127}));
  connect(chiDOE2.port_b2, souVol.ports[1]) annotation (Line(points={{40,2},{20,
          2},{20,-60},{-80,-60}}, color={0,127,255}));
  connect(loaPum.ports[1], chiDOE2.port_a1) annotation (Line(points={{80,70},{
          84,70},{84,50},{32,50},{32,14},{40,14}}, color={0,127,255}));
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
  file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/DOE2Reversible.mos"
        "Simulate and plot"),
         experiment(StopTime=2600, Tolerance=1e-06),
Documentation(info="<html>
<p>
Example that simulates the performance of
<a href=\"modelica://Buildings.Fluid.HeatPumps.DOE2Reversible\">
Buildings.Fluid.HeatPumps.DOE2Reversible</a> based on the equation fit method.
The heat pump takes as an input the set point for the heating or the chilled leaving
water temperature and an integer input to
specify the heat pump operational mode.
</p>
</html>", revisions="<html>
<ul>
<li>
June 18, 2019, by Hagar Elarga:<br/>
First implementation.
 </li>
 </ul>
 </html>"));
end DOE2Reversible;
