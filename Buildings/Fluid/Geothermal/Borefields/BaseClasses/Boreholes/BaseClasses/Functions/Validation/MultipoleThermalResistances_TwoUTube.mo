within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.Validation;
model MultipoleThermalResistances_TwoUTube
  "Validation of the thermal resitances for a double U-tube borehole"
  extends Modelica.Icons.Example;

  parameter Integer nPip=4 "Number of pipes";
  parameter Integer J=3 "Number of multipoles";
  parameter Modelica.Units.SI.Position[nPip] xPip={0.03,-0.03,-0.03,0.03}
    "x-Coordinates of pipes";
  parameter Modelica.Units.SI.Position[nPip] yPip={0.03,0.03,-0.03,-0.03}
    "y-Coordinates of pipes";
  parameter Modelica.Units.SI.Radius rBor=0.07 "Borehole radius";
  parameter Modelica.Units.SI.Radius[nPip] rPip=fill(0.02, nPip)
    "Outter radius of pipes";
  parameter Modelica.Units.SI.ThermalConductivity kFil=1.5
    "Thermal conductivity of grouting material";
  parameter Modelica.Units.SI.ThermalConductivity kSoi=2.5
    "Thermal conductivity of soil material";
  parameter Real[nPip] RFluPip(each unit="(m.K)/W")=
    fill(1.2/(2*Modelica.Constants.pi*kFil), nPip)
    "Fluid to pipe wall thermal resistances";
  parameter Modelica.Units.SI.Temperature TBor=0
    "Average borehole wall temperature";

  parameter Real[nPip,nPip] RDelta_Ref(each unit="(m.K)/W")=
    {{1/3.61, 1/0.35, -1/0.25, 1/0.35},
     {1/0.35, 1/3.61, 1/0.35, -1/0.25},
     {-1/0.25, 1/0.35, 1/3.61, 1/0.35},
     {1/0.35, -1/0.25, 1/0.35, 1/3.61}}
    "Reference delta-circuit thermal resistances";
  parameter Real[nPip,nPip] R_Ref(each unit="(m.K)/W")=
    {{0.2509, 0.0192, -0.0122, 0.0192},
     {0.0192, 0.2509, 0.0192, -0.0122},
     {-0.0122, 0.0192, 0.2509, 0.0192},
     {0.0192, -0.0122, 0.0192, 0.2509}}
    "Reference internal thermal resistances";

  Real[nPip,nPip] RDelta(each unit="(m.K)/W")
    "Delta-circuit thermal resistances";
  Real[nPip,nPip] R(each unit="(m.K)/W")
    "Internal thermal resistances";

equation
  (RDelta, R) = Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.multipoleThermalResistances(
    nPip, J, xPip, yPip, rBor, rPip, kFil, kSoi, RFluPip, TBor);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Functions/Validation/MultipoleThermalResistances_TwoUTube.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0),
    Documentation(info="<html>
<p>
This example validates the implementation of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.multipoleThermalResistances\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.multipoleThermalResistances</a>
for the evaluation of the borehole thermal resistances.
</p>
<p>
The multipole method is used to evaluate thermal resistances for a double U-tube
borehole with symmetrically positionned pipes. Results are compared to
reference values given in Claesson (2012).
</p>
<h4>References</h4>
<p>
Claesson, J. (2012). Multipole method to calculate borehole thermal resistances.
Mathematical report. Department of Building Physics, Lund University, Box 118,
SE-221 00 Lund, Sweden. 128 pages.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultipoleThermalResistances_TwoUTube;
