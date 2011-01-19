within Buildings.HeatTransfer.WindowsBeta.BaseClasses;
model Shade
  "Model for long-wave radiative heat balance of a layer that may or may not have a shade"

  parameter Modelica.SIunits.Area A "Heat transfer area";
  parameter Modelica.SIunits.Emissivity epsLW_air
    "Long wave emissivity of surface that faces air";
  parameter Modelica.SIunits.Emissivity epsLW_glass
    "Long wave emissivity of surface that faces glass";
  parameter Modelica.SIunits.TransmissionCoefficient tauLW_air
    "Long wave transmissivity of shade for radiation coming from the exterior or the room";
  parameter Modelica.SIunits.TransmissionCoefficient tauLW_glass
    "Long wave transmissivity of shade for radiation coming from the glass";
  parameter Boolean thisSideHasShade
    "Set to true if this side of the window has a shade";
  final parameter Modelica.SIunits.ReflectionCoefficient rhoLW_air=1-epsLW_air-tauLW_air
    "Long wave reflectivity of surface that faces air";
  final parameter Modelica.SIunits.ReflectionCoefficient rhoLW_glass=1-epsLW_glass-tauLW_glass
    "Long wave reflectivity of surface that faces glass";
  parameter Boolean linearize = false "Set to true to linearize emissive power"
  annotation (Evaluate=true);
  parameter Modelica.SIunits.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer"
    annotation (Dialog(enable=linearize), Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput u
    "Input connector, used to scale the surface area to take into account an operable shading device"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealInput Gc
    "Signal representing the convective thermal conductance in [W/K]"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,30}), iconTransformation(extent={{-10,-10},{10,10}},
          origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput QAbs_flow(unit="W", quantity="Power")
    "Solar radiation absorbed by shade"
    annotation (Placement(transformation(
        origin={0,-120},
        extent={{-20,-20},{20,20}},
        rotation=90), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));

  Interfaces.RadiosityInflow JIn_air(start=A*0.8*293.15^4)
    "Incoming radiosity at the air-side surface of the shade"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Interfaces.RadiosityInflow JIn_glass(start=A*0.8*293.15^4)
    "Incoming radiosity at the glass-side surface of the shade"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));
  Interfaces.RadiosityOutflow JOut_air
    "Outgoing radiosity at the air-side surface of the shade"
    annotation (Placement(transformation(extent={{-100,-90},{-120,-70}})));
  Interfaces.RadiosityOutflow JOut_glass
    "Outgoing radiosity at the glass-side surface of the shade"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a air
    "Port that connects to the air (room or outside)"        annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}},
                       rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glass
    "Heat port that connects to shaded part of glass"
    annotation (Placement(transformation(extent={{84,-10},{104,10}},
                                                                   rotation=0),
        iconTransformation(extent={{84,-10},{104,10}})));
 Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a sha(T(start=293.15))
    "Heat port to shade"
     annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}},
                       rotation=0), iconTransformation(extent={{-36,-108},{-16,-88}})));
protected
 final parameter Real T03(min=0, unit="K3")=T0^3 "3rd power of temperature T0"
 annotation(Evaluate=true);
 Real T4(min=1E8, start=293.15^4, nominal=1E10, unit="K4")
    "4th power of temperature";
 Modelica.SIunits.RadiantPower Eb_air
    "Emissive power of surface that faces air";
 Modelica.SIunits.RadiantPower Eb_glass
    "Emissive power of surface that faces glass";

equation
  if thisSideHasShade then
  // Radiosities that are outgoing from the surface, which are
  // equal to the long-wave emissivity plus the reflected incoming
  // radiosity plus the radiosity that is transmitted from the
  // other surface.
    T4 = if linearize then T03 * sha.T else (sha.T)^4;
    Eb_air   = u * A * epsLW_air   * Modelica.Constants.sigma * T4;
    Eb_glass = u * A * epsLW_glass * Modelica.Constants.sigma * T4;
    // Radiosity outgoing from shade towards air side and glass side
    JOut_air   = - Eb_air   - tauLW_glass * JIn_glass - rhoLW_air*JIn_air;
    JOut_glass = - Eb_glass - tauLW_air   * JIn_air   - rhoLW_glass*JIn_glass;
    // Heat balance of shade
    // fixme: verify equation. Heat resistance is too high if glass only exchanges heat with shade
    QAbs_flow + epsLW_air*JIn_air + epsLW_glass*JIn_glass
      = -air.Q_flow-glass.Q_flow+Eb_air+Eb_glass;
    // Convective heat flow at air node
    air.Q_flow   = Gc*(air.T-sha.T);
    glass.Q_flow = Gc*(glass.T-sha.T);
  else
    air.Q_flow   = Gc*(air.T-glass.T);
    glass.Q_flow = -air.Q_flow;
    sha.T = (air.T+glass.T)/2;
    T4 = T03 * T0;
    Eb_air = 0;
    Eb_glass = 0;
    JOut_air = -JIn_glass;
    JOut_glass = -JIn_air;
  end if;
//  0 = air.Q_flow + glass.Q_flow + JIn_air + JIn_glass + JOut_air + JOut_glass + QAbs_flow;

  annotation (Diagram(graphics),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-100,132},{100,102}},
        textString="%name",
        lineColor={0,0,255}),
        Polygon(
          points={{-20,54},{-20,46},{20,58},{20,66},{-20,54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,14},{-20,6},{20,18},{20,26},{-20,14}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,34},{-20,26},{20,38},{20,46},{-20,34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-26},{-20,-34},{20,-22},{20,-14},{-20,-26}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-6},{-20,-14},{20,-2},{20,6},{-20,-6}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-66},{-20,-74},{20,-62},{20,-54},{-20,-66}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-46},{-20,-54},{20,-42},{20,-34},{-20,-46}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{14,-82},{48,-100}},
          lineColor={0,0,127},
          textString="QAbs"),
        Rectangle(
          extent={{-2,90},{2,-80}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-40,94},{40,80}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-102,90},{-68,72}},
          lineColor={0,0,127},
          textString="u"),
        Text(
          extent={{-100,52},{-66,34}},
          lineColor={0,0,127},
          textString="Gc"),
        Rectangle(
          extent={{88,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Model for the convective and the long-wave radiative heat balance 
of a shade that is in the outside or the room-side of a window.
</p>
<p>
The input port <code>QAbs_flow</code> needs to be connected to the short-wave radiation 
that is absorbed by the shade.
</p>
</html>", revisions="<html>
<ul>
<li>
November 3 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Shade;
