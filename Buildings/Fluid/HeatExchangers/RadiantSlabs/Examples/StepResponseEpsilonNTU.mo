within Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples;
model StepResponseEpsilonNTU
  "Model that tests the radiant slab with epsilon-NTU configuration"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water;
  Sources.Boundary_ph sin(redeclare package Medium = Medium, nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));
  Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=298.15,
    nPorts=1) "Source"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Modelica.Blocks.Sources.Pulse pulse(
    period=86400,
    startTime=0,
    amplitude=-m_flow_nominal,
    offset=m_flow_nominal)
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
       sla(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    layers=layers,
    iLayPip=1,
    pipe=pipe,
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.2,
    A=A,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    heatTransfer=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.HeatTransfer.FiniteDifference)
    "Slabe with embedded pipes"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.167
    "Nominal mass flow rate";
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAirAbo(T=293.15)
    "Air temperature above the slab"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TRadAbo(T=293.15)
    "Radiant temperature above the slab"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAirBel(T=293.15)
    "Air temperature below the slab"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TRadBel(T=293.15)
    "Radiant temperature below the slab"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  HeatTransfer.Convection.Interior conAbo(
    A=A,
    conMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    til=Buildings.Types.Tilt.Floor)
    "Convective heat transfer above the slab"
    annotation (Placement(transformation(extent={{0,60},{-20,80}})));
  parameter Modelica.Units.SI.Area A=10 "Heat transfer area";
  HeatTransfer.Convection.Interior conBel(
    A=A,
    conMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    til=Buildings.Types.Tilt.Ceiling)
    "Convective heat transfer below the slab"
    annotation (Placement(transformation(extent={{0,-60},{-20,-40}})));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation hRadAbo(Gr=A/(1/0.7 + 1
        /0.7 - 1)) "Radiative heat transfer above the slab"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation hRadBel(Gr=A/(1/0.7 + 1
        /0.7 - 1)) "Radiative heat transfer below the slab"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic layers(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.08,
        k=1.13,
        c=1000,
        d=1400,
        nSta=5),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.05,
        k=0.04,
        c=1400,
        d=10),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.2,
        k=1.8,
        c=1100,
        d=2400)})
    "Material layers from surface a to b (8cm concrete, 5 cm insulation, 20 cm reinforced concrete)"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  parameter Data.Pipes.PEX_RADTEST pipe "Pipe material"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Sensors.TemperatureTwoPort TOut(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal) "Outlet temperature of the slab"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
equation
  connect(pulse.y, sou.m_flow_in)       annotation (Line(
      points={{-59,-12},{-30,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], sla.port_a) annotation (Line(
      points={{-10,-20},{10,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TAirAbo.port, conAbo.fluid) annotation (Line(
      points={{-40,70},{-20,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRadAbo.port, hRadAbo.port_a) annotation (Line(
      points={{-40,30},{-20,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAirBel.port, conBel.fluid) annotation (Line(
      points={{-40,-50},{-20,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRadBel.port, hRadBel.port_a) annotation (Line(
      points={{-40,-90},{-20,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conAbo.solid, sla.surf_a) annotation (Line(
      points={{5.55112e-16,70},{24,70},{24,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hRadAbo.port_b, sla.surf_a) annotation (Line(
      points={{5.55112e-16,30},{24,30},{24,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conBel.solid, sla.surf_b) annotation (Line(
      points={{5.55112e-16,-50},{24,-50},{24,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hRadBel.port_b, sla.surf_b) annotation (Line(
      points={{5.55112e-16,-90},{24,-90},{24,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla.port_b, TOut.port_a) annotation (Line(
      points={{30,-20},{40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1]) annotation (Line(
      points={{60,-20},{70,-20}},
      color={0,127,255},
      smooth=Smooth.None));

 annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/RadiantSlabs/Examples/StepResponseEpsilonNTU.mos"
        "Simulate and plot"),
          Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-120},
            {100,100}})),
Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponseFiniteDifference\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponseFiniteDifference</a>
except that the number of segments in the slab is set to <i>1</i>
and the heat transfer between the fluid and the slab is computed using
an epsilon-NTU model.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
October 7, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=86400,
      Tolerance=1e-6));
end StepResponseEpsilonNTU;
