within Buildings.ThermalZones.ReducedOrder.SolarGain.BaseClasses;
partial model PartialCorrectionG
  "Partial model for correction of the solar gain factor"

  parameter Integer n(min = 1) "Vector size for input and output";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UWin
    "Thermal transmission coefficient of whole window";

  Modelica.Blocks.Interfaces.RealInput HSkyDifTil[n](
    each final quantity="RadiantEnergyFluenceRate",
    each final unit="W/m2")
    "Hemispherical diffuse solar irradiation on a tilted surface from the sky"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
    iconTransformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput HDirTil[n](
    each final quantity="RadiantEnergyFluenceRate",
    each final unit="W/m2")
    "Direct solar radiation on a tilted surface per unit area"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput HGroDifTil[n](
    each final quantity="RadiantEnergyFluenceRate",
    each final unit="W/m2")
    "Hemispherical diffuse solar irradiation on a tilted surface from the ground"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput inc[n](
    each final quantity="Angle",
    each final unit="rad",
    each displayUnit="deg") "Incidence angles"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput solarRadWinTrans[n](
    each final quantity="RadiantEnergyFluenceRate",
    each final unit="W/m2") "transmitted solar radiation through windows"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));
  annotation (Icon(coordinateSystem(
  preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
  Rectangle(
  extent={{-100,100},{100,-100}},
  lineColor={0,0,0},
  fillColor={215,215,215},
  fillPattern=FillPattern.Solid), Text(
  extent={{-52,24},{62,-16}},
  textColor={0,0,0},
  textString="%name")}),
  Documentation(info="<html>
  <p>Partial model for correction factors for transmitted solar radiation
  through a transparent element.</p>
  </html>", revisions="<html>
  <ul>
  <li>
  February 27, 2016, by Michael Wetter:<br/>
  Moved input above outputs.
  </li>
  <li>
  February 24, 2014, by Reza Tavakoli:<br/>
  Implemented.
  </li>
  </ul>
  </html>"));
end PartialCorrectionG;
