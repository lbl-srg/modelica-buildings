within Buildings.Fluid.HeatExchangers.Radiators;
model RadiatorEN442_2 "Dynamic radiator for space heating"
   extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
   showDesignFlowDirection = false,
   show_T=true,
   m_flow_nominal=abs(Q_flow_nominal/cp_nominal/(T_a_nominal-T_b_nominal)));
   extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
     final X_start = Medium.X_default,
     final C_start = fill(0, Medium.nC),
     final C_nominal = fill(1E-2, Medium.nC),
     final mSenFac = 1 + 500*mDry/(VWat*cp_nominal*Medium.density(
        Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))));

  parameter Integer nEle(min=1) = 5
    "Number of elements used in the discretization";
  parameter Real fraRad(min=0, max=1) = 0.35 "Fraction radiant heat transfer";
  // Assumptions

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
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Mass mDry = 0.0263*abs(Q_flow_nominal)
    "Dry mass of radiator that will be lumped to water heat capacity"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Heat flow rates
  Modelica.SIunits.HeatFlowRate QCon_flow = heatPortCon.Q_flow
    "Heat input into the water due to convective heat transfer with room air";
  Modelica.SIunits.HeatFlowRate QRad_flow = heatPortRad.Q_flow
    "Heat input into the water due to radiative heat transfer with room";
  Modelica.SIunits.HeatFlowRate Q_flow = QCon_flow + QRad_flow
    "Heat input into the water";

  // Heat ports
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon
    "Heat port for convective heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{-30,62},{-10,82}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad
    "Heat port for radiative heat transfer with room radiation temperature"
    annotation (Placement(transformation(extent={{10,62},{30,82}})));

  Fluid.MixingVolumes.MixingVolume[nEle] vol(
    redeclare each package Medium = Medium,
    each nPorts = 2,
    each V=VWat/nEle,
    each final m_flow_nominal = m_flow_nominal,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final mSenFac=mSenFac) "Volume for fluid stream"
    annotation (Placement(transformation(extent={{-9,0},{11,-20}})));
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

   Buildings.HeatTransfer.Sources.PrescribedHeatFlow[nEle] preCon
    "Heat input into radiator from convective heat transfer"
     annotation (Placement(transformation(extent={{-48,-48},{-28,-28}})));
   Buildings.HeatTransfer.Sources.PrescribedHeatFlow[nEle] preRad
    "Heat input into radiator from radiative heat transfer"
     annotation (Placement(transformation(extent={{-48,-80},{-28,-60}})));

   Modelica.SIunits.TemperatureDifference dTCon[nEle] = heatPortCon.T .- vol.T
    "Temperature difference for convective heat transfer";
   Modelica.SIunits.TemperatureDifference dTRad[nEle] = heatPortRad.T .- vol.T
    "Temperature difference for radiative heat transfer";

  Modelica.Blocks.Sources.RealExpression QCon[nEle](y=if homotopyInitialization
         then homotopy(actual=(1 - fraRad) .* UAEle .* dTCon .*
        Buildings.Utilities.Math.Functions.regNonZeroPower(
        x=dTCon,
        n=n - 1,
        delta=0.05), simplified=(1 - fraRad) .* UAEle .* abs(dTCon_nominal) .^ (
        n - 1) .* dTCon) else (1 - fraRad) .* UAEle .* dTCon .*
        Buildings.Utilities.Math.Functions.regNonZeroPower(
        x=dTCon,
        n=n - 1,
        delta=0.05)) "Convective heat flow rate"
    annotation (Placement(transformation(extent={{-100,-48},{-80,-28}})));

  Modelica.Blocks.Sources.RealExpression QRad[nEle](y=if homotopyInitialization
         then homotopy(actual=fraRad .* UAEle .* dTRad .*
        Buildings.Utilities.Math.Functions.regNonZeroPower(
        x=dTRad,
        n=n - 1,
        delta=0.05), simplified=fraRad .* UAEle .* abs(dTRad_nominal) .^ (n - 1)
         .* dTRad) else fraRad .* UAEle .* dTRad .*
        Buildings.Utilities.Math.Functions.regNonZeroPower(
        x=dTRad,
        n=n - 1,
        delta=0.05)) "Radiative heat flow rate"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preSumCon
    "Heat input into radiator from convective heat transfer"
    annotation (Placement(transformation(extent={{52,-60},{72,-40}})));
  Modelica.Blocks.Math.Sum sumCon(nin=nEle, k=-ones(nEle))
    "Sum of convective heat flow rate"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Math.Sum sumRad(nin=nEle, k=-ones(nEle))
    "Sum of radiative heat flow rate"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preSumRad
    "Heat input into radiator from radiative heat transfer"
    annotation (Placement(transformation(extent={{52,-90},{72,-70}})));
