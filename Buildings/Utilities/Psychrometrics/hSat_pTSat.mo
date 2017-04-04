within Buildings.Utilities.Psychrometrics;
model hSat_pTSat
  "Calculate saturation enthalpy given a saturation (dry bulb) temperature"
  extends Modelica.Blocks.Icons.Block;

  // INPUTS
  Modelica.Blocks.Interfaces.RealInput p(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar") = 101325
    "Pressure of the fluid"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput TSat(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 0.0,
    start = 288.15,
    nominal = 300,
    displayUnit="degC")
    "Saturation temperature of the fluid"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  // OUTPUTS
  Modelica.Blocks.Interfaces.RealOutput hSat(
    final quantity="SpecificEnergy",
    final unit="J/kg")
    "Dew point temperature of air"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  constant Integer watIdx = 1;
  constant Integer othIdx = 2;
  Modelica.SIunits.AbsolutePressure pSat
    "Saturation pressure of water vapor in air at TSat";
  Real XSat[2]
    "Mass fractions of water and air in moist air at saturation";

equation
  pSat = Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TSat);
  XSat[watIdx] = Buildings.Utilities.Psychrometrics.Functions.X_pW(
    p_w=pSat, p=p);
  XSat[othIdx] = 1 - XSat[watIdx];
  hSat = Buildings.Media.Air.specificEnthalpy_pTX(p=p, T=TSat, X=XSat);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end hSat_pTSat;
