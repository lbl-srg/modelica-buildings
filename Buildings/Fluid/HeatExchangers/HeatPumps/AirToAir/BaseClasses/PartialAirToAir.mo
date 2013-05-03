within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses;
partial model PartialAirToAir "Partial model for air to air heat pump"
  extends Interfaces.FourPortHeatMassExchanger(
    final show_T=false,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol1( final allowFlowReversal=true),
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(V=m2_flow_nominal*tau2/rho2_nominal,
       nPorts=2,final allowFlowReversal=true));

  parameter Boolean computeReevaporation=true
    "Set to true to compute reevaporation of water that accumulated on coil";

  parameter Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.HPData datHP
    "Heat pump data";
  Modelica.SIunits.SpecificEnthalpy h1In=
    inStream(port_a1.h_outflow) "Enthalpy of air entering the heat pump";
  Modelica.SIunits.MassFraction X1In[Medium1.nXi] = inStream(port_a1.Xi_outflow)
    "Water mass fraction in air entering the heat pump";
  Modelica.SIunits.Temperature T1In = Medium1.T_phX(p=port_a1.p, h=h1In, X=X1In)
    "Temperature of air entering the heat pump";
  Modelica.SIunits.SpecificEnthalpy h2In=
    inStream(port_a2.h_outflow) "Enthalpy of air entering the heat pump";
  Modelica.SIunits.MassFraction X2In[Medium2.nXi] = inStream(port_a2.Xi_outflow)
    "Water mass fraction in air entering the heat pump";
  Modelica.SIunits.Temperature T2In = Medium2.T_phX(p=port_a2.p, h=h2In, X=X2In)
    "Temperature of air entering the heat pump";
//   Modelica.SIunits.Temperature T2In = Medium2.temperature_ph(p=port_a2.p, h=h2In)
//     "Temperature of water entering the heat pump";
  parameter Modelica.SIunits.Mass mSta= 0
    "Mass of water accumulated on the coil at time = 0"
     annotation (Evaluate=true, Dialog(tab = "Dynamics", group="Initial condition",
     enable = computeReevaporation));

  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power",unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,84},{120,104}},rotation=0)));

protected
  HeatTransfer.Sources.PrescribedHeatFlow q[2] "Heat added/extracted by coil"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.RealExpression mIn_flow[2](final y={port_a1.m_flow,
        port_a2.m_flow}) "Inlet mass flow rates"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.RealExpression TIn[2](final y={T1In,T2In})
    "Inlet Temperatures"
    annotation (Placement(transformation(extent={{-80,6},{-60,26}})));
public
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DynamicStartStop dynStaSto[2](
    each tauOn= 15,
    each tauOff= 30) "Dynamic start"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.HeatMassFlow heaMasFlo(
    redeclare package Medium1 = Medium1,
    variableSpeedCoil=true,
    datHP=datHP) "Water to air heat flow operation"
              annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Temperature of the control volume"
    annotation (Placement(transformation(extent={{-18,14},{-6,26}})));
  Modelica.Blocks.Sources.RealExpression p(final y=port_a1.p)
    "Inlet air pressure"
    annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
  Modelica.Blocks.Sources.RealExpression X(final y=X1In[1])
    "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-80,-42},{-60,-22}})));
  Modelica.Blocks.Sources.RealExpression h(final y=h1In)
    "Inlet air specific enthalpy"
    annotation (Placement(transformation(extent={{-80,-56},{-60,-36}})));
equation

  connect(q[2].port, vol2.heatPort) annotation (Line(
      points={{90,6.10623e-16},{92,6.10623e-16},{92,-60},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(q[1].port, vol1.heatPort) annotation (Line(
      points={{90,6.10623e-16},{92,6.10623e-16},{92,76},{-26,76},{-26,60},{-10,
          60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(heaMasFlo.Q1_flow, dynStaSto[1].u) annotation (Line(
      points={{17,6},{32,6},{32,6.66134e-16},{38,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaMasFlo.Q2_flow, dynStaSto[2].u) annotation (Line(
      points={{17,-8},{32,-8},{32,6.66134e-16},{38,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dynStaSto.y, q.Q_flow) annotation (Line(
      points={{61,6.10623e-16},{64.5,6.10623e-16},{64.5,6.66134e-16},{70,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(heaMasFlo.P, P) annotation (Line(
      points={{17,8},{32,8},{32,94},{110,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaMasFlo.T1CoiSur, vol1.TWat) annotation (Line(
      points={{17,4},{24,4},{24,40},{-24,40},{-24,55.2},{-12,55.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaMasFlo.m1Wat_flow, vol1.mWat_flow) annotation (Line(
      points={{17,2},{28,2},{28,44},{-20,44},{-20,52},{-12,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol1.heatPort, TVol.port) annotation (Line(
      points={{-10,60},{-26,60},{-26,20},{-18,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TVol.T, heaMasFlo.T1Out) annotation (Line(
      points={{-6,20},{4.1,20},{4.1,11.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol1.X_w, heaMasFlo.X1Out) annotation (Line(
      points={{12,64},{16,64},{16,20},{7.9,20},{7.9,11.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn.y, heaMasFlo.TIn) annotation (Line(
      points={{-59,16},{-40,16},{-40,5},{-5,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mIn_flow.y, heaMasFlo.m_flow) annotation (Line(
      points={{-59,6.10623e-16},{-40.5,6.10623e-16},{-40.5,2.4},{-5,2.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, heaMasFlo.p) annotation (Line(
      points={{-59,-16},{-36,-16},{-36,-2.4},{-5,-2.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X.y, heaMasFlo.X1In) annotation (Line(
      points={{-59,-32},{-30,-32},{-30,-5},{-5,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h.y, heaMasFlo.h1In) annotation (Line(
      points={{-59,-46},{-24,-46},{-24,-7.7},{-5,-7.7}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics),
              defaultComponentName="watToWatHP",  Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.MultiStage\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.MultiStage</a>, 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.SingleSpeed\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.SingleSpeed</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.VariableSpeed\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.VariableSpeed</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 10, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end PartialAirToAir;