initial equation
  if T_b_nominal > TAir_nominal then
     assert(T_a_nominal > T_b_nominal,
       "In RadiatorEN442_2, T_a_nominal must be higher than T_b_nominal.");
     assert(Q_flow_nominal > 0,
       "In RadiatorEN442_2, nominal power must be bigger than zero if T_b_nominal > TAir_nominal.");
  else
     assert(T_a_nominal < T_b_nominal,
       "In RadiatorEN442_2, T_a_nominal must be lower than T_b_nominal.");
     assert(Q_flow_nominal < 0,
       "In RadiatorEN442_2, nominal power must be smaller than zero if T_b_nominal < TAir_nominal.");
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
    QEle_flow_nominal[i] = k * UAEle * (fraRad *
                   Buildings.Utilities.Math.Functions.powerLinearized(x=k*dTRad_nominal[i],
                   n=n,
                   x0=0.1*k*(T_b_nominal-TRad_nominal))
                   + (1-fraRad) *
                   Buildings.Utilities.Math.Functions.powerLinearized(x=k*dTCon_nominal[i],
                   n=n,
                   x0=0.1*k*(T_b_nominal-TAir_nominal)));
   end for;

equation
  connect(preCon.port, vol.heatPort)       annotation (Line(
      points={{-28,-38},{-20,-38},{-20,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preRad.port, vol.heatPort)       annotation (Line(
      points={{-28,-70},{-20,-70},{-20,-10},{-9,-10}},
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
  connect(QCon.y, preCon.Q_flow)                  annotation (Line(
      points={{-79,-38},{-48,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sumCon.u, QCon.y)          annotation (Line(
      points={{18,-50},{-60,-50},{-60,-38},{-79,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sumCon.y, preSumCon.Q_flow)     annotation (Line(
      points={{41,-50},{52,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preSumCon.port, heatPortCon)       annotation (Line(
      points={{72,-50},{80,-50},{80,40},{-20,40},{-20,72}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QRad.y, preRad.Q_flow)       annotation (Line(
      points={{-79,-70},{-48,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QRad.y, sumRad.u) annotation (Line(
      points={{-79,-70},{-60,-70},{-60,-80},{18,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sumRad.y, preSumRad.Q_flow)        annotation (Line(
      points={{41,-80},{52,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preSumRad.port, heatPortRad)        annotation (Line(
      points={{72,-80},{86,-80},{86,50},{20,50},{20,72}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation ( Icon(graphics={
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
    defaultComponentName="rad",
    Documentation(info="<html>
<p>
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
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q<sup>i</sup><sub>c</sub> = sign(T<sup>i</sup>-T<sub>a</sub>)
     (1-f<sub>r</sub>) UA &frasl; N |T<sup>i</sup>-T<sub>a</sub>|<sup>n</sup>
  <br/> <br/>
  Q<sup>i</sup><sub>r</sub> = sign(T<sup>i</sup>-T<sub>r</sub>)
     f<sub>r</sub> UA &frasl; N |T<sup>i</sup>-T<sub>r</sub>|<sup>n</sup>
</p>
<p>
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
The parameter <code>energyDynamics</code> (in the Assumptions tab),
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
April 11, 2015, by Filip Jorissen:<br/>
Propagated <code>vol.massDynamics</code> to  
top level parameter <code>massDynamics</code> instead of <code>energyDynamics</code>.
</li>
<li>
November 25, 2014, by Carles Ribas Tugores:<br/>
Interchange position of <code>fraRad</code> parameter and the complementary <code>(1-fraRad)</code>
in the equation used to calculate the nominal heating power of each element, <code>QEle_flow_nominal[i]</code>.
</li>
<li>
October 29, 2014, by Michael Wetter:<br/>
Made assignment of <code>mFactor</code> final, and changed computation of
density to use default medium states as are also used to compute the
specific heat capacity.
</li>
<li>
October 21, 2014, by Filip Jorissen:<br/>
Added parameter <code>mFactor</code> and removed thermal capacity
which can lead to an index reduction.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
October 8, 2013 by Michael Wetter:<br/>
Removed conditional statement in the declaration of the parameter
<code>mDry</code>, as this is incorrect syntax.
</li>
<li>
September 26, 2013 by Michael Wetter:<br/>
Reformulated implementation to avoid mixing textual and graphical
declarations in the <code>equation</code> section.
</li>
<li>
April 4, 2011 by Michael Wetter:<br/>
Changed the implementation to use
<a href=\"modelica://Buildings.Utilities.Math.Functions.regNonZeroPower\">
Buildings.Utilities.Math.Functions.regNonZeroPower</a>.
This allows formulating the model without any non-differentiable function
inside the equation section.
</li>
<li>
April 2, 2011 by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
February 11, 2011 by Michael Wetter:<br/>
Revised the initialization to ensure that at the nominal conditions, the
amount of transferred heat is excatly the same as the specified nominal power.
In the previous implementation, the UA-value was computed using a simplified
expression for the temperature difference, leading to a slightly different amount
of heat transfer.
</li>
<li>
February 4, 2011 by Michael Wetter:<br/>
Simplified implementation.
</li>
<li>
January 30, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RadiatorEN442_2;
