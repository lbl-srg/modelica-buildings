within Buildings.Fluid.HeatExchangers.Radiators;
model RadiatorEN442_2 "Dynamic radiator for space heating"
   extends Fluid.Interfaces.PartialStaticTwoPortInterface(
   showDesignFlowDirection = false,
   show_T=true,
   m_flow_nominal=abs(Q_flow_nominal/cp_nominal/(T_a_nominal-T_b_nominal)));
  parameter Integer nEle(min=1) = 5
    "Number of elements used in the discretization"
    annotation (Dialog(tab="Assumptions", group="Dynamics"));
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
  parameter Medium.Temperature T_start[nEle]=
    if use_T_start then fill(system.T_start, nEle) else TWat_nominal
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", enable = use_T_start));
  parameter Medium.SpecificEnthalpy h_start[nEle]=
    if use_T_start then Medium.specificEnthalpy_pTX(p_start, T_start, X_start) else
           Medium.specificEnthalpy_pTX(Medium.p_default, TWat_nominal, Medium.X_default)
    "Start value of specific enthalpy"
    annotation(Dialog(tab = "Initialization", enable = not use_T_start));
  parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
       each quantity=Medium.extraPropertiesNames)= fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heating power (positive for heating)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a_nominal
    "Water inlet temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b_nominal
    "Water outlet temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TAir_nominal = 293.15
    "Air temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TRad_nominal = TAir_nominal
    "Radiative temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));

  parameter Real n = 1.24 "Exponent for heat transfer";
  parameter Modelica.SIunits.Volume VWat = 5.8E-6*abs(Q_flow_nominal)
    "Water volume of radiator"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Mass mDry = 0.0263*abs(Q_flow_nominal) if
        not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Dry mass of radiator that will be lumped to water heat capacity"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  Modelica.SIunits.HeatFlowRate QCon_flow
    "Heat input into the water due to convective heat transfer with room air";
  Modelica.SIunits.HeatFlowRate QRad_flow
    "Heat input into the water due to radiative heat transfer with room";
  Modelica.SIunits.HeatFlowRate Q_flow "Heat input into the water";
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon
    "Heat port for convective heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{-30,62},{-10,82}},
                                 rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad
    "Heat port for radiative heat transfer with room radiation temperature"
    annotation (Placement(transformation(extent={{10,62},{30,82}},
                                 rotation=0)));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[nEle] heaCap(each C=500
        *mDry/nEle, T(start=T_start)) if
                           not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "heat capacity of radiator metal"
    annotation (Placement(transformation(extent={{-50,12},{-30,32}})));

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
    final T_start=T_start,
    final h_start=h_start,
    each final X_start=X_start,
    each final C_start=C_start) "Volume for fluid stream"
    annotation (Placement(transformation(extent={{-9,0},{11,-20}},
                          rotation=0)));
protected
   parameter Modelica.SIunits.SpecificHeatCapacity cp_nominal=
      Medium.specificHeatCapacityCp(
        Medium.setState_pTX(Medium.p_default, T_a_nominal, Medium.X_default))
    "Specific heat capacity at nominal conditions";
   parameter Modelica.SIunits.HeatFlowRate QEle_flow_nominal[nEle](
      each fixed=false, each start=Q_flow_nominal/nEle)
    "Nominal heating power of each element";
   parameter Modelica.SIunits.Temperature TWat_nominal[nEle](
      each fixed=false,
      start={T_a_nominal - i/nEle * (T_a_nominal-T_b_nominal) for i in 1:nEle})
    "Water temperature in each element at nominal conditions";
   parameter Modelica.SIunits.TemperatureDifference[nEle] dTRad_nominal(
    each fixed=false, start={T_a_nominal - i/nEle * (T_a_nominal-T_b_nominal) - TRad_nominal
    for i in 1:nEle})
    "Temperature difference for radiative heat transfer at nominal conditions";
   parameter Modelica.SIunits.TemperatureDifference[nEle] dTCon_nominal(
    each fixed=false, start={T_a_nominal - i/nEle * (T_a_nominal-T_b_nominal) - TAir_nominal
    for i in 1:nEle})
    "Temperature difference for convective heat transfer at nominal conditions";

   parameter Modelica.SIunits.ThermalConductance UAEle(fixed=false, min=0,
     start=Q_flow_nominal/((T_a_nominal+T_b_nominal)/2-((1-fraRad)*TAir_nominal+fraRad*TRad_nominal))/nEle)
    "UA value at nominal condition for each element";

   final parameter Real k = if T_b_nominal > TAir_nominal then 1 else -1
    "Parameter that is used to compute QEle_flow_nominal for heating or cooling mode";
   Modelica.SIunits.TemperatureDifference dTCon[nEle]
    "Temperature difference for convective heat transfer";
   Modelica.SIunits.TemperatureDifference dTRad[nEle]
    "Temperature difference for radiative heat transfer";

