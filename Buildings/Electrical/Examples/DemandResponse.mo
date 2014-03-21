within Buildings.Electrical.Examples;
model DemandResponse
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Power P1 = 85000
    "Nominal power consumption building 1";
  parameter Modelica.SIunits.Power P2 = 65000
    "Nominal power consumption building 2";
  parameter Modelica.SIunits.Power P3 = 40000
    "Nominal power consumption building 3";
  parameter Modelica.SIunits.Energy Ebatt = 0.5*(P1+P2+P3)*2*3600
    "Storage capacity for the battery";
  AC.OnePhase.Sources.FixedVoltage grid(
    f=60,
    Phi=0,
    V=45000)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  AC.OnePhase.Conversion.ACACTransformer acac(
    Vlow=15000,
    Vhigh=45000,
    XoverR=8,
    Zperc=0.02,
    VAbase=2.0*(P1 + P2 + P3))
    annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));
  BaseClasses.Cable line1(V_nominal=480, l=80)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  BaseClasses.Cable line2(V_nominal=480, l=50)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BaseClasses.Cable line3(V_nominal=480, l=75)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  BaseClasses.Building building(
    A=1000,
    startTime=0,
    P_nominal=P1)    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-36,30})));
  BaseClasses.Building building1(
    P_nominal=P2,
    startTime=-3600,
    A=800) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-6,30})));
  BaseClasses.Building building2(
    startTime=-1800,
    P_nominal=P3,
    A=1000)
           annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={24,30})));
  AC.OnePhase.Conversion.ACDCConverter acdc(conversionFactor=600/15000, eta=0.9)
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  DC.Storage.Battery battery(EMax=Ebatt, SOC_start=0.5)
    annotation (Placement(transformation(extent={{76,-10},{96,10}})));
  Modelica.Blocks.Sources.RealExpression SolarRadiation(y=600*sin(2*Modelica.Constants.pi
        *time/(2*24*3600))^8)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
equation
  connect(grid.terminal, acac.terminal_n)            annotation (Line(
      points={{-80,0},{-72,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(acac.terminal_p, line1.p)            annotation (Line(
      points={{-52,0},{-40,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.n, line2.p) annotation (Line(
      points={{-20,6.66134e-16},{-16,6.66134e-16},{-16,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.n, line3.p) annotation (Line(
      points={{10,6.66134e-16},{16,6.66134e-16},{16,0},{20,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(building.node, line1.n) annotation (Line(
      points={{-26.2,30},{-20,30},{-20,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(building1.node, line3.p) annotation (Line(
      points={{3.8,30},{10,30},{10,0},{20,0},{20,5.55112e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(building2.node, line3.n) annotation (Line(
      points={{33.8,30},{40,30},{40,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(acdc.terminal_n, line3.n) annotation (Line(
      points={{46,0},{40,0},{40,5.55112e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(acdc.terminal_p, battery.terminal) annotation (Line(
      points={{66,0},{76,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SolarRadiation.y, building.G) annotation (Line(
      points={{-59,70},{-52,70},{-52,34},{-44,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SolarRadiation.y, building1.G) annotation (Line(
      points={{-59,70},{-20,70},{-20,34},{-14,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SolarRadiation.y, building2.G) annotation (Line(
      points={{-59,70},{8,70},{8,34},{16,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, battery.P) annotation (Line(
      points={{61,80},{86,80},{86,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end DemandResponse;
