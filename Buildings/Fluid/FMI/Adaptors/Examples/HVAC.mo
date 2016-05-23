within Buildings.Fluid.FMI.Adaptors.Examples;
model HVAC "Example of an HVAC model"
extends Modelica.Icons.Example;
  Buildings.Fluid.FMI.Adaptors.HVAC theHvaAda(
    redeclare final package Medium = MediumA,
    nFluPor=1)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

   replaceable package MediumA = Buildings.Media.Air "Medium for air";

   parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";
      parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  Modelica.Blocks.Sources.Constant rooAir(k=295.13)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{-64,30},{-44,50}})));
  Modelica.Blocks.Sources.Constant radTem(k=298.13)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRad
    "Radiative temperature"
    annotation (Placement(transformation(extent={{-66,-50},{-46,-30}})));
  Sources.FixedBoundary bou(
    redeclare package Medium = MediumA,
    T=293.15,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Source_T sou(
    redeclare package Medium = MediumA,
    use_p_in=use_p_in,
    allowFlowReversal = allowFlowReversal)
    "Source for mass flow rate and pressure"
    annotation (Placement(transformation(extent={{50,0},{30,20}})));
  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal*3) "Mass flow rate"
    annotation (Placement(transformation(extent={{94,60},{74,80}})));
  Modelica.Blocks.Sources.Constant pIn(k=100000) "Inlet pressure"
    annotation (Placement(transformation(extent={{94,30},{74,50}})));
  Modelica.Blocks.Sources.Constant TIn(k=293.15) "Inlet temperature"
    annotation (Placement(transformation(extent={{94,0},{74,20}})));
  Modelica.Blocks.Sources.Constant X_w_in(k=0.01) "Inlet mass fraction"
    annotation (Placement(transformation(extent={{94,-40},{74,-20}})));
  Modelica.Blocks.Sources.Constant C[MediumA.nC](each k=0.01) if
     MediumA.nC > 0 "Trace substances for forward flow"
    annotation (Placement(transformation(extent={{94,-72},{74,-52}})));
protected
  Modelica.Blocks.Sources.Constant zero(k=0) "Zero output signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-70})));
equation
  connect(rooAir.y, TAir.T)
    annotation (Line(points={{-79,40},{-79,40},{-66,40}}, color={0,0,127}));
  connect(TAir.port, theHvaAda.heaPorAir) annotation (Line(points={{-44,40},{
          -40,40},{-40,17.5},{-20,17.5}},   color={191,0,0}));
  connect(radTem.y, TRad.T)
    annotation (Line(points={{-79,-40},{-68,-40}}, color={0,0,127}));
  connect(TRad.port, theHvaAda.heaPorRad) annotation (Line(points={{-46,-40},{
          -40,-40},{-40,3.75},{-20,3.75}},     color={191,0,0}));
  connect(sou.m_flow_in, m_flow.y) annotation (Line(points={{52,20},{52,20},{60,
          20},{60,70},{73,70}}, color={0,0,127}));
  connect(sou.p_in, pIn.y) annotation (Line(points={{52,14.8},{70,14.8},{70,40},
          {73,40}}, color={0,127,127}));
  connect(sou.T_in, TIn.y)
    annotation (Line(points={{52,10},{52,10},{73,10}}, color={0,0,127}));
  connect(sou.X_w_in, X_w_in.y) annotation (Line(points={{52,5},{70,5},{70,-30},
          {73,-30}}, color={0,0,127}));
  connect(sou.C_in, C.y) annotation (Line(points={{52,0},{60,0},{60,-62},{73,
          -62}},     color={0,0,127}));
  connect(sou.outlet, theHvaAda.fluPor[1]) annotation (Line(points={{29,10},{20,
          10},{20,17.5},{0.714286,17.5}}, color={0,0,255}));
  connect(bou.ports[1], theHvaAda.ports[1]) annotation (Line(points={{-80,0},{
          -60,0},{-60,10},{-40,10},{-20,10},{-20,10},{-19.8571,10}},
                                  color={0,127,255}));
  connect(zero.y, theHvaAda.QGaiRad_flow) annotation (Line(points={{-10,-59},{
          -10,-50},{-14.2857,-50},{-14.2857,-1.25}},    color={0,0,127}));
  connect(zero.y, theHvaAda.QGaiCon_flow) annotation (Line(points={{-10,-59},{
          -10,-1.25}},                        color={0,0,127}));
  connect(zero.y, theHvaAda.QGaiLat_flow) annotation (Line(points={{-10,-59},{
          -10,-59},{-10,-50},{-5.71429,-50},{-5.71429,-1.25}},
                                                          color={0,0,127}));
 annotation (
    Diagram(coordinateSystem(extent={{-120,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-120,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example demonstrates how to 
use the <a href=\"modelica://Buildings.Fluid.FMI.HVACAdaptor\">
Buildings.Fluid.FMI.HVACAdaptor
</a>. 
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Adaptors/Examples/HVAC.mos"
        "Simulate and plot"),
    experiment(StopTime=1));
end HVAC;
