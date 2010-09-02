within Buildings.BoundaryConditions.SkyTemperature;
block BlackBodySkyTemperature
  "Black body sky temperature with input of simulation time"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Modelica.Blocks.Interfaces.RealOutput y(
    quantity="ThermodynamicTemperature",
    displayUnit="degC",
    unit="K") "Black-body sky temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Utilities.IO.WeatherData.WeatherBus weaBus "Weather data bus" annotation (
      Placement(transformation(extent={{-90,-10},{-70,10}})));

protected
  BaseClasses.BlackBodySkyTemperature TBlaSky
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  BaseClasses.DiurnalCorrection_t diuCor_t
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  BaseClasses.ClearSkyEmissivity skyEmi
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  BaseClasses.ElevationCorrection eleCor
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  BaseClasses.BaseEmissivity basEmi
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  BaseClasses.InfraredCloudAmount infClo
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
equation

  connect(eleCor.eleCor, skyEmi.eleCor) annotation (Line(
      points={{1,-20},{8,-20},{8,6.66134e-16},{18,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyEmi.diuCor, diuCor_t.y) annotation (Line(
      points={{18,-6},{12,-6},{12,-60},{-59,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(basEmi.basEmi, skyEmi.basEmi) annotation (Line(
      points={{1,20},{12,20},{12,6},{18,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyEmi.skyEmi, TBlaSky.cleSkyEmi) annotation (Line(
      points={{41,6.10623e-16},{50,6.10623e-16},{50,54},{58,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(infClo.infCloAmo, TBlaSky.infCloAmo) annotation (Line(
      points={{1,60},{58,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBlaSky.TBlaSky, y) annotation (Line(
      points={{81,60},{90,60},{90,0},{100,0},{100,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(weaBus.nTol, infClo.nTol) annotation (Line(
      points={{-80,5.55112e-16},{-64,5.55112e-16},{-64,66},{-22,66}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.celHei, infClo.celHei) annotation (Line(
      points={{-80,5.55112e-16},{-64,5.55112e-16},{-64,60},{-22,60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.nOpa, infClo.nOpa) annotation (Line(
      points={{-80,5.55112e-16},{-64,5.55112e-16},{-64,54},{-22,54}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.pAtm, eleCor.p) annotation (Line(
      points={{-80,5.55112e-16},{-64,5.55112e-16},{-64,-20},{-22,-20}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, TBlaSky.TDry) annotation (Line(
      points={{-80,5.55112e-16},{-64,5.55112e-16},{-64,40},{20,40},{20,66},{58,
          66}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDew, basEmi.TDew) annotation (Line(
      points={{-80,5.55112e-16},{-52,5.55112e-16},{-52,20},{-22,20}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.cloTim, diuCor_t.cloTim) annotation (Line(
      points={{-80,5.55112e-16},{-80,-30},{-92,-30},{-92,-60},{-82,-60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    defaultComponentName="TBlaSky",
    Documentation(info="<HTML>
<p>
This component computes the black-body sky temperature.
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
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={Text(
          extent={{-54,52},{56,-34}},
          lineColor={0,0,127},
          textString="T (t)"), Text(
          extent={{-26,-4},{2,-20}},
          lineColor={0,0,127},
          textString="bs")}));
end BlackBodySkyTemperature;