initial equation
  if T_b_nominal > TAir_nominal then
     assert(T_a_nominal > T_b_nominal, "In RadiatorEN442_2, T_a_nominal must be higher than T_b_nominal");
     assert(Q_flow_nominal > 0, "In RadiatorEN442_2, nominal power must be bigger than zero if T_b_nominal > TAir_nominal");
  else
     assert(T_a_nominal < T_b_nominal, "In RadiatorEN442_2, T_a_nominal must be lower than T_b_nominal");
     assert(Q_flow_nominal < 0, "In RadiatorEN442_2, nominal power must be smaller than zero if T_b_nominal < TAir_nominal");
  end if;
  TWat_nominal[1] = T_a_nominal - QEle_flow_nominal[1]/m_flow_nominal/
  Medium.specificHeatCapacityCp(
        Medium.setState_pTX(Medium.p_default, T_a_nominal, Medium.X_default));
  for i in 2:nEle loop
    TWat_nominal[i] = TWat_nominal[i-1] - QEle_flow_nominal[i]/m_flow_nominal/
    Medium.specificHeatCapacityCp(
        Medium.setState_pTX(Medium.p_default, TWat_nominal[i-1], Medium.X_default));
  end for;
  dTRad_nominal = TWat_nominal .- TRad_nominal;
  dTCon_nominal = TWat_nominal .- TAir_nominal;
  Q_flow_nominal = sum(QEle_flow_nominal);

  for i in 1:nEle loop
    QEle_flow_nominal[i] = k * UAEle * ((1-fraRad) *
                   Buildings.Utilities.Math.Functions.powerLinearized(x=k*dTRad_nominal[i],
                   n=n,
                   x0=0.1*k*(T_b_nominal-TRad_nominal))
                   + fraRad *
                   Buildings.Utilities.Math.Functions.powerLinearized(x=k*dTCon_nominal[i],
                   n=n,
                   x0=0.1*k*(T_b_nominal-TAir_nominal)));
   end for;

equation
  dTCon = heatPortCon.T .- vol.medium.T;
  dTRad = heatPortRad.T .- vol.medium.T;
  preHeaFloCon.Q_flow = sign(dTCon) .* (1-fraRad) .* UAEle .* abs(dTCon).^n;
  preHeaFloRad.Q_flow = sign(dTCon) .* fraRad     .* UAEle .* abs(dTRad).^n;

  QCon_flow = sum(preHeaFloCon.Q_flow);
  QRad_flow = sum(preHeaFloRad.Q_flow);
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
  connect(heaCap.port, vol.heatPort)    annotation (Line(
      points={{-40,12},{-40,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_a, vol[1].ports[1]) annotation (Line(
      points={{-100,5.55112e-16},{-75.25,5.55112e-16},{-75.25,1.11022e-15},{
          -50.5,1.11022e-15},{-50.5,5.55112e-16},{-1,5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol[nEle].ports[2], port_b) annotation (Line(
      points={{3,5.55112e-16},{27.25,5.55112e-16},{27.25,1.11022e-15},{51.5,
          1.11022e-15},{51.5,5.55112e-16},{100,5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nEle-1 loop
    connect(vol[i].ports[2], vol[i+1].ports[1]) annotation (Line(
        points={{3,5.55112e-16},{2,5.55112e-16},{2,1.11022e-15},{1,1.11022e-15},
            {1,5.55112e-16},{-1,5.55112e-16}},
        color={0,127,255},
        smooth=Smooth.None));
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
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
This is a model of a radiator that can be used as a dynamic or steady-state model.
The required parameters are data that are typically available from
manufacturers that follow the European Norm EN 442-2.
</p>
<p>
However, to allow for varying mass flow rates, the transferred heat is computed
using a discretization along the water flow path, and heat is exchanged between
each compartment and a uniform room air and radiation temperature.
This discretization is different from the computation in EN 442-2, which 
may yield water outlet temperatures that are below
the room temperature at low mass flow rates.
Furthermore, rather than using only one room temperature, this model uses
a room air and room radiation temperature.
</p>
<p>
The transferred heat is modeled as follows:
Let <i>N</i> denote the number of elements used to discretize the radiator model.
For each element <i>i &isin; {1, &hellip; , N}</i>,
the convective and radiative heat transfer
<i>Q<sup>i</sup><sub>c</sub></i> and
<i>Q<sup>i</sup><sub>r</sub></i>
from the radiator to the room is
<p align=\"center\" style=\"font-style:italic;\">
  Q<sup>i</sup><sub>c</sub> = sign(T<sup>i</sup>-T<sub>a</sub>)
     (1-f<sub>r</sub>) UA &frasl; N |T<sup>i</sup>-T<sub>a</sub>|<sup>n</sup> 
  <br> <br>
  Q<sup>i</sup><sub>r</sub> = sign(T<sup>i</sup>-T<sub>r</sub>)
     f<sub>r</sub> UA &frasl; N |T<sup>i</sup>-T<sub>r</sub>|<sup>n</sup>
</p>
where
<i>T<sup>i</sup></i> is the water temperature of the element,
<i>T<sub>a</sub></i> is the temperature of the room air,
<i>T<sub>r</sub></i> is the radiative temperature,
<i>0 &lt; f<sub>r</sub> &lt; 1</i> is the fraction of radiant to total heat transfer,
<i>UA</i> is the UA-value of the radiator,
and
<i>n</i> is an exponent for the heat transfer.
The model computes the UA-value by numerically solving the above equations
for given
nominal heating power, nominal temperatures, fraction radiant to total heat transfer
and exponent for heat transfer.
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
The default parameters for the heat capacities are valid for a flat plate radiator without fins, 
with one plate of water carying fluid, and a height of 0.42 meters.
</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2011 by Michael Wetter:<br>
Revised the initialization to ensure that at the nominal conditions, the
amount of transferred heat is excatly the same as the specified nominal power.
In the previous implementation, the UA-value was computed using a simplified
expression for the temperature difference, leading to a slightly different amount
of heat transfer.
</li>
<li>
February 4, 2011 by Michael Wetter:<br>
Simplified implementation.
</li>
<li>
January 30, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end RadiatorEN442_2;
