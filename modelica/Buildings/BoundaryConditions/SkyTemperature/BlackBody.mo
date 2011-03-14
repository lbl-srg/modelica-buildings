within Buildings.BoundaryConditions.SkyTemperature;
block BlackBody "Calculate black body sky temperature"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
// fixme: why is calTSky by default set to 0? Shouldn't it be left empty?
// Is the room model using calTSky=1, since TSky is used for the long-wave radiation exchange,
// and hence should not depend on the horizontal (short-wave) irradiation
  parameter Integer calTSky(min=0, max=1)=0 " 0: Use radHor; 1: Use TDry, TDewPoi and nOpa";
  Modelica.Blocks.Interfaces.RealInput TDryBul(
    final quantity="Temperature",
    final unit="K",
    displayUnit="degC") "Dry bulb temperature at ground level"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TDewPoi(
    final quantity="Temperature",
    final unit="K",
    displayUnit="degC") "Dew point temperature"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput nOpa "Opaque sky cover"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealOutput TBlaSky(
    final quantity="Temperature",
    displayUnit="degC",
    final unit="K") "Black-body sky temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput radHor "Horizontal radiation"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
protected
  Modelica.SIunits.Temperature TDewPoiK;
  Real epsSky;
  Real nOpa10;
algorithm
  if calTSky == 1 then
    TBlaSky := (radHor/Modelica.Constants.sigma)^0.25;
  else
    TDewPoiK := min(TDryBul, TDewPoi); // fixme: use smoothMin
    nOpa10 := 10*nOpa
      "Input nOpa is scaled to [0,1] instead of [0,10] in formula";
    epsSky := (0.787 + 0.764*Modelica.Math.log(-TDewPoiK/Modelica.Constants.T_zero))*(1 + 0.0224*nOpa10 -
      0.0035*(nOpa10^2) + 0.00028*(nOpa10^3));
    TBlaSky := TDryBul*(epsSky^0.25);
  end if;
  annotation (
    defaultComponentName="TBlaSky",
    Documentation(info="<HTML>
<p>
This component computes the black-body sky temperature.
</p>
<p>
For <code>calTSky = 0</code>, the model uses horizontal irradiation. 
Otherwise, it uses dry buld temperature, dew point temperature and opaque sky cover.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
June 1, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
                    graphics),
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
          textString="radHor"),
        Text(
          extent={{16,-6},{54,-28}},
          lineColor={0,0,255},
          textString="bs"),
        Text(
          extent={{-88,-24},{-64,-36}},
          lineColor={0,0,127},
          textString="nOpa")}));
end BlackBody;
