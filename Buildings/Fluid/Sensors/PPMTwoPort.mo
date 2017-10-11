within Buildings.Fluid.Sensors;
model PPMTwoPort
  "Ideal two port trace substances sensor outputting in parts per million"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor(
     port_a(C_outflow(each final quantity="MassFraction",
                   each final unit="1",
                   each min=0,
                   each max=1)),
     port_b(C_outflow(each final quantity="MassFraction",
                   each final unit="1",
                   each min=0,
                   each max=1)));
  extends Modelica.Icons.RotationalSensor;

  parameter String substanceName = "CO2" "Name of trace substance";
  parameter Real C_start(min=0) = 0
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.SIunits.MolarMass MM=
    Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
    "Molar mass of the trace substance";
  Modelica.Blocks.Interfaces.RealOutput ppm(min=0)
    "Trace substance in port medium in ppm"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));

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

  final parameter Real MMFraction(min=0, unit="1")=MMBul/MM
    "Molar mass of the medium divided by the molar mass of the trace substance";

  final parameter Real coeff = MMFraction*1e6
    "Conversion from mass fraction to ppm";

  Real CMed(min=0, start=C_start, nominal=sum(Medium.C_nominal))=
    if allowFlowReversal then
              Modelica.Fluid.Utilities.regStep(
                x=port_a.m_flow,
                y1=s*port_b.C_outflow,
                y2=s*port_a.C_outflow,
                x_small=m_flow_small)
              else
                s*port_b.C_outflow
    "Trace substance concentration to which the sensor is exposed";
  Real C(min=0,start=C_start)
    "Trace substance concentration of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));

initial equation
  assert(max(s) > 0.9, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(C) = 0;
     elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      C = C_start;
    end if;
  end if;

equation
  ppm = C*coeff;

  // Output signal of sensor
  if dynamic then
    der(C) = (CMed-C)*k*tauInv;
  else
    C = CMed;
  end if;
annotation (defaultComponentName="senPPM",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Text(
          extent={{82,122},{0,92}},
          lineColor={0,0,0},
          textString="ppm"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<html>
<p>
This model outputs the trace substance of the passing fluid
in parts per million.
The sensor is ideal, i.e., it does not influence the fluid.
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation.
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2016, by Filip Jorissen:<br/>
First implementation.
See issue
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">#372</a>
</li>
</ul>
</html>"));
end PPMTwoPort;
