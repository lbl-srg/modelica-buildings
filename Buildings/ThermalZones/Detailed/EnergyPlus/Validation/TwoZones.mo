within Buildings.ThermalZones.Detailed.EnergyPlus.Validation;
model TwoZones "Validation model for two zones"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter String fmuName = "aaa.fmu" "Name of the FMU file that contains this zone";

  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  ThermalZone zon1(
    fmuName="bld.fmu",
    zoneName="Zone 1",
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Thermal zone"
    annotation (Placement(transformation(extent={{20,20},{60,60}})));
  ThermalZone zon2(
    fmuName="bld.fmu",
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Zone 2",
    nPorts=2) "Thermal zone"
    annotation (Placement(transformation(extent={{18,-40},{58,0}})));
  Fluid.FixedResistances.PressureDrop duc(
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=47*6/3600*1.2,
    redeclare package Medium = Medium)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0,
    T=298.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Fluid.Sources.Boundary_pT freshAir(
    nPorts=1,
    redeclare package Medium = Medium)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-59,40},{-52,40},{-52,17},{-42,17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-59,10},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow. y) annotation (Line(points={{-42,3},
          {-52,3},{-52,-20},{-59,-20}}, color={0,0,127}));
  connect(zon1.qGai_flow, multiplex3_1.y) annotation (Line(points={{18,50},{-8,
          50},{-8,10},{-19,10}}, color={0,0,127}));
  connect(zon2.qGai_flow, multiplex3_1.y) annotation (Line(points={{16,-10},{-8,
          -10},{-8,10},{-19,10}}, color={0,0,127}));
  connect(freshAir.ports[1],duc. port_a)
    annotation (Line(points={{-20,-50},{-10,-50}}, color={0,127,255}));
  connect(duc.port_b,zon2. ports[1])
    annotation (Line(points={{10,-50},{36,-50},{36,-39.2}},
                                                          color={0,127,255}));
  connect(bou.ports[1],zon2. ports[2])
    annotation (Line(points={{-20,-80},{40,-80},{40,-39.2}},
                                                           color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Simple test case for one buildings with two thermal zones.
</p>
</html>", revisions="<html>
<ul><li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/EnergyPlus/Validation/TwoZones.mos"
        "Simulate and plot"),
experiment(
      StopTime=86400,
      Tolerance=1e-06));
end TwoZones;
