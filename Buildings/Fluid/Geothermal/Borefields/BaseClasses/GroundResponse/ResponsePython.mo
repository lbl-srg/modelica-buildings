within Buildings.Fluid.Geothermal.Borefields.BaseClasses.GroundResponse;
model ResponsePython

  parameter Integer nSeg=10 "Total number of segments";

  Modelica.Blocks.Interfaces.RealInput QBor_flow[nSeg](
    final unit=fill("W", nSeg))
    "Heat flow from boreholes (positive if heat from fluid into soil)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput TBorWal_start[nSeg](
    final unit=fill("K", nSeg),
    displayUnit=fill("degC", nSeg),
    quantity=fill("ThermodynamicTemperature", nSeg))
    "Start borehole outer wall temperature" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput TBorWal[nSeg](
    final unit=fill("K", nSeg),
    displayUnit=fill("degC", nSeg),
    quantity=fill("ThermodynamicTemperature", nSeg))
    "Temperature of current borehole wall temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Utilities.IO.Python27.Real_Real pyt(
    moduleName="GroundResponse",
    functionName="doStep",
    nDblRea=nSeg,
    nDblWri=2*nSeg+1,
    samplePeriod=60,
    passPythonObject=true)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Routing.Multiplex mul(final n=2*nSeg+1) "Multiplex"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

equation
  connect(pyt.yR, TBorWal)
    annotation (Line(points={{41,0},{120,0}}, color={0,0,127}));
  connect(mul.y, pyt.uR)
    annotation (Line(points={{1,0},{18,0}}, color={0,0,127}));
  connect(QBor_flow, mul.u[1:10])
    annotation (Line(points={{-120,60},{-40,60},{-40,0},{-20,0}},
      color={0,0,127}));
  connect(TBorWal_start, mul.u[11:20]) annotation (Line(points={{-120,0},{-70,0},
          {-70,0},{-20,0}}, color={0,0,127}));
  connect(clock.y, mul.u[21])
    annotation (Line(points={{-59,-50},{-40,-50},{-40,0},{-20,0}},
      color={0,0,127}));

annotation (defaultComponentName="toughRes",
Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,30},{100,-100}},
          lineColor={0,0,0},
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,30},{-94,-100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-66,-4},{72,-4}},
          color={255,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Rectangle(
          extent={{-100,30},{-94,-100}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
            textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=
           false)));
end ResponsePython;
