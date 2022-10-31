within Buildings.Fluid.Geothermal.Borefields.BaseClasses.GroundResponse;
model WithGroundCheck
  "Response model with checking the temperature and pressure in the interested points"

  parameter Integer nSeg=10 "Total number of segments";
  parameter Integer nInt=10 "NUmber of points in the ground to be investigated";
  parameter Modelica.Units.SI.Time samplePeriod=60 "Sample period of component"
    annotation(Dialog(group="Sampling"));
  parameter Integer flag=0
    "Flag for double values (0: use current value, 1: use average over interval, 2: use integral over interval)"
    annotation(Dialog(group="Sampling"));

  Modelica.Blocks.Interfaces.RealInput QBor_flow[nSeg](
    final unit=fill("W", nSeg))
    "Heat flow from boreholes (positive if heat from fluid into soil)"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput TBorWal_start[nSeg](
    final unit=fill("K", nSeg),
    displayUnit=fill("degC", nSeg),
    quantity=fill("ThermodynamicTemperature", nSeg))
    "Initial borehole outer wall temperature at the begining of the simulation"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput TBorWal[nSeg](
    final unit=fill("K", nSeg),
    displayUnit=fill("degC", nSeg),
    quantity=fill("ThermodynamicTemperature", nSeg))
    "Temperature of current borehole wall temperature"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
      iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput pInt[nInt]
    "Pressure of the interested points"
    annotation (Placement(transformation(
          extent={{100,30},{140,70}}), iconTransformation(extent={{100,30},{120,
            50}})));
  Modelica.Blocks.Interfaces.RealOutput xInt[nInt]
    "Satuation of the interested points"
    annotation (Placement(transformation(extent={{100,-10},{140,30}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput TInt[nInt](
    final unit=fill("K", nInt),
    displayUnit=fill("degC", nInt),
    quantity=fill("ThermodynamicTemperature", nInt))
    "Temperature at the interested points"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput yCheTou
    "Check if TOUGH simulation is successful" annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}),  iconTransformation(
          extent={{100,-80},{120,-60}})));
  Modelica.Blocks.Interfaces.RealOutput yTouFin "TOUGH final simulation time"
    annotation (Placement(transformation(extent={{100,-110},{140,-70}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

  Buildings.Utilities.IO.Python_3_8.Real_Real pyt(
    moduleName="GroundResponse",
    functionName="doStep",
    nDblRea=nSeg + 3*nInt + 2,
    nDblWri=2*nSeg+2,
    samplePeriod=samplePeriod,
    flag=flag,
    passPythonObject=true)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Routing.Multiplex mul(final n=2*nSeg+2)       "Multiplex"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.ContinuousClock clock
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

equation
  connect(pyt.yR[1:nSeg], TBorWal)
    annotation (Line(points={{41,0},{60,0},{60,90},{120,90}}, color={0,0,127}));
  connect(mul.y, pyt.uR)
    annotation (Line(points={{1,0},{18,0}}, color={0,0,127}));
  connect(QBor_flow, mul.u[1:nSeg])
    annotation (Line(points={{-120,80},{-40,80},{-40,0},{-20,0}},
      color={0,0,127}));
  connect(TBorWal_start, mul.u[nSeg+1:2*nSeg]) annotation (Line(points={{-120,40},{-60,40},
          {-60,0},{-20,0}}, color={0,0,127}));
  connect(TOut, mul.u[2*nSeg+1]) annotation (Line(points={{-120,0},{-70,0},{-70,0},{-20,
          0}}, color={0,0,127}));
  connect(clock.y, mul.u[2*nSeg+2]) annotation (Line(points={{-59,-50},{-40,-50},{-40,
          0},{-20,0}}, color={0,0,127}));
  connect(pyt.yR[nSeg + 1:nSeg + nInt], pInt) annotation (Line(points={{41,0},{60,
          0},{60,50},{120,50}}, color={0,0,127}));
  connect(pyt.yR[nSeg+nInt+1:nSeg+2*nInt], xInt)
    annotation (Line(points={{41,0},{80,0},{80,10},{120,10}},
                                              color={0,0,127}));
  connect(pyt.yR[nSeg+2*nInt+1:nSeg+3*nInt], TInt)
    annotation (Line(points={{41,0},{60,0},{60,-30},{120,-30}}, color={0,0,127}));
  connect(pyt.yR[nSeg+3*nInt+1], yCheTou) annotation (Line(points={{41,0},{60,0},
          {60,-60},{120,-60}},
                     color={0,0,127}));
  connect(pyt.yR[nSeg+3*nInt+2], yTouFin) annotation (Line(points={{41,0},{60,0},{60,-90},{120,
          -90}}, color={0,0,127}));
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
end WithGroundCheck;
