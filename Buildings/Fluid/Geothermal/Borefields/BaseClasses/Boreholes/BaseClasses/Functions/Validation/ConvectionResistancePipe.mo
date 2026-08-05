within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.Validation;
model ConvectionResistancePipe
  "Validation of the correlation used to evaluate the convection resistance in pipes"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Height hSeg=1.0 "Height of the element";
  parameter Modelica.Units.SI.Radius rTub=0.02 "Tube radius";
  parameter Modelica.Units.SI.Length eTub=0.002 "Tube thickness";
  // thermal properties
  parameter Modelica.Units.SI.ThermalConductivity kMed=0.6
    "Thermal conductivity of the fluid";
  parameter Modelica.Units.SI.DynamicViscosity muMed=1.002e-3
    "Dynamic viscosity of the fluid";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpMed=4182
    "Specific heat capacity of the fluid";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Real Re_start(unit="1") = 0
    "Start value for Reynolds number";
  parameter Real Re_end(unit="1") = 10000
    "End value for Reynolds number";
  parameter Modelica.Units.SI.Time tEnd = 30
    "Time used to sweep the Reynolds number";
  parameter Real k(unit="1/s") = (Re_end - Re_start)/tEnd
    "Conversion factor from time to Reynolds number";

  Real Re(unit="1")
    "Reynolds number";
  Real Nu "Nusselt number";
  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.ThermalResistance RConv "Convection resistance";

equation

  Re = Re_start + k*time;
  Re = 2*m_flow/(muMed*Modelica.Constants.pi*(rTub-eTub));
  RConv = Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistancePipe(
    hSeg=hSeg,
    rTub=rTub,
    eTub=eTub,
    kMed=kMed,
    muMed=muMed,
    cpMed=cpMed,
    m_flow=m_flow,
    m_flow_nominal=m_flow_nominal);
  Nu = 1/(kMed*Modelica.Constants.pi*hSeg*RConv);

  annotation (experiment(Tolerance=1e-6, StopTime=30),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Functions/Validation/ConvectionResistancePipe.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates the implementation of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistancePipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistancePipe</a>
for the evaluation of the convection thermal resistance in pipes.
</p>
<p>
In this validation case, the Reynolds number is prescribed as a dimensionless
ramp from <i>100</i> to <i>10000</i> using an explicit conversion factor from
simulation time. The corresponding mass flow rate is computed from the Reynolds
number, fluid viscosity, and pipe inner radius.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConvectionResistancePipe;
