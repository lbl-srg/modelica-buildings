within Buildings.Templates.Components.Validation;
model BoilerHotWater "Test model for the hot water boiler model"
  extends Buildings.Templates.Components.Validation.BoilerHotWaterRecord;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  parameter Buildings.Templates.Components.Data.BoilerHotWater datBoiPol(
    final typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    mHeaWat_flow_nominal=datBoiTab.cap_nominal/15/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    cap_nominal=1000E3,
    dpHeaWat_nominal(displayUnit="Pa") = 5000,
    THeaWatSup_nominal=333.15)
    "Design and operating parameters for the boiler model using a polynomial"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Templates.Components.Boilers.HotWaterTable boiTab(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final dat=datBoiTabRed,
    is_con=false)
    "Boiler model with efficiency described by a table"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Sources.Boundary_pT retHeaWat(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_min + boiTab.dpHeaWat_nominal,
    use_T_in=true,
    T=datBoiTab.THeaWatSup_nominal - 15,
    nPorts=2) "Boundary conditions for HW distribution system"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Fluid.Sources.Boundary_pT supHeaWat(redeclare final package Medium =Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_min,
    nPorts=2)
    "Boundary conditions for HW distribution system"
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(redeclare final package Medium =
        Medium, final m_flow_nominal=datBoiTab.mHeaWat_flow_nominal)
    "HW supply temperature"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp THeaWatRet(
    y(final unit="K", displayUnit="degC"),
    height=35,
    duration=500,
    offset=datBoiTab.THeaWatSup_nominal - 25,
    startTime=100) "HW return temperature value"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Boi(
    table=[0,1; 1,1],
    timeScale=3600,
    period=3600) "Boiler Enable signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Templates.HeatingPlants.HotWater.Interfaces.Bus bus
    "Boiler control bus"
    annotation (
      Placement(transformation(extent={{-20,20},{20,60}}), iconTransformation(
          extent={{-296,-74},{-256,-34}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(
    k=Buildings.Templates.Data.Defaults.THeaWatSup,
    y(final unit="K", displayUnit="degC"))
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Boilers.HotWaterPolynomial boiPol(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final dat=datBoiPol,
    is_con=false)
    "Boiler model with efficiency described by a polynomial"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup1(
    redeclare final package Medium =Medium,
    final m_flow_nominal=datBoiTab.mHeaWat_flow_nominal)
    "HW supply temperature"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  HeatingPlants.HotWater.Interfaces.Bus bus1
    "Boiler control bus"
    annotation (
      Placement(transformation(extent={{-20,-60},{20,-20}}),
      iconTransformation(extent={{-296,-74},{-256,-34}})));
equation
  connect(retHeaWat.ports[1], boiTab.port_a) annotation (Line(points={{-20,-21},
          {-20,0},{-10,0}},         color={0,127,255}));
  connect(boiTab.port_b, THeaWatSup.port_a)
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  connect(THeaWatSup.port_b, supHeaWat.ports[1])
    annotation (Line(points={{50,0},{60,0},{60,-21},{70,-21}},
                                             color={0,127,255}));
  connect(THeaWatRet.y, retHeaWat.T_in) annotation (Line(points={{-58,0},{-50,0},
          {-50,-16},{-42,-16}},
                            color={0,0,127}));
  connect(boiTab.bus, bus) annotation (Line(
      points={{0,10},{0,10},{0,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(y1Boi.y[1], bus.y1) annotation (Line(points={{-58,80},{0,80},{0,40}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(THeaWatSupSet.y, bus.THeaWatSupSet)
    annotation (Line(points={{-58,40},{0,40}}, color={0,0,127}));
  connect(retHeaWat.ports[2], boiPol.port_a)
    annotation (Line(points={{-20,-19},{-20,-80},{-10,-80}},
                                                           color={0,127,255}));
  connect(THeaWatSup1.port_b, supHeaWat.ports[2]) annotation (Line(points={{50,-80},
          {60,-80},{60,-19},{70,-19}},
                                   color={0,127,255}));
  connect(boiPol.port_b, THeaWatSup1.port_a)
    annotation (Line(points={{10,-80},{30,-80}}, color={0,127,255}));
  connect(bus1, boiPol.bus) annotation (Line(
      points={{0,-40},{0,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaWatSupSet.y, bus1.THeaWatSupSet) annotation (Line(points={{-58,40},
          {-50,40},{-50,-38},{0,-38},{0,-40}},
                                       color={0,0,127}));
  connect(y1Boi.y[1], bus1.y1) annotation (Line(points={{-58,80},{-52,80},{-52,-40},
          {0,-40}}, color={255,0,255}));
  annotation (
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/BoilerHotWater.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the parameter propagation within the record class
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup\">
Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup</a>.
It illustrates
</p>
<ul>
<li>
the manual propagation of the nominal value of the condenser cooling
fluid temperature <code>TConEnt_nominal</code>
when redeclaring the performance data record <code>per</code>,
</li>
<li>
how the original bindings for other design parameters such as the
CHW and CW flow rates persist when redeclaring the performance data record,
</li>
<li>
how to overwrite such persistent bindings if the nominal conditions
used to assess the performance data differ from the design conditions:
see the parameter binding for <code>QEva_flow_nominal</code>,
</li>
<li>
how different performance curves may be assigned to each chiller
inside the same group.
</li>
</ul>
</html>"));
end BoilerHotWater;
