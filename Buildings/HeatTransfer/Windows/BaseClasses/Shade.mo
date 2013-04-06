within Buildings.HeatTransfer.Windows.BaseClasses;
model Shade
  "Model for infrared radiative heat balance of a layer that may or may not have a shade"

  parameter Modelica.SIunits.Area A "Heat transfer area";
  parameter Modelica.SIunits.Emissivity absIR_air
    "Infrared absorptivity of surface that faces air";
  parameter Modelica.SIunits.Emissivity absIR_glass
    "Infrared absorptivity of surface that faces glass";
  parameter Modelica.SIunits.TransmissionCoefficient tauIR_air
    "Infrared transmissivity of shade for radiation coming from the exterior or the room";
  parameter Modelica.SIunits.TransmissionCoefficient tauIR_glass
    "Infrared transmissivity of shade for radiation coming from the glass";
  parameter Boolean thisSideHasShade
    "Set to true if this side of the window has a shade";
  final parameter Modelica.SIunits.ReflectionCoefficient rhoIR_air=1-absIR_air-tauIR_air
    "Infrared reflectivity of surface that faces air";
  final parameter Modelica.SIunits.ReflectionCoefficient rhoIR_glass=1-absIR_glass-tauIR_glass
    "Infrared reflectivity of surface that faces glass";
  parameter Boolean linearize = false "Set to true to linearize emissive power"
  annotation (Evaluate=true);
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer"
    annotation (Dialog(enable=linearize), Evaluate=true);

  parameter Real k(min=0, max=1)=1
    "Coefficient used to scale convection between shade and glass";
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

  Interfaces.RadiosityInflow JIn_air(start=A*0.8*Modelica.Constants.sigma*293.15^4)
    "Incoming radiosity at the air-side surface of the shade"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Interfaces.RadiosityInflow JIn_glass(start=A*0.8*Modelica.Constants.sigma*293.15^4)
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
     annotation (Placement(transformation(extent={{-50,-110},{-30,-90}},
                       rotation=0), iconTransformation(extent={{-36,-108},{-16,-88}})));
protected
 final parameter Real T03(min=0, unit="K3")=T0^3 "3rd power of temperature T0"
 annotation(Evaluate=true);
 Real T4(min=1E8, start=293.15^4, nominal=1E10, unit="K4")
    "4th power of temperature";
 Modelica.SIunits.RadiantPower E_air "Emissive power of surface that faces air";
 Modelica.SIunits.RadiantPower E_glass
    "Emissive power of surface that faces glass";
equation
  if thisSideHasShade then
  // Radiosities that are outgoing from the surface, which are
  // equal to the infrared absorptivity plus the reflected incoming
  // radiosity plus the radiosity that is transmitted from the
  // other surface.
    if linearize then
      T4 = T03 * sha.T;
    else
      if homotopyInitialization then
	T4 = homotopy(actual=(sha.T)^4, simplified=T03 * sha.T);
      else
	T4 = (sha.T)^4;
      end if;
    end if;

    E_air   = u * A * absIR_air   * Modelica.Constants.sigma * T4;
    E_glass = u * A * absIR_glass * Modelica.Constants.sigma * T4;
    // Radiosity outgoing from shade towards air side and glass side
    JOut_air   = - E_air   - tauIR_glass * JIn_glass - rhoIR_air*JIn_air;
    JOut_glass = - E_glass - tauIR_air   * JIn_air   - rhoIR_glass*JIn_glass;
    // Heat balance of shade
    // The term 2*Gc is to combine the parallel convective heat transfer resistances,
    // see figure in info section.
    QAbs_flow + absIR_air*JIn_air + absIR_glass*JIn_glass
      = -Gc*(2*(air.T-sha.T)+k*(glass.T-sha.T))+E_air+E_glass;
    // Convective heat flow at air node
    air.Q_flow   = Gc*(2*(air.T-sha.T) + (air.T-glass.T));
    // Convective heat flow at glass node
    glass.Q_flow = Gc*((glass.T-air.T)+k*(glass.T-sha.T));
  else
    air.Q_flow   = Gc*(air.T-glass.T);
    glass.Q_flow = -air.Q_flow;
    sha.T = (air.T+glass.T)/2;
    T4 = T03 * T0;
    E_air = 0;
    E_glass = 0;
    JOut_air = -JIn_glass;
    JOut_glass = -JIn_air;
  end if;

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
Model for the convective and the infrared radiative heat balance 
of a shade that is in the outside or the room-side of a window.
</p>
<p>
The input port <code>QAbs_flow</code> needs to be connected to the solar radiation 
that is absorbed by the shade.
</p>
<p>
The convective heat balance is based on the model described by Wright (2008), which can
be shown as a convective heat resistance model as follows:
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/convection.png\" border=\"1\"/>
</p>
<p>
Wright (2008) reports that if the shading layer is far enough from the window,
the boundary layers associated with each surface will not interfere with
each other. In this case, it is reasonable to consider each surface on an 
individual basis by setting the convective heat transfer coefficient shown in grey to zero,
and setting the black depicted convective heat transfer coefficients
to <i>h=4 W/m<sup>2</sup> K</i>.
In the here implemented model, the grey depicted convective heat transfer coefficient
is set set to <i>h' = k &nbsp; h</i>, where <i>0 &le; k &le; 1</i> is a parameter.
</p>
<h4>References</h4>
<ul>
<li>
Jon L. Wright.<br>
Calculating Center-Glass Performance Indices
of Glazing Systems with Shading Devices.<br>
<i>ASHRAE Transactions</i>, SL-08-020. 2008.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 2, 2011 by Michael Wetter:<br>
Added <code>homotopy</code> operator.
</li>
<li>
February 3, by Michael Wetter:<br>
Corrected bug in start value of radiosity port and in heat balance of shade.
</li>
<li>
January 28 2011, by Michael Wetter:<br>
Fixed computation of convective heat balance between air, shade and glass.
</li>
<li>
November 3 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Shade;
