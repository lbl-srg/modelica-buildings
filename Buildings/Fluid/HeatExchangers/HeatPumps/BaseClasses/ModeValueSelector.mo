within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block ModeValueSelector "Selects results from dry or wet coil"

  Modelica.Blocks.Interfaces.IntegerInput mode "Mode of operation"
    annotation (Placement(transformation(extent={{-120,10},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealInput EIRHea "Energy Input Ratio"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,110})));
  Modelica.Blocks.Interfaces.RealInput QHea_flow(
    min=0,
    unit="W") "Total heating capacity"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,110})));
  Modelica.Blocks.Interfaces.RealInput SHRCoo(
    min=0,
    max=1.0) "Sensible Heat Ratio: Ratio of sensible heat load to total load"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={1.77636e-15,-110})));
  Modelica.Blocks.Interfaces.RealInput THeaCoiSur(
    quantity="ThermodynamicTemperature",
    unit="K",
    min=273.15,
    max=373.15) "Coil surface temperature in heating mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,110})));
  Modelica.Blocks.Interfaces.RealInput mCooWat_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,-110})));
  Modelica.Blocks.Interfaces.RealInput EIRCoo "Energy Input Ratio"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-110})));
  Modelica.Blocks.Interfaces.RealInput QCoo_flow(max=0, unit="W")
    "Total cooling capacity"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-110})));
  Modelica.Blocks.Interfaces.RealInput TADPCoo(
    quantity="ThermodynamicTemperature",
    unit="K",
    min=273.15,
    max=373.15) "Dry bulb temperature of air at ADP"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-110})));

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
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput TCoiSur(
    quantity="ThermodynamicTemperature",
    unit="K",
    min=273.15,
    max=373.15) "Dry bulb temperature "
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput mWat_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

equation
  EIR       = if mode == 1 then EIRHea elseif mode ==2 then EIRCoo else 0;
  Q_flow    = if mode == 1 then  QHea_flow elseif mode ==2 then QCoo_flow else 0;
  SHR       = if mode == 2 then SHRCoo  else 1;
  TCoiSur   = if mode == 1 then THeaCoiSur elseif mode ==2 then TADPCoo else 273.15+10;
  mWat_flow = if mode == 2 then mCooWat_flow  else 0;

  annotation (defaultComponentName="modValSel",
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
September 20, 2012 by Michael Wetter:<br>
Revised implementation. 
</li>
<li>
August 9, 2012 by Kaustubh Phalak:<br>
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
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),
    Diagram(graphics));
end ModeValueSelector;
