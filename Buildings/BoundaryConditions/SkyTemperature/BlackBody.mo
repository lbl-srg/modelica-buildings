within Buildings.BoundaryConditions.SkyTemperature;
block BlackBody "Calculate black body sky temperature"
  extends Modelica.Blocks.Icons.Block;
  import Buildings.BoundaryConditions.Types.SkyTemperatureCalculation;
  parameter Buildings.BoundaryConditions.Types.SkyTemperatureCalculation calTSky=
    SkyTemperatureCalculation.TemperaturesAndSkyCover
    "Computation of black-body sky temperature"
    annotation(choicesAllMatching=true,
               Evaluate=true);
  Modelica.Blocks.Interfaces.RealInput TDryBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dry bulb temperature at ground level"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TDewPoi(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dew point temperature"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput nOpa "Opaque sky cover"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealOutput TBlaSky(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") "Black-body sky temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput radHorIR(
    unit="W/m2",
    min=0,
    nominal=100) "Horizontal infrared irradiation"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
protected
  Modelica.SIunits.Temperature TDewPoiK "Dewpoint temperature";
  Modelica.SIunits.Emissivity epsSky "Black-body absorptivity of sky";
  Real nOpa10(min=0, max=10) "Opaque sky cover";
algorithm
  if calTSky == Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover then
    TDewPoiK := Buildings.Utilities.Math.Functions.smoothMin(TDryBul, TDewPoi, 0.1);
    nOpa10 := 10*nOpa "Input nOpa is scaled to [0,1] instead of [0,10]";
    epsSky := (0.787 + 0.764*Modelica.Math.log(-TDewPoiK/Modelica.Constants.T_zero))*(1 + 0.0224*nOpa10 -
      0.0035*(nOpa10^2) + 0.00028*(nOpa10^3));
    TBlaSky := TDryBul*(epsSky^0.25);
  else
    TDewPoiK := 273.15;
    nOpa10   := 0.0;
    epsSky   := 0.0;
    TBlaSky  := (radHorIR/Modelica.Constants.sigma)^0.25;
  end if;
  annotation (
    defaultComponentName="TBlaSky",
    Documentation(info="<html>
<p>
This component computes the black-body sky temperature.
</p>
<p>
For <code>calTSky = 0</code>, the model uses horizontal infrared irradiation.
Otherwise, it uses dry buld temperature, dew point temperature and opaque sky cover.
</p>
</html>", revisions="<html>
<ul>
<li>
August 11, 2012, by Wangda Zuo:<br/>
Renamed <code>radHor</code> to <code>radHorIR</code>.
</li>
<li>
October 3, 2011, by Michael Wetter:<br/>
Used enumeration to set the sky temperature computation.
Fixed error in <code>if-then</code> statement that led to
a selection of the wrong branch to compute the sky temperature.
</li>
<li>
March 16, 2011, by Michael Wetter:<br/>
Added types for parameters and attributes for variables.
Removed default parameter value.
</li>
<li>
March 15, 2011, by Wangda Zuo:<br/>
Use <code>smoothMin()</code> instead of <code>min()</code>.
</li>
<li>
June 1, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-50,44},{56,-40}},
          lineColor={0,0,255},
          textString="T"),
        Text(
          extent={{-96,84},{-66,74}},
          lineColor={0,0,127},
          textString="TDry"),
        Text(
          extent={{-90,36},{-66,24}},
          lineColor={0,0,127},
          textString="TDewPoi"),
        Text(
          extent={{-92,-74},{-62,-88}},
          lineColor={0,0,127},
          textString="radHorIR"),
        Text(
          extent={{16,-6},{54,-28}},
          lineColor={0,0,255},
          textString="bs"),
        Text(
          extent={{-88,-24},{-64,-36}},
          lineColor={0,0,127},
          textString="nOpa")}));
end BlackBody;
