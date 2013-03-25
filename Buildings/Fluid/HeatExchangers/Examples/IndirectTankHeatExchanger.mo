within Buildings.Fluid.HeatExchangers.Examples;
model IndirectTankHeatExchanger
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.IndirectTankHeatExchanger indTanHX(
    nSeg=3,
    C=50,
    UA_nominal=20,
    m_flow_nominal_htf=0.1,
    HtfVol=0.0004,
    ASurHX=0.1999,
    redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47,
    dHXExt=0.01905,
    redeclare package Medium_2 = Modelica.Media.Water.WaterIF97_pT)
                          annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=90,
        origin={-19,3})));

  Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package Medium
      = Modelica.Media.Incompressible.Examples.Glycol47)
    annotation (Placement(transformation(extent={{-72,-42},{-52,-22}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47,
    m_flow=0.1,
    nPorts=1,
    T=323.15) annotation (Placement(transformation(extent={{-72,34},{-52,54}})));

  Buildings.HeatTransfer.Sources.FixedTemperature watTem[3](each T=293.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={36,4})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
equation
  connect(bou1.ports[1], indTanHX.port_a) annotation (Line(
      points={{-52,-32},{-22.85,-32},{-22.85,-1.95}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], indTanHX.port_b) annotation (Line(
      points={{-52,44},{-22.85,44},{-22.85,8.94}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(indTanHX.port_b1, watTem.port) annotation (Line(
      points={{-15.26,3.55},{12.4,3.55},{12.4,4},{26,4}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
// fixme: documentation and .mos script is missing
end IndirectTankHeatExchanger;
