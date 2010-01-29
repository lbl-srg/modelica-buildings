within Buildings.Fluid.HeatExchangers.Radiators;
model RadiatorEN442_2 "Dynamic radiator for space heating"
   extends Fluid.Interfaces.PartialStaticTwoPortInterface;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={
        Ellipse(
          extent={{-20,22},{20,-20}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-95,6},{106,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,-4},{-2,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,22},{20,-20}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-66,30},{66,30}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-66,2},{66,2}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-66,-30},{66,-30}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-66,60},{-66,-60}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{66,60},{66,-60}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Documentation(info="<html>
This is a model of a radiator that can compute the dynamic or steady-state
response.
The required parameters are data that are typically available from
manufacturers that follow the European Norm EN 442-2.
</p>
<p>
However, to allow for varying mass flow rates, the transferred heat is computed
using a discretization along the water flow path, and heat is exchanged between
each compartment and a uniform room air and radiation temperature.
This discretization is different from the computation in EN 442-2, which 
may give water outlet temperatures that are below
the room temperature at low mass flow rates.
Also, rather than using only one room temperature, this model uses
a room air and room radiation temperature.
</p>
<p>
The parameter <tt>energyDynamics</tt> (in the Assumptions tab),
determines whether the model computes the dynamic or the steady-state response.
For the transient response, heat storage is computed using a 
finite volume approach for the 
water and the metal mass, which are both assumed to be at the same
temperature. 
</p>
<p>
The default parameters are for a flat plate radiator without fins, 
with one plate of water carying fluid, and a height of 0.42 meters.
</p>
</html>", revisions="<html>
<ul>
<li>
January 30, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Integer nEle(min=1) = 5
    "Number of elements used in the discretization" 
    annotation (Dialog(tab="Assumptions", group="Dynamics"));
  parameter Modelica.SIunits.Power Q_flow_nominal "Nominal heating power";
  parameter Real fraRad(min=0, max=1) = 0.35 "Fraction radiant heat transfer";
  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=system.energyDynamics
    "Formulation of energy balance" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

 // Initialization
  parameter Medium.AbsolutePressure p_start = system.p_start
    "Start value of pressure" 
    annotation(Dialog(tab = "Initialization"));
  parameter Boolean use_T_start = true "= true, use T_start, otherwise h_start"
    annotation(Dialog(tab = "Initialization"), Evaluate=true);
  parameter Medium.Temperature T_start=
    if use_T_start then system.T_start else Medium.temperature_phX(p_start,h_start,X_start)
    "Start value of temperature" 
    annotation(Dialog(tab = "Initialization", enable = use_T_start));
  parameter Medium.SpecificEnthalpy h_start=
    if use_T_start then Medium.specificEnthalpy_pTX(p_start, T_start, X_start) else Medium.h_default
    "Start value of specific enthalpy" 
    annotation(Dialog(tab = "Initialization", enable = not use_T_start));
  parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
    "Start value of mass fractions m_i/m" 
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances" 
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  parameter Modelica.SIunits.TemperatureDifference dT_nominal(min=0) = 50
    "Nominal temperature difference (between water and air)";
  parameter Real n = 1.24 "Exponent for heat transfer";
  parameter Modelica.SIunits.Volume VWat = 5.8E-6*Q_flow_nominal
    "Water volume of radiator" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Mass mDry = 0.0263*Q_flow_nominal if 
        not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Dry mass of radiator that will be lumped to water heat capacity" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  Modelica.SIunits.HeatFlowRate QCon_flow
    "Heat input into the water due to convective heat transfer with room air";
  Modelica.SIunits.HeatFlowRate QRad_flow
    "Heat input into the water due to radiative heat transfer with room";
  Modelica.SIunits.HeatFlowRate Q_flow "Heat input into the water";
  parameter Modelica.SIunits.TemperatureDifference deltaT=0.1
    "Temperature difference used for smoothing of heat transfer coefficient" 
    annotation (Dialog(tab="Advanced"));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon
    "Heat port for convective heat transfer with room air temperature" 
    annotation (Placement(transformation(extent={{-30,62},{-10,82}},
                                 rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad
    "Heat port for radiative heat transfer with room radiation temperature" 
    annotation (Placement(transformation(extent={{10,62},{30,82}},
                                 rotation=0)));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[nEle] heaCapDry(
      each C=500*mDry/nEle,
      each T(start=T_start)) if not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "heat capacity of radiator metal" 
    annotation (Placement(transformation(extent={{-80,4},{-60,24}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nEle] preHeaFloCon
    "Heat input into radiator from convective heat transfer" 
    annotation (Placement(transformation(extent={{-48,-48},{-28,-28}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nEle] preHeaFloRad
    "Heat input into radiator from radiative heat transfer" 
    annotation (Placement(transformation(extent={{-48,-70},{-28,-50}})));

  Fluid.MixingVolumes.MixingVolume[nEle] vol(
    redeclare each package Medium = Medium,
    each nPorts = 2,
    each V=VWat/nEle,
    each final use_HeatTransfer=true,
    redeclare each model HeatTransfer = 
        Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer,
    each final energyDynamics=energyDynamics,
    each final massDynamics=energyDynamics,
    each final p_start=p_start,
    each final use_T_start=use_T_start,
    each final T_start=T_start,
    each final h_start=h_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final m_flow_small=m_flow_small) "Volume for fluid stream" 
    annotation (Placement(transformation(extent={{-9,0},{11,-20}},
                          rotation=0)));
protected
   Modelica.SIunits.TemperatureDifference[nEle] dTCon
    "Temperature difference for convective heat transfer";
   Modelica.SIunits.TemperatureDifference[nEle] dTRad
    "Temperature difference for radiative heat transfer";
   parameter Modelica.SIunits.ThermalConductance UA_nominaln = Q_flow_nominal /dT_nominal^n/nEle;
   Modelica.SIunits.ThermalConductance[nEle] UACon
    "Thermal conductance between radiator and room for convective heat transfer";
   Modelica.SIunits.ThermalConductance[nEle] UARad
    "Thermal conductance between radiator and room for radiative heat transfer";

equation
  for i in 1:nEle loop
     dTCon[i] = heatPortCon.T - vol[i].medium.T;
     dTRad[i] = heatPortRad.T - vol[i].medium.T;
     UACon[i] = (1-fraRad)  * UA_nominaln *
                Buildings.Utilities.Math.Functions.regNonZeroPower(x=dTCon[i], n=n-1, delta=deltaT);
     UARad[i] = fraRad      * UA_nominaln *
                Buildings.Utilities.Math.Functions.regNonZeroPower(x=dTRad[i], n=n-1, delta=deltaT);
     preHeaFloCon[i].Q_flow = UACon[i] * dTCon[i];
     preHeaFloRad[i].Q_flow = UARad[i] * dTRad[i];
  end for;
  QCon_flow = sum(preHeaFloCon[i].Q_flow for i in 1:nEle);
  QRad_flow = sum(preHeaFloRad[i].Q_flow for i in 1:nEle);
  Q_flow = QCon_flow + QRad_flow;
  heatPortCon.Q_flow = QCon_flow;
  heatPortRad.Q_flow = QRad_flow;

  connect(preHeaFloCon.port, vol.heatPort) annotation (Line(
      points={{-28,-38},{-18,-38},{-18,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHeaFloRad.port, vol.heatPort) annotation (Line(
      points={{-28,-60},{-12,-60},{-12,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCapDry.port, vol.heatPort) annotation (Line(
      points={{-70,4},{-40,4},{-40,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_a, vol[1].ports[1]) annotation (Line(
      points={{-100,0},{-1,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol[nEle].ports[2], port_b) annotation (Line(
      points={{3,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nEle-1 loop

    connect(vol[i].ports[2], vol[i+1].ports[1]) annotation (Line(
        points={{3,0},{-1,0}},
        color={0,127,255},
        smooth=Smooth.None));
  end for;
end RadiatorEN442_2;
