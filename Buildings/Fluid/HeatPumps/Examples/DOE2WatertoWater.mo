within Buildings.Fluid.HeatPumps.Examples;
model DOE2WatertoWater
 extends Modelica.Icons.Example;
   package Medium = Buildings.Media.Water "Medium model";

   parameter Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
    per "Performance data"
     annotation (Placement(transformation(extent={{72,24},{92,44}})));
   parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
       "Evaporator nominal mass flow rate";
   parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
       "Condenser nominal mass flow rate";

    DOE2WaterToWater heaPumDOE2(
    per=per,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    show_T=true,
    dp1_nominal=200,
    dp2_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Water to Water heatpump DOE2 method"
     annotation (Placement(transformation(extent={{32,-10},{52,10}})));
    Sources.MassFlowSource_T conPum(
    use_m_flow_in=false,
    m_flow=mCon_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium)
     "Condenser water pump"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,90})));
    Sources.MassFlowSource_T evaPum(
    m_flow=mEva_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium)
     "Evaporator water pump"
      annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=180,
        origin={73,-47})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TConEnt(
    height=5,
    duration(displayUnit="h") = 14400,
    offset=30 + 273.15,
    startTime=0)
    "Condesner entering water temperature"
     annotation (Placement(transformation(extent={{-120,76},{-100,96}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaEnt(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15,
    startTime=0)
    "Evaporator entering water temperature"
     annotation (Placement(transformation(extent={{60,-96},{80,-76}})));
    FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{56,56},{76,76}})));
    FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{-10,-94},{10,-74}})));
    Modelica.Fluid.Sources.FixedBoundary heaVol(nPorts=1, redeclare package Medium = Medium)
    "Volume for heating load"
     annotation (Placement(transformation(extent={{104,74},{84,94}})));
    Modelica.Fluid.Sources.FixedBoundary cooVol(nPorts=1, redeclare package Medium = Medium)
    "Volume for cooling load"
     annotation (Placement(transformation(extent={{-60,-94},{-40,-74}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaSet(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15,
    startTime=0)
    "Evaporator setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TConSet(
    height=5,
    duration(displayUnit="h") = 14400,
    offset=35 + 273.15,
    startTime=0)
    "Condenser setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,60},{0,80}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp uMod(
    height=2,
    duration(displayUnit="h") = 14400,
    offset=-1,
    startTime=0)
    "HeatPump operational mode input signal"
     annotation (Placement(transformation(extent={{-116,
            -10},{-96,10}})));
    Modelica.Blocks.Math.RealToInteger reaToInt
     annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(heaPumDOE2.port_a1, conPum.ports[1])
    annotation (Line(points={{32,6},{
          24,6},{24,90},{-40,90}}, color={0,127,255}));
  connect(TConEnt.y, conPum.T_in)
    annotation (Line(points={{-99,86},{-62,86}}, color={0,0,127}));
  connect(TEvaEnt.y, evaPum.T_in)
    annotation (Line(points={{81,-86},{98,-86},{98,
          -51.4},{86.2,-51.4}}, color={0,0,127}));
  connect(evaPum.ports[1], heaPumDOE2.port_a2)
    annotation (Line(points={{62,-47},
          {56,-47},{56,-6},{52,-6}}, color={0,127,255}));
  connect(cooVol.ports[1],res2. port_a)
    annotation (Line(points={{-40,-84},{-10,-84}}, color={0,127,255}));
  connect(res1.port_a, heaPumDOE2.port_b1)
    annotation (Line(points={{56,66},{52,66},{52,6}}, color={0,127,255}));
  connect(res2.port_b, heaPumDOE2.port_b2)
    annotation (Line(points={{10,-84},{24,
          -84},{24,-6},{32,-6}}, color={0,127,255}));
  connect(TConSet.y, heaPumDOE2.TConSet)
    annotation (Line(points={{1,70},{16,70},
          {16,9},{31.6,9}}, color={0,0,127}));
  connect(TEvaSet.y, heaPumDOE2.TEvaSet)
    annotation (Line(points={{1,-50},{16,-50},
          {16,-9.1},{31.5,-9.1}}, color={0,0,127}));
  connect(res1.port_b,heaVol. ports[1])
    annotation (Line(points={{76,66},{84,66},{84,84}}, color={0,127,255}));
  connect(uMod.y, reaToInt.u)
    annotation (Line(points={{-95,0},{-62,0}}, color={0,0,127}));
  connect(reaToInt.y, heaPumDOE2.uMod)
    annotation (Line(points={{-39,0},{-4,0},{
          -4,-0.1},{31.5,-0.1}}, color={255,127,0}));
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
    Diagram(coordinateSystem(extent={{-120,-100},{120,100}})));
end DOE2WatertoWater;
