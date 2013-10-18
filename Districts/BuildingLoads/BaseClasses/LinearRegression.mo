within Districts.BuildingLoads.BaseClasses;
block LinearRegression
  "Whole building load model based on linear regression and table look-up"
  extends Districts.BuildingLoads.BaseClasses.PartialRegression;

  parameter String fileName="NoName" "File where matrix is stored";

protected
  Modelica.Blocks.Tables.CombiTable1Ds coef(
    final tableOnFile=true,
    final fileName=ModelicaServices.ExternalReferences.loadResource(fileName),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="tab1",
    columns=2:47) "Table reader with coefficients for linear model"
    annotation (Placement(transformation(extent={{-48,0},{-28,20}})));
  Utilities.SimulationTime simTim "Simulation time"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Multiply mul(nU=nU, nY=nY)
    "Block that multiplies the regression coefficients with the input signal"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Interfaces.IntegerOutput weekDay "Weekday indicator"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Math.RealToInteger weeDayInd
    "Type conversion for week-day indicator"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
public
  Modelica.Blocks.Routing.ExtractSignal extSig(
    nin=nY + nU*nY + 1,
    nout=nY + nU*nY,
    extract=2:nY + nU*nY + 1)
    "Extract the signals used for the data regression"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(simTim.y, coef.u) annotation (Line(
      points={{-79,10},{-50,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.TOut, TOut) annotation (Line(
      points={{-2,58},{-80,58},{-80,80},{-120,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.TDewPoi, TDewPoi) annotation (Line(
      points={{-2,54},{-80,54},{-80,40},{-120,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirNor, mul.HDirNor) annotation (Line(
      points={{-120,-40},{-70,-40},{-70,46},{-2,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.HDif, HDif) annotation (Line(
      points={{-2,42},{-64,42},{-64,-80},{-120,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.QCoo, QCoo) annotation (Line(
      points={{21,59},{60,59},{60,90},{110,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.QHea, QHea) annotation (Line(
      points={{21,57},{62,57},{62,70},{110,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.PLigInd, PLigInd) annotation (Line(
      points={{21,55},{62.5,55},{62.5,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.PPlu, PPlu) annotation (Line(
      points={{21,53},{60.5,53},{60.5,30},{110,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.PFan, PFan) annotation (Line(
      points={{21,51},{58.5,51},{58.5,10},{110,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.PDX, PDX) annotation (Line(
      points={{21,49},{30,49},{30,48},{38,48},{38,-10},{110,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.PLigOut, PLigOut) annotation (Line(
      points={{21,47},{24,47},{24,46},{34,46},{34,-30},{110,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.PTot, PTot) annotation (Line(
      points={{21,45},{26,45},{26,44},{30,44},{30,-50},{110,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.PGas, PGas) annotation (Line(
      points={{21,43},{24,43},{24,42},{28,42},{28,-70},{110,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weeDayInd.y, weekDay) annotation (Line(
      points={{61,-90},{110,-90}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(coef.y[1], weeDayInd.u) annotation (Line(
      points={{-27,10},{-14,10},{-14,-90},{38,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  for i in 1:nY+nY*nU loop
  end for;
  connect(coef.y, extSig.u) annotation (Line(
      points={{-27,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.beta, extSig.y) annotation (Line(
      points={{10,38},{10,30},{26,30},{26,10},{21,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
This is the low-level implementation for the linear regression model used by
<a href=\"modelica://Districts.BuildingLoads.LinearRegression\">
Districts.BuildingLoads.LinearRegression</a>.
Rather than using physical ports, this model uses input and output signals.
</html>", revisions="<html>
<ul>
<li>
October 18, 2013, by Michael Wetter:<br/>
Added <code>ModelicaServices.ExternalReferences.loadResource</code> when loading
the data file.
</li>
<li>
April 22, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LinearRegression;
