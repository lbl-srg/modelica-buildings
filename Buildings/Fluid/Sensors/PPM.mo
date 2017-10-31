within Buildings.Fluid.Sensors;
model PPM
  "Ideal one port trace substances sensor outputting in parts per million"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor(
    port(C_outflow(each final quantity="MassFraction",
                   each final unit="1",
                   each min=0,
                   each max=1)));
  extends Modelica.Icons.RotationalSensor;

  parameter String substanceName = "CO2" "Name of trace substance";

  parameter Modelica.SIunits.MolarMass MM=
    Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
    "Molar mass of the trace substance";

  Modelica.Blocks.Interfaces.RealOutput ppm(min=0)
    "Trace substance in port medium in ppm"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Real s[:]= {
    if ( Modelica.Utilities.Strings.isEqual(string1=Medium.extraPropertiesNames[i],
                                            string2=substanceName,
                                            caseSensitive=false))
    then 1 else 0 for i in 1:Medium.nC}
    "Vector with zero everywhere except where species is";

  final parameter Modelica.SIunits.MolarMass MMBul=Medium.molarMass(
    Medium.setState_phX(
      p=Medium.p_default,
      h=Medium.h_default,
      X=Medium.X_default)) "Molar mass of bulk medium";

  final parameter Real MMFraction(
    min=0,
    max=1,
    final unit="1",
    final quantity="MassFraction")=MMBul/MM
    "Molar mass of the medium divided by the molar mass of the trace substance";

  final parameter Real coeff = MMFraction*1e6
    "Conversion from mass fraction to ppm";

initial equation
  assert(max(s) > 0.9, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  // We obtain the species concentration with a vector multiplication
  // because Dymola 7.3 cannot find the derivative in the model
  // Buildings.Examples.VAVSystemCTControl.mo
  // if we set C = CVec[ind];
  ppm = s*inStream(port.C_outflow)*coeff;

annotation (defaultComponentName="senPPM",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{0,-70},{0,-100}}, color={0,0,127}),
        Text(
          extent={{-150,80},{150,120}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{160,-30},{60,-60}},
          lineColor={0,0,0},
          textString="ppm"),
        Line(points={{70,0},{100,0}}, color={0,0,127})}),
  Documentation(info="<html>
<p>
This model outputs the trace substance concentration in ppm contained in the fluid connected to its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
The parameter <code>MM</code> is the molar mass of the trace substance.
For a list of molar masses, see
<a href=\"modelica://Modelica.Media.IdealGases.Common.SingleGasesData\">
Modelica.Media.IdealGases.Common.SingleGasesData</a>
and
<a href=\"modelica://Modelica.Media.IdealGases.Common.FluidData\">
Modelica.Media.IdealGases.Common.FluidData</a>.
</p>
<p>
Read the
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a>
prior to using this model with one fluid port.
</p>
<h4>Assumptions</h4>
<p>
This sensor assumes that the concentration <i>C</i> of the medium
is in mass fraction. Otherwise, the conversion to <i>ppm</i> will be
wrong.
</p>
</html>", revisions="<html>
<ul>
<li>
December 16, 2015, by Michael Wetter:<br/>
Revised implementation, corrected error in the molar fraction which
used the inverse ratio.
</li>
<li>
December 2, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PPM;
