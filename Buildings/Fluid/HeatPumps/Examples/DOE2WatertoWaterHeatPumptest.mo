within Buildings.Fluid.HeatPumps.Examples;
model DOE2WatertoWaterHeatPumptest

 package Medium = Buildings.Media.Water "Medium model";

  DOE2WaterToWatertest                       heaPum(redeclare package Medium1
      = Medium, redeclare package Medium2 = Medium,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=per)
    annotation (Placement(transformation(extent={{20,-12},{40,8}})));

 parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
       "Nominal mass flow rate";
 parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
       "Nominal mass flow rate";

  Sources.FixedBoundary cooBui(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-52,-94},{-32,-74}})));
  Sources.FixedBoundary heaBui(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{110,-2},{90,18}})));
  Sources.MassFlowSource_T evaPum(
    m_flow=5,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-36})));
  Sources.MassFlowSource_T conPum(
    m_flow=5,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-38,92})));
  FixedResistances.PressureDrop                 res1(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{54,-2},{74,18}})));
  FixedResistances.PressureDrop                 res2(
    redeclare package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{-24,-94},{-4,-74}})));

//   Buildings.Fluid.HeatPumps.WaterSourceHeatPump heaPum1
//     annotation (Placement(transformation(extent={{32,24},{52,44}})));

  Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=10,
    duration(displayUnit="h") = 3600,
    offset=-5,
    startTime=0)      annotation (Placement(transformation(extent={{-98,-14},{-84,
            0}})));
  Controls.OBC.CDL.Continuous.LessEqualThreshold           lesEquThr(threshold=
        -1) annotation (Placement(transformation(extent={{-70,16},{-56,30}})));
  Controls.OBC.CDL.Continuous.GreaterEqualThreshold           greEquThr(threshold=
       1)
    annotation (Placement(transformation(extent={{-68,-44},{-54,-30}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger           booToInt(integerTrue=
        -1)
    annotation (Placement(transformation(extent={{-44,16},{-30,30}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger           booToInt1
    annotation (Placement(transformation(extent={{-44,-44},{-30,-30}})));
  Controls.OBC.CDL.Integers.Add           heaMod
    annotation (Placement(transformation(extent={{-16,-10},{-4,2}})));

  Controls.OBC.CDL.Continuous.Sources.Constant TSet_HeatingWater(k=273.15 + 30)
    annotation (Placement(transformation(extent={{-18,42},{-2,58}})));
  Modelica.Blocks.Sources.Constant         TCon_Ent(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-100,78},{-82,96}})));
  Controls.OBC.CDL.Continuous.Sources.Constant
                                           TEva_ent(k=12 + 273.15)
    annotation (Placement(transformation(extent={{84,-78},{98,-64}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSet_ChilledWater(k=12 + 273.15)
    annotation (Placement(transformation(extent={{-20,-58},{-4,-42}})));
  parameter
    Data.DOE2WaterToWater.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes per
    annotation (Placement(transformation(extent={{78,60},{98,80}})));
equation
  connect(evaPum.ports[1], heaPum.port_a2)
    annotation (Line(points={{60,-36},{40,-36},{40,-8}}, color={0,127,255}));
  connect(heaPum.port_a1, conPum.ports[1]) annotation (Line(points={{20,4},{18,4},
          {18,92},{-28,92}}, color={0,127,255}));
  connect(heaPum.port_b1, res1.port_a)
    annotation (Line(points={{40,4},{40,6},{54,6},{54,8}},
                                             color={0,127,255}));
  connect(res1.port_b, heaBui.ports[1])
    annotation (Line(points={{74,8},{90,8}}, color={0,127,255}));
  connect(heaPum.port_b2, res2.port_b) annotation (Line(points={{20,-8},{8,-8},{
          8,-84},{-4,-84}},     color={0,127,255}));
  connect(res2.port_a, cooBui.ports[1])
    annotation (Line(points={{-24,-84},{-32,-84}}, color={0,127,255}));

  connect(ram.y,lesEquThr. u) annotation (Line(points={{-83.3,-7},{-78,-7},{-78,
          23},{-71.4,23}},
                     color={0,0,127}));
  connect(ram.y,greEquThr. u) annotation (Line(points={{-83.3,-7},{-80,-7},{-80,
          -8},{-78,-8},{-78,-37},{-69.4,-37}},
                      color={0,0,127}));
  connect(lesEquThr.y,booToInt. u)
    annotation (Line(points={{-55.3,23},{-45.4,23}},
                                                color={255,0,255}));
  connect(greEquThr.y,booToInt1. u)
    annotation (Line(points={{-53.3,-37},{-45.4,-37}},    color={255,0,255}));
  connect(booToInt1.y,heaMod. u2) annotation (Line(points={{-29.3,-37},{-26,-37},
          {-26,-8},{-22,-8},{-22,-7.6},{-17.2,-7.6}},
                           color={255,127,0}));
  connect(booToInt.y,heaMod. u1) annotation (Line(points={{-29.3,23},{-24,23},{-24,
          -0.4},{-17.2,-0.4}},
                   color={255,127,0}));
  connect(heaMod.y, heaPum.heaPumMod) annotation (Line(points={{-3.4,-4},{10,-4},
          {10,-11.5},{18.7,-11.5}}, color={255,127,0}));
  connect(TSet_HeatingWater.y, heaPum.TConSet)
    annotation (Line(points={{-1.2,50},{16,50},{16,7},{19.4,7}},
                                                            color={0,0,127}));
  connect(TCon_Ent.y, conPum.T_in)
    annotation (Line(points={{-81.1,87},{-50,87},{-50,88}}, color={0,0,127}));
  connect(TEva_ent.y, evaPum.T_in) annotation (Line(points={{98.7,-71},{108,-71},
          {108,-40},{82,-40}}, color={0,0,127}));
  connect(TSet_ChilledWater.y, heaPum.TEvaSet) annotation (Line(points={{-3.2,-50},
          {16,-50},{16,-1.9},{18.7,-1.9}}, color={0,0,127}));
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
end DOE2WatertoWaterHeatPumptest;
