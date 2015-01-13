within Buildings.HeatTransfer.Windows.BaseClasses;
model GlassLayer "Model for a glass layer of a window assembly"
  extends Buildings.HeatTransfer.Radiosity.BaseClasses.RadiosityTwoSurfaces;
  extends Buildings.HeatTransfer.Radiosity.BaseClasses.ParametersTwoSurfaces(
    final rhoIR_a=1-absIR_a-tauIR,
    final rhoIR_b=1-absIR_b-tauIR);
  parameter Modelica.SIunits.Length x "Material thickness";
  parameter Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
  parameter Modelica.SIunits.Area A "Heat transfer area";
  parameter Modelica.SIunits.Emissivity absIR_a
    "Infrared absorptivity of surface a (usually room-facing surface)";
  parameter Modelica.SIunits.Emissivity absIR_b
    "Infrared absorptivity of surface b (usually outside-facing surface)";
  parameter Modelica.SIunits.TransmissionCoefficient tauIR
    "Infrared transmittance of glass";

  Modelica.Blocks.Interfaces.RealInput u
    "Input connector, used to scale the surface area to take into account an operable shading device"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=293.15))
    "Heat port at surface a"
    annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(T(start=293.15))
    "Heat port at surface b"
    annotation (Placement(transformation(extent={{90,-10},{
            110,10}})));
  Modelica.Blocks.Interfaces.RealInput QAbs_flow(unit="W", quantity="Power")
    "Solar radiation absorbed by glass" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
  parameter Boolean linearize=false "Set to true to linearize emissive power";
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
protected
 Real T4_a(min=1E8, unit="K4", start=293.15^4, nominal=1E10)
    "4th power of temperature at surface a";
 Real T4_b(min=1E8, unit="K4", start=293.15^4, nominal=1E10)
    "4th power of temperature at surface b";
 Modelica.SIunits.HeatFlowRate E_a(min=0, nominal=1E2)
    "Emissive power of surface a";
 Modelica.SIunits.HeatFlowRate E_b(min=0, nominal=1E2)
    "Emissive power of surface b";
 final parameter Modelica.SIunits.ThermalResistance R = x/2/k/A
    "Thermal resistance from surface of glass to center of glass";
equation
  // Heat balance of surface node
  // These equations are from Window 6 Technical report, (2.1-14) to (2.1-17)
  0 = port_a.Q_flow + port_b.Q_flow + QAbs_flow + JIn_a  + JIn_b - JOut_a - JOut_b;
  u * (port_b.T-port_a.T) = 2*R * (-port_a.Q_flow-QAbs_flow/2-JIn_a+JOut_a + tauIR * (JIn_a - JIn_b));
  // Radiosity balance
  if linearize then
    T4_a = 4*T03*port_a.T - 3*T04;
    T4_b = 4*T03*port_b.T - 3*T04;
  else
    if homotopyInitialization then
      T4_a = homotopy(actual=port_a.T^4, simplified=4*T03*port_a.T - 3*T04);
      T4_b = homotopy(actual=port_b.T^4, simplified=4*T03*port_b.T - 3*T04);
    else
      T4_a = port_a.T^4;
      T4_b = port_b.T^4;
    end if;
  end if;
  // Emissive power
  E_a = u * A * absIR_a * Modelica.Constants.sigma * T4_a;
  E_b = u * A * absIR_b * Modelica.Constants.sigma * T4_b;
  // Radiosities that are outgoing from the surface, which are
  // equal to the infrared absorptivity plus the reflected incoming
  // radiosity plus the radiosity that is transmitted from the
  // other surface.
  JOut_a = E_a + rhoIR_a * JIn_a + tauIR * JIn_b;
  JOut_b = E_b + rhoIR_b * JIn_b + tauIR * JIn_a;
  annotation (    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,2},{92,-4}},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-4,2},{4,-100}},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{8,-70},{60,-98}},
          lineColor={0,0,127},
          textString="QAbs"),
        Text(
          extent={{-96,88},{-64,70}},
          lineColor={0,0,127},
          textString="u")}),
    Documentation(info="<html>
Model of a single layer of window glass. The input port <code>QAbs_flow</code>
needs to be connected to the solar radiation that is absorbed
by the glass pane.
The model computes the heat conduction between the two glass surfaces.
The heat flow <code>QAbs_flow</code> is added at the center of the glass.
The model also computes the infrared radiative heat balance using an instance
of the model
<a href=\"Buildings.HeatTransfer.Radiosity.WindowPane\">
Buildings.HeatTransfer.Radiosity.WindowPane</a>.
<br/>
</html>", revisions="<html>
<ul>
<li>
December 8, 2014, by Michael Wetter:<br/>
Added term <code>tauIR * (JIn_a - JIn_b)</code>
to heat balance. This is to correct
issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/304\">#304</a>
that led to an error in the glass temperatures if the glass conductance
is very small.
</li>
<li>
October 17, 2014, by Michael Wetter:<br/>
Removed nominal value for heat ports as the default is already
<i>300</i> Kelvin.
</li>
<li>
October 15, 2014, by Michael Wetter:<br/>
Changed type of <code>tauIR</code> from
<code>Modelica.SIunits.Emissivity</code> to
<code>Modelica.SIunits.TransmissionCoefficient</code>.
This avoids a type error in OpenModelica.
</li>
<li>
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
<li>
March 20, 2012 by Wangda Zuo:<br/>
Fixed bug for heat flow reported by Pierre Tittelein and fixed bug for temperature linearization.
</li>
<li>
April 2, 2011 by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
August 18 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end GlassLayer;
