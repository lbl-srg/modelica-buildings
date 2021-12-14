within Buildings.HeatTransfer.Windows.BaseClasses;
model ShadeConvection
  "Model for convective heat balance of a layer that may or may not have a shade"

  parameter Modelica.Units.SI.Area A "Heat transfer area";
  parameter Boolean thisSideHasShade
    "Set to true if this side of the window has a shade";

  parameter Real k(min=0, max=1)=1
    "Coefficient used to scale convection between shade and glass";

  Modelica.Blocks.Interfaces.RealInput Gc(unit="W/K")
    "Signal representing the convective thermal conductance"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        origin={-120,30}), iconTransformation(extent={{-10,-10},{10,10}},
          origin={-110,40})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a air
    "Port that connects to the air (room or outside)"        annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glass
    "Heat port that connects to shaded part of glass"
    annotation (Placement(transformation(extent={{84,-10},{104,10}}),
        iconTransformation(extent={{84,-10},{104,10}})));
 Modelica.Blocks.Interfaces.RealInput QRadAbs_flow(unit="W")
    "Total net radiation that is absorbed by the shade (positive if absorbed)"
     annotation (Placement(transformation(extent={{10,-10},{-10,10}},
                       rotation=270,
        origin={-60,-110}),         iconTransformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-60,-110})));

  Modelica.Blocks.Interfaces.RealOutput TSha(quantity="ThermodynamicTemperature",
      unit="K") "Shade temperature"
    annotation (Placement(transformation(
        origin={58,-120},
        extent={{20,-20},{-20,20}},
        rotation=90), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,-110})));
equation
  if thisSideHasShade then
    // Convective heat balance of shade.
    // The term 2*Gc is to combine the parallel convective heat transfer resistances,
    // see figure in info section.
 //   2*(air.T-TSha) = k*(glass.T-TSha);
    // Convective heat flow at air node
    air.Q_flow   = Gc*(2*(air.T-TSha) + (air.T-glass.T));
    // Convective heat flow at glass node
    glass.Q_flow = Gc*((glass.T-air.T)+k*(glass.T-TSha));
    air.Q_flow + glass.Q_flow + QRadAbs_flow = 0;
  else
    air.Q_flow   = Gc*(air.T-glass.T);
    air.Q_flow + glass.Q_flow = 0;
    TSha = (air.T+glass.T)/2;
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
          extent={{-100,52},{-66,34}},
          textColor={0,0,127},
          textString="Gc"),
        Rectangle(
          extent={{88,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-68,-80},{-34,-98}},
          textColor={0,0,127},
          textString="QAbsNet"),
        Text(
          extent={{42,-82},{76,-100}},
          textColor={0,0,127},
          textString="T")}),
    Documentation(info="<html>
<p>
Model for the convective heat balance
of a shade that is in the outside or the room-side of a window.
</p>
<p>
The convective heat balance is based on the model described by Wright (2008), which can
be shown as a convective heat resistance model as follows:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/convection.png\" border=\"1\"/>
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
Jon L. Wright.<br/>
Calculating Center-Glass Performance Indices
of Glazing Systems with Shading Devices.<br/>
<i>ASHRAE Transactions</i>, SL-08-020. 2008.
</li>
</ul>
</html>", revisions="<html>
<ul>
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
end ShadeConvection;
