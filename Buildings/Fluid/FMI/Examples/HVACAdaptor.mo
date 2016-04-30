within Buildings.Fluid.FMI.Examples;
block HVACAdaptor "Validation model for the convective HVAC system"
extends Modelica.Icons.Example;
  Buildings.Fluid.FMI.HVACAdaptor theHvaAda(redeclare final package Medium =
        MediumA, nPorts=1)
    annotation (Placement(transformation(extent={{-28,-20},{12,20}})));

  replaceable package MediumA = Buildings.Media.Air "Medium for air";
protected
  Modelica.Blocks.Sources.Constant zero(k=0) "Zero output signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-8,-80})));
public
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
    annotation (Placement(transformation(extent={{-62,30},{-42,50}})));
  Modelica.Blocks.Sources.Constant radTem(k=298.13)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRad
    "Radiative temperature"
    annotation (Placement(transformation(extent={{-66,-50},{-46,-30}})));
  Sources.FixedBoundary bou(
    nPorts=2,
    redeclare package Medium = MediumA,
    T=293.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-118,-8},{-98,12}})));
  Source_T sou(
    redeclare package Medium = MediumA,
    use_p_in=use_p_in,
    allowFlowReversal = allowFlowReversal)
    "Source for mass flow rate and pressure"
    annotation (Placement(transformation(extent={{54,0},{34,20}})));
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
equation
  connect(zero.y, theHvaAda.QGaiCon_flow)
    annotation (Line(points={{-8,-69},{-8,-23.3333}},
                                                    color={0,0,127}));
  connect(zero.y, theHvaAda.QGaiLat_flow) annotation (Line(points={{-8,-69},{-8,
          -56},{4,-56},{4,-23.3333}},
                                   color={0,0,127}));
  connect(zero.y, theHvaAda.QGaiRad_flow) annotation (Line(points={{-8,-69},{-8,
          -56},{-20,-56},{-20,-23.3333}},
                                     color={0,0,127}));
  connect(rooAir.y, TAir.T)
    annotation (Line(points={{-79,40},{-79,40},{-64,40}}, color={0,0,127}));
  connect(TAir.port, theHvaAda.heaPorAir) annotation (Line(points={{-42,40},{
          -38,40},{-38,12.6667},{-28,12.6667}},
                                            color={191,0,0}));
  connect(radTem.y, TRad.T)
    annotation (Line(points={{-79,-40},{-68,-40}}, color={0,0,127}));
  connect(TRad.port, theHvaAda.heaPorRad) annotation (Line(points={{-46,-40},{
          -38,-40},{-38,-13.3333},{-28.4,-13.3333}},
                                               color={191,0,0}));
  connect(bou.ports[1:2], theHvaAda.ports)
    annotation (Line(points={{-98,0},{-98,0},{-28,0}}, color={0,127,255}));
  connect(sou.m_flow_in, m_flow.y) annotation (Line(points={{56,20},{56,20},{62,
          20},{64,20},{64,70},{73,70}},
                                color={0,0,127}));
  connect(sou.p_in, pIn.y) annotation (Line(points={{56,14.8},{70,14.8},{70,40},
          {73,40}}, color={0,127,127}));
  connect(sou.T_in, TIn.y)
    annotation (Line(points={{56,10},{56,10},{73,10}}, color={0,0,127}));
  connect(sou.X_w_in, X_w_in.y) annotation (Line(points={{56,5},{70,5},{70,-30},
          {73,-30}}, color={0,0,127}));
  connect(sou.C_in, C.y) annotation (Line(points={{56,0},{66,0},{66,-62},{73,-62}},
                     color={0,0,127}));
  connect(sou.outlet, theHvaAda.supAir[1]) annotation (Line(points={{33,10},{28,
          10},{28,13.3333},{14,13.3333}}, color={0,0,255}));
 annotation (Line(points={{40,70},{76,70},
          {76,100},{110,100}}, color={0,127,255}),
    Diagram(coordinateSystem(extent={{-120,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-120,-100},{100,100}})),
    Documentation(info="<html>
<p>This example demonstrates how to uses the <a href=\"modelica://Buildings.Fluid.FMI.HVACAdaptor\">Buildings.Fluid.FMI.HVACAdaptor</a>. </p>
</html>", revisions="<html>
<ul>
<li>April 28, 2016 by Thierry S. Nouidui:<br>First implementation. </li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/HVACAdaptor.mos"
        "Simulate and plot"),
    experiment(StopTime=1));
end HVACAdaptor;
