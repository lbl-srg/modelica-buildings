within Buildings.Fluid.HeatPumps.Compressors.BaseClasses;
partial model PartialCompressor "Partial compressor model"

  replaceable package ref = Buildings.Media.Refrigerants.R410A
    "Refrigerant in the component"
    annotation (choicesAllMatching = true);

    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
      "Refrigerant connector a (corresponding to the evaporator)"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
      "Refrigerant connector b (corresponding to the condenser)"
      annotation (Placement(transformation(extent={{110,-10},{90,10}})));

    Modelica.Blocks.Interfaces.RealInput y(final unit = "1")
     "Modulating signal for compressor frequency, equal to 1 at full load conditions"
      annotation (Placement(
        transformation(
          extent={{-120,70},{-100,50}},
          rotation = -90)));

    Modelica.Blocks.Interfaces.RealOutput P(
      final quantity="Power",
      final unit="W") "Electric power consumed by compressor"
      annotation (Placement(transformation(extent={{100,50},{120,70}},
          rotation=-90)));

  Modelica.SIunits.SpecificEnthalpy hEva
    "Specific enthalpy of saturated vapor at evaporator temperature";

  Modelica.SIunits.SpecificEnthalpy hCon
    "Specific enthalpy of saturated liquid at condenser temperature";

  Modelica.SIunits.AbsolutePressure pEva(start = 100e3)
    "Pressure of saturated vapor at evaporator temperature";

  Modelica.SIunits.AbsolutePressure pCon(start = 1000e3)
    "Pressure of saturated liquid at condenser temperature";

  Modelica.SIunits.AbsolutePressure pDis(start = 1000e3)
    "Discharge pressure of the compressor";

  Modelica.SIunits.AbsolutePressure pSuc(start = 100e3)
    "Suction pressure of the compressor";

  Modelica.SIunits.Temperature TSuc
    "Temperature at suction of the compressor";

  Boolean isOn(fixed=false)
    "State of the compressor, true if turned on";

  Modelica.SIunits.SpecificVolume vSuc(start = 1e-4, min = 0)
    "Specific volume of the refrigerant at suction of the compressor";

protected
  Real PR(min = 0.0, unit = "1", start = 2.0)
    "Pressure ratio";

initial equation
  pre(isOn) = if y > 0.01 then true else false;

equation
  isOn = not pre(isOn) and y > 0.01 or pre(isOn) and y >= 0.005;

  PR = max(pDis/pSuc, 0);

  // The specific volume at suction of the compressor is calculated
  // from the Martin-Hou equation of state
  vSuc = ref.specificVolumeVap_pT(pSuc, TSuc);

  // Saturation pressure of refrigerant vapor at condenser temperature
  pCon = ref.pressureSatVap_T(port_b.T);

  // Specific enthaply of saturated liquid refrigerant at condenser temperature
  hCon = ref.enthalpySatLiq_T(port_b.T);

  // Saturation pressure of refrigerant vapor at evaporator temperature
  pEva = ref.pressureSatVap_T(port_a.T);

  // Specific enthaply of saturated refrigerant vapor at evaporator temperature
  hEva = ref.enthalpySatVap_T(port_a.T);

  // Assert statements to verify that the refrigerant temperatures are within
  // bounds of the property data in the refrigerant package
  assert(port_b.T > ref.T_min and port_b.T < ref.TCri,
    "Condensing temperature must be above the minimum refrigerant temperature
    and below the critical temperature.");
  assert(port_a.T > ref.T_min and port_a.T < ref.TCri,
    "Evaporating temperature must be above the minimum refrigerant temperature
    and below the critical temperature.");

  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Text(extent={{62,-82},{72,-98}},    textString="P",
          lineColor={0,0,127}),
        Text(extent={{62,98},{72,82}},
          lineColor={0,0,127},
          textString="y"),
        Polygon(
          points={{-70,-80},{-70,80},{70,60},{70,-60},{-70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-5},{100,5}},
          lineColor={255,0,0},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{60,-58},{60,-100}},        color={0,0,255}),
        Line(points={{60,58},{60,100}},        color={0,0,0}),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}),
    defaultComponentName="com",
      Documentation(info="<html>
<p>
This is the base class for the compressor model.
</p>
<p>
The model evaluates the evaporating pressure of the refrigerant <i>p<sub>eva</sub></i>,
the specific enthalpy of the evaporating saturated refrigerant vapor <i>h<sub>eva</sub></i>,
the condensing pressure of the refrigerant <i>p<sub>con</sub></i>
and the specific enthalpy of the condensing saturated liquid refrigerant <i>h<sub>cond</sub></i>
at the evaporating temperature <i>T<sub>eva</sub></i> = <code>port_a.T</code>
and condensing temperature <i>T<sub>con</sub></i> = <code>port_b.T</code>.
</p>
<p>
Thermodynamic properties are evaluated from functions contained in the specified refrigerant package.
</p>
<h4>Assumptions and limitations</h4>
<p>
The model assumes isothermal condensation and evaporation, therefore
refrigerant mass flow is not accounted for and heat ports are used instead of fluid ports.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2017, by Filip Jorissen:<br/>
Removed <code>pressure_error</code> as
this is replaced by
<a href=\"modelica://Buildings.Fluid.HeatPumps.Compressors.BaseClasses.TemperatureProtection\">
Buildings.Fluid.HeatPumps.Compressors.BaseClasses.TemperatureProtection</a>.
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/769\">#769</a>.
</li>
<li>
May 26, 2017, by Michael Wetter and Thierry Nouidui:<br/>
Reformulated <code>isOn</code> to use the same construct as the hysteresis block,
and to work around a JModelica limitation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/774\">#774</a>.
</li>
<li>
April 25, 2017, by Michael Wetter:<br/>
Reformulated <code>when</code> conditions and moved common assignments
to this base class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/739\">#739</a>.
</li>
<li>
November 11, 2016, by Massimo Cimmino:<br/>
First implementation of this base class.
</li>
</ul>
</html>"));
end PartialCompressor;
