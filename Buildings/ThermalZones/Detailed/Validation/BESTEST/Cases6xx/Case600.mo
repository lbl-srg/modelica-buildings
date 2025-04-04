within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case600 "Case 600FF, but with dual-setpoint for heating and cooling"
  extends Case600FF(
    redeclare Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.StandardResults staRes(
      annualHea(
        Min=3.993*3.6e9,
        Max=4.504*3.6e9,
        Mean=4.213*3.6e9),
      annualCoo(
        Min=-5.432*3.6e9,
        Max=-6.162*3.6e9,
        Mean=-5.856*3.6e9),
    peakHea(Min=3.020*1000, Max=3.359*1000, Mean=3.184*1000),
    peakCoo(Min=-5.422*1000, Max=-6.481*1000, Mean=-6.024*1000)));
  replaceable parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.CriteriaLimits
      heaCri(lowerLimit=3.75*3.6e9, upperLimit=4.98*3.6e9)
    "Annual heating load limits of the test acceptance criteria from ASHRAE/ANSI Standard 140"
    annotation (Placement(transformation(extent={{-96,82},{-82,96}})));
  replaceable parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.CriteriaLimits
      cooCri(lowerLimit=-5*3.6e9, upperLimit=-6.83*3.6e9)
    "Annual cooling load limits of the test acceptance criteria from ASHRAE/ANSI Standard 140"
    annotation (Placement(transformation(extent={{-96,62},{-82,76}})));
  Buildings.Controls.OBC.CDL.Reals.PID conHea(
    k=0.1,
    Ti=300,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Controller for heating"
    annotation (Placement(transformation(extent={{-72,30},{-64,38}})));
  Buildings.Controls.OBC.CDL.Reals.PID conCoo(
    k=0.1,
    Ti=300,
    reverseActing=false,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Controller for cooling"
    annotation (Placement(transformation(extent={{-72,8},{-64,16}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiHea(k=1E6)
    "Gain for heating"
    annotation (Placement(transformation(extent={{-58,30},{-50,38}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiCoo(k=-1E6)
    "Gain for cooling"
    annotation (Placement(transformation(extent={{-58,8},{-50,16}})));
  Modelica.Blocks.Math.Sum sumHeaCoo(nin=2)
    "Sum of heating and cooling heat flow rate"
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
  replaceable BaseClasses.DaySchedule TSetHea(table=[0.0,273.15 + 20])
    "Heating setpoint"
    annotation (Placement(transformation(extent={{-92,30},{-84,38}})));
  replaceable BaseClasses.DaySchedule TSetCoo(table=[0.0,273.15 + 27])
    "Cooling setpoint"
    annotation (Placement(transformation(extent={{-92,8},{-84,16}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage PHea(delta=3600)
    "Hourly averaged heating power"
    annotation (Placement(transformation(extent={{-20,48},{-12,56}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage PCoo(delta=3600)
    "Hourly averaged cooling power"
    annotation (Placement(transformation(extent={{-20,-8},{-12,0}})));
  Modelica.Blocks.Sources.RealExpression hGloHor(
    y(final unit="W/m2")=weaDat.weaBus.HGloHor)
    "Global horizontal solar irradiance"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Continuous.Integrator gloHor(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(final unit="W/m2"),
    y(final unit="J/m2"))
    "Annual global horizontal solar irradiance"
    annotation (Placement(transformation(extent={{74,26},{82,34}})));
  Modelica.Blocks.Continuous.Integrator gloSou(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(final unit="W/m2"),
    y(final unit="J/m2"))
    "Annual south global solar irradiance"
    annotation (Placement(transformation(extent={{80,2},{88,10}})));
  Modelica.Blocks.Continuous.Integrator traSol(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(final unit="W"),
    y(final unit="J"))
    "Annual transmitted solar irradiance"
    annotation (Placement(transformation(extent={{88,-12},{96,-4}})));
  Modelica.Blocks.Sources.RealExpression TSkyTem(
    y(final unit="K", displayUnit="degC")=weaDat.weaBus.TBlaSky)
    "Black body sky temperature"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage TSkyTemHou(
    delta=3600,
    u(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC"))
    "Hourly averaged sky temperature"
    annotation (Placement(transformation(extent={{88,-48},{96,-40}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage TSkyTemAnn(
    delta=86400*365,
    u(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC"))
    "Annual averaged sky temperature"
    annotation (Placement(transformation(extent={{88,-60},{96,-52}})));
equation
  connect(TRooAir.T,conHea. u_m) annotation (Line(
      points={{1.5,-15},{-80,-15},{-80,24},{-68,24},{-68,29.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_m, TRooAir.T)  annotation (Line(
      points={{-68,7.2},{-68,-15},{1.5,-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.y,gaiHea. u) annotation (Line(
      points={{-63.2,34},{-58.8,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.y,gaiCoo. u)  annotation (Line(
      points={{-63.2,12},{-58.8,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gaiHea.y,multiplex2. u1[1]) annotation (Line(
      points={{-49.2,34},{-42,34},{-42,26.4},{-36.8,26.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gaiCoo.y,multiplex2. u2[1]) annotation (Line(
      points={{-49.2,12},{-42,12},{-42,21.6},{-36.8,21.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex2.y, sumHeaCoo.u) annotation (Line(
      points={{-27.6,24},{-20.8,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sumHeaCoo.y, preHea.Q_flow) annotation (Line(
      points={{-11.6,24},{-6,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(EHea.u,gaiHea. y) annotation (Line(
      points={{-20.8,40},{-32,40},{-32,34},{-49.2,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ECoo.u,gaiCoo. y) annotation (Line(
      points={{-20.8,10},{-34,10},{-34,12},{-49.2,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetHea.y[1],conHea. u_s) annotation (Line(
      points={{-83.2,34},{-72.8,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetCoo.y[1],conCoo. u_s) annotation (Line(
      points={{-83.2,12},{-72.8,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCoo.u,gaiCoo. y) annotation (Line(
      points={{-20.8,-4},{-42,-4},{-42,12},{-49.2,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PHea.u,gaiHea. y) annotation (Line(
      points={{-20.8,52},{-42,52},{-42,34},{-49.2,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHea.port, roo.heaPorAir) annotation (Line(
      points={{6,24},{16,24},{16,-15},{50.25,-15}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hGloHor.y, gloHor.u)
    annotation (Line(points={{61,30},{73.2,30}}, color={0,0,127}));
  connect(TSkyTem.y, TSkyTemHou.u) annotation (Line(points={{61,-50},{70,-50},{70,
          -44},{87.2,-44}}, color={0,0,127}));
  connect(TSkyTem.y, TSkyTemAnn.u) annotation (Line(points={{61,-50},{70,-50},{70,
          -56},{87.2,-56}}, color={0,0,127}));
  connect(roo.QTraGlo[1], traSol.u) annotation (Line(points={{67.5,-25.5},{78,-25.5},
          {78,-8},{87.2,-8}}, color={0,0,127}));
  connect(roo.HGlo[1], gloSou.u) annotation (Line(points={{67.5,-22.5},{72,-22.5},
          {72,6},{79.2,6}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case600.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(revisions="<html>
<ul>
<li>
May 12, 2023, by Jianjun Hu:<br/>
Added test acceptance criteria limits.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3396\">issue 3396</a>.
</li>    
<li>
April 8, 2020, by Michael Wetter:<br/>
Removed <code>initType</code> in PID controller.
</li>
<li>
January 21, 2020, by Michael Wetter:<br/>
Changed calculation of time averaged values to use
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.MovingMean\">
Buildings.Controls.OBC.CDL.Reals.MovingMean</a>
because this does not trigger a time event every hour.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1714\">issue 1714</a>.
</li>
<li>
July 15, 2012, by Michael Wetter:<br/>
Changed computation of power to use hourly averaged power
instead of instantaneous power in order to avoid peaks
after set point changes.
This is required because the Modelica model is solved using a
continuous time solver, whereas the BESTEST reference results
were obtained using simulators with discrete time steps.
Changed base class to be
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF\">
Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF</a>.
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
