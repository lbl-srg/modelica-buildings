within Buildings.Fluid.DXSystems.BaseClasses;
block DryWetSelector "Selects results from dry or wet coil"

  constant Modelica.Units.SI.MassFraction deltaX=0.0001
    "Range of x where transition between dry and wet coil occurs";
  Modelica.Blocks.Interfaces.RealInput XEvaIn "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput XADP "Mass fraction at ADP"
    annotation (Placement(transformation(extent={{-120,50},{-100,30}})));

  Modelica.Blocks.Interfaces.RealInput EIRWet "Energy Input Ratio"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,110})));
  Modelica.Blocks.Interfaces.RealInput QWet_flow(
    max=0,
    unit="W") "Total cooling capacity"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,110})));
  Modelica.Blocks.Interfaces.RealInput SHRWet(
    min=0,
    max=1.0)
    "Sensible Heat Ratio: Ratio of sensible heat load to total heat load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,110})));
  Modelica.Blocks.Interfaces.RealInput mWetWat_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,110})));
  Modelica.Blocks.Interfaces.RealInput EIRDry "Energy Input Ratio"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-110})));
  Modelica.Blocks.Interfaces.RealInput QDry_flow(max=0, unit="W")
    "Total cooling capacity"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-110})));
  Modelica.Blocks.Interfaces.RealOutput EIR "Energy Input Ratio"
     annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    max=0,
    unit="W") "Total cooling capacity"
     annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput SHR(
    min=0,
    max=1.0)
    "Sensible Heat Ratio: Ratio of sensible heat load to total heat load"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput mWat_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

 output Real fraDry(min=0, max=1)
    "Fraction of results that are taken from the dry coil model";
 output Real fraWet(min=0, max=1)
    "Fraction of results that are taken from the wet coil model";
protected
  output Modelica.Units.SI.MassFraction dX(min=-1, max=1)
    "Difference between apparatus dew point mass fraction of wet coil and inlet air mass fraction";
equation
  dX = XADP-XEvaIn;
  fraDry=Buildings.Utilities.Math.Functions.spliceFunction(
    pos=+1,
    neg=0,
    x= dX+deltaX,
    deltax= deltaX);
  fraWet=1-fraDry;
  EIR       = fraDry * EIRDry    + fraWet * EIRWet;
  Q_flow    = fraDry * QDry_flow + fraWet * QWet_flow;
  SHR       = fraDry             + fraWet * SHRWet;
  mWat_flow =                      fraWet * mWetWat_flow;

  annotation (defaultComponentName="dryWetPre",
      Documentation(info="<html>
<p>
This block smoothly transitions the results from the dry coil and
the wet coil computation.
The independent variable for the transition is the difference between
the water mass fractions at the apparatus dew point, as computed by the wet coil model,
and the coil inlet mass fraction.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 7, 2020, by Michael Wetter:<br/>
Corrected limits for <code>dX</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1933\">#1933</a>.
</li>
<li>
April 13, 2017, by Michael Wetter:<br/>
Removed temperature that is no longer needed.
</li>
<li>
September 20, 2012 by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
August 9, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"),
      Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-58,28},{-2,-28}}, lineColor={0,0,255}),
        Line(
          points={{-100,50},{-82,50},{-50,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-100,-50},{-82,-50},{-50,-20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-42,14},{-16,0},{-40,-16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-2,0},{54,0}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.DashDotDot),
        Polygon(
          points={{78,0},{48,8},{48,-8},{78,0}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.CrossDiag),
        Text(
          extent={{-70,94},{70,52}},
          textColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end DryWetSelector;
