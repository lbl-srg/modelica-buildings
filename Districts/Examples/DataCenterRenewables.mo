within Districts.Examples;
model DataCenterRenewables
  "Model of a data center connected to renewable energy generation"
  extends Modelica.Icons.Example;
  BaseClasses.DataCenterContinuousTimeControl dataCenterContinuousTimeControl
    annotation (Placement(transformation(extent={{-150,-102},{-130,-82}})));
  Electrical.DC.Sources.WindTurbine           winTur(scale=200e3, h=50)
    "Wind turbines"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Electrical.DC.Sources.PVSimple     pv(A=200e3/800/0.12) "PV array"
    annotation (Placement(transformation(extent={{-42,50},{-22,70}})));
  Electrical.DC.Storage.Battery     bat(EMax=500e3*4*3600) "Battery"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
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
        origin={94,-10})));
  Modelica.Electrical.Analog.Basic.Ground groDC
    annotation (Placement(transformation(extent={{10,-120},{30,-100}})));
  Districts.BoundaryConditions.WeatherData.Bus
    weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-90,-128},{-70,-108}})));
  Electrical.DC.Loads.VariableConductor     varResDC
    "Resistor to model DC load"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  BaseClasses.BatteryControl con "Battery controller"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
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
equation
  connect(dataCenterContinuousTimeControl.PAC, varResAC.y)
    annotation (Line(
      points={{-129,-88},{60,-88},{60,-10},{84,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pv.p, winTur.p)                  annotation (Line(
      points={{-42,60},{-68,60},{-68,20},{-40,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pv.p, bat.p)           annotation (Line(
      points={{-42,60},{-68,60},{-68,-40},{-20,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(groDC.p, conv.pin_nDC)  annotation (Line(
      points={{20,-100},{20,10},{50,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bat.n, conv.pin_nDC)     annotation (Line(
      points={{4.44089e-16,-40},{20,-40},{20,10},{50,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(winTur.n, conv.pin_nDC)            annotation (Line(
      points={{-20,20},{20,20},{20,10},{50,10}},
      color={0,0,255},
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
  connect(bat.p, varResDC.p)             annotation (Line(
      points={{-20,-40},{-68,-40},{-68,-80},{-40,-80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varResDC.n, conv.pin_nDC)         annotation (Line(
      points={{-20,-80},{20,-80},{20,10},{50,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dataCenterContinuousTimeControl.PDC, varResDC.P)         annotation (
      Line(
      points={{-129,-96},{-100,-96},{-100,-72},{-42,-72}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(bat.SOC, con.SOC) annotation (Line(
      points={{1,-34},{10,-34},{10,0},{-60,0},{-60,-20},{-52,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, bat.P) annotation (Line(
      points={{-29,-20},{-10,-20},{-10,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pv.n, conv.pin_nDC)       annotation (Line(
      points={{-22,60},{20,60},{20,10},{50,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conv.pin_pDC, pv.p)       annotation (Line(
      points={{50,30},{40,30},{40,90},{-68,90},{-68,60},{-42,60}},
      color={0,0,255},
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
      points={{104,-10},{109.9,-10},{109.9,60}},
      color={0,0,0},
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
