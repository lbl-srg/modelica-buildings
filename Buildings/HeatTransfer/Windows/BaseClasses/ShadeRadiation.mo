within Buildings.HeatTransfer.Windows.BaseClasses;
model ShadeRadiation
  "Model for infrared radiative heat balance of a layer that may or may not have a shade"

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.Units.SI.Area A "Heat transfer area";
  parameter Modelica.Units.SI.Emissivity absIR_air
    "Infrared absorptivity of surface that faces air";
  parameter Modelica.Units.SI.Emissivity absIR_glass
    "Infrared absorptivity of surface that faces glass";
  parameter Modelica.Units.SI.TransmissionCoefficient tauIR_air
    "Infrared transmissivity of shade for radiation coming from the exterior or the room";
  parameter Modelica.Units.SI.TransmissionCoefficient tauIR_glass
    "Infrared transmissivity of shade for radiation coming from the glass";
  parameter Boolean thisSideHasShade
    "Set to true if this side of the window has a shade";
  final parameter Modelica.Units.SI.ReflectionCoefficient rhoIR_air=1 -
      absIR_air - tauIR_air "Infrared reflectivity of surface that faces air";
  final parameter Modelica.Units.SI.ReflectionCoefficient rhoIR_glass=1 -
      absIR_glass - tauIR_glass
    "Infrared reflectivity of surface that faces glass";
  parameter Boolean linearize = false "Set to true to linearize emissive power"
  annotation (Evaluate=true);

  parameter Modelica.Units.SI.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer"
    annotation (Dialog(enable=linearize));

  Modelica.Blocks.Interfaces.RealInput u
    "Input connector, used to scale the surface area to take into account an operable shading device"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealInput QSolAbs_flow(unit="W", quantity="Power")
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

 Modelica.Blocks.Interfaces.RealOutput QRadAbs_flow(unit="W")
    "Total net radiation that is absorbed by the shade (positive if absorbed)"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                       rotation=270,
        origin={-50,-110}),         iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,-110})));

  Modelica.Blocks.Interfaces.RealInput TSha(quantity="ThermodynamicTemperature",
      unit="K",
      start=293.15)
      if thisSideHasShade "Shade temperature"
    annotation (Placement(transformation(
        origin={60,-120},
        extent={{-20,-20},{20,20}},
        rotation=90), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-110})));

protected
   Modelica.Blocks.Interfaces.RealInput TSha_internal(quantity="ThermodynamicTemperature",
      unit="K",
      start=293.15) "Internal connector for shade temperature";

 final parameter Real T03(min=0, final unit="K3")=T0^3
    "3rd power of temperature T0";
 Real T4(min=1E8, start=293.15^4, nominal=1E10, final unit="K4")
    "4th power of temperature";
  Modelica.Units.SI.RadiantPower E_air
    "Emissive power of surface that faces air";
  Modelica.Units.SI.RadiantPower E_glass
    "Emissive power of surface that faces glass";

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(TSha_internal, TSha);
  if thisSideHasShade then
  // Radiosities that are outgoing from the surface, which are
  // equal to the infrared absorptivity plus the reflected incoming
  // radiosity plus the radiosity that is transmitted from the
  // other surface.
    if linearize then
      T4 = T03 * TSha_internal;
    else
      if homotopyInitialization then
        T4 = homotopy(actual=(TSha_internal)^4, simplified=T03 * TSha_internal);
      else
        T4 = TSha_internal^4;
      end if;
    end if;

    E_air   = u * A * absIR_air   * Modelica.Constants.sigma * T4;
    E_glass = u * A * absIR_glass * Modelica.Constants.sigma * T4;
    // Radiosity outgoing from shade towards air side and glass side
    JOut_air   = E_air   + tauIR_glass * JIn_glass + rhoIR_air*JIn_air;
    JOut_glass = E_glass + tauIR_air   * JIn_air   + rhoIR_glass*JIn_glass;
    // Radiative heat balance of shade.
    QSolAbs_flow + absIR_air*JIn_air + absIR_glass*JIn_glass
      = E_air+E_glass+QRadAbs_flow;
  else
    QRadAbs_flow = 0;
    T4 = T03 * T0;
    E_air = 0;
    E_glass = 0;
    JOut_air = JIn_glass;
    JOut_glass = JIn_air;
    TSha_internal = T0;
  end if;

  annotation (    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-100,132},{100,102}},
        textString="%name",
        textColor={0,0,255}),
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
          extent={{-18,-82},{16,-100}},
          textColor={0,0,127},
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
          textColor={0,0,127},
          textString="u"),
        Rectangle(
          extent={{88,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{42,-82},{76,-100}},
          textColor={0,0,127},
          textString="T"),
        Text(
          extent={{-68,-80},{-34,-98}},
          textColor={0,0,127},
          textString="QAbsNet")}),
    Documentation(info="<html>
<p>
Model for the infrared radiative heat balance
of a shade that is at the outside or the room-side of a window.
The model also includes the absorbed solar radiation.
</p>
<p>
The input port <code>QAbs_flow</code> needs to be connected to the solar radiation
that is absorbed by the shade.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
June 11, 2013, by Michael Wetter:<br/>
Redesigned model to separate convection from radiation, which is
required for the implementation of a CFD model.
</li>
<li>
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
<li>
April 2, 2011 by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
February 3, by Michael Wetter:<br/>
Corrected bug in start value of radiosity port and in heat balance of shade.
</li>
<li>
January 28 2011, by Michael Wetter:<br/>
Fixed computation of convective heat balance between air, shade and glass.
</li>
<li>
November 3 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShadeRadiation;
