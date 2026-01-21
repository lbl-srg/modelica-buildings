within Buildings.Fluid.Geothermal.Borefields.TOUGH.BaseClasses;
model GroundResponse "Ground response calculated by the TOUGH simulator"

  parameter Modelica.Units.SI.Height hBor "Total height of the borehole";
  parameter Integer nSeg "Total number of segments";
  parameter Integer nInt "Number of points in the ground to be investigated";
  parameter Integer nTouSeg "Total number of grids along the entire borehole in the TOUGH mesh";
  parameter Modelica.Units.SI.Time samplePeriod "Sample period of component"
    annotation(Dialog(group="Sampling"));

  Modelica.Blocks.Interfaces.RealInput QBor_flow[nSeg](
    final unit=fill("W", nSeg))
    "Heat flow from boreholes (positive if heat from fluid into soil)"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput TBorWal_start[nSeg](
    final unit=fill("K", nSeg),
    displayUnit=fill("degC", nSeg),
    quantity=fill("ThermodynamicTemperature", nSeg))
    "Initial borehole outer wall temperature at the begining of the simulation"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput TBorWal[nSeg](
    final unit=fill("K", nSeg),
    displayUnit=fill("degC", nSeg),
    quantity=fill("ThermodynamicTemperature", nSeg))
    "Temperature of current borehole wall temperature"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput pInt[nInt]
    "Pressure of the interested points"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput xInt[nInt]
    "Satuation of the interested points"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
      iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput TInt[nInt](
    final unit=fill("K", nInt),
    displayUnit=fill("degC", nInt),
    quantity=fill("ThermodynamicTemperature", nInt))
    "Temperature at the interested points"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Utilities.IO.Python_3_8.Real_Real pyt(
    final moduleName="GroundResponse",
    final functionName="doStep",
    final nDblRea=nSeg+3*nInt,
    final nDblWri=2*nSeg + 6,
    final samplePeriod=samplePeriod,
    final flag=0,
    final passPythonObject=true)
    "Python interface model to call TOUGH simulator"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Routing.Multiplex mul(
    final n=2*nSeg + 6)
    "Multiplex"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.ContinuousClock clock
    "Current time"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant griNum[3](
    final k={nSeg,nTouSeg,nInt}) "Total number of grids"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant borHei(final k=hBor)
    "Total height of the borehole"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

equation
  connect(pyt.yR[1:nSeg], TBorWal)
    annotation (Line(points={{61,0},{80,0},{80,60},{120,60}}, color={0,0,127}));
  connect(mul.y, pyt.uR)
    annotation (Line(points={{21,0},{38,0}},color={0,0,127}));
  connect(pyt.yR[nSeg + 1:nSeg + nInt], pInt) annotation (Line(points={{61,0},{80,
          0},{80,20},{120,20}}, color={0,0,127}));
  connect(pyt.yR[nSeg+nInt+1:nSeg+2*nInt], xInt)
    annotation (Line(points={{61,0},{80,0},{80,-20},{120,-20}}, color={0,0,127}));
  connect(pyt.yR[nSeg+2*nInt+1:nSeg+3*nInt], TInt)
    annotation (Line(points={{61,0},{80,0},{80,-60},{120,-60}}, color={0,0,127}));
  connect(griNum.y, mul.u[1:3]) annotation (Line(points={{-58,70},{-30,70},{-30,
          0},{0,0}}, color={0,0,127}));
  connect(QBor_flow, mul.u[4:nSeg+3]) annotation (Line(points={{-120,40},{-40,40},
          {-40,0},{0,0}}, color={0,0,127}));
  connect(TBorWal_start, mul.u[nSeg+4:2*nSeg+3]) annotation (Line(points={{-120,0},
          {0,0}}, color={0,0,127}));
  connect(TOut, mul.u[2*nSeg+4]) annotation (Line(points={{-120,-40},{-40,-40},{
          -40,0},{0,0}}, color={0,0,127}));
  connect(clock.y, mul.u[2*nSeg+5]) annotation (Line(points={{-59,-60},{-30,-60},
          {-30,0},{0,0}}, color={0,0,127}));
  connect(borHei.y, mul.u[2*nSeg+6]) annotation (Line(points={{-18,-80},{-10,-80},
          {-10,0},{0,0}},  color={0,0,127}));

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
          color={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
            textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=
           false)),
 Documentation(info="<html>
<p>
This model calculates the ground temperature response to obtain the temperature
at the borehole wall in a geothermal system where heat is being injected into or
extracted from the ground.
</p>
<p>
The instance <code>pyt</code> finds the ground response with the
<a href=\"https://tough.lbl.gov/software/tough3\">TOUGH</a> simulator
through the Python interface
<a href=\"modelica://Buildings.Utilities.IO.Python_3_8.Real_Real\">
Buildings.Utilities.IO.Python_3_8.Real_Real</a>. See
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGH.UsersGuide\">
Buildings.Fluid.Geothermal.Borefields.TOUGH.UsersGuide</a>
for instructions.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2024, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end GroundResponse;
