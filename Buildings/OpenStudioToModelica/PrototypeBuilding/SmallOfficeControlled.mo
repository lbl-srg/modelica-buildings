within Buildings.OpenStudioToModelica.PrototypeBuilding;
model SmallOfficeControlled
  extends Buildings.BaseClasses.BaseIconBuilding;
  parameter Boolean useDeltaTSP = false
    "Boolean flag that is used to select the delta Tsp signal";
  parameter Modelica.SIunits.Angle lon "Longitude of the building";
  parameter Modelica.SIunits.Angle lat "Latiture of the building";
  parameter Modelica.SIunits.Time timZon "Time zone of the building";
  parameter Modelica.SIunits.Temperature T_sp = 273.15 + 22
    "Set point temperature for the thermal zones";
  parameter Modelica.SIunits.Area A "Surface area of the PV";
  parameter Modelica.SIunits.Angle til_pv "Titl angle of the PVs";
  parameter Modelica.SIunits.Angle azi_pv "Azimuth angle of the PVs";
  parameter Real pf=0.8 "Power factor of the building load";
  parameter Modelica.SIunits.Voltage V_nominal=480
    "Nominal voltage of the electric network";
  parameter Modelica.SIunits.Power P_hvac_nominal
    "Nominal cooling/heating power of the HVAC system ";
  parameter Real COP_nominal "Coefficient of performance at nominal condition";
  parameter Real a[:]={0.3, 0.7}
    "Coefficients for efficiency curve (need p(a=a, y=1)=1)";
  parameter Modelica.SIunits.HeatFlux PPlu=15
    "Plug load per zone per unit area";
  parameter Modelica.SIunits.Power PPer=120 "Power per person";
  parameter Real nOcc=1/19 "Number of zone occupants per unit area";
  parameter Modelica.SIunits.HeatFlux PLig=14
    "Lights power per zone per unit area";
  parameter Real patternWeekPlug[24]={0.2,0.2,0.2,0.2,0.2,0.2,0.3,0.7,0.8,0.9,1.0,
      1.0,0.8,1.0,0.9,0.7,0.7,0.6,0.4,0.2,0.2,0.2,0.2,0.2}
    "Pattern for plug loads during week days (fraction of P_nominal)";
  parameter Real patternWeekendPlug[24]={0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,
      0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2}
    "Pattern for plug loads during weekend days (fraction of P_nominal)";
  parameter Real patternWeekOcc[24]={0,0,0,0,0,0.1,0.2,0.3,0.8,1.0,1.0,1.0,0.9,1.0,
      0.9,0.9,0.8,0.6,0.2,0.05,0,0,0,0}
    "Pattern for occupancy during week days (fraction of nominal occupancy)";
  parameter Real patternWeekendOcc[24]=zeros(24)
    "Pattern for occupancy during weekend days (fraction of nominal occupancy)";
  parameter Real patternWeekLight[24]={0.1,0.1,0.1,0.1,0.1,0.4,0.6,0.7,0.6,0.5,0.4,
      0.4,0.4,0.4,0.4,0.6,0.8,0.5,0.4,0.3,0.2,0.1,0.1,0.1}
    "Pattern for lights during week days (fraction of P_nominal)";
  parameter Real patternWeekendLight[24]={0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,
      0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1}
    "Pattern for lights during weekend days (fraction of P_nominal)";

  SmallOfficeBuilding bui(
    lon=lon,
    lat=lat,
    timZon=timZon,
    roomEnDyn=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Building model"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{-110,70},{-90,90}}),
        iconTransformation(extent={{-110,70},{-90,90}})));
  InternalHeatGains.FixedTemperatureIHGSchedule zonCtr[5](
    AZon = {bui.Core_ZN.AFlo,
            bui.Perimeter_ZN_3.AFlo,
            bui.Perimeter_ZN_4.AFlo,
            bui.Perimeter_ZN_2.AFlo,
            bui.Perimeter_ZN_1.AFlo},
    each PLig=PLig,
    each nOcc=nOcc,
    each PPer=PPer,
    each PPlu=PPlu,
    each patternWeekPlug=patternWeekPlug,
    each patternWeekendPlug=patternWeekendPlug,
    each patternWeekOcc=patternWeekOcc,
    each patternWeekendOcc=patternWeekendOcc,
    each patternWeekLight=patternWeekLight,
    each patternWeekendLight=patternWeekendLight)
    "Block that imposes the temperature set point in each zone"
    annotation (Placement(transformation(extent={{-60,-6},{-40,14}})));
  Modelica.Blocks.Sources.RealExpression
                                   temSp(y=T_sp + deltaTsp)
    "Temperature set point for the thermal zones"
    annotation (Placement(transformation(extent={{-92,-6},{-72,14}})));

  InternalHeatGains.ZeroInternalHeatGain noAct
    "Boundary conditions for Attic zone (not controlled)"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Electrical.AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv(
    A=A,
    til=til_pv,
    lat=lat,
    azi=azi_pv,
    V_nominal=V_nominal) "PV model"
    annotation (Placement(transformation(extent={{42,50},{22,70}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loa(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=V_nominal,
    pf=pf,
    initMode=Buildings.Electrical.Types.InitMode.zero_current)
    "Electric load representing the building"        annotation (Placement(transformation(extent={{78,-10},
            {58,10}})));
  Electrical.AC.ThreePhasesBalanced.Interfaces.Terminal_n term
    "Electric connector of the building"                                                            annotation (
      Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));
  InternalHeatGains.ElectricPowerWithCOP cooPowToElePow(
    P_hvac_nominal=P_hvac_nominal,
    COP_nominal=COP_nominal,
    a=a)
    "Function that computes the electric power from the cooling or heating power using a COP based curve"
    annotation (Placement(transformation(extent={{-6,-60},{14,-40}})));
  Modelica.Blocks.Math.Sum cooHeaLoad(nin=5)
    "Total cooling or heating load of the building"
    annotation (Placement(transformation(extent={{-32,-60},{-12,-40}})));
  Modelica.Blocks.Math.Gain inv(k=-1) "Change sign for consumed power"
    annotation (Placement(transformation(extent={{36,-8},{52,8}})));
  Modelica.Blocks.Interfaces.RealOutput PPv "Power generated by PVs"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput PHvac
    "Electric power consumed by HVAC system" annotation (Placement(
        transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent=
           {{100,-70},{120,-50}})));
  Modelica.Blocks.Math.Sum elPow(nin=5)
    "Sum of th electric power of the building"
    annotation (Placement(transformation(extent={{-32,-90},{-12,-70}})));
  Modelica.Blocks.Interfaces.RealOutput PLigPlu
    "Electric power consumed by lights and plug loads system" annotation (
      Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{18,-6},{30,6}})));
  Modelica.Blocks.Interfaces.RealInput dTSp if useDeltaTSP
    "Delta temperature set point"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
