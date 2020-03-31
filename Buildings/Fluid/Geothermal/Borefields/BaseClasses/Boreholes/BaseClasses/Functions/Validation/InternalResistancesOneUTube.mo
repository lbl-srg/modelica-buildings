within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.Validation;
model InternalResistancesOneUTube
  "Validation of the thermal resistances using the method of Bauer et al. (2011) for a single U-tube borehole"
  extends Modelica.Icons.Example;


  // Geometry of the borehole
  parameter Real Rb(unit="(m.K)/W") = 0.0
    "Borehole thermal resistance (Not used)";
  parameter Modelica.Units.SI.Height hSeg=1.0 "Height of the element";
  parameter Modelica.Units.SI.Radius rBor=0.07 "Radius of the borehole";
  // Geometry of the pipe
  parameter Modelica.Units.SI.Radius rTub=0.02 "Radius of the tube";
  parameter Modelica.Units.SI.Length eTub=0.002 "Thickness of the tubes";
  parameter Modelica.Units.SI.Length sha=0.03
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole";

  // Thermal properties (Solids)
  parameter Modelica.Units.SI.ThermalConductivity kFil=1.5
    "Thermal conductivity of the grout";
  parameter Modelica.Units.SI.ThermalConductivity kSoi=2.5
    "Thermal conductivity of the soi";
  parameter Modelica.Units.SI.ThermalConductivity kTub=0.4
    "Thermal conductivity of the tube";

  // Thermal properties (Fluid)
  parameter Modelica.Units.SI.ThermalConductivity kMed=0.6
    "Thermal conductivity of the fluid";
  parameter Modelica.Units.SI.DynamicViscosity muMed=1.0e-3
    "Dynamic viscosity of the fluid";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpMed=4180.0
    "Specific heat capacity of the fluid";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.25
    "Nominal mass flow rate";

  // Outputs
  parameter Real x(fixed=false) "Capacity location";
  parameter Modelica.Units.SI.ThermalResistance Rgb(fixed=false)
    "Thermal resistance between grout zone and borehole wall";
  parameter Modelica.Units.SI.ThermalResistance Rgg(fixed=false)
    "Thermal resistance between the two grout zones";
  parameter Modelica.Units.SI.ThermalResistance RCondGro(fixed=false)
    "Thermal resistance between: pipe wall to capacity in grout";

initial equation
  (x, Rgb, Rgg, RCondGro) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesOneUTube(
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
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Functions/Validation/InternalResistancesOneUTube.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0),
    Documentation(info="<html>
<p>
This example validates the implementation of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesOneUTube\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesOneUTube</a>
for the evaluation of the internal thermal resistances of a single U-tube
borehole.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end InternalResistancesOneUTube;
