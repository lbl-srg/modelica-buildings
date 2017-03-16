model HeaterCoolerHumidifier_u
  "Example of the HeaterCoolerHumidifier_u model"
  extends Modelica.Icons.Example;

  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  constant Modelica.SIunits.AbsolutePressure pAtm = 101325;

  parameter Modelica.SIunits.Pressure pAirIn = pAtm + 20
    "Inlet air pressure";
  parameter Modelica.SIunits.Pressure pAirOut = pAtm
    "Outlet air pressure";
  parameter Modelica.SIunits.MassFlowRate masFloAirNom = 2.646
    "Nominal mass flow rate of air";
  parameter Modelica.SIunits.MassFlowRate masFloCon = 0.0025
    "Mass flow rate of condensate";                     // 0.00247525
  parameter Modelica.SIunits.Temperature TAirIn = 25 + 273.15;
  parameter Real XWatIn = 0.0089757;
  parameter Modelica.SIunits.Temperature TAirOut = 20 + 273.15;
  parameter Modelica.SIunits.Temperature TCon = 10.3 + 273.15
    "Mass flow rate of condensate";
  parameter Modelica.SIunits.HeatFlowRate QSen = -1000
    "Sensible heat flow rate";

  Buildings.Fluid.HeatExchangers.HeaterCoolerHumidifier_u heaCooHum(
    redeclare package Medium = Medium_A,
    show_T=true,
    use_T_in=true,
    mWat_flow_nominal=1,
    Q_flow_nominal=1,
    m_flow_nominal=masFloAirNom,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = Medium_A,
    p=pAirIn,
    T=TAirIn,
    X={XWatIn, 1 - XWatIn},
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-80,0})));
  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    p=pAirOut,
    T=TAirOut,
    X={XWatIn, 1 - XWatIn},
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={56,0})));
  Buildings.Fluid.FixedResistances.PressureDrop airRes(
    redeclare package Medium = Medium_A,
    m_flow_nominal=masFloAirNom,
    dp_nominal=pAirIn - pAirOut)
    "Pressure drop in airway"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-42,0})));
  Modelica.Blocks.Sources.RealExpression masFloConInp(y=-1*masFloCon)
    "Expression for the mass flow of the condensate"
    annotation (Placement(transformation(extent={{-56,34},{-28,46}})));
  Modelica.Blocks.Sources.RealExpression TConInp(y=TCon)
    "Expression for the condensate temperature"
    annotation (Placement(transformation(extent={{-56,-26},{-28,-14}})));
  Modelica.Blocks.Sources.RealExpression QSenInp(y=QSen)
    "Expression for the condensate temperature"
    annotation (Placement(transformation(extent={{-56,-40},{-28,-28}})));

  // VARIABLES
  Modelica.SIunits.Temperature TAirOutSenExp
    "Expected output temperature for sensible only";
  Modelica.SIunits.Temperature TAirOutTotExp
    "Expected output temperature for sensible + latent";
  Modelica.SIunits.Temperature TAirOutAtUnit
    "Outlet air temperature at the heaCooHum";
  Modelica.SIunits.SpecificHeatCapacity cpAir
    "Specific heat capacity of air";

equation
  TAirOutAtUnit = Medium_A.temperature(
    Medium_A.setState_phX(
      p=heaCooHum.port_b.p,
      h=actualStream(heaCooHum.port_b.h_outflow),
      X={actualStream(heaCooHum.port_b.Xi_outflow[1]),
        1 - actualStream(heaCooHum.port_b.Xi_outflow[1])}));
  TAirOutSenExp = QSen / (masFloAirNom * cpAir) + TAirIn;
  TAirOutTotExp = TAirOutSenExp;
  cpAir = Medium_A.specificHeatCapacityCp(
    Medium_A.setState_phX(
      p=airRes.port_b.p,
      h=inStream(airRes.port_b.h_outflow),
      X={XWatIn, 1 - XWatIn}));
  connect(heaCooHum.port_b, sinAir.ports[1])
    annotation (Line(points={{10,0},{46,0}},        color={0,127,255},
      thickness=1));
  connect(souAir.ports[1], airRes.port_a) annotation (Line(
      points={{-70,0},{-52,0}},
      color={0,127,255},
      thickness=1));
  connect(airRes.port_b, heaCooHum.port_a) annotation (Line(
      points={{-32,0},{-21,0},{-10,0}},
      color={0,127,255},
      thickness=1));
  connect(masFloConInp.y, heaCooHum.u) annotation (Line(points={{
          -26.6,40},{-20,40},{-20,6},{-12,6}}, color={0,0,127}));
  connect(TConInp.y, heaCooHum.T_in) annotation (Line(points={{-26.6,
          -20},{-22,-20},{-22,-6},{-12,-6}}, color={0,0,127}));
  connect(QSenInp.y, heaCooHum.u1) annotation (Line(points={{-26.6,
          -34},{-18,-34},{-18,-9},{-12,-9}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeaterCoolerHumidifier_u;

