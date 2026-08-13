within Buildings.Fluid.FixedResistances;
model HydraulicDiameter
  "Major and minor pressure loss of a pipe using hydraulic diameter"
  extends Buildings.Fluid.BaseClasses.PartialResistance(
    final dp_nominal=1,
    final from_dp=false,
    final linearized=false,
    final n=2,
    final m_flow_turbulent=0);

  parameter Boolean computePressureDrop = true
    "Set to true to compute Darcy-Weisbach pressure drop"
    annotation (
      Evaluate=true,
      Dialog(group="Pressure drop"));

  parameter Modelica.Units.SI.Length length
    "Pipe length"
    annotation (Dialog(group="Geometry"));

  parameter Modelica.Units.SI.Length dh
    "Hydraulic diameter"
    annotation (Dialog(group="Geometry"));

  parameter Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness"
    annotation (Dialog(group="Geometry"));

  parameter Real kMinor(unit="1", min=0) = 0
    "Total minor-loss coefficient"
    annotation (Dialog(
      group="Pressure drop",
      enable=computePressureDrop));

  parameter Buildings.Fluid.Types.FluidProperties fluidProperties =
    Buildings.Fluid.Types.FluidProperties.DefaultTemperature
    "Fluid-property evaluation for the pressure drop calculation"
    annotation (
      Evaluate=true,
      Dialog(
        group="Fluid properties",
        enable=computePressureDrop));

  parameter Modelica.Units.SI.Temperature T_ref = Medium.T_default
    "Reference temperature for fluid-property evaluation"
    annotation (Dialog(
      group="Fluid properties",
      enable=computePressureDrop and
             fluidProperties == Buildings.Fluid.Types.FluidProperties.DefaultTemperature));

  parameter Modelica.Units.SI.Density rhoMed =
    Medium.density(Medium.setState_pTX(
      Medium.p_default,
      T_ref,
      Medium.X_default))
    "Constant fluid density used for pressure drop calculation"
    annotation (Dialog(
      group="Fluid properties",
      enable=computePressureDrop and
             fluidProperties == Buildings.Fluid.Types.FluidProperties.Constant));

  parameter Modelica.Units.SI.DynamicViscosity muMed =
    Medium.dynamicViscosity(Medium.setState_pTX(
      Medium.p_default,
      T_ref,
      Medium.X_default))
    "Constant fluid dynamic viscosity used for pressure drop calculation"
    annotation (Dialog(
      group="Fluid properties",
      enable=computePressureDrop and
             fluidProperties == Buildings.Fluid.Types.FluidProperties.Constant));

  Modelica.Units.SI.PressureDifference dpMajor
    "Major Darcy-Weisbach pressure drop";

  Modelica.Units.SI.PressureDifference dpMinor
    "Minor pressure drop";

  Modelica.Units.SI.ReynoldsNumber Re
    "Reynolds number";

protected
  final parameter .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid
    tDepFluid =
      .Buildings.Fluid.BaseClasses.Media.Functions.temperatureDependentFluidFromMediumName(
        mediumName=Medium.mediumName)
    "Temperature-dependent fluid-property method derived from the redeclared medium";

  final parameter Modelica.Units.SI.MassFraction X_a_internal =
    if tDepFluid ==
      .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid.Water
    then
      0
    else
      .Buildings.Fluid.BaseClasses.Media.Functions.massFractionFromMediumName(
        mediumName=Medium.mediumName)
    "Glycol mass fraction derived from the redeclared medium";

  Medium.MassFraction XiAct[Medium.nXi]
    "Independent mass fractions of actual stream";

  Medium.MassFraction XAct[Medium.nX]
    "Mass fractions of actual stream";

  Medium.SpecificEnthalpy hAct
    "Specific enthalpy used for property evaluation";

  Medium.ThermodynamicState staAct
    "Actual stream state used for generic medium property evaluation";

  Medium.ThermodynamicState staRef
    "Reference state used for fixed-temperature property evaluation";

  Modelica.Units.SI.Temperature TAct
    "Actual stream temperature used for property evaluation";

  Modelica.Units.SI.DynamicViscosity muMedAct
    "Dynamic viscosity used for pressure drop";

  Modelica.Units.SI.Density rhoMedAct
    "Density used for pressure drop";

  Modelica.Units.SI.DynamicViscosity muMedRef
    "Dynamic viscosity at reference temperature";

  Modelica.Units.SI.Density rhoMedRef
    "Density at reference temperature";

