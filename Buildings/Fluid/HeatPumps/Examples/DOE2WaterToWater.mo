within Buildings.Fluid.HeatPumps.Examples;
model DOE2WaterToWater
 extends Modelica.Icons.Example;
   package Medium = Buildings.Media.Water "Medium model";

    parameter Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes per
    "Performance data"
     annotation (Placement(transformation(extent={{28,68},{48,88}})));
    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal*SF
    "Evaporator nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal*SF
    "Condenser nominal mass flow rate";
    parameter Real SF=1
    "Load scale factor for heatpump";

    Buildings.Fluid.HeatPumps.DOE2WaterToWater heaPumDOE2(
    SF=SF,
    per=per,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    show_T=true,
    dp1_nominal=200,
    dp2_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Water to water heatpump model implementing DOE2 method"
     annotation (Placement(transformation(extent={{32,-10},{52,10}})));
    Sources.MassFlowSource_T conPum(
      use_m_flow_in=false,
      m_flow=mCon_flow_nominal,
      nPorts=1,
      use_T_in=true,
      redeclare package Medium = Medium)
     "Condenser water pump"
      annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},rotation=180,origin={-32,60})));
    Sources.MassFlowSource_T evaPum(
      m_flow=mEva_flow_nominal,
      nPorts=1,
      use_T_in=true,
      redeclare package Medium = Medium)
     "Evaporator water pump"
      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}}, rotation=180,origin={72,-6})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TConEnt(
    height=5,
      duration(displayUnit="h") = 14400,
    offset=20 + 273.15,
      startTime=0)
    "Condesner entering water temperature"
     annotation (Placement(transformation(extent={{-80,46},{-60,66}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaEnt(
      height=4,
      duration(displayUnit="h") = 14400,
      offset=12 + 273.15,
      startTime=0)
    "Evaporator entering water temperature"
     annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
    FixedResistances.PressureDrop res1(
      redeclare package Medium = Medium,
      m_flow_nominal=mCon_flow_nominal,
      dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{56,50},{76,70}})));
    FixedResistances.PressureDrop res2(
      redeclare package Medium = Medium,
      m_flow_nominal=mEva_flow_nominal,
      dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{-12,-90},{8,-70}})));
    Modelica.Fluid.Sources.FixedBoundary heaVol(
      nPorts=1,
      redeclare package Medium =Medium)
    "Volume for heating load"
     annotation (Placement(transformation(extent={{100,50},{80,70}})));
    Modelica.Fluid.Sources.FixedBoundary cooVol(
      nPorts=1,
      redeclare package Medium =Medium)
    "Volume for cooling load"
     annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaSet(
      height=4,
      duration(displayUnit="h") = 14400,
      offset=6 + 273.15,
      startTime=0)
    "Evaporator setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TConSet(
    height=5,
      duration(displayUnit="h") = 14400,
    offset=30 + 273.15,
      startTime=0)
    "Condenser setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp uMod(
      height=2,
      duration(displayUnit="h") = 14400,
      offset=-1,
      startTime=0)
    "HeatPump operational mode input signal"
     annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    Modelica.Blocks.Math.RealToInteger reaToInt
     annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));

equation
  connect(heaPumDOE2.port_a1, conPum.ports[1])
  annotation (Line(points={{32,6},{24,6},{24,60},{-22,60}},color={0,127,255}));
  connect(TConEnt.y, conPum.T_in)
  annotation (Line(points={{-58,56},{-44,56}},                  color={0,0,127}));
  connect(TEvaEnt.y, evaPum.T_in)
  annotation (Line(points={{82,-50},{98,-50},{98,-10},{84,-10}},color={0,0,127}));
  connect(evaPum.ports[1], heaPumDOE2.port_a2)
  annotation (Line(points={{62,-6},{52,-6}},color={0,127,255}));
  connect(cooVol.ports[1],res2. port_a)
  annotation (Line(points={{-40,-80},{-12,-80}},color={0,127,255}));
  connect(res1.port_a, heaPumDOE2.port_b1)
  annotation (Line(points={{56,60},{54,60},{54,6},{52,6}},color={0,127,255}));
  connect(res2.port_b, heaPumDOE2.port_b2)
  annotation (Line(points={{8,-80},{24,-80},{24,-6},{32,-6}}, color={0,127,255}));
  connect(TConSet.y, heaPumDOE2.TConSet)
  annotation (Line(points={{2,30},{16,30},{16,9},{31.6,9}},color={0,0,127}));
  connect(TEvaSet.y, heaPumDOE2.TEvaSet)
  annotation (Line(points={{2,-30},{16,-30},{16,-9.1},{31.5,-9.1}},color={0,0,127}));
  connect(res1.port_b,heaVol. ports[1])
  annotation (Line(points={{76,60},{80,60}}, color={0,127,255}));
  connect(uMod.y, reaToInt.u)
  annotation (Line(points={{-58,0},{-44,0}}, color={0,0,127}));
  connect(reaToInt.y, heaPumDOE2.uMod)
  annotation (Line(points={{-21,0},{-4,0},{-4,-0.1},{31.5,-0.1}}, color={255,127,0}));
  annotation (experiment(StopTime=14400, Tolerance=1e-06),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/DOE2WaterToWater.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
  <p>
  Example that simulates the performance of <a href=\"modelica://Buildings.Fluid.HeatPumps.DOE2WaterToWater\">
  Buildings.Fluid.HeatPumps.DOE2WaterToWater </a> whose efficiency is computed based on the
  condenser entering and evaporator leaving fluid temperature.
  Three curves i.e. two biquadratic and one bicubic polynomial are used to compute
  the heatpump part load performance based on the DOE2 method.
  </p>
  </html>",
  revisions="<html>
  <ul>
  <li>
June 10, 2019, by Hagar Elarga:<br/>
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})));
end DOE2WaterToWater;
