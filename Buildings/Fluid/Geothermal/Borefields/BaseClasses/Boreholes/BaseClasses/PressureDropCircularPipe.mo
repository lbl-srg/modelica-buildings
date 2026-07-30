within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
model PressureDropCircularPipe
  "Major and minor pressure loss of a circular vertical GHE pipe"
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
  parameter Modelica.Units.SI.Density rhoMed
    "Fluid density";
  parameter Modelica.Units.SI.DynamicViscosity muMed
    "Fluid dynamic viscosity";
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
      Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.GenericMedium
    "Method used to evaluate fluid properties for pressure drop"
    annotation (Dialog(enable=computePressureDrop and use_TDepPressureDrop));
  parameter Modelica.Units.SI.MassFraction X_a(min=0, max=0.6) = 0.40
    "Mass fraction of propylene glycol in water"
    annotation (Dialog(
      enable=computePressureDrop and use_TDepPressureDrop and
        fluidPropertyEvaluation ==
          Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater));


protected
  final parameter Real kMinor(unit="1") = nUBend*kUBend
    "Total minor-loss coefficient";

  Medium.MassFraction XiAct[Medium.nXi]
    "Independent mass fractions of actual stream";

  Medium.MassFraction XAct[Medium.nX]
    "Mass fractions of actual stream";

  Medium.ThermodynamicState staAct
    "Actual stream state used for generic medium property evaluation";

  Modelica.Units.SI.Temperature TAct
    "Actual stream temperature used for property evaluation";

  Modelica.Units.SI.SpecificHeatCapacity cpMedAct
    "Specific heat capacity returned by property helper, not used for pressure drop";

  Modelica.Units.SI.ThermalConductivity kMedAct
    "Thermal conductivity returned by property helper, not used for pressure drop";

  Modelica.Units.SI.DynamicViscosity muMedAct
    "Dynamic viscosity used for pressure drop";

  Modelica.Units.SI.Density rhoMedAct
    "Density used for pressure drop";


equation
  port_a.m_flow + port_b.m_flow = 0;
  XiAct = actualStream(port_a.Xi_outflow);

  XAct =
    if Medium.nXi == 0 then
      Medium.X_default
    elseif Medium.reducedX then
      cat(1, XiAct, {1 - sum(XiAct)})
    else
      XiAct;

  staAct = Medium.setState_phX(
    p=port_a.p,
    h=actualStream(port_a.h_outflow),
    X=XAct);

  TAct = Medium.temperature(staAct);

    if computePressureDrop and use_TDepPressureDrop and
     fluidPropertyEvaluation ==
       Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.GenericMedium then

    rhoMedAct = Medium.density(staAct);
    muMedAct = Medium.dynamicViscosity(staAct);
    cpMedAct = Medium.specificHeatCapacityCp(staAct);
    kMedAct = Medium.thermalConductivity(staAct);

  else

    (cpMedAct, kMedAct, muMedAct, rhoMedAct) =
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
        use_TDep=computePressureDrop and use_TDepPressureDrop,
        fluidPropertyEvaluation=fluidPropertyEvaluation,
        T=TAct,
        p=port_a.p,
        X_a=X_a,
        cp_default=1,
        k_default=1,
        mu_default=muMed,
        rho_default=rhoMed);

  end if;

  dp =
    if computePressureDrop then
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossPipe(
        length=length,
        rTub=rTub,
        eTub=eTub,
        roughness=roughness,
        rhoMed=rhoMedAct,
        muMed=muMedAct,
        m_flow=m_flow,
        kMinor=kMinor)
    else
      0;

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
This model computes the pressure loss of a circular vertical ground heat
exchanger pipe.
</p>

<p>
If <code>computePressureDrop=true</code>, the pressure drop is computed from the
instantaneous mass flow rate using
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe</a>.
The calculation includes the major Darcy-Weisbach pipe-friction loss and the
U-bend minor loss.
</p>

<p>
The total U-bend minor-loss coefficient passed to the pressure-loss function is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  K<sub>minor</sub> = n<sub>UBend</sub> K<sub>UBend</sub>.
</p>
<p>
For a single U-tube, use <code>nUBend=1</code>. For a double U-tube, use
<code>nUBend=2</code>.
</p>

<p>
If <code>computePressureDrop=false</code>, this component imposes zero pressure
drop and acts as a hydraulic pass-through. In that case, U-bend minor losses are
not included.
</p>

<p>
The equations used for the major and minor pressure-loss calculations are
documented in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe</a>.
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

end PressureDropCircularPipe;
