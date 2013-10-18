within Districts.BuildingLoads.BaseClasses;
block TimeSeries "Whole building load model based on a time series"
  extends Districts.BuildingLoads.BaseClasses.PartialRegression;

  parameter String fileName="NoName" "File where matrix is stored";

protected
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=ModelicaServices.ExternalReferences.loadResource(fileName),
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns=2:14,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic) "Data reader"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
public
  Utilities.Diagnostics.AssertEquality assEquTOut(
    u2(unit="K"),
    threShold=10,
    startTime=startTime + 36000)
    "Assert that the data from the weather bus corresponds with the data in the time series"
    annotation (Placement(transformation(extent={{-40,64},{-20,84}})));
  Utilities.Diagnostics.AssertEquality assEquTDewPoi(
    u2(unit="K"),
    threShold=10,
    startTime=startTime + 36000)
    "Assert that the data from the weather bus corresponds with the data in the time series"
    annotation (Placement(transformation(extent={{-40,24},{-20,44}})));
  Utilities.Diagnostics.AssertEquality assEquHDirNor(
    u1(unit="W/m2"),
    startTime=startTime + 36000,
    threShold=300)
    "Assert that the data from the weather bus corresponds with the data in the time series"
    annotation (Placement(transformation(extent={{-40,-44},{-20,-24}})));
  Utilities.Diagnostics.AssertEquality assEquHDif(
    u1(unit="W/m2"),
    startTime=startTime + 36000,
    threShold=300)
    "Assert that the data from the weather bus corresponds with the data in the time series"
    annotation (Placement(transformation(extent={{-40,-84},{-20,-64}})));
  final parameter Modelica.SIunits.Time startTime(fixed=false)
    "Start time of the model";
initial equation
 startTime=time;
 assert(time >= 0, "fixme: Model has not yet been tested for negative start time.");

equation
  connect(QCoo, datRea.y[6]) annotation (Line(
      points={{110,90},{0,90},{0,4.44089e-16},{-59,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QHea, datRea.y[5]) annotation (Line(
      points={{110,70},{0,70},{0,4.44089e-16},{-59,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[7], PLigInd) annotation (Line(
      points={{-59,4.44089e-16},{0,4.44089e-16},{0,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[8], PPlu) annotation (Line(
      points={{-59,4.44089e-16},{0,4.44089e-16},{0,30},{110,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[9], PFan) annotation (Line(
      points={{-59,4.44089e-16},{34,4.44089e-16},{34,10},{110,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[10], PDX) annotation (Line(
      points={{-59,4.44089e-16},{0,4.44089e-16},{0,-10},{110,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[11], PLigOut) annotation (Line(
      points={{-59,4.44089e-16},{0,4.44089e-16},{0,-30},{110,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[12], PTot) annotation (Line(
      points={{-59,4.44089e-16},{0,4.44089e-16},{0,-50},{110,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[13], PGas) annotation (Line(
      points={{-59,4.44089e-16},{0,4.44089e-16},{0,-70},{110,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut, assEquTOut.u1) annotation (Line(
      points={{-120,80},{-42,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[1], assEquTOut.u2) annotation (Line(
      points={{-59,4.44089e-16},{-50,4.44089e-16},{-50,68},{-42,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TDewPoi, assEquTDewPoi.u1) annotation (Line(
      points={{-120,40},{-42,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[2], assEquTDewPoi.u2) annotation (Line(
      points={{-59,4.44089e-16},{-50,4.44089e-16},{-50,28},{-42,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[4], assEquHDirNor.u1) annotation (Line(
      points={{-59,4.44089e-16},{-50,4.44089e-16},{-50,-28},{-42,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirNor, assEquHDirNor.u2) annotation (Line(
      points={{-120,-40},{-42,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[3], assEquHDif.u1) annotation (Line(
      points={{-59,4.44089e-16},{-50,4.44089e-16},{-50,-68},{-42,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDif, assEquHDif.u2) annotation (Line(
      points={{-120,-80},{-42,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p>
This is the low-level implementation for reading the time series
that contains the building load. It is used by by
<a href=\"modelica://Districts.BuildingLoads.TimeSeries\">
Districts.BuildingLoads.TimeSeries</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 18, 2013, by Michael Wetter:<br/>
Added <code>ModelicaServices.ExternalReferences.loadResource</code> when loading
the data file.
</li>
<li>
August 23, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TimeSeries;
