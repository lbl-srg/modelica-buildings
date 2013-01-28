within Buildings.Fluid.HeatExchangers.Examples;
model IndirectTankHeatExchanger
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.IndirectTankHeatExchanger indTanHX(
    nSeg=3,
    C=50,
    GlyVol=0.01,
    UA_nominal=20,
    m_flow_nominal_gly=0.1,
    m_flow_nominal_wat=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,10})));

  Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package Medium
      = Modelica.Media.Incompressible.Examples.Glycol47)
    annotation (Placement(transformation(extent={{-72,-42},{-52,-22}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47,
    m_flow=0.1,
    nPorts=1) annotation (Placement(transformation(extent={{-72,34},{-52,54}})));

  Buildings.HeatTransfer.Sources.FixedTemperature watTem[3](T=303.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={36,4})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
equation
  connect(bou1.ports[1], indTanHX.port_a) annotation (Line(
      points={{-52,-32},{-17,-32},{-17,17}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], indTanHX.port_b) annotation (Line(
      points={{-52,44},{2.8,44},{2.8,17}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(indTanHX.port_b1, watTem.port) annotation (Line(
      points={{-7,3.2},{12.4,3.2},{12.4,4},{26,4}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end IndirectTankHeatExchanger;
