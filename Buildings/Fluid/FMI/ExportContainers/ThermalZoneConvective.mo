within Buildings.Fluid.FMI.ExportContainers;
partial block ThermalZoneConvective
  "Partial block to export a model of a thermal zone as an FMU"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model" annotation (choicesAllMatching=true);
  parameter Integer nFluPor(min=1) "Number of fluid ports";

  Interfaces.Inlet fluPor[nFluPor](
    redeclare each final package Medium = Medium,
    each final use_p_in=false,
    each final allowFlowReversal=false) "Fluid connector" annotation (Placement(
        transformation(extent={{-180,150},{-160,170}}), iconTransformation(
          extent={{-180,150},{-160,170}})));

  Modelica.Blocks.Interfaces.RealOutput TAirZon(final unit="K", displayUnit="degC")
    "Zone air temperature" annotation (Placement(transformation(extent={{-160,-40},
            {-200,0}}), iconTransformation(extent={{-160,-40},{-200,0}})));
  Modelica.Blocks.Interfaces.RealOutput X_wZon(
    each final unit="kg/kg") if
    Medium.nXi > 0 "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{-160,-80},{-200,-40}}),
        iconTransformation(extent={{-160,-80},{-200,-40}})));
  Modelica.Blocks.Interfaces.RealOutput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-160,-120},{-200,-80}})));

  Buildings.Fluid.FMI.Adaptors.ThermalZone theHvaAda(
    redeclare final package
    Medium = Medium, nFluPor=nFluPor)
    "Adapter between the HVAC supply and return air, and its connectors for the FMU"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

equation
  connect(theHvaAda.fluPor, fluPor) annotation (Line(points={{-82.2,158},{-82,
          158},{-82,158},{-110,158},{-140,158},{-140,160},{-170,160}},
                                             color={0,0,255}));
  connect(X_wZon, X_wZon)
    annotation (Line(points={{-180,-60},{-180,-60}},         color={0,0,127}));
  connect(CZon, theHvaAda.CZon) annotation (Line(points={{-180,-100},{-142,-100},
          {-100,-100},{-100,143},{-82.2,143}}, color={0,0,127}));
  connect(X_wZon, theHvaAda.X_wZon) annotation (Line(points={{-180,-60},{-150,
          -60},{-120,-60},{-120,148.2},{-82.2,148.2}}, color={0,0,127}));
  connect(TAirZon, theHvaAda.TAirZon) annotation (Line(points={{-180,-20},{-180,
          -20},{-140,-20},{-140,152.8},{-82.2,152.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,180}}), graphics={Rectangle(
          extent={{-160,180},{160,-140}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          lineColor={0,0,0}),
        Rectangle(
          extent={{-74,-76},{92,114}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-154,6},{-104,-14}},
          lineColor={0,0,127},
          textString="TRadZon"),
        Text(
          extent={{-150,-30},{-100,-50}},
          lineColor={0,0,127},
          textString="QRad"),
        Text(
          extent={{-150,-70},{-100,-90}},
          lineColor={0,0,127},
          textString="QCon"),
        Text(
          extent={{-154,-108},{-104,-128}},
          lineColor={0,0,127},
          textString="QLat"),
        Text(
          extent={{-156,48},{-106,28}},
          lineColor={0,0,127},
          textString="CZon"),
        Text(
          extent={{-152,90},{-102,70}},
          lineColor={0,0,127},
          textString="X_wZon"),
        Text(
          extent={{-154,130},{-104,110}},
          lineColor={0,0,127},
          textString="TAirZon"),
        Text(
          extent={{-64,270},{78,164}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-62,100},{80,-62}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{80,72},{92,-32}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{84,72},{88,-32}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,180}})),
    Documentation(info="<html>
<p>fixme: Michael to review documentation
Model that is used as a container for a thermal
zone that is to be exported as an FMU.
</p>
<h4>Typical use and important parameters</h4>
<p>
This model has a user-defined parameter <code>nFluPor</code>
which sets the number of inlet fluid ports.
</p>
<p>
This model gets a vector <code>fluPor</code> of <code>nFluPor</code> FMI connector 
for fluid inlets.
These connectors contain for each fluid inlet the mass flow rate, the temperature, 
the water vapor mass fraction per per total mass of the air, 
and trace substances. 
</p>

<p>
The model uses a mass flow source
<a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">
Buildings.Fluid.FMI.Sources.MassFlowSource_pT
</a> to transfer these quantities to the signal <code>ports</code>.
<p>
The signal <code>ports</code> are used to connect the model with a thermal zone.
The number of connection of the signal <code>ports</code> must 
match the number of <code>nFlupor</code>.
</p>

<p>
The output signals of this model are the zone air temperature,
the water vapor mass fraction per total mass of the air (unless <code>Medium.nXi=0</code>)
and trace substances (unless <code>Medium.nC=0</code>). The outflowing fluid stream(s) 
at the port <code>ports</code> are at this state.
</p>

<p>
To use this model, all <code>nFluPor</code>
<code>ports</code> need to be connected as described in example
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective
</a>.
</p>
<p>
To use this model as a container for an FMU, simply extend from this model,
rather than instantiate it, and add your thermal zone. By extending from this model,
the top-level signal connectors on the left stay at the top-level,
and hence will be visible at the FMI interface.The example
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective
</a>
shows how a simple convective thermal zone system can be implemented
and exported as an FMU.
The example
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective\">
Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective
</a>
shows conceptually how such an FMU can then be connected to a HVAC system
that has signal flow.
</p>
<p>
The conversion between the fluid ports and signal ports is done in the HVAC
adapter <code>theHvaAda</code>.
</p>
<h4>Typical use</h4>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective
</a>
for a model that uses this model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZoneConvective;
