within Buildings.ThermalZones.Detailed.Validation.BESTEST;
model Case600 "Case 600FF, but with dual-setpoint for heating and cooling"
  extends Case600FF(
    redeclare Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.StandardResults staRes(
    annualHea(Min=4.296*3.6e9, Max=5.709*3.6e9, Mean=5.090*3.6e9),
    annualCoo(Min=-6.137*3.6e9, Max=-7.964*3.6e9, Mean=-6.832*3.6e9),
    peakHea(Min=3.437*1000, Max=4.354*1000, Mean=4.000*1000),
    peakCoo(Min=-5.965*1000, Max=-6.827*1000, Mean=-6.461*1000)));
  Controls.Continuous.LimPID           conHea(
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    Ti=300,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1) "Controller for heating"
    annotation (Placement(transformation(extent={{-72,30},{-64,38}})));
  Controls.Continuous.LimPID           conCoo(
    Td=60,
    reverseAction=true,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    Ti=300,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1) "Controller for cooling"
    annotation (Placement(transformation(extent={{-72,8},{-64,16}})));
  Modelica.Blocks.Math.Gain gaiHea(k=1E6) "Gain for heating"
    annotation (Placement(transformation(extent={{-58,30},{-50,38}})));
  Modelica.Blocks.Math.Gain gaiCoo(k=-1E6) "Gain for cooling"
    annotation (Placement(transformation(extent={{-58,8},{-50,16}})));
  Modelica.Blocks.Math.Sum sum1(nin=2)
    annotation (Placement(transformation(extent={{-20,20},{-12,28}})));
  Modelica.Blocks.Routing.Multiplex2 multiplex2
    annotation (Placement(transformation(extent={{-36,20},{-28,28}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow for heating and cooling"
    annotation (Placement(transformation(extent={{-6,18},{6,30}})));
  Modelica.Blocks.Continuous.Integrator EHea(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(unit="W"),
    y(unit="J")) "Heating energy in Joules"
    annotation (Placement(transformation(extent={{-20,36},{-12,44}})));
  Modelica.Blocks.Continuous.Integrator ECoo(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(unit="W"),
    y(unit="J")) "Cooling energy in Joules"
    annotation (Placement(transformation(extent={{-20,6},{-12,14}})));
  BaseClasses.DaySchedule TSetHea(table=[0.0,273.15 + 20]) "Heating setpoint"
    annotation (Placement(transformation(extent={{-92,30},{-84,38}})));
  BaseClasses.DaySchedule TSetCoo(table=[0.0,273.15 + 27]) "Cooling setpoint"
    annotation (Placement(transformation(extent={{-92,8},{-84,16}})));
  Modelica.Blocks.Math.Mean PHea(f=1/3600) "Hourly averaged heating power"
    annotation (Placement(transformation(extent={{-20,48},{-12,56}})));
  Modelica.Blocks.Math.Mean PCoo(f=1/3600) "Hourly averaged cooling power"
    annotation (Placement(transformation(extent={{-20,-8},{-12,0}})));
equation
  connect(TRooAir.T,conHea. u_m) annotation (Line(
      points={{-78,-24},{-78,24},{-68,24},{-68,29.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_m, TRooAir.T)  annotation (Line(
      points={{-68,7.2},{-68,0},{-78,0},{-78,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.y,gaiHea. u) annotation (Line(
      points={{-63.6,34},{-58.8,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.y,gaiCoo. u)  annotation (Line(
      points={{-63.6,12},{-58.8,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gaiHea.y,multiplex2. u1[1]) annotation (Line(
      points={{-49.6,34},{-42,34},{-42,26.4},{-36.8,26.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gaiCoo.y,multiplex2. u2[1]) annotation (Line(
      points={{-49.6,12},{-42,12},{-42,21.6},{-36.8,21.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex2.y,sum1. u) annotation (Line(
      points={{-27.6,24},{-20.8,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sum1.y,preHea. Q_flow) annotation (Line(
      points={{-11.6,24},{-6,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(EHea.u,gaiHea. y) annotation (Line(
      points={{-20.8,40},{-32,40},{-32,34},{-49.6,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ECoo.u,gaiCoo. y) annotation (Line(
      points={{-20.8,10},{-34,10},{-34,12},{-49.6,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetHea.y[1],conHea. u_s) annotation (Line(
      points={{-83.6,34},{-72.8,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetCoo.y[1],conCoo. u_s) annotation (Line(
      points={{-83.6,12},{-72.8,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCoo.u,gaiCoo. y) annotation (Line(
      points={{-20.8,-4},{-42,-4},{-42,12},{-49.6,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PHea.u,gaiHea. y) annotation (Line(
      points={{-20.8,52},{-42,52},{-42,34},{-49.6,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHea.port, roo.heaPorAir) annotation (Line(
      points={{6,24},{12,24},{12,-15},{50.25,-15}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Case600.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-006),
    Documentation(revisions="<html>
<ul>
<li>
July 15, 2012, by Michael Wetter:<br/>
Changed computation of power to use hourly averaged power
instead of instantaneous power in order to avoid peaks
after set point changes.
This is required because the Modelica model is solved using a
continuous time solver, whereas the BESTEST reference results
were obtained using simulators with discrete time steps.
Changed base class to be
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BESTEST.Case600FF\">
Buildings.ThermalZones.Detailed.Validation.BESTEST.Case600FF</a>.

</li>
<li>
July 14, 2012, by Michael Wetter:<br/>
Changed units of integrator to use Joules instead of MWh.
</li>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is used for the basic test case 600 of the BESTEST validation suite.
Case 600 is a light-weight building with room temperature control set to
<i>20&deg;C</i> for heating and <i>27&deg;C</i> for cooling.
The room has no shade and a window that faces south.
</p>
</html>"));
end Case600;
