within Buildings.Fluid.Chillers.Examples;
model AbsorptionIndirect
  "Test model for absorption indirect steam chiller"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water
   "Medium model";
  parameter Data.AbsorptionIndirect.AbsorptionIndirectChiller_EnergyPlus perEP
    "Performance data implemented at EnergyPlus example"
    annotation (Placement(transformation(extent={{60,74},{80,94}})));

  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=perEP.mEva_flow_nominal
    "Evaporator nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=perEP.mCon_flow_nominal
    "Condenser nominal mass flow rate";
  Buildings.Fluid.Chillers.AbsorptionIndirect absIndSte(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    show_T=true,
    per=perEP,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp1_nominal=200,
    dp2_nominal=200) "Absorption Indirect Chiller model"
    annotation (Placement(transformation(extent={{12,0},{32,20}})));
    Sources.MassFlowSource_T conPum(
      use_m_flow_in=false,
      m_flow=mCon_flow_nominal,
      use_T_in=true,
      redeclare package Medium = Medium,
      nPorts=1)
     "Condenser water pump"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-48,70})));
    Sources.MassFlowSource_T evaPum(
      m_flow=mEva_flow_nominal,
      use_T_in=true,
      redeclare package Medium = Medium,
      nPorts=1)
     "Evaporator water pump"
     annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=180,
        origin={63,-37})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TConEnt(
      height=5,
      duration(displayUnit="h") = 14400,
      offset=20 + 273.15,
      startTime=0)
     "Condesner entering water temperature"
     annotation (Placement(transformation(extent={{-96,56},{-76,76}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaEnt(
      height=4,
      duration(displayUnit="h") = 14400,
      offset=12 + 273.15,
      startTime=0)
     "Evaporator entering water temperature"
     annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
    FixedResistances.PressureDrop res1(
      redeclare package Medium = Medium,
      m_flow_nominal=mCon_flow_nominal,
      dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{40,6},{60,26}})));
    FixedResistances.PressureDrop res2(
      redeclare package Medium = Medium,
      m_flow_nominal=mEva_flow_nominal,
      dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{-38,-72},{-18,-52}})));
    Modelica.Fluid.Sources.FixedBoundary heaVol(nPorts=1, redeclare package
      Medium = Medium)
    "Volume for heating load"
     annotation (Placement(transformation(extent={{98,40},{78,60}})));
    Modelica.Fluid.Sources.FixedBoundary cooVol(nPorts=1, redeclare package
      Medium = Medium)
    "Volume for cooling load"
     annotation (Placement(transformation(extent={{-94,-72},{-74,-52}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaSet(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15,
    startTime=0)
    "Evaporator setpoint water temperature"
     annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
    Modelica.Blocks.Sources.Pulse pulse(period=3600/2)
     annotation (Placement(transformation(extent={{-94,0},{-74,20}})));
    Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0.5)
     annotation (Placement(transformation(extent={{-54,0},{-34,20}})));
equation
  connect(absIndSte.port_b1, res1.port_a)
    annotation (Line(
      points={{32,16},{40,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TConEnt.y,conPum. T_in)
    annotation (Line(points={{-74,66},{-60,66}}, color={0,0,127}));
  connect(TEvaEnt.y,evaPum. T_in)
    annotation (Line(points={{82,-80},{98,-80},{98,-41.4},{76.2,-41.4}},
                                color={0,0,127}));
  connect(cooVol.ports[1],res2. port_a)
    annotation (Line(points={{-74,-62},{-38,-62}}, color={0,127,255}));
  connect(res1.port_b,heaVol. ports[1])
    annotation (Line(points={{60,16},{78,16},{78,50}}, color={0,127,255}));
  connect(absIndSte.port_a2, evaPum.ports[1])
    annotation (Line(points={{32,4},{40,4},{40,-37},{52,-37}},
                                 color={0,127,255}));
  connect(res2.port_b, absIndSte.port_b2)
    annotation (Line(points={{-18,-62},{12,-62},{12,4}},
                              color={0,127,255}));
  connect(absIndSte.TSet, TEvaSet.y) annotation (Line(points={{11,8},{-6,8},{-6,
          -30},{-38,-30}}, color={0,0,127}));
  connect(conPum.ports[1], absIndSte.port_a1)
    annotation (Line(points={{-38,70},{-20,70},{-20,16},{12,16}},
                                     color={0,127,255}));
  connect(greaterThreshold.u,pulse. y)
    annotation (Line(
      points={{-56,10},{-73,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(absIndSte.on, greaterThreshold.y)
    annotation (Line(points={{11,12},{-33,12},{-33,10}},
                                color={255,0,255}));
  annotation (
experiment(Tolerance=1e-6, StopTime=14400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/AbsorptionIndirect.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates a chiller whose efficiency is computed based on the
condenser entering and evaporator leaving fluid temperature.
Cubic and quadratic polynomial curves are used to compute the absorption chiller part load performance.
</p>
</html>", revisions="<html>
<ul>
<li>
July 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirect;