protected
  Modelica.Blocks.Interfaces.RealInput deltaTsp
    "Inner version of the delta T set point input used by the conditional connector";
equation
  connect(deltaTsp, dTSp);
  if not useDeltaTSP then
    deltaTsp = 0.0;
  end if;
  connect(bui.weaBus, weaBus) annotation (Line(
      points={{-20.3,17.7},{-20,17.7},{-20,80},{-100,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(zonCtr.roomConnector_out, bui.rooms_conn[1:5])
    annotation (Line(points={{-40,4},{-32,4},{-20,4}}, color={0,0,120}));
  connect(noAct.roomConnector_out, bui.rooms_conn[6]) annotation (Line(points={{-40,50},
          {-34,50},{-34,4.66667},{-20,4.66667}},         color={0,0,120}));
  connect(weaBus, pv.weaBus) annotation (Line(
      points={{-100,80},{32,80},{32,69}},
      color={255,204,51},
      thickness=0.5));
  connect(pv.terminal, term) annotation (Line(points={{42,60},{80,60},{80,0},{110,
          0}}, color={0,120,120}));
  connect(loa.terminal, term) annotation (Line(points={{78,0},{78,0},{110,0}},
                    color={0,120,120}));
  connect(zonCtr.Q_flow, cooHeaLoad.u)
    annotation (Line(points={{-41,-7},{-41,-50},{-34,-50}}, color={0,0,127}));
  connect(cooHeaLoad.y, cooPowToElePow.P_cool)
    annotation (Line(points={{-11,-50},{-11,-50},{-4,-50}}, color={0,0,127}));
  connect(inv.y, loa.Pow)
    annotation (Line(points={{52.8,0},{58,0}}, color={0,0,127}));
  connect(cooPowToElePow.P_el, PHvac) annotation (Line(points={{13,-50},{80,-50},
          {80,-60},{110,-60}}, color={0,0,127}));
  connect(pv.P, PPv) annotation (Line(points={{21,67},{-96,67},{-96,-96},{80,-96},
          {80,-80},{110,-80}}, color={0,0,127}));
  connect(zonCtr.PEl, elPow.u)
    annotation (Line(points={{-43,-7},{-43,-80},{-34,-80}}, color={0,0,127}));
  connect(add.y, inv.u)
    annotation (Line(points={{30.6,0},{34.4,0},{34.4,0}}, color={0,0,127}));
  connect(cooPowToElePow.P_el, add.u1) annotation (Line(points={{13,-50},{20,-50},
          {20,-28},{4,-28},{4,3.6},{16.8,3.6}}, color={0,0,127}));
  connect(elPow.y, add.u2) annotation (Line(points={{-11,-80},{24,-80},{24,-24},
          {8,-24},{8,-3.6},{16.8,-3.6}}, color={0,0,127}));
  connect(elPow.y, PLigPlu) annotation (Line(points={{-11,-80},{24,-80},{24,-40},
          {110,-40}}, color={0,0,127}));
  connect(temSp.y, zonCtr[1].TZon)
    annotation (Line(points={{-71,4},{-66.5,4},{-62,4}}, color={0,0,127}));
  connect(temSp.y, zonCtr[2].TZon)
    annotation (Line(points={{-71,4},{-66.5,4},{-62,4}}, color={0,0,127}));
  connect(temSp.y, zonCtr[3].TZon)
    annotation (Line(points={{-71,4},{-62,4}}, color={0,0,127}));
  connect(temSp.y, zonCtr[4].TZon)
    annotation (Line(points={{-71,4},{-66.5,4},{-62,4}}, color={0,0,127}));
  connect(temSp.y, zonCtr[5].TZon)
    annotation (Line(points={{-71,4},{-66.5,4},{-62,4}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}},
        initialScale=0.2)),     Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
        initialScale=0.2),                 graphics={
        Polygon(
          points={{0,98},{-30,68},{50,28},{80,58},{0,98}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={189,195,199}),
        Polygon(
          points={{-14,80},{-24,70},{12,52},{22,62},{-14,80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={108,122,137}),
        Polygon(
          points={{0,94},{-10,84},{26,66},{36,76},{0,94}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={108,122,137}),
        Polygon(
          points={{36,76},{26,66},{62,48},{72,58},{36,76}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={108,122,137}),
        Polygon(
          points={{22,62},{12,52},{48,34},{58,44},{22,62}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={108,122,137})}));
end SmallOfficeControlled;
