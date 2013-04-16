within Districts.Examples;
model DataCenterRenewables
  "Model of a data center connected to renewable energy generation"
  extends Modelica.Icons.Example;
  BaseClasses.DataCenterContinuousTimeControl dataCenterContinuousTimeControl
    annotation (Placement(transformation(extent={{-150,-102},{-130,-82}})));
  Electrical.DC.Sources.WindTurbine           winTur(scale=200e3, h=50)
    "Wind turbines"
    annotation (Placement(transformation(extent={{-20,10},{-40,30}})));
  Electrical.DC.Sources.PVSimple     pv(A=200e3/800/0.12) "PV array"
    annotation (Placement(transformation(extent={{-22,50},{-42,70}})));
  Electrical.DC.Storage.Battery     bat(EMax=500e3*4*3600) "Battery"
    annotation (Placement(transformation(extent={{0,-42},{-20,-22}})));
  Electrical.AC.Conversion.ACDCConverter                          conv(
      conversionFactor=480/480, eta=0.9) "AC/DC converter"
    annotation (Placement(transformation(extent={{70,10},{50,30}})));
  Electrical.AC.Sources.Grid                          gri(
    f=60,
    V=480,
    phi=0) annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Electrical.AC.Loads.VariableInductorResistor                          varResAC(P_nominal=
       1) "Resistor and inductor to model AC load"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-88})));
  Modelica.Electrical.Analog.Basic.Ground groDC
    annotation (Placement(transformation(extent={{28,-14},{48,6}})));
  Districts.BoundaryConditions.WeatherData.Bus
    weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-90,-128},{-70,-108}})));
  Electrical.DC.Loads.VariableConductor     varResDC
    "Resistor to model DC load"
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));
  BaseClasses.BatteryControl con "Battery controller"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez           HDifTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-160,58},{-140,78}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface           HDirTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-160,18},{-140,38}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Electrical.DC.Interfaces.DCplug dCplug1
    annotation (Placement(transformation(extent={{28,10},{48,30}})));
equation
  connect(dataCenterContinuousTimeControl.PAC, varResAC.y)
    annotation (Line(
      points={{-129,-88},{40,-88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dataCenterContinuousTimeControl.weaBus, weaBus) annotation (Line(
      points={{-172.2,-100.8},{-172,-118},{-80,-118}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.winSpe, winTur.vWin)            annotation (Line(
      points={{-80,-118},{-80,40},{-30,40},{-30,32}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(bat.SOC, con.SOC) annotation (Line(
      points={{-21,-26},{-64,-26},{-64,-10},{-52,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, bat.P) annotation (Line(
      points={{-29,-10},{-10,-10},{-10,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.H,G. u1) annotation (Line(
      points={{-139,68},{-132,68},{-132,56},{-122,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H,G. u2) annotation (Line(
      points={{-139,28},{-132,28},{-132,44},{-122,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.weaBus, dataCenterContinuousTimeControl.weaBus) annotation (
      Line(
      points={{-160,28},{-172.2,28},{-172.2,-100.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDifTil.weaBus, dataCenterContinuousTimeControl.weaBus) annotation (
      Line(
      points={{-160,68},{-172,68},{-172,-100.8},{-172.2,-100.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(G.y, pv.G) annotation (Line(
      points={{-99,50},{-90,50},{-90,80},{-32,80},{-32,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gri.sPhasePlug, conv.plug1) annotation (Line(
      points={{109.9,60},{110,60},{110,20},{70,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(varResAC.sPhasePlug, gri.sPhasePlug) annotation (Line(
      points={{60,-88},{109.9,-88},{109.9,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conv.dCplug, dCplug1) annotation (Line(
      points={{50,20},{38,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(groDC.p, dCplug1.n) annotation (Line(
      points={{38,6},{38,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dataCenterContinuousTimeControl.PDC, varResDC.P) annotation (Line(
      points={{-129,-96},{-68,-96},{-68,-40},{-8,-40},{-8,-52},{-18,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pv.dcPlug, conv.dCplug) annotation (Line(
      points={{-22,60},{10,60},{10,20},{50,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(winTur.dcPlug, conv.dCplug) annotation (Line(
      points={{-20,20},{50,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bat.dcPlug, conv.dCplug) annotation (Line(
      points={{0,-32},{10,-32},{10,20},{50,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varResDC.dcPlug, conv.dCplug) annotation (Line(
      points={{-20,-60},{10,-60},{10,20},{50,20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-180,-160},{140,100}},
          preserveAspectRatio=false), graphics), Icon(coordinateSystem(extent={{-180,
            -160},{140,100}})),
    experiment(
      StopTime=604800,
      Tolerance=1e-05,
      __Dymola_Algorithm="Radau"),
    __Dymola_experimentSetupOutput,
    Commands(file=
          "Resources/Scripts/Dymola/Examples/DataCenterRenewables.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
January 10, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model illustrates a data center with DC and AC load.
The electrical supply is from a grid, from wind turbines and from PV.
The battery is charged during the night and discharged during
the day in such a way that it is fully charged and discharged.
This control logic is implemented using a finite state machine
inside the model <code>con</code>.
</p>
</html>"));
end DataCenterRenewables;
