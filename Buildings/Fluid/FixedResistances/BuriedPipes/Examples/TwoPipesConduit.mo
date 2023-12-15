within Buildings.Fluid.FixedResistances.BuriedPipes.Examples;
model TwoPipesConduit
  "Example model of a buried conduit housing a supply and return pipe"
  extends Modelica.Icons.Example;

  replaceable parameter
    Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Boston
    cliCon "Surface temperature climatic conditions";
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe"
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Length dCon=0.3 "Conduit diameter";
  parameter Modelica.Units.SI.Length len=1000 "Conduit length";
  parameter Modelica.Units.SI.Length xConWal=0.01 "Conduit wall thickness";

  parameter Buildings.HeatTransfer.Data.Soil.Generic conMat(
    k=0.19,
    c=840,
    d=1380) "Conduit wall material (PVC)"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic
    soiDat(k=1.58,c=1150,d=1600) "Soil thermal properties"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  FixedResistances.PlugFlowPipe pipSup(
    redeclare package Medium = Medium,
    dh=0.1,
    length=len,
    m_flow_nominal=1,
    dIns(displayUnit="mm") = 0.06,
    kIns=0.05,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032) "Buried pipe"
    annotation (Placement(transformation(extent={{-10,50},{10,30}})));

  Buildings.Fluid.FixedResistances.BuriedPipes.GroundCoupling gro(
    nPip=1,
    cliCon=cliCon,
    soiDat=soiDat,
    nSeg=1,
    len={len},
    dep={1.5},
    pos={0},
    rad={dCon}) "Ground coupling" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,90})));

  Modelica.Blocks.Sources.Sine TinSup(
    amplitude=5,
    f=1/180/24/60/60,
    offset=273.15 + 70) "Pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Sources.MassFlowSource_T souSup(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Sensors.TemperatureTwoPort senTemInlSup(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=343.15) "Pipe inlet temperature sensor"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Sources.Boundary_pT sinSup(
    redeclare package Medium = Medium,
    T=343.15,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Boundary condition"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Sensors.TemperatureTwoPort senTemOutSup(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=343.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));

  FixedResistances.PlugFlowPipe pipRet(
    redeclare package Medium = Medium,
    dh=0.1,
    length=len,
    m_flow_nominal=1,
    dIns=0.01,
    kIns=0.19,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032) "Buried pipe"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Sensors.TemperatureTwoPort senTemOutRet(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=323.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Sensors.TemperatureTwoPort senTemInlRet(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=323.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Sources.MassFlowSource_T souRet(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-40})));
  Sources.Boundary_pT sinRet(
    redeclare package Medium = Medium,
    T=323.15,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Boundary condition" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-40})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor conAir(C=VConAir * rhoAir * cpAir, T(start=
          313.15, fixed=true))
    "Conduit air heat capacity" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-72,0})));

  Modelica.Blocks.Sources.Sine TinRet(
    amplitude=2,
    f=1/180/24/60/60,
    phase=0.78539816339745,
    offset=273.15 + 50) "Pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{120,-50},{100,-30}})));

  HeatTransfer.Conduction.SingleLayerCylinder con(
    final material=conMat,
    final h=len,
    final r_a=dCon,
    final r_b=dCon + xConWal,
    nSta=1,
    TInt_start=313.15,
    TExt_start=313.15)        "Conduit heat conduction"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  parameter Modelica.Units.SI.Volume VConAir=len*Modelica.Constants.pi*((dCon/2)
      ^2 - (pipSup.dh/2)^2 - (pipRet.dh/2)^2) "Air volume in conduit";
  constant Modelica.Units.SI.Density rhoAir=1.2 "Air density";
  constant Modelica.Units.SI.SpecificHeatCapacity cpAir=Buildings.Utilities.Psychrometrics.Constants.cpAir
    "Air specific heat capacity";

equation
  connect(TinSup.y, souSup.T_in) annotation (Line(points={{-99,40},{-88,40},{-88,
          44},{-82,44}}, color={0,0,127}));
  connect(souSup.ports[1], senTemInlSup.port_a)
    annotation (Line(points={{-60,40},{-50,40}}, color={0,127,255}));
  connect(senTemOutSup.port_b, sinSup.ports[1])
    annotation (Line(points={{50,40},{60,40}}, color={0,127,255}));
  connect(senTemInlSup.port_b, pipSup.port_a)
    annotation (Line(points={{-30,40},{-10,40}}, color={0,127,255}));
  connect(senTemOutRet.port_b,pipRet. port_a)
    annotation (Line(points={{-30,-40},{-10,-40}},
                                                 color={0,127,255}));
  connect(souRet.ports[1],senTemInlRet. port_b)
    annotation (Line(points={{60,-40},{50,-40}}, color={0,127,255}));
  connect(sinRet.ports[1],senTemOutRet. port_a)
    annotation (Line(points={{-60,-40},{-50,-40}}, color={0,127,255}));
  connect(conAir.port, pipSup.heatPort) annotation (Line(points={{-62,-5.55112e-16},
          {0,-5.55112e-16},{0,30}}, color={191,0,0}));
  connect(conAir.port,pipRet. heatPort) annotation (Line(points={{-62,-4.44089e-16},
          {0,-4.44089e-16},{0,-30}},               color={191,0,0}));
  connect(TinRet.y,souRet. T_in) annotation (Line(points={{99,-40},{88,-40},{88,
          -44},{82,-44}}, color={0,0,127}));
  connect(con.port_a, pipSup.heatPort)
    annotation (Line(points={{40,0},{0,0},{0,30}}, color={191,0,0}));
  connect(con.port_b, gro.ports[1, 1])
    annotation (Line(points={{60,0},{90,0},{90,80}}, color={191,0,0}));
  connect(pipSup.port_b, senTemOutSup.port_a)
    annotation (Line(points={{10,40},{30,40}}, color={0,127,255}));
  connect(pipRet.port_b, senTemInlRet.port_a)
    annotation (Line(points={{10,-40},{30,-40}}, color={0,127,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}})),
    experiment(StopTime=63072000, Tolerance=1e-06),
    Documentation(info="<html>
<p>
This example showcases the ground thermal coupling for a buried conduit
that contains one insulated hot water supply pipe oscillating around
<i>70</i>°C and an uninsulated hot water return pipe oscillating around
<i>50</i>°C.
</p>
</html>", revisions="<html>
<ul>
<li>
December 7, 2023, by Ettore Zanetti:<br/>
Moved <code>BuriedPipes</code> package<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
</li>
<li>
September 14, 2021, by Michael Wetter:<br/>
Updated example for new pipe model.
</li>
<li>
June 02, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/BuriedPipes/Examples/TwoPipesConduit.mos"
        "Simulate and plot"));
end TwoPipesConduit;
