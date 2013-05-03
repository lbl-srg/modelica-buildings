within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses;
block HeatFlow "Calculates heat flow rates for source and load side"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.InputInterface;
//   parameter
//     Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.HeatingMode perHea
//     "Heating performance data";
//   parameter
//     Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.CoolingMode perCoo
//     "Cooling performance data";
  parameter Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.HPData
                                                                      datHP
    "Heat pump data";
//   Modelica.Blocks.Interfaces.RealInput TLoa(
//     quantity="Temperature",unit="K",displayUnit="degC")
//     "Temperature of water entering the load side coil "
//     annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
//         iconTransformation(extent={{-120,30},{-100,50}})));
//   Modelica.Blocks.Interfaces.RealInput TSou(
//     quantity="Temperature",unit="K",displayUnit="degC")
//     "Temperature of water entering the source side coil "
//     annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
//         iconTransformation(extent={{-120,-30},{-100,-10}})));
//   Modelica.Blocks.Interfaces.RealInput mLoa_flow(
//     quantity="MassFlowRate",unit="kg/s") "Load side water mass flow rate"
//     annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
//         iconTransformation(extent={{-120,0},{-100,20}})));
//   Modelica.Blocks.Interfaces.RealInput mSou_flow(
//     quantity="MassFlowRate", unit="kg/s") "Source side water mass flow rate"
//     annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
//         iconTransformation(extent={{-120,-60},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealOutput Q1_flow(unit="W")
    "Vol1 heat transfer rate"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput Q2_flow(unit="W")
    "Vol2 heat transfer rate"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power",unit="W")
    "Electrical power consumed by the compressor"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},rotation=0)));

//   Modelica.Blocks.Interfaces.IntegerInput mode(min=1)
//     "Mode of operation of heatpump (mode=0: off, mode=1: heating, mode=2: cooling)"
//     annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
//         iconTransformation(extent={{-120,90},{-100,110}})));
  CapacityCalculator capCal(
    datHP=datHP) "Calculates heating or cooling capacity for given speed ratio"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
equation
  connect(speRat,capCal. speRat) annotation (Line(
      points={{-120,70},{-80,70},{-80,18},{-1,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1,capCal. T1) annotation (Line(
      points={{-120,40},{-90,40},{-90,14},{-1,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m1_flow,capCal. m1_flow) annotation (Line(
      points={{-120,10},{-61,10},{-61,11},{-1,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2,capCal. T2) annotation (Line(
      points={{-120,-20},{-40,-20},{-40,8},{-1,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2_flow,capCal. m2_flow) annotation (Line(
      points={{-120,-50},{-20,-50},{-20,5},{-1,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(capCal.Q1_flow, Q1_flow) annotation (Line(
      points={{21,13},{61.5,13},{61.5,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(capCal.P, P) annotation (Line(
      points={{21,7},{60.5,7},{60.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(capCal.Q1_flow, add.u1) annotation (Line(
      points={{21,13},{40,13},{40,-34},{58,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(capCal.P, add.u2) annotation (Line(
      points={{21,7},{34,7},{34,-46},{58,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, Q2_flow) annotation (Line(
      points={{81,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode,capCal.mode)  annotation (Line(
      points={{-120,100},{-20,100},{-20,20},{-1,20}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(rho, capCal.rho) annotation (Line(
      points={{-120,-80},{-10,-80},{-10,2},{-1,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="heaFlo", Diagram(graphics), Documentation(info="<html>
<p>
This block calculates the rate of heat transfer for heating (or cooling) the water on source side.
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 9, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),Icon(graphics={
        Line(
          points={{-60,-38},{-50,-80},{-40,-40},{-30,-80},{-20,-40},{-10,-80},{0,
              -40},{10,-80},{20,-40},{30,-80},{40,-40},{50,-80},{60,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-60,40},{-50,80},{-40,40},{-30,80},{-20,40},{-10,80},{0,40},{
              10,80},{20,40},{30,80},{40,40},{50,80},{60,42}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-78,18},{-78,40}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{78,2},{78,42}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{78,-40},{78,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-78,-38},{-78,-22}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(extent={{-98,18},{-58,-22}}, lineColor={0,0,255}),
        Polygon(
          points={{68,22},{88,-18},{68,-18},{88,22},{68,22}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,16},{-58,-24}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="C"),
        Text(
          extent={{-60,-80},{60,-100}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Vol2"),
        Text(
          extent={{-50,100},{50,80}},
          lineColor={255,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Vol1"),
        Line(
          points={{-60,40},{-78,40}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-78,-38},{-60,-38}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{78,42},{60,42}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,-40},{78,-40}},
          color={0,0,255},
          smooth=Smooth.None)}),     Diagram(graphics));
end HeatFlow;
