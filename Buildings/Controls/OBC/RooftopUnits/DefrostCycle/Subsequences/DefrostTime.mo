within Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences;
block DefrostTime "Sequences to determine defrost time"
  extends Modelica.Blocks.Icons.Block;

  parameter Real pAtm(
    final quantity="Pressure",
    final unit="Pa")=101325
    "Atmospheric pressure";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDefTim(
    final quantity="Time",
    final unit="s") "Defrost time"
    annotation (Placement(
        transformation(extent={{100,-20},{140,20}}),
          iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput phi(
    final min=0,
    final max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

protected
  Real TCoiOut(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Outdoor coil temperature";
  Real p_s(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="Pa")
    "Saturated water vapor pressure";
  Real p_v(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="Pa")
    "Water vapor partial pressure";
  Real w_s(
    final unit="1")
    "Saturated water vapor mass fraction in kg per kg dry air";
  Real w_v(
    final unit="1",
    nominal=0.01)
    "Water vapor mass fraction in kg per kg dry air";
  Real delta_w(
    final unit="1")
    "Humdity ratio diference";

equation
  TCoiOut=(0.82*(TOut-273.15)-8.589)+273.15;
  p_s=Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TCoiOut);
  p_v=phi*p_s;
  w_s=0.6219647130774989*p_s/(pAtm-p_s);
  w_v=0.6219647130774989*p_v/(pAtm-p_v);
  delta_w=max(1.0e-6,w_v-w_s);
  yDefTim=1/(1+(0.01446/delta_w));

  annotation (
    defaultComponentName="DefTim",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,100}},
            textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end DefrostTime;