equation
  assert(
    dh > 0,
    "In " + getInstanceName() + ": The hydraulic diameter dh must be positive.");

  if computePressureDrop and
     fluidProperties == Buildings.Fluid.Types.FluidProperties.ActualTemperature then

    XiAct =
      if allowFlowReversal then
        actualStream(port_a.Xi_outflow)
      else
        inStream(port_a.Xi_outflow);

    XAct =
      if Medium.nXi == 0 then
        Medium.X_default
      elseif Medium.reducedX then
        cat(1, XiAct, {1 - sum(XiAct)})
      else
        XiAct;

    hAct =
      if allowFlowReversal then
        actualStream(port_a.h_outflow)
      else
        inStream(port_a.h_outflow);

    TAct = Medium.temperature_phX(
      p=port_a.p,
      h=hAct,
      X=XAct);

    staAct = Medium.setState_phX(
      p=port_a.p,
      h=hAct,
      X=XAct);

    (muMedAct, rhoMedAct) =
      .Buildings.Fluid.BaseClasses.Media.Functions.fluidDensityViscosity_T(
        fluid=tDepFluid,
        T=TAct,
        p=port_a.p,
        X_a=X_a_internal);

    staRef = Medium.setState_pTX(
      p=Medium.p_default,
      T=T_ref,
      X=Medium.X_default);

    muMedRef = Medium.dynamicViscosity(staRef);
    rhoMedRef = Medium.density(staRef);

  elseif computePressureDrop and
         fluidProperties == Buildings.Fluid.Types.FluidProperties.DefaultTemperature then

    XiAct = zeros(Medium.nXi);
    XAct = Medium.X_default;
    hAct = Medium.h_default;

    TAct = T_ref;

    staAct = Medium.setState_pTX(
      p=Medium.p_default,
      T=T_ref,
      X=Medium.X_default);

    staRef = staAct;

    (muMedRef, rhoMedRef) =
      .Buildings.Fluid.BaseClasses.Media.Functions.fluidDensityViscosity_T(
        fluid=tDepFluid,
        T=T_ref,
        p=Medium.p_default,
        X_a=X_a_internal);

    muMedAct = muMedRef;
    rhoMedAct = rhoMedRef;

  else

    XiAct = zeros(Medium.nXi);
    XAct = Medium.X_default;
    hAct = Medium.h_default;

    TAct = T_ref;

    staAct = Medium.setState_pTX(
      p=Medium.p_default,
      T=T_ref,
      X=Medium.X_default);

    staRef = staAct;

    muMedRef = muMed;
    rhoMedRef = rhoMed;

    muMedAct = muMed;
    rhoMedAct = rhoMed;

  end if;

  if computePressureDrop then
    (dp, dpMajor, dpMinor, Re) =
      .Buildings.Fluid.FixedResistances.Functions.pressureLossPipe(
        length=length,
        rTub=dh/2,
        eTub=0,
        roughness=roughness,
        rhoMed=rhoMedAct,
        muMed=muMedAct,
        m_flow=m_flow,
        kMinor=kMinor);
  else
    dp = 0;
    dpMajor = 0;
    dpMinor = 0;
    Re = 0;
  end if;

  annotation (defaultComponentName="res",
Documentation(info="<html>
<p>
This model computes the pressure drop of a pipe from its geometry using a
Darcy-Weisbach pressure loss calculation.
The pressure loss includes the major pipe-friction loss and, optionally, a
minor-loss contribution.
</p>
<p>
The pressure drop is computed from the instantaneous mass flow rate, the pipe
length, the inner pipe radius, the wall roughness, the fluid density and the
fluid dynamic viscosity.
</p>
<h4>Implementation</h4>
<p>
This model extends
<a href=\"modelica://Buildings.Fluid.BaseClasses.PartialResistance\">
Buildings.Fluid.BaseClasses.PartialResistance</a>
to reuse the common two-port flow resistance equations for mass balance,
enthalpy transport and species transport.
The pressure drop equation itself is replaced by a Darcy-Weisbach calculation
based on the pipe geometry and fluid properties.
</p>
<h4>Pressure drop calculation</h4>
<p>
If <code>computePressureDrop=true</code>, the pressure drop is computed by
calling
<a href=\"modelica://Buildings.Fluid.FixedResistances.Functions.pressureLossPipe\">
Buildings.Fluid.FixedResistances.Functions.pressureLossPipe</a>.
</p>
<p>
The pressure drop is separated into a major-loss contribution and a minor-loss
contribution. The variables <code>dpMajor</code>, <code>dpMinor</code>, and
<code>Re</code> can be used to inspect the major pressure drop, the minor
pressure drop, and the Reynolds number.
</p>
<p>
If <code>computePressureDrop=false</code>, the component imposes zero pressure
drop and acts as a hydraulic pass-through.
</p>
<h4>Geometry</h4>
<p>
The pipe geometry is defined by the pipe length <code>length</code>, the outer
tube radius <code>rTub</code>, and the tube wall thickness <code>eTub</code>.
The inner pipe radius used for the pressure drop calculation is obtained from
these parameters in the pressure loss function.
</p>
<p>
The parameter <code>roughness</code> is the absolute wall roughness used for the
friction factor calculation.
</p>
<h4>Minor losses</h4>
<p>
The model can include a lumped minor-loss contribution. The total minor-loss
coefficient is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k<sub>minor</sub> = n<sub>Bend</sub> k<sub>Bend</sub>.
</p>
<p>
The parameter <code>nBend</code> is the number of bends represented by this
component, and <code>kBend</code> is the minor-loss coefficient of one bend.
If no minor losses should be included, keep the default values
<code>nBend=0</code> and <code>kBend=0</code>.
</p>
<h4>Fluid properties</h4>
<p>
The parameter <code>fluidProperties</code> controls how density and dynamic
viscosity are evaluated for the pressure drop calculation.
</p>
<p>
If <code>fluidProperties=Buildings.Fluid.Types.FluidProperties.Constant</code>,
the pressure drop calculation uses the user-specified constant density
<code>rhoMed</code> and dynamic viscosity <code>muMed</code>.
</p>
<p>
If <code>fluidProperties=Buildings.Fluid.Types.FluidProperties.DefaultTemperature</code>,
the density and dynamic viscosity are evaluated at the fixed reference
temperature <code>T_ref</code>. These values remain fixed during the simulation.
This option is useful when the pressure drop should be computed with fixed
fluid properties at a selected reference temperature.
</p>
<p>
If <code>fluidProperties=Buildings.Fluid.Types.FluidProperties.ActualTemperature</code>,
the density and dynamic viscosity are evaluated from the current fluid
temperature during the simulation. This allows the pressure drop to vary with
the fluid state.
</p>
<p>
Using <code>ActualTemperature</code> can increase the computational cost,
especially in large flow networks. For large systems, using
<code>Constant</code> or <code>DefaultTemperature</code> is generally more
efficient.
</p>
<h4>Flow reversal</h4>
<p>
If <code>allowFlowReversal=true</code>, the model evaluates the actual stream
properties using <code>actualStream</code>. If <code>allowFlowReversal=false</code>,
the model uses the upstream stream properties based on the declared flow
direction.
</p>
<p>
Setting <code>allowFlowReversal=false</code> can lead to simpler equations.
However, this should only be set to <code>false</code> if one can guarantee
that the flow never reverses its direction.
</p>
<h4>Relation to other fixed resistance models</h4>
<p>
For a flow resistance that uses a prescribed nominal pressure drop and nominal
mass flow rate, use
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>.
</p>
<p>
This model is intended for cases where the pressure drop should be computed
from pipe geometry and fluid properties rather than from a prescribed nominal
pressure drop.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2026, by Lone Meertens:<br/>
Changed the implementation to compute the pipe pressure drop from a
Darcy-Weisbach pressure loss calculation using
<a href=\"modelica://Buildings.Fluid.FixedResistances.Functions.pressureLossPipe\">
Buildings.Fluid.FixedResistances.Functions.pressureLossPipe</a>.
The model can include major and minor losses and can optionally evaluate fluid
properties from the current fluid temperature.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4687\">Buildings, #4687</a>.
</li>
<li>
May 07, 2025, by Fabian Wuelhorst and Michael Wetter:<br/>
Add option to <code>disableComputeFlowResistance</code>.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2001\">#2001</a>.
</li>
<li>
September 21, 2021, by Michael Wetter:<br/>
Corrected typo in comments.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1525\">#1525</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/480\">#480</a>.
</li>
</ul>
</html>"),
  Icon(graphics={Text(
          extent={{-40,18},{38,-20}},
          textColor={255,255,255},
          textString="dh")}));


end HydraulicDiameter;
