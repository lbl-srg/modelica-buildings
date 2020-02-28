within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.Validation;
model MultipoleThermalResistances_OneUTube
  "Validation of the thermal resitances for a single U-tube borehole"
  extends Modelica.Icons.Example;

  parameter Integer nPip=2 "Number of pipes";
  parameter Integer J=3 "Number of multipoles";
  parameter Modelica.Units.SI.Position[nPip] xPip={0.03,-0.03}
    "x-Coordinates of pipes";
  parameter Modelica.Units.SI.Position[nPip] yPip={0.00,0.02}
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
    {{1/3.680, 1/0.242},{1/0.242, 1/3.724}}
    "Reference delta-circuit thermal resistances";
  parameter Real[nPip,nPip] R_Ref(each unit="(m.K)/W")=
    {{0.25592, 0.01561},{0.01561, 0.25311}}
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
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Functions/Validation/MultipoleThermalResistances_OneUTube.mos"
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
The multipole method is used to evaluate thermal resistances for a single U-tube
borehole with asymmetrically positionned pipes. Results are compared to
reference values given in Claesson and Hellstr&ouml;m (2011).
</p>
<h4>References</h4>
<p>
Claesson, J., &amp; Hellstr&ouml;m, G. (2011). Multipole method to calculate
borehole thermal resistances in a borehole heat exchanger. <i>HVAC&amp;R
Research, 17</i>(6), 895-911.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultipoleThermalResistances_OneUTube;
