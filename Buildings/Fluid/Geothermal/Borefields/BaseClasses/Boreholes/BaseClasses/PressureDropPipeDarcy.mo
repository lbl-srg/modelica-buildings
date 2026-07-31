within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
model PressureDropPipeDarcy
  "Major and minor pressure loss of a vertical GHE pipe"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Boolean computePressureDrop = true
    "Set to true to compute Darcy-Weisbach pressure drop";
  parameter Modelica.Units.SI.Length length
    "Pipe length";
  parameter Modelica.Units.SI.Radius rTub
    "Outer tube radius";
  parameter Modelica.Units.SI.Length eTub
    "Tube wall thickness";
  parameter Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness";
  parameter Modelica.Units.SI.Density rhoMed_default =
    Medium.density(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Default fluid density";
  parameter Modelica.Units.SI.DynamicViscosity muMed_default =
    Medium.dynamicViscosity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Default fluid dynamic viscosity";
  parameter Integer nUBend(min=0) = 1
    "Number of U-bends represented by this pressure-drop component"
    annotation (Dialog(enable=computePressureDrop));
  parameter Real kUBend(unit="1", min=0) = 2
    "Minor-loss coefficient of one U-bend"
    annotation (Dialog(enable=computePressureDrop));
  parameter Boolean use_TDepPressureDrop = false
    "Set to true to evaluate density and viscosity from the current fluid temperature"
    annotation (Dialog(enable=computePressureDrop));
  parameter Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation
    fluidPropertyEvaluation=
      Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.use_MediaFunctions
    "Method used to evaluate fluid properties for pressure drop"
    annotation (Dialog(enable=computePressureDrop and use_TDepPressureDrop));
  parameter Modelica.Units.SI.MassFraction X_a(min=0, max=0.6) 
    "Mass fraction of propylene glycol in water"
    annotation (Dialog(
      enable=computePressureDrop and use_TDepPressureDrop and
        fluidPropertyEvaluation ==
          Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater));
  Modelica.Units.SI.PressureDifference dpMajor
    "Major Darcy-Weisbach pressure drop";
  Modelica.Units.SI.PressureDifference dpMinor
    "Minor pressure drop";
  Modelica.Units.SI.ReynoldsNumber Re
    "Reynolds number";


protected
  final parameter Real kMinor(unit="1") = nUBend*kUBend
    "Total minor-loss coefficient";

  Medium.MassFraction XiAct[Medium.nXi]
    "Independent mass fractions of actual stream";

  Medium.MassFraction XAct[Medium.nX]
    "Mass fractions of actual stream";

  Medium.SpecificEnthalpy hAct
  "Specific enthalpy used for property evaluation";

  Medium.ThermodynamicState staAct
    "Actual stream state used for generic medium property evaluation";

  Modelica.Units.SI.Temperature TAct
    "Actual stream temperature used for property evaluation";

  Modelica.Units.SI.DynamicViscosity muMedAct
    "Dynamic viscosity used for pressure drop";

  Modelica.Units.SI.Density rhoMedAct
    "Density used for pressure drop";


equation
  port_a.m_flow + port_b.m_flow = 0;

  if computePressureDrop and use_TDepPressureDrop then

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

    if fluidPropertyEvaluation ==
       Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.use_MediaFunctions then

      staAct = Medium.setState_phX(
        p=port_a.p,
        h=hAct,
        X=XAct);

      rhoMedAct = Medium.density(staAct);
      muMedAct = Medium.dynamicViscosity(staAct);

    else

      staAct = Medium.setState_pTX(
        p=Medium.p_default,
        T=Medium.T_default,
        X=Medium.X_default);

      (muMedAct, rhoMedAct) =
        Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidDensityViscosity_T(
          fluidPropertyEvaluation=fluidPropertyEvaluation,
          T=TAct,
          p=port_a.p,
          X_a=X_a);

    end if;

  else
    XiAct = zeros(Medium.nXi);
    XAct = Medium.X_default;
    hAct = Medium.h_default;

    staAct = Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default);

    TAct = Medium.T_default;

    rhoMedAct = rhoMed_default;
    muMedAct = muMed_default;

  end if;

  if computePressureDrop then
    (dp, dpMajor, dpMinor, Re) =
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossPipe(
        length=length,
        rTub=rTub,
        eTub=eTub,
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

  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Line(
          points={{-100,0},{-60,0}},
          color={0,127,255},
          thickness=1),
        Line(
          points={{60,0},{100,0}},
          color={0,127,255},
          thickness=1),
        Line(
          points={{-60,0},{-45,25},{-30,-25},{-15,25},{0,-25},{15,25},{30,-25},{45,25},{60,0}},
          color={0,127,255},
          thickness=1)}),
    Documentation(info="<html>
<p>
This model computes the Darcy-Weisbach pressure loss of a borehole pipe segment.
The pressure loss includes the major pipe-friction loss and, optionally, a
minor-loss contribution.
</p>
<p>
If <code>computePressureDrop=true</code>, the pressure drop is computed from the
instantaneous mass flow rate using
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossPipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossPipe</a>.
</p>
<p>
The total minor-loss coefficient passed to the pressure-loss function is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k<sub>minor</sub> = n<sub>UBend</sub> k<sub>UBend</sub>.
</p>
<p>
The parameter <code>nUBend</code> is the number of U-bends represented by this
component, and <code>kUBend</code> is the minor-loss coefficient of one U-bend.
</p>
<p>
If <code>use_TDepPressureDrop=true</code>, density and dynamic viscosity are
evaluated from the local fluid temperature. Otherwise, the default medium
properties <code>rhoMed_default</code> and <code>muMed_default</code> are used.
</p>
<p>
If <code>computePressureDrop=false</code>, this component imposes zero pressure
drop and acts as a hydraulic pass-through.
</p>
<p>
The outputs <code>dpMajor</code>, <code>dpMinor</code>, and <code>Re</code>
allow post-processing of the major-loss contribution, minor-loss contribution,
and active Reynolds number.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 18, 2026, by Lone Meertens:<br/>
First implementation for Darcy-Weisbach pressure-drop calculation in vertical
GHE pipes.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
</ul>
</html>"));

end PressureDropPipeDarcy;
