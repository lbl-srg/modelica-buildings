within Buildings.Examples.ChillerPlant;
model DataCenterRenewables
  "Model of a data center connected to renewable energy generation"
  extends Modelica.Icons.Example;
  BaseClasses.DataCenterContinuousTimeControl dataCenterContinuousTimeControl
    annotation (Placement(transformation(extent={{-66,-60},{-46,-40}})));
  Buildings.Electrical.DC.Sources.WindTurbine winTur(
    scale=200e3,
    h=50,
    V_nominal=480) "Wind turbines"
    annotation (Placement(transformation(extent={{-20,10},{-40,30}})));
  Electrical.DC.Sources.PVSimpleOriented pv(
    A=200e3/800/0.12,
    til=0.34906585039887,
    azi=-0.78539816339745,
    V_nominal=480) "PV array"
    annotation (Placement(transformation(extent={{-22,50},{-42,70}})));
  Buildings.Electrical.DC.Storage.Battery bat(
    EMax=500e3*4*3600,
    V_nominal=480) "Battery"
    annotation (Placement(transformation(extent={{0,-42},{-20,-22}})));
  Buildings.Electrical.AC.OnePhase.Conversion.ACDCConverter conv(
    conversionFactor=480/480,
    eta=0.9) "AC/DC converter"
    annotation (Placement(transformation(extent={{40,10},{20,30}})));
  Buildings.Electrical.AC.OnePhase.Sources.Grid gri(
    f=60,
    V=480,
    phiSou=0) annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.BoundaryConditions.WeatherData.Bus
    weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  BaseClasses.Controls.BatteryControl con "Battery controller"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  Buildings.Electrical.DC.Loads.Conductor dcLoad(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=480)
    annotation (Placement(transformation(extent={{0,-70},{-20,-50}})));
  Buildings.Electrical.AC.OnePhase.Loads.Inductive acLoad(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=480)
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));
equation
  connect(dataCenterContinuousTimeControl.weaBus, weaBus) annotation (Line(
      points={{-88.2,-58.8},{-88.2,40},{-60,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.winSpe, winTur.vWin)            annotation (Line(
      points={{-60,40},{-30,40},{-30,32}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(bat.SOC, con.SOC) annotation (Line(
      points={{-21,-26},{-64,-26},{-64,-10},{-51.25,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, bat.P) annotation (Line(
      points={{-29.375,-10},{-10,-10},{-10,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dataCenterContinuousTimeControl.PDC, dcLoad.Pow) annotation (Line(
      points={{-45,-53},{-40,-53},{-40,-60},{-20,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pv.terminal, conv.terminal_p) annotation (Line(
      points={{-22,60},{14,60},{14,20},{20,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(winTur.terminal, conv.terminal_p) annotation (Line(
      points={{-20,20},{20,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bat.terminal, conv.terminal_p) annotation (Line(
      points={{4.44089e-16,-32},{14,-32},{14,20},{20,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dcLoad.terminal, conv.terminal_p) annotation (Line(
      points={{4.44089e-16,-60},{14,-60},{14,20},{20,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dataCenterContinuousTimeControl.PAC, acLoad.Pow) annotation (Line(
      points={{-45,-45},{-40,-45},{-40,-40},{20,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(acLoad.terminal, gri.terminal) annotation (Line(
      points={{40,-40},{70,-40},{70,60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conv.terminal_n, gri.terminal) annotation (Line(
      points={{40,20},{70,20},{70,60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(dataCenterContinuousTimeControl.weaBus, pv.weaBus) annotation (Line(
      points={{-88.2,-58.8},{-88.2,80},{-32,80},{-32,69}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (    experiment(
      StopTime=604800,
      Tolerance=1e-6),
      __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/DataCenterRenewables.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed assignment of parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
July 7, 2015, by Michael Wetter:<br/>
Set missing nominal voltages.
</li>
<li>
January 10, 2013, by Michael Wetter:<br/>
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
