within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.Validation;
model InternalResistancesTwoUTubeNegative
  "Validation of the thermal resistances using the method of Bauer et al. (2011) for a double U-tube borehole"
  extends Modelica.Icons.Example;

  // Geometry of the borehole
  parameter Real Rb(unit="(m.K)/W") = 0.0
    "Borehole thermal resistance (Not used)";
  parameter Modelica.SIunits.Height hSeg = 1.0 "Height of the element";
  parameter Modelica.SIunits.Radius rBor = 0.07 "Radius of the borehole";
  // Geometry of the pipe
  parameter Modelica.SIunits.Radius rTub = 0.02 "Radius of the tube";
  parameter Modelica.SIunits.Length eTub = 0.002 "Thickness of the tubes";
  parameter Modelica.SIunits.Length sha = 0.05
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole";

  // Thermal properties (Solids)
  parameter Modelica.SIunits.ThermalConductivity kFil = 1.5
    "Thermal conductivity of the grout";
  parameter Modelica.SIunits.ThermalConductivity kSoi = 2.5
    "Thermal conductivity of the soi";
  parameter Modelica.SIunits.ThermalConductivity kTub = 0.4
    "Thermal conductivity of the tube";

  // Thermal properties (Fluid)
  parameter Modelica.SIunits.ThermalConductivity kMed = 0.6
    "Thermal conductivity of the fluid";
  parameter Modelica.SIunits.DynamicViscosity muMed = 1.0e-3
    "Dynamic viscosity of the fluid";
  parameter Modelica.SIunits.SpecificHeatCapacity cpMed = 4180.0
    "Specific heat capacity of the fluid";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.25
    "Nominal mass flow rate";

  // Outputs
  parameter Real x(fixed=false) "Capacity location";
  parameter Modelica.SIunits.ThermalResistance Rgb(fixed=false)
    "Thermal resistance between grout zone and borehole wall";
  parameter Modelica.SIunits.ThermalResistance Rgg1(fixed=false)
    "Thermal resistance between the two adjacent grout zones";
  parameter Modelica.SIunits.ThermalResistance Rgg2(fixed=false)
    "Thermal resistance between the two opposite grout zones";
  parameter Modelica.SIunits.ThermalResistance RCondGro(fixed=false)
    "Thermal resistance between: pipe wall to capacity in grout";

initial equation
  (x, Rgb, Rgg1, Rgg2, RCondGro) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesTwoUTube(
      hSeg=hSeg,
      rBor=rBor,
      rTub=rTub,
      eTub=eTub,
      sha=sha,
      kFil=kFil,
      kSoi=kSoi,
      kTub=kTub,
      Rb=Rb,
      kMed=kMed,
      muMed=muMed,
      cpMed=cpMed,
      m_flow_nominal=m_flow_nominal);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Functions/Validation/InternalResistancesTwoUTubeNegative.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0),
    Documentation(info="<html>
<p>
This example validates the implementation of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesTwoUTube\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesTwoUTube</a>
for the evaluation of the internal thermal resistances of a double U-tube
borehole.
</p>
<p>
In this case, the shank spacing is defined such that the pipes are close to the
borehole wall, rendering the short-circuit thermal resistances negative. The
capacity location <code>x</code> is then automatically set to zero.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end InternalResistancesTwoUTubeNegative;
