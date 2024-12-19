within Buildings.Fluid.CHPs.DistrictCHP;
package Obsolete
  "Here are the obsolate packages or models in the developement process"
  model ToppingCyclePolynomial
      extends Modelica.Blocks.Icons.Block;
   //Nominal condition
    parameter Modelica.Units.SI.Power P_nominal = per.P_nominal
    "Gas turbine power generation capacity"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.NonSI.Temperature_degC TExh_nominal = per.TExh_nominal
    "Nominal exhaust gas temperature"
    annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.SI.MassFlowRate mExh_nominal = per.mExh_nominal
    "Nominal exhaust mass flow rate"
    annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.SI.Efficiency eta_nominal=per.eta_nominal
    "Nominal gas turbine efficiency"
      annotation (Dialog(group="Nominal condition"));
    // Natural gas properties
    parameter Modelica.Units.SI.SpecificEnthalpy  LHVFue = per.LHVFue
     "Lower heating value";

    // Coefficients for off-design correction factor functions
    parameter Real a_gas[:] = per.a_gas
    "Coefficients for gas turbine efficiency"
    annotation (Dialog(tab="Advanced", group="Off-design condition"));
    parameter Real a_exhT[:] = per.a_exhT
    "Coefficients for exhaust temperature"
    annotation (Dialog(tab="Advanced", group="Off-design condition"));
    parameter Real a_exhM[:] = per.a_exhM
     "Coefficients for exhaust mass flow"
     annotation (Dialog(tab="Advanced", group="Off-design condition"));

    // Data input
    parameter Buildings.Fluid.CHPs.DistrictCHP.Obsolete.Taurus70_11100 per
      "Records of gas turbine performance data" annotation (choicesAllMatching=
          true, Placement(transformation(extent={{-80,-80},{-60,-60}})));

    GasTurbineGeneratorEfficiency gasTurEff(final a=a_gas, final eta_nominal=
          eta_nominal)
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    ExhaustTemperature exhTem(final a=a_exhT, final TExh_nominal=TExh_nominal)
      annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
    ExhaustMassFlow exhMas(final a=a_exhM, final mExh_nominal=mExh_nominal)
      annotation (Placement(transformation(extent={{-40,-62},{-18,-40}})));
    Modelica.Blocks.Interfaces.RealInput y "Part load ratio"
     annotation (
        Placement(transformation(extent={{-140,20},{-100,60}}),
          iconTransformation(extent={{-140,20},{-100,60}})));

    Modelica.Blocks.Interfaces.RealInput TSet(
    final quantity="ThermodynamicTemperature",
    final unit = "degC")
    "Ambient temperature"
      annotation (Placement(
          transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
            extent={{-140,-60},{-100,-20}})));
    Modelica.Blocks.Interfaces.RealOutput PEle(
    final quantity= "Power",
    final unit = "W")
      annotation (Placement(
          transformation(extent={{100,70},{120,90}}), iconTransformation(extent=
             {{100,70},{120,90}})));
    Modelica.Blocks.Interfaces.RealOutput mFue(
    final unit= "kg/s")
      annotation (Placement(
          transformation(extent={{100,40},{120,60}}), iconTransformation(extent={{100,40},
              {120,60}})));
    Modelica.Blocks.Interfaces.RealOutput TExh(
    final quantity="ThermodynamicTemperature",
    final unit = "degC")
      annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={40,-110}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-40,-110})));
    Modelica.Blocks.Interfaces.RealOutput mExh(
    final unit= "kg/s")
      annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,-110}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={40,-110})));

  protected
    Buildings.Controls.OBC.CDL.Reals.Divide groHea
      "Gross heat input into the system"
      annotation (Placement(transformation(extent={{20,40},{40,60}})));
    Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter eleCap(
    final k=P_nominal) "Fuel mass flow rate computation"
      annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
    Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter nomHea(
    final k=1/LHVFue)    "Low heating value"
      annotation (Placement(transformation(extent={{60,40},{80,60}})));

  equation
    connect(eleCap.y, groHea.u1) annotation (Line(
        points={{-18,80},{0,80},{0,56},{18,56}},
        color={0,0,127}));
    connect(gasTurEff.eta, groHea.u2) annotation (Line(
        points={{-18,30},{0,30},{0,44},{18,44}},
        color={0,0,127}));
    connect(groHea.y, nomHea.u) annotation (Line(
        points={{42,50},{58,50}},
        color={0,0,127}));
    connect(nomHea.y, mFue) annotation (Line(
        points={{82,50},{110,50}},
        color={0,0,127}));
    connect(eleCap.y,PEle)
      annotation (Line(points={{-18,80},{110,80}}, color={0,0,127}));
    connect(y, eleCap.u) annotation (Line(points={{-120,40},{-60,40},{-60,80},{-42,
            80}},     color={0,0,127}));
    connect(y, gasTurEff.loaFac) annotation (Line(points={{-120,40},{-60,40},{-60,
            34},{-42,34}}, color={0,0,127}));
    connect(TSet, gasTurEff.TAmb) annotation (Line(points={{-120,-40},{-80,-40},{-80,
            26},{-42,26}}, color={0,0,127}));
    connect(exhTem.TExh, TExh)
      annotation (Line(points={{-18,-11},{40,-11},{40,-110}}, color={0,0,127}));
    connect(exhMas.mExh, mExh) annotation (Line(points={{-15.8,-52.1},{0,-52.1},{0,
            -110}}, color={0,0,127}));
    connect(exhTem.loaFac, y) annotation (Line(points={{-42,-7},{-60,-7},{-60,
            40},{-120,40}}, color={0,0,127}));
    connect(exhTem.TAmb,TSet)  annotation (Line(points={{-42,-15},{-80,-15},{-80,-40},
            {-120,-40}}, color={0,0,127}));
    connect(exhMas.loaFac, y) annotation (Line(points={{-42.2,-47.7},{-42.2,-48},
            {-60,-48},{-60,40},{-120,40}}, color={0,0,127}));
    connect(exhMas.TAmb,TSet)  annotation (Line(points={{-42.2,-56.5},{-80,-56.5},
            {-80,-40},{-120,-40}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ToppingCyclePolynomial;

  model BottomingCycle
    extends Modelica.Blocks.Icons.Block;

    package MediumSte = Buildings.Media.Steam
      "Steam medium - Medium model for port_b (outlet)";
    package MediumWat =
        Buildings.Media.Specialized.Water.TemperatureDependentDensity
      "Water medium - Medium model for 1 (inlet)";

    // Parameters
    parameter Real a_ST[:]={0, 0, 0}
    "Polynominal coefficients for steam turbine power generation 
   efficiency function";
    parameter Modelica.Units.NonSI.Temperature_degC TSta = 138
      "Exhaust stack temperature in Celsius";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=28.63
      "Nominal mass flow rate";

     parameter Real a_SteMas[:]={0.153, 0.018, 0.002}
   "Coefficients for steam mass flow correlation function";

    Buildings.DHC.Plants.Steam.BaseClasses.ControlVolumeEvaporation steBoi(
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      V=1,
      redeclare package MediumWat = MediumWat,
      redeclare package MediumSte = MediumSte,
      final m_flow_nominal=m_flow_nominal "",
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      allowFlowReversal=true) "Dynamic volume"
      annotation (Placement(transformation(extent={{40,-70},{60,-90}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
      "Prescribed heat flow rate"
      annotation (Placement(transformation(extent={{26,-42},{46,-22}})));
    Buildings.Controls.OBC.CDL.Utilities.Assert AssertHeatingDemand(message=
          "The heating demand is larger than the available heat")
      annotation (Placement(transformation(extent={{60,40},{80,60}})));
    Buildings.Controls.OBC.CDL.Reals.Greater gre
      annotation (Placement(transformation(extent={{20,40},{40,60}})));
    Modelica.Blocks.Sources.RealExpression FixSteEnt(y=steBoi.port_b.h_outflow)
      annotation (Placement(transformation(extent={{-82,-50},{-60,-26}})));
    Modelica.Blocks.Sources.RealExpression FixWatEnt(y=sou.ports[1].h_outflow)
      annotation (Placement(transformation(extent={{-82,-74},{-60,-48}})));
    Modelica.Blocks.Interfaces.RealInput TExh
      annotation (Placement(
          transformation(extent={{-126,68},{-100,94}}),  iconTransformation(
            extent={{-126,68},{-100,94}})));

    Modelica.Blocks.Interfaces.RealInput mExh
      annotation (Placement(
          transformation(extent={{-126,10},{-100,36}}),iconTransformation(
            extent={{-126,10},{-100,36}})));

    Modelica.Blocks.Interfaces.RealInput TAmb
     "Ambient temperature"
      annotation (
        Placement(transformation(extent={{-126,46},{-100,72}}),
          iconTransformation(extent={{-126,40},{-100,66}})));
    Modelica.Blocks.Sources.RealExpression TSte(y=steBoi.stateSte.T)
      "Superheated steam temperature"
      annotation (Placement(transformation(extent={{-82,-30},{-60,-6}})));

    Modelica.Blocks.Interfaces.RealOutput PEle_ST
      annotation (Placement(
          transformation(extent={{100,68},{124,92}}), iconTransformation(extent={{100,68},
              {124,92}})));
    SteamTurbine steTur(final a_ST=a_ST, final TSta=TSta)
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
    BaseClasses.HeatInput heaInp(
      final a_SteMas = a_SteMas)
      annotation (Placement(transformation(extent={{-40,-2},{-20,18}})));
      //redeclare Buildings.Fluid.Movers.Data.Generic
      //per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2)),

    Modelica.Fluid.Interfaces.FluidPort_b port(redeclare final package Medium =
          MediumSte)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{110,-10},{90,10}})));
    Modelica.Fluid.Sources.MassFlowSource_T sou(
      redeclare package Medium = MediumWat,
      use_m_flow_in=true,
      T=313.15,
      nPorts=1) "Flow source"
      annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
  equation
    connect(preHeaFlo.port, steBoi.heatPort)
      annotation (Line(points={{46,-32},{50,-32},{50,-70}}, color={191,0,0}));
    connect(gre.y, AssertHeatingDemand.u)
      annotation (Line(points={{42,50},{58,50}},   color={255,0,255}));
    connect(steTur.Q_RemSte, gre.u1) annotation (Line(points={{-18.2,66},{0,66},
            {0,50},{18,50}},
                      color={0,0,127}));
    connect(steTur.PEle_ST, PEle_ST)
      annotation (Line(points={{-18.1,73.9},{40,73.9},{40,80},{112,80}},
                                                   color={0,0,127}));
    connect(heaInp.QFlo, preHeaFlo.Q_flow) annotation (Line(points={{-18.2,12},{0,
            12},{0,-32},{26,-32}},  color={0,0,127}));
    connect(gre.u2, heaInp.QFlo) annotation (Line(points={{18,42},{0,42},{0,12},{-18.2,
            12}}, color={0,0,127}));
    connect(steTur.mExh, mExh) annotation (Line(points={{-42,66},{-60,66},{-60,23},
            {-113,23}},     color={0,0,127}));
    connect(heaInp.mExh, mExh) annotation (Line(points={{-42,12},{-60,12},{-60,23},
            {-113,23}}, color={0,0,127}));
    connect(FixSteEnt.y, heaInp.steEnt) annotation (Line(points={{-58.9,-38},{-50,
            -38},{-50,4},{-42,4}},color={0,0,127}));
    connect(FixWatEnt.y, heaInp.watEnt) annotation (Line(points={{-58.9,-61},{-46,
            -61},{-46,0},{-42,0}},   color={0,0,127}));
    connect(steBoi.port_b, port)
      annotation (Line(points={{60,-80},{100,-80},{100,0}}, color={0,127,255}));
    connect(steTur.TAmb, TAmb) annotation (Line(points={{-42,70},{-42,70},{-70,
            70},{-70,59},{-113,59}},     color={0,0,127}));
    connect(heaInp.TExh, TExh) annotation (Line(points={{-42,16},{-80,16},{-80,81},
            {-113,81}}, color={0,0,127}));
    connect(steTur.TExh, TExh) annotation (Line(points={{-42,74},{-80,74},{-80,81},
            {-113,81}},     color={0,0,127}));
    connect(TSte.y, heaInp.TSte) annotation (Line(points={{-58.9,-18},{-54,-18},{-54,
            8},{-42,8}},
                       color={0,0,127}));
    connect(sou.ports[1], steBoi.port_a)
      annotation (Line(points={{12,-80},{40,-80}}, color={0,127,255}));
    connect(heaInp.mSte, sou.m_flow_in) annotation (Line(points={{-30.1,-3.9},{-30.1,
            -72},{-8,-72}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})));
  end BottomingCycle;

  model BottomingCycleVolume
    extends Modelica.Blocks.Icons.Block;

    package MediumSte = Buildings.Media.Steam
      "Steam medium - Medium model for port_b (outlet)";
    package MediumWat =
        Buildings.Media.Specialized.Water.TemperatureDependentDensity
      "Water medium - Medium model for 1 (inlet)";

    // Parameters
    parameter Real a_ST[:]={0.4, 0, 0}
    "Polynominal coefficients for steam turbine power generation 
   efficiency function";
    parameter Modelica.Units.NonSI.Temperature_degC TSta = 87.778
      "Exhaust stack temperature in Celsius";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=28.63
      "Nominal mass flow rate";

     parameter Real a_SteMas[:]={0.153, 0.018, 0.002}
   "Coefficients for steam mass flow correlation function";

    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
      "Prescribed heat flow rate"
      annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
    Buildings.Controls.OBC.CDL.Utilities.Assert AssertHeatingDemand(message=
          "The heating demand is larger than the available heat")
      annotation (Placement(transformation(extent={{60,40},{80,60}})));
    Buildings.Controls.OBC.CDL.Reals.Greater gre
      annotation (Placement(transformation(extent={{20,40},{40,60}})));
    Modelica.Blocks.Sources.RealExpression FixSteEnt(y=780753)
      annotation (Placement(transformation(extent={{-82,-50},{-60,-26}})));
    Modelica.Blocks.Sources.RealExpression FixWatEnt(y=sou.medium.h)
      annotation (Placement(transformation(extent={{-82,-74},{-60,-48}})));
    Modelica.Blocks.Interfaces.RealInput TExh
      annotation (Placement(
          transformation(extent={{-126,68},{-100,94}}),  iconTransformation(
            extent={{-126,68},{-100,94}})));

    Modelica.Blocks.Interfaces.RealInput mExh
      annotation (Placement(
          transformation(extent={{-126,10},{-100,36}}),iconTransformation(
            extent={{-126,10},{-100,36}})));

    Modelica.Blocks.Interfaces.RealInput TAmb
     "Ambient temperature"
      annotation (
        Placement(transformation(extent={{-126,46},{-100,72}}),
          iconTransformation(extent={{-126,40},{-100,66}})));
    Modelica.Blocks.Sources.RealExpression TSte(y=184)
      "Saturated steam temperature"
      annotation (Placement(transformation(extent={{-82,-30},{-60,-6}})));

    Modelica.Blocks.Interfaces.RealOutput PEle_ST
      annotation (Placement(
          transformation(extent={{100,68},{124,92}}), iconTransformation(extent={{100,68},
              {124,92}})));
    SteamTurbine steTur(final a_ST=a_ST, final TSta=TSta)
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
    BaseClasses.HeatInput heaInp(
      final a_SteMas = a_SteMas)
      annotation (Placement(transformation(extent={{-40,-2},{-20,18}})));
      //redeclare Buildings.Fluid.Movers.Data.Generic
      //per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2)),

    Modelica.Fluid.Sources.MassFlowSource_T sou(
      redeclare package Medium = MediumWat,
      use_m_flow_in=true,
      T=313.15,
      nPorts=1) "Flow source"
      annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
    Modelica.Fluid.Interfaces.FluidPort_b port(redeclare final package Medium =
          Modelica.Media.Water.StandardWater)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{110,-10},{90,10}})));
    Modelica.Fluid.Vessels.ClosedVolume volume(
      redeclare package Medium = Modelica.Media.Water.StandardWater,
      use_portsData=false,
      use_HeatTransfer=true,
      V=1,
      nPorts=2) annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  equation
    connect(gre.y, AssertHeatingDemand.u)
      annotation (Line(points={{42,50},{58,50}},   color={255,0,255}));
    connect(steTur.Q_RemSte, gre.u1) annotation (Line(points={{-18.2,66},{0,66},
            {0,50},{18,50}},
                      color={0,0,127}));
    connect(steTur.PEle_ST, PEle_ST)
      annotation (Line(points={{-18.1,73.9},{40,73.9},{40,80},{112,80}},
                                                   color={0,0,127}));
    connect(heaInp.QFlo, preHeaFlo.Q_flow) annotation (Line(points={{-18.2,12},{
            14,12},{14,-50},{20,-50}},
                                    color={0,0,127}));
    connect(gre.u2, heaInp.QFlo) annotation (Line(points={{18,42},{0,42},{0,12},{-18.2,
            12}}, color={0,0,127}));
    connect(steTur.mExh, mExh) annotation (Line(points={{-42,66},{-60,66},{-60,23},
            {-113,23}},     color={0,0,127}));
    connect(heaInp.mExh, mExh) annotation (Line(points={{-42,12},{-60,12},{-60,23},
            {-113,23}}, color={0,0,127}));
    connect(FixSteEnt.y, heaInp.steEnt) annotation (Line(points={{-58.9,-38},{-50,
            -38},{-50,4},{-42,4}},color={0,0,127}));
    connect(FixWatEnt.y, heaInp.watEnt) annotation (Line(points={{-58.9,-61},{-46,
            -61},{-46,0},{-42,0}},   color={0,0,127}));
    connect(steTur.TAmb, TAmb) annotation (Line(points={{-42,70},{-42,70},{-70,
            70},{-70,59},{-113,59}},     color={0,0,127}));
    connect(heaInp.TExh, TExh) annotation (Line(points={{-42,16},{-80,16},{-80,81},
            {-113,81}}, color={0,0,127}));
    connect(steTur.TExh, TExh) annotation (Line(points={{-42,74},{-80,74},{-80,81},
            {-113,81}},     color={0,0,127}));
    connect(TSte.y, heaInp.TSte) annotation (Line(points={{-58.9,-18},{-54,-18},{-54,
            8},{-42,8}},
                       color={0,0,127}));
    connect(heaInp.mSte, sou.m_flow_in) annotation (Line(points={{-30.1,-3.9},{-30.1,
            -72},{-8,-72}}, color={0,0,127}));
    connect(preHeaFlo.port, volume.heatPort) annotation (Line(points={{40,-50},{
            50,-50},{50,-70},{60,-70}}, color={191,0,0}));
    connect(sou.ports[1], volume.ports[1])
      annotation (Line(points={{12,-80},{69,-80}}, color={0,127,255}));
    connect(volume.ports[2], port) annotation (Line(points={{71,-80},{92,-80},{92,
            0},{100,0}}, color={0,127,255}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})));
  end BottomingCycleVolume;

  model BottomingCycleExperimentV2
    extends Modelica.Blocks.Icons.Block;

    package MediumSte = Buildings.Media.Steam
      "Steam medium - Medium model for port_b (outlet)";
    package MediumWat =
        Buildings.Media.Specialized.Water.TemperatureDependentDensity
      "Water medium - Medium model for 1 (inlet)";

    // Parameters
    parameter Real a_ST[:]={0, 0, 0}
    "Polynominal coefficients for steam turbine power generation 
   efficiency function";
    parameter Modelica.Units.NonSI.Temperature_degC TSta = 138
      "Exhaust stack temperature in Celsius";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=55
      "Nominal mass flow rate";

    parameter Modelica.Units.SI.AbsolutePressure pSteSet=3000000
      "Steam pressure setpoint";

    parameter Modelica.Units.SI.AbsolutePressure pTanFW=101325
      "Pressure of feedwater tank";

     parameter Real a_SteMas[:]={0.153, 0.018, 0.002}
   "Coefficients for steam mass flow correlation function";
     parameter Buildings.Fluid.Movers.Data.Generic per(
      pressure(
        V_flow=(m_flow_nominal/1000)*{0.4,0.6,0.8,1.0},
        dp=(pSteSet-pTanFW)*{1.34,1.27,1.17,1.0}))
      "Performance data for the feedwater pump";

    Buildings.DHC.Plants.Steam.BaseClasses.ControlVolumeEvaporation steBoi(
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      V=12.4,
      redeclare package MediumWat = MediumWat,
      redeclare package MediumSte = MediumSte,
      final m_flow_nominal=m_flow_nominal "",
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      allowFlowReversal=true,
      VWat_start=steBoi.V*0.2) "Dynamic volume"
      annotation (Placement(transformation(extent={{40,-70},{60,-90}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
      "Prescribed heat flow rate"
      annotation (Placement(transformation(extent={{26,2},{46,22}})));
    Buildings.Controls.OBC.CDL.Utilities.Assert AssertHeatingDemand(message=
          "The heating demand is larger than the available heat")
      annotation (Placement(transformation(extent={{60,40},{80,60}})));
    Buildings.Controls.OBC.CDL.Reals.Greater gre
      annotation (Placement(transformation(extent={{20,40},{40,60}})));
    Modelica.Blocks.Sources.RealExpression FixSteEnt(y=steBoi.port_b.h_outflow)
      annotation (Placement(transformation(extent={{-82,-36},{-60,-12}})));
    Modelica.Blocks.Sources.RealExpression FixWatEnt(y=pumFW.port_b.h_outflow)
      annotation (Placement(transformation(extent={{-82,-60},{-60,-34}})));
    Modelica.Blocks.Interfaces.RealInput TExh
      annotation (Placement(
          transformation(extent={{-126,68},{-100,94}}),  iconTransformation(
            extent={{-126,68},{-100,94}})));

    Modelica.Blocks.Interfaces.RealInput mExh
      annotation (Placement(
          transformation(extent={{-126,10},{-100,36}}),iconTransformation(
            extent={{-126,10},{-100,36}})));

    Modelica.Blocks.Interfaces.RealInput TAmb
     "Ambient temperature"
      annotation (
        Placement(transformation(extent={{-126,46},{-100,72}}),
          iconTransformation(extent={{-126,40},{-100,66}})));
    Modelica.Blocks.Sources.RealExpression TSte(y=steBoi.stateSte.T)
      "Superheated steam temperature"
      annotation (Placement(transformation(extent={{-82,-16},{-60,8}})));

    Modelica.Blocks.Interfaces.RealOutput PEle_ST
      annotation (Placement(
          transformation(extent={{100,68},{124,92}}), iconTransformation(extent={{100,68},
              {124,92}})));
    SteamTurbine steTur(final a_ST=a_ST, final TSta=TSta)
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
    BaseClasses.HeatInput heaInp(
      final a_SteMas = a_SteMas)
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
      //redeclare Buildings.Fluid.Movers.Data.Generic
      //per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2)),

    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
          MediumWat)
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

    Buildings.Fluid.Movers.SpeedControlled_y pumFW(
      redeclare final package Medium = MediumWat,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      p_start=3000000,
      final allowFlowReversal=false,
      final per=per,
      final y_start=1)
      "Feedwater pump"
      annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
    Modelica.Blocks.Math.Gain VNor(final k=1/steBoi.V) "Normalized volume "
      annotation (Placement(transformation(extent={{80,-50},{62,-32}})));
    Modelica.Blocks.Sources.Constant uni(final k=0.2)
                                                    "Unitary"
      annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare final package Medium =
          MediumSte)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{110,-10},{90,10}})));
    Buildings.Controls.Continuous.LimPID conPID(
      Td=1,
      k=0.5,
      Ti=15) annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  equation
    connect(preHeaFlo.port, steBoi.heatPort)
      annotation (Line(points={{46,12},{50,12},{50,-70}},   color={191,0,0}));
    connect(gre.y, AssertHeatingDemand.u)
      annotation (Line(points={{42,50},{58,50}},   color={255,0,255}));
    connect(steTur.Q_RemSte, gre.u1) annotation (Line(points={{-18.2,66},{0,66},
            {0,50},{18,50}},
                      color={0,0,127}));
    connect(steTur.PEle_ST, PEle_ST)
      annotation (Line(points={{-18.1,73.9},{40,73.9},{40,80},{112,80}},
                                                   color={0,0,127}));
    connect(heaInp.QFlo, preHeaFlo.Q_flow) annotation (Line(points={{-18.2,14},{4,
            14},{4,12},{26,12}},    color={0,0,127}));
    connect(gre.u2, heaInp.QFlo) annotation (Line(points={{18,42},{0,42},{0,14},{-18.2,
            14}}, color={0,0,127}));
    connect(steTur.mExh, mExh) annotation (Line(points={{-42,66},{-60,66},{-60,23},
            {-113,23}},     color={0,0,127}));
    connect(heaInp.mExh, mExh) annotation (Line(points={{-42,14},{-60,14},{-60,23},
            {-113,23}}, color={0,0,127}));
    connect(FixSteEnt.y, heaInp.steEnt) annotation (Line(points={{-58.9,-24},{-50,
            -24},{-50,6},{-42,6}},color={0,0,127}));
    connect(FixWatEnt.y, heaInp.watEnt) annotation (Line(points={{-58.9,-47},{-46,
            -47},{-46,2},{-42,2}},   color={0,0,127}));
    connect(steTur.TAmb, TAmb) annotation (Line(points={{-42,70},{-42,70},{-70,70},
            {-70,59},{-113,59}},         color={0,0,127}));
    connect(heaInp.TExh, TExh) annotation (Line(points={{-42,18},{-80,18},{-80,81},
            {-113,81}}, color={0,0,127}));
    connect(steTur.TExh, TExh) annotation (Line(points={{-42,74},{-80,74},{-80,81},
            {-113,81}},     color={0,0,127}));
    connect(TSte.y, heaInp.TSte) annotation (Line(points={{-58.9,-4},{-54,-4},{-54,
            10},{-42,10}},
                       color={0,0,127}));
    connect(steBoi.port_b, port_b)
      annotation (Line(points={{60,-80},{100,-80},{100,0}}, color={0,127,255}));
    connect(pumFW.port_b, steBoi.port_a)
      annotation (Line(points={{10,-80},{40,-80}}, color={0,127,255}));
    connect(port_a, pumFW.port_a) annotation (Line(points={{-100,0},{-100,-80},{-10,
            -80}}, color={0,127,255}));
    connect(steBoi.VLiq, VNor.u) annotation (Line(points={{61,-87},{81.8,-87},{81.8,
            -41}}, color={0,0,127}));
    connect(uni.y, conPID.u_s)
      annotation (Line(points={{-19,-20},{-12,-20}}, color={0,0,127}));
    connect(conPID.y, pumFW.y) annotation (Line(points={{11,-20},{16,-20},{16,-68},
            {0,-68}}, color={0,0,127}));
    connect(conPID.u_m, VNor.y)
      annotation (Line(points={{0,-32},{0,-41},{61.1,-41}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})));
  end BottomingCycleExperimentV2;

  model CombinedCycleCHPV2
    extends Modelica.Icons.Example;
    package MediumSte = Buildings.Media.Steam
      "Steam medium - Medium model for port_b (outlet)";
    package MediumWat =
        Buildings.Media.Specialized.Water.TemperatureDependentDensity
      "Water medium - Medium model for port_a (inlet)";

    Combined combinedCyclePowerPlant
      annotation (Placement(transformation(extent={{-20,-24},{20,24}})));
    Modelica.Blocks.Sources.CombiTimeTable LoadProfile(table=[0,1.0; 1,0.8; 2,0.6;
          3,1; 4,1; 5,1; 6,0.8; 7,0.8; 8,0.8], timeScale(displayUnit="h") = 3600)
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Sources.CombiTimeTable AmbientTemperature(table=[0.0,15; 1,15;
          2,15; 3,15; 4,20; 5,25; 6,15; 7,20; 8,25], timeScale(displayUnit="h")=
           3600)
      annotation (Placement(transformation(extent={{-82,0},{-62,20}})));
    Modelica.Fluid.Sources.FixedBoundary bou(
      redeclare package Medium = MediumSte,
      p=1000000,
      T=523.15,
      nPorts=1) "Boundary condition"
      annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
    Modelica.Blocks.Continuous.Integrator mFuel(y(unit="kg/s"))
      "Mass flow of fuel consumption "
      annotation (Placement(transformation(extent={{60,20},{80,40}})));
    Modelica.Blocks.Continuous.Integrator STG_Ele(y(unit="W"))
      "Steam turbine electrical energy generated"
      annotation (Placement(transformation(extent={{60,-20},{80,0}})));
    Modelica.Blocks.Continuous.Integrator GTG_Ele(y(unit="W"))
      "Gas turbine electrical energy generated"
      annotation (Placement(transformation(extent={{60,60},{80,80}})));
  equation
    connect(LoadProfile.y[1], combinedCyclePowerPlant.y) annotation (Line(points=
            {{-59,70},{-40,70},{-40,20},{-24,20},{-24,19.2}}, color={0,0,127}));
    connect(AmbientTemperature.y[1], combinedCyclePowerPlant.TAmb)
      annotation (Line(points={{-61,10},{-60,10},{-60,9.6},{-24,9.6}}, color=
            {0,0,127}));
    connect(combinedCyclePowerPlant.PEle, GTG_Ele.u) annotation (Line(points={{22,
            18.24},{22,20},{40,20},{40,70},{58,70}},color={0,0,127}));
    connect(combinedCyclePowerPlant.PEle_ST, STG_Ele.u) annotation (Line(points={{22,9.6},
            {22,10},{52,10},{52,-10},{58,-10}},          color={0,0,127}));
    connect(combinedCyclePowerPlant.mFue, mFuel.u) annotation (Line(points={{22.4,
            15.36},{52,15.36},{52,30},{58,30}},
                                        color={0,0,127}));
    connect(combinedCyclePowerPlant.port_b, bou.ports[1]) annotation (Line(
          points={{20,0},{50,0},{50,-50},{60,-50}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end CombinedCycleCHPV2;

  model BottomingCycleExperimentV2_Validation

    extends Modelica.Icons.Example;
      package MediumSte = Buildings.Media.Steam
      "Steam medium - Medium model for port_b (outlet)";
    package MediumWat =
        Buildings.Media.Specialized.Water.TemperatureDependentDensity
      "Water medium - Medium model for port_a (inlet)";

    // Parameters
    parameter Real a_ST[:]={0.4, 0, 0}
    "Polynominal coefficients for steam turbine power generation 
   efficiency function";
    parameter Modelica.Units.NonSI.Temperature_degC TSta = 87.778
      "Exhaust stack temperature in Celsius";

      parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=55
      "Nominal mass flow rate";

    parameter Modelica.Units.SI.AbsolutePressure pSteSet=3000000
      "Steam pressure setpoint";

    parameter Modelica.Units.SI.AbsolutePressure pTanFW=101325
      "Pressure of feedwater tank";

     parameter Buildings.Fluid.Movers.Data.Generic per(
      pressure(
        V_flow=(m_flow_nominal/1000)*{0.4,0.6,0.8,1.0},
        dp=(pSteSet-pTanFW)*{1.34,1.27,1.17,1.0}))
      "Performance data for the feedwater pump";

    Modelica.Blocks.Sources.Constant exhMas(k=500)
      "Exhaust gas mass flow rate (kg/s)"
      annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
    Modelica.Blocks.Sources.Constant ambTemp(k=15) "Ambient temperature (deg_C)"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    Buildings.Fluid.Sources.Boundary_pT sou(
      redeclare package Medium = MediumWat,
      use_p_in=false,
      p=50000,
      T=504.475,
      nPorts=1)
      annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
    Modelica.Blocks.Sources.Ramp ramp(
      height=-60,
      duration=300,
      offset=750,
      startTime=500)
      annotation (Placement(transformation(extent={{-80,42},{-60,62}})));
    Modelica.Fluid.Sources.FixedBoundary bou(
      redeclare package Medium = MediumSte,
      p=3000000,
      T=523.15,
      nPorts=1) "Boundary condition"
      annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
    Buildings.Fluid.CHPs.DistrictCHP.Obsolete.BottomingCycleExperimentV2 botCyc(pumFW(
          T_start=504.475, inputType=Buildings.Fluid.Types.InputType.Continuous))
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(botCyc.TExh, ramp.y) annotation (Line(points={{-11.3,8.1},{-16,8.1},{
            -16,8},{-20,8},{-20,52},{-59,52}}, color={0,0,127}));
    connect(botCyc.mExh, exhMas.y) annotation (Line(points={{-11.3,2.3},{-52,2.3},
            {-52,-20},{-59,-20}}, color={0,0,127}));
    connect(botCyc.TAmb, ambTemp.y) annotation (Line(points={{-11.3,5.3},{-11.3,6},
            {-52,6},{-52,20},{-59,20}}, color={0,0,127}));
    connect(botCyc.port_a, sou.ports[1]) annotation (Line(points={{-10,0},{-24,0},
            {-24,-40},{-30,-40}}, color={0,127,255}));
    connect(bou.ports[1], botCyc.port_b) annotation (Line(points={{30,-40},{16,
            -40},{16,0},{10,0}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end BottomingCycleExperimentV2_Validation;

  model BottomingCycleVolume_Validation
    extends Modelica.Icons.Example;
      package MediumSte = Buildings.Media.Steam
      "Steam medium - Medium model for port_b (outlet)";
    package MediumWat =
        Buildings.Media.Specialized.Water.TemperatureDependentDensity
      "Water medium - Medium model for port_a (inlet)";

    // Parameters
    parameter Real a_ST[:]={0.4, 0, 0}
    "Polynominal coefficients for steam turbine power generation 
   efficiency function";
    parameter Modelica.Units.NonSI.Temperature_degC TSta = 87.778
      "Exhaust stack temperature in Celsius";
     parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=28.63
      "Nominal mass flow rate";

    Modelica.Fluid.Sources.FixedBoundary bou(
      redeclare package Medium = MediumSte,
      p=1000000,
      T=523.15,
      nPorts=1) "Boundary condition"
      annotation (Placement(transformation(extent={{50,-10},{30,10}})));
    Modelica.Blocks.Sources.Constant exhTemp(k=522.78)
      "Exhaust gas temperature (deg_C)"
      annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
    Modelica.Blocks.Sources.Constant exhMas(k=26.58)
      "Exhaust gas mass flow rate (kg/s)"
      annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
    Modelica.Blocks.Sources.Constant ambTemp(k=15) "Ambient temperature (deg_C)"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    Buildings.Fluid.CHPs.DistrictCHP.Obsolete.BottomingCycleVolume botCycleVol(volume(
          massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState, V=1000))
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(botCycleVol.port, bou.ports[1])
      annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
    connect(exhMas.y, botCycleVol.mExh) annotation (Line(points={{-59,-20},{-24,
            -20},{-24,2.3},{-11.3,2.3}}, color={0,0,127}));
    connect(botCycleVol.TAmb, ambTemp.y) annotation (Line(points={{-11.3,5.3},{
            -11.3,4},{-52,4},{-52,20},{-59,20}}, color={0,0,127}));
    connect(botCycleVol.TExh, exhTemp.y) annotation (Line(points={{-11.3,8.1},{
            -38,8.1},{-38,30},{-48,30},{-48,60},{-59,60}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end BottomingCycleVolume_Validation;

  model ToppingCyclePolynomial_Validation
    extends Modelica.Icons.Example;
    Buildings.Fluid.CHPs.DistrictCHP.Obsolete.ToppingCyclePolynomial topCyc(per=
          Buildings.Fluid.CHPs.DistrictCHP.Obsolete.Taurus70_11100())
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Constant parLoa(k=1)
      "Gas turbine generator part load ratio in a range of 0 to 1"
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    Modelica.Blocks.Sources.Constant ambTem(k=15) "Ambient temperature in deg_C"
      annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  equation
    connect(ambTem.y, topCyc.TSet) annotation (Line(points={{-39,-30},{-18,-30},{-18,
            -4},{-12,-4}}, color={0,0,127}));
    connect(topCyc.y, parLoa.y) annotation (Line(points={{-12,4},{-32,4},{-32,30},
            {-39,30}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ToppingCyclePolynomial_Validation;

  model BottomingCycle_Validation
    extends Modelica.Icons.Example;
      package MediumSte = Buildings.Media.Steam
      "Steam medium - Medium model for port_b (outlet)";
    package MediumWat =
        Buildings.Media.Specialized.Water.TemperatureDependentDensity
      "Water medium - Medium model for port_a (inlet)";

    // Parameters
    parameter Real a_ST[:]={0.4, 0, 0}
    "Polynominal coefficients for steam turbine power generation 
   efficiency function";
    parameter Modelica.Units.NonSI.Temperature_degC TSta = 87.778
      "Exhaust stack temperature in Celsius";
     parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=28.63
      "Nominal mass flow rate";

    Buildings.Fluid.CHPs.DistrictCHP.Obsolete.BottomingCycle bottomingCycle(
      a_ST={0,0,0},
      TSta=138,
      final m_flow_nominal=m_flow_nominal,
      steBoi(
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        p_start=1130000),
      TSte(y=183),
      sou(T=383.15))
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Fluid.Sources.FixedBoundary bou(
      redeclare package Medium = MediumSte,
      p=1000000,
      T=523.15,
      nPorts=1) "Boundary condition"
      annotation (Placement(transformation(extent={{50,-10},{30,10}})));
    Modelica.Blocks.Sources.Constant exhTemp(k=520.556)
      "Exhaust gas temperature (deg_C)"
      annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
    Modelica.Blocks.Sources.Constant exhMas(k=27.0986)
      "Exhaust gas mass flow rate (kg/s)"
      annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
    Modelica.Blocks.Sources.Constant ambTemp(k=10) "Ambient temperature (deg_C)"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  equation
    connect(bottomingCycle.port, bou.ports[1])
      annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
    connect(bottomingCycle.TExh, exhTemp.y) annotation (Line(points={{-11.3,8.1},{
            -20,8.1},{-20,60},{-59,60}},
                                   color={0,0,127}));
    connect(bottomingCycle.mExh, exhMas.y) annotation (Line(points={{-11.3,2.3},{-40,
            2.3},{-40,-20},{-59,-20}},
                                     color={0,0,127}));
    connect(bottomingCycle.TAmb, ambTemp.y) annotation (Line(points={{-11.3,5.3},{
            -11.3,6},{-40,6},{-40,20},{-59,20}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end BottomingCycle_Validation;

  record Generic "Generic data record for gas turibne performance"
    extends Modelica.Icons.Record;
    //Polynominal curve coefficients
    parameter Real a_gas[6]
     "Coefficients for GTG efficiency correction factor";
    parameter Real a_exhT[6]
     "Coefficients for exhaust temperature correction factor";
    parameter Real a_exhM[6]
     "Coefficients for exhaust mass flow correction factor";

    //Look-up tables
    parameter Real capPowCor_GTG[:,:]= [0, 1; 1, 1]
     "Power capacity correction factors as a table 
    First row = outside temperature(F), 
    First column = Part load percentage";

    parameter Real effCor_GTG[:,:]= [0, 1; 1, 1]
     "Efficiency curves as a table: 
    First row = outside temperature(F), 
    First column = Part load percentage";

    parameter Real exhTempCor_GT[:,:]= [0, 1; 1, 1]
     "Exhaust temperature correction factors as a table: 
    First row = outside temperature(F), 
    First column = Part load percentage";

    parameter Real exhMasCor_GT[:,:]=[0, 1; 1, 1]
     "Exhaust mass flow correction factors as a table: 
    First row = outside temperature(F), 
    First column = Part load percentage";

    // Nominal values
    parameter Modelica.Units.SI.Efficiency eta_nominal
      "Efficiency at 59 F and full load operation";

    parameter Modelica.Units.SI.Power P_nominal
      "Nominal power generation (W)";

    parameter Modelica.Units.SI.MassFlowRate mExh_nominal
      "Nominal exhaust mass flow rate (kg/s)";

    parameter Modelica.Units.NonSI.Temperature_degC TExh_nominal
      "Nominal exhaust temperature (C)";

    parameter Modelica.Units.SI.SpecificEnthalpy LHVFue
      "Lower heating value";
    annotation (
    defaultComponentName="per",
    defaultComponentPrefixes = "parameter",
    Documentation(info="<html>
<p>
This record is used as a template for performance data
for the gas turbine model

</p>

</html>",   revisions="<html>
<ul>
<li>
Octorber 6, 2023 by Zhanwei He :<br/>
First implementation.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
  end Generic;

  record Taurus70_11100
    extends Buildings.Fluid.CHPs.DistrictCHP.Obsolete.Generic(
    final a_gas=
    {0.00000000e+00,-6.45953810e-04,1.45444871e-02,-7.20100000e-06,6.59257576e-06,-7.20181061e-05},
    final a_exhT=
     {0.00000000e+00, -2.34801662e-03,  1.97219621e-02,  2.06507928e-05,
     6.25614694e-06, -1.50921113e-04},
    final a_exhM=
     { 0.00000000e+00, 9.08818203e-03, -7.81762156e-03, -5.69252216e-05,
     -4.94320242e-05,  1.26673886e-04},
    final capPowCor_GTG=
     [  0,          50,          55,          60,          65,          70,          75,          80;
      100, 1.031375502, 1.014056225, 0.996360442, 0.975778112, 0.955948795, 0.933609438, 0.911897590],
    final effCor_GTG=
     [  0,          50,          55,          60,          65,          70,          75,          80;
       10, 0.341039835, 0.322986304, 0.305405131, 0.299930896, 0.295153535, 0.288639328, 0.282432532;
       20, 0.533411518, 0.527695895, 0.521986643, 0.514922575, 0.507844338, 0.499739695, 0.491327542;
       30, 0.641687373, 0.636618553, 0.631318341, 0.624507000, 0.618034404, 0.610122863, 0.602094811;
       40, 0.713465162, 0.709018886, 0.704181059, 0.698422839, 0.692526711, 0.685231078, 0.677685153;
       50, 0.773084912, 0.769330311, 0.765230414, 0.759754249, 0.754342846, 0.748052815, 0.741377806;
       60, 0.840297822, 0.836731571, 0.832772753, 0.827519844, 0.822208058, 0.815455001, 0.808323158;
       70, 0.904188136, 0.899945084, 0.897141994, 0.890108430, 0.884067328, 0.877070052, 0.869881537;
       80, 0.954183680, 0.950166872, 0.946710932, 0.940444870, 0.935191483, 0.928032279, 0.921202437;
       90, 0.990320992, 0.986022716, 0.982253482, 0.976751520, 0.972235474, 0.963976471, 0.957550782;
      100, 1.004527075, 1.001506196, 0.998027395, 0.993169084, 0.988115636, 0.981791309, 0.974944759],
     final exhTempCor_GT=
     [  0,          50,          55,          60,          65,          70,          75,          80;
       10, 0.562674463, 0.543937269, 0.523419802, 0.530882983, 0.538811366, 0.547536277, 0.556675654;
       20, 0.805165479, 0.806840000, 0.808168671, 0.810154194, 0.812167589, 0.814696406, 0.817101669;
       30, 0.920781937, 0.923718377, 0.926198124, 0.929492669, 0.932649429, 0.936782034, 0.940549988;
       40, 1.030472201, 1.034103964, 1.037302060, 1.041358893, 1.045357809, 1.050351519, 1.055027929;
       50, 1.093691020, 1.096664895, 1.099979986, 1.104932251, 1.110978323, 1.112153272, 1.115721075;
       60, 1.057970028, 1.060510965, 1.063180399, 1.067106427, 1.070907611, 1.075909374, 1.080681091;
       70, 1.019200503, 1.024309848, 1.023077488, 1.033648465, 1.040699199, 1.045837038, 1.051002663;
       80, 1.016283643, 1.018579221, 1.021941352, 1.025076115, 1.028778484, 1.033764672, 1.038891995;
       90, 0.977312952, 0.980689677, 0.982764695, 0.986691381, 0.990313346, 0.995499419, 1.000392576;
      100, 0.995944040, 0.998269555, 1.001011874, 1.004737888, 1.008650584, 1.013200191, 1.018272351],
     final exhMasCor_GT=
     [  0,          50,           55,          60,         65,          70,          75,          80;
       10, 0.776406964, 0.862628043, 0.955235631, 0.946256014, 0.936419874, 0.926954580, 0.916726659;
       20, 0.596536494, 0.596368092, 0.596503010, 0.595692722, 0.595143242, 0.594198577, 0.593644664;
       30, 0.609764285, 0.606671656, 0.603806928, 0.599763730, 0.596051776, 0.591489954, 0.587333748;
       40, 0.626049963, 0.620970515, 0.616015547, 0.609771640, 0.603819216, 0.596945621, 0.590398265;
       50, 0.660401723, 0.654307407, 0.647931249, 0.639857199, 0.631537809, 0.625045850, 0.617619479;
       60, 0.736379447, 0.729482847, 0.722440341, 0.713671721, 0.705283437, 0.695724869, 0.686610287;
       70, 0.810299531, 0.801127361, 0.795269509, 0.781737786, 0.770509792, 0.759737085, 0.749175166;
       80, 0.861718756, 0.854097685, 0.844378333, 0.835264392, 0.825018323, 0.813190198, 0.801521141;
       90, 0.956998742, 0.947937171, 0.938763667, 0.927125632, 0.914684856, 0.903017749, 0.889108434;
      100, 1.019169896, 1.008667824, 0.997681345, 0.984378720, 0.971387018, 0.956928574, 0.942594612],
     final LHVFue = 47.614E6,
     final mExh_nominal= 26.58013489,
     final TExh_nominal = 522.78,
     final P_nominal=7968000,
     final eta_nominal= 0.335);

  end Taurus70_11100;

  record Taurus70
    extends Buildings.Fluid.CHPs.DistrictCHP.Data.Generic(
    final LHVFue = 47.614E6,
    final mExh_nominal= 26.58013489,
    final TExh_nominal = 522.78,
    final P_nominal=7968000,
    final eta_nominal= 0.335,
    final capPowCor_GTG=
     [  0,          50,          55,          60,          65,          70,          75,          80;
      100, 1.031375502, 1.014056225, 0.996360442, 0.975778112, 0.955948795, 0.933609438, 0.911897590],
    final effCor_GTG=
     [  0,          50,          55,          60,          65,          70,          75,          80;
       10, 0.341039835, 0.322986304, 0.305405131, 0.299930896, 0.295153535, 0.288639328, 0.282432532;
       20, 0.533411518, 0.527695895, 0.521986643, 0.514922575, 0.507844338, 0.499739695, 0.491327542;
       30, 0.641687373, 0.636618553, 0.631318341, 0.624507000, 0.618034404, 0.610122863, 0.602094811;
       40, 0.713465162, 0.709018886, 0.704181059, 0.698422839, 0.692526711, 0.685231078, 0.677685153;
       50, 0.773084912, 0.769330311, 0.765230414, 0.759754249, 0.754342846, 0.748052815, 0.741377806;
       60, 0.840297822, 0.836731571, 0.832772753, 0.827519844, 0.822208058, 0.815455001, 0.808323158;
       70, 0.904188136, 0.899945084, 0.897141994, 0.890108430, 0.884067328, 0.877070052, 0.869881537;
       80, 0.954183680, 0.950166872, 0.946710932, 0.940444870, 0.935191483, 0.928032279, 0.921202437;
       90, 0.990320992, 0.986022716, 0.982253482, 0.976751520, 0.972235474, 0.963976471, 0.957550782;
      100, 1.004527075, 1.001506196, 0.998027395, 0.993169084, 0.988115636, 0.981791309, 0.974944759],
     final exhTempCor_GT=
     [  0,          50,          55,          60,          65,          70,          75,          80;
       10, 0.562674463, 0.543937269, 0.523419802, 0.530882983, 0.538811366, 0.547536277, 0.556675654;
       20, 0.805165479, 0.806840000, 0.808168671, 0.810154194, 0.812167589, 0.814696406, 0.817101669;
       30, 0.920781937, 0.923718377, 0.926198124, 0.929492669, 0.932649429, 0.936782034, 0.940549988;
       40, 1.030472201, 1.034103964, 1.037302060, 1.041358893, 1.045357809, 1.050351519, 1.055027929;
       50, 1.093691020, 1.096664895, 1.099979986, 1.104932251, 1.110978323, 1.112153272, 1.115721075;
       60, 1.057970028, 1.060510965, 1.063180399, 1.067106427, 1.070907611, 1.075909374, 1.080681091;
       70, 1.019200503, 1.024309848, 1.023077488, 1.033648465, 1.040699199, 1.045837038, 1.051002663;
       80, 1.016283643, 1.018579221, 1.021941352, 1.025076115, 1.028778484, 1.033764672, 1.038891995;
       90, 0.977312952, 0.980689677, 0.982764695, 0.986691381, 0.990313346, 0.995499419, 1.000392576;
      100, 0.995944040, 0.998269555, 1.001011874, 1.004737888, 1.008650584, 1.013200191, 1.018272351],
     final exhMasCor_GT=
     [  0,          50,           55,          60,         65,          70,          75,          80;
       10, 0.776406964, 0.862628043, 0.955235631, 0.946256014, 0.936419874, 0.926954580, 0.916726659;
       20, 0.596536494, 0.596368092, 0.596503010, 0.595692722, 0.595143242, 0.594198577, 0.593644664;
       30, 0.609764285, 0.606671656, 0.603806928, 0.599763730, 0.596051776, 0.591489954, 0.587333748;
       40, 0.626049963, 0.620970515, 0.616015547, 0.609771640, 0.603819216, 0.596945621, 0.590398265;
       50, 0.660401723, 0.654307407, 0.647931249, 0.639857199, 0.631537809, 0.625045850, 0.617619479;
       60, 0.736379447, 0.729482847, 0.722440341, 0.713671721, 0.705283437, 0.695724869, 0.686610287;
       70, 0.810299531, 0.801127361, 0.795269509, 0.781737786, 0.770509792, 0.759737085, 0.749175166;
       80, 0.861718756, 0.854097685, 0.844378333, 0.835264392, 0.825018323, 0.813190198, 0.801521141;
       90, 0.956998742, 0.947937171, 0.938763667, 0.927125632, 0.914684856, 0.903017749, 0.889108434;
      100, 1.019169896, 1.008667824, 0.997681345, 0.984378720, 0.971387018, 0.956928574, 0.942594612]);

  end Taurus70;

  model ToppingCycleOld
      extends Modelica.Blocks.Icons.Block;
   //Nominal condition
    parameter Modelica.Units.SI.Power P_nominal = per.P_nominal
    "Gas turbine power generation capacity"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.SI.Temperature TExh_nominal = per.TExh_nominal
    "Nominal exhaust gas temperature"
    annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.SI.MassFlowRate mExh_nominal = per.mExh_nominal
    "Nominal exhaust mass flow rate"
    annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.SI.Efficiency eta_nominal=per.eta_nominal
    "Nominal gas turbine efficiency"
      annotation (Dialog(group="Nominal condition"));
    // Natural gas properties
    parameter Modelica.Units.SI.SpecificEnthalpy  LHVFue = per.LHVFue
     "Lower heating value";

    // Coefficients for off-design correction factor functions
  //  parameter Real a_gas[:] = per.a_gas
    //"Coefficients for gas turbine efficiency"
   // annotation (Dialog(tab="Advanced", group="Off-design condition"));
   // parameter Real a_exhT[:] = {1.4041,0.373,-0.7931,0,0}
   // "Coefficients for exhaust temperature"
  //  annotation (Dialog(tab="Advanced", group="Off-design condition"));
   // parameter Real a_exhM[:] = {0.351,0.139,0.5182,0,0}
     //"Coefficients for exhaust mass flow"
   //  annotation (Dialog(tab="Advanced", group="Off-design condition"));

    // Data input
    parameter Buildings.Fluid.CHPs.DistrictCHP.Obsolete.Taurus70_11100 per
      "Records of gas turbine performance data" annotation (choicesAllMatching=
          true, Placement(transformation(extent={{-80,-78},{-60,-58}})));

   Modelica.Blocks.Tables.CombiTable2Ds eleCap_CorFac(
   final table=per.capPowCor_GTG, final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
      "Look-up table that represents a set of efficiency curves varying with both the outdoor air temperature and the part load ratio"
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

    Modelica.Blocks.Tables.CombiTable2Ds gasTurEff_CorFac(
    final table=per.effCor_GTG, final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
      "Look-up table that represents a set of efficiency curves varying with both the outdoor air temperature and the part load ratio"
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

    Modelica.Blocks.Tables.CombiTable2Ds exhT_CorFac(
    final table=per.exhTempCor_GT,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
      annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

    Modelica.Blocks.Tables.CombiTable2Ds exhMas_CorFac(
    final table=per.exhMasCor_GT, final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
      annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
    degC_to_degF1 from_degF
      annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

    Modelica.Blocks.Interfaces.RealInput y "Part load ratio"
     annotation (
        Placement(transformation(extent={{-140,20},{-100,60}}),
          iconTransformation(extent={{-140,20},{-100,60}})));

    Modelica.Blocks.Interfaces.RealInput TSet "Ambient temperature"
      annotation (Placement(
          transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
            extent={{-140,-60},{-100,-20}})));
    Modelica.Blocks.Interfaces.RealOutput PEle(
    final quantity= "Power",
    final unit = "W")
      annotation (Placement(
          transformation(extent={{100,64},{132,96}}), iconTransformation(extent={{100,64},
              {132,96}})));
    Modelica.Blocks.Interfaces.RealOutput mFue(
    final unit= "kg/s")
      annotation (Placement(
          transformation(extent={{100,4},{134,38}}),  iconTransformation(extent={{100,4},
              {134,38}})));
    Modelica.Blocks.Interfaces.RealOutput TExh(
    final quantity="ThermodynamicTemperature",
    final unit = "degC")
      annotation (Placement(
          transformation(
          extent={{-17,-17},{17,17}},
          rotation=-90,
          origin={81,-117}), iconTransformation(
          extent={{-19,-19},{19,19}},
          rotation=-90,
          origin={81,-119})));
    Modelica.Blocks.Interfaces.RealOutput mExh(
    final unit= "kg/s")
      annotation (Placement(
          transformation(
          extent={{-19,-19},{19,19}},
          rotation=-90,
          origin={41,-119}),iconTransformation(
          extent={{-19,-19},{19,19}},
          rotation=-90,
          origin={19,-119})));

    Modelica.Blocks.Sources.Constant fulCap(k=100)
      "Full power generation capacity"
      annotation (Placement(transformation(extent={{-88,70},{-68,90}})));
    Buildings.Controls.OBC.CDL.Reals.Multiply pow
      annotation (Placement(transformation(extent={{40,70},{60,90}})));
    Modelica.Blocks.Sources.RealExpression loaFac(y=loaPer.u)
      annotation (Placement(transformation(extent={{0,80},{20,100}})));
  protected
    Buildings.Controls.OBC.CDL.Reals.Divide groHea
      "Gross heat input into the system"
      annotation (Placement(transformation(extent={{40,20},{60,40}})));
    Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter eleCap(
    final k=P_nominal) "Fuel mass flow rate computation"
      annotation (Placement(transformation(extent={{0,60},{20,80}})));
    Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter nomHea(
    final k=1/LHVFue)    "Low heating value"
      annotation (Placement(transformation(extent={{72,10},{92,30}})));

    Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gasTurEff(final k=
          eta_nominal) "Gas turbine efficiency computation"
      annotation (Placement(transformation(extent={{0,20},{20,40}})));
    Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter exhTemp(final k=
          TExh_nominal) "Exhaust temperature computation"
      annotation (Placement(transformation(extent={{0,-20},{20,0}})));
    Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter exhMas(final k=
          mExh_nominal) "Exhaust mass flow rate computation"
      annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
    Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter loaPer(final k=100)
      "Transfer from load ratio to load percentage"
      annotation (Placement(transformation(extent={{-88,30},{-68,50}})));
  equation
    connect(exhT_CorFac.y, exhTemp.u)
      annotation (Line(points={{-19,-10},{-2,-10}}, color={0,0,127}));
    connect(exhMas_CorFac.y, exhMas.u)
      annotation (Line(points={{-19,-50},{-2,-50}}, color={0,0,127}));
    connect(TSet, from_degF.u)
      annotation (Line(points={{-120,-40},{-92,-40}}, color={0,0,127}));
    connect(loaPer.u, y)
      annotation (Line(points={{-90,40},{-120,40}}, color={0,0,127}));
    connect(gasTurEff_CorFac.u1, loaPer.y) annotation (Line(points={{-42,36},{-60,
            36},{-60,40},{-66,40}}, color={0,0,127}));
    connect(exhT_CorFac.u1, loaPer.y) annotation (Line(points={{-42,-4},{-60,-4},{
            -60,40},{-66,40}}, color={0,0,127}));
    connect(exhMas_CorFac.u1, loaPer.y) annotation (Line(points={{-42,-44},{-60,-44},
            {-60,40},{-66,40}}, color={0,0,127}));
    connect(gasTurEff_CorFac.u2, from_degF.y) annotation (Line(points={{-42,24},{-50,
            24},{-50,-40},{-68,-40}}, color={0,0,127}));
    connect(exhT_CorFac.u2, from_degF.y) annotation (Line(points={{-42,-16},{-50,-16},
            {-50,-40},{-68,-40}}, color={0,0,127}));
    connect(exhMas_CorFac.u2, from_degF.y) annotation (Line(points={{-42,-56},{-50,
            -56},{-50,-40},{-68,-40}}, color={0,0,127}));
    connect(gasTurEff.u, gasTurEff_CorFac.y)
      annotation (Line(points={{-2,30},{-19,30}}, color={0,0,127}));
    connect(eleCap_CorFac.u2, from_degF.y) annotation (Line(points={{-42,64},{-50,
            64},{-50,-40},{-68,-40}}, color={0,0,127}));
    connect(fulCap.y, eleCap_CorFac.u1) annotation (Line(points={{-67,80},{-60,80},
            {-60,76},{-42,76}}, color={0,0,127}));
    connect(eleCap_CorFac.y, eleCap.u)
      annotation (Line(points={{-19,70},{-2,70}}, color={0,0,127}));
    connect(gasTurEff.y, groHea.u2) annotation (Line(points={{22,30},{30,30},{30,
            24},{38,24}},
                      color={0,0,127}));
    connect(exhTemp.y, TExh)
      annotation (Line(points={{22,-10},{81,-10},{81,-117}}, color={0,0,127}));
    connect(exhMas.y, mExh)
      annotation (Line(points={{22,-50},{41,-50},{41,-119}}, color={0,0,127}));
    connect(nomHea.y, mFue)
      annotation (Line(points={{94,20},{106,20},{106,21},{117,21}},
                                                  color={0,0,127}));
    connect(nomHea.u, groHea.y) annotation (Line(points={{70,20},{66,20},{66,30},
            {62,30}},color={0,0,127}));
    connect(pow.y, PEle)
      annotation (Line(points={{62,80},{116,80}}, color={0,0,127}));
    connect(loaFac.y, pow.u1) annotation (Line(points={{21,90},{32,90},{32,86},{
            38,86}}, color={0,0,127}));
    connect(eleCap.y, pow.u2) annotation (Line(points={{22,70},{30,70},{30,74},{
            38,74}}, color={0,0,127}));
    connect(pow.y, groHea.u1) annotation (Line(points={{62,80},{80,80},{80,60},{
            32,60},{32,36},{38,36}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ToppingCycleOld;

  package Examples

    model CombinedCycleCHP
      extends Modelica.Icons.Example;
      package MediumSte = Buildings.Media.Steam
        "Steam medium - Medium model for port_b (outlet)";
      package MediumWat =
          Buildings.Media.Specialized.Water.TemperatureDependentDensity
        "Water medium - Medium model for port_a (inlet)";

      Combined combinedCyclePowerPlant
        annotation (Placement(transformation(extent={{-20,-24},{20,24}})));
      Modelica.Blocks.Sources.CombiTimeTable LoadProfile(table=[0,1.0; 14400,1.0;
            28800,1.0; 43200,1.0; 57600,0.8; 72000,0.5; 86400,0.5])
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
      Modelica.Blocks.Sources.CombiTimeTable AmbientTemperature(table=[0.0,25;
            14400,25; 28800,25; 43200,23; 57600,22; 72000,23; 86400,25])
        annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
      Buildings.Fluid.Sources.Boundary_pT sou(
        redeclare package Medium = MediumWat,
        use_p_in=false,
        p=1100000,
        T=333.15,
        nPorts=1)
        annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
      Modelica.Fluid.Sources.FixedBoundary bou(
        redeclare package Medium = MediumSte,
        p=1000000,
        T=523.15,
        nPorts=1) "Boundary condition"
        annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
      Modelica.Blocks.Continuous.Integrator mFuel(y(unit="kg/s"))
        "Mass flow of fuel consumption "
        annotation (Placement(transformation(extent={{60,20},{80,40}})));
      Modelica.Blocks.Continuous.Integrator STG_Ele(y(unit="W"))
        "Steam turbine electrical energy generated"
        annotation (Placement(transformation(extent={{60,-20},{80,0}})));
      Modelica.Blocks.Continuous.Integrator GTG_Ele(y(unit="W"))
        "Gas turbine electrical energy generated"
        annotation (Placement(transformation(extent={{60,60},{80,80}})));
    equation
      connect(combinedCyclePowerPlant.port_b, bou.ports[1]) annotation (Line(points=
             {{20,0},{40,0},{40,-50},{60,-50}}, color={0,127,255}));
      connect(LoadProfile.y[1], combinedCyclePowerPlant.y) annotation (Line(points=
              {{-59,70},{-40,70},{-40,20},{-24,20},{-24,19.2}}, color={0,0,127}));
      connect(AmbientTemperature.y[1], combinedCyclePowerPlant.TAmb)
        annotation (Line(points={{-59,10},{-60,10},{-60,9.6},{-24,9.6}}, color=
              {0,0,127}));
      connect(combinedCyclePowerPlant.PEle, GTG_Ele.u) annotation (Line(points={{22,
              18.24},{22,20},{40,20},{40,70},{58,70}},color={0,0,127}));
      connect(combinedCyclePowerPlant.PEle_ST, STG_Ele.u) annotation (Line(points={{22,9.6},
              {22,10},{52,10},{52,-10},{58,-10}},          color={0,0,127}));
      connect(combinedCyclePowerPlant.mFue, mFuel.u) annotation (Line(points={{22.4,
              15.36},{52,15.36},{52,30},{58,30}},
                                          color={0,0,127}));
      connect(combinedCyclePowerPlant.port_a, sou.ports[1]) annotation (Line(points=
             {{-20,0},{-38,0},{-38,-50},{-60,-50},{-60,-50}}, color={0,127,255}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end CombinedCycleCHP;
  end Examples;

  package Validation

    model RatSteMasToExhMas
      extends Modelica.Icons.Example;
      BaseClasses.SteamToExhaustMassFlowRatio ratSteMasToExhMas(a={-0.4726,
            0.6840})
        annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
      Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TExh(
        y(final unit="degC", displayUnit="degC"),
        final height=30,
        final duration=360,
        final offset=510,
        final startTime=600) "Exhaust gas temperature"
        annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
      .Buildings.Fluid.CHPs.DistrictCHP.Obsolete.degC_to_degF1 Temp_toF
        "Convert the temperature unit"
        annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    equation
      connect(Temp_toF.u, TExh.y)
        annotation (Line(points={{-42,0},{-58,0}}, color={0,0,127}));
      connect(Temp_toF.y, ratSteMasToExhMas.TExh)
        annotation (Line(points={{-18,0},{-14,0},{-14,4},{-10,4}},
                                                   color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end RatSteMasToExhMas;

    model ExhTemp
      extends Modelica.Icons.Example;
      ExhaustTemperature exhTemp(a={1.4041,0.373,-0.7931,0,0}, TExh_des=510)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Buildings.Controls.OBC.CDL.Reals.Sources.Ramp LoaFac(
        y(final unit="K", displayUnit="degC"),
        final height=0.4,
        final duration=360,
        final offset=0.6,
        final startTime=600) "Part load ratio"
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAmb(k=15, y(final unit=
              "K", displayUnit="degC")) "Ambient temperature"
        annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
    equation
      connect(LoaFac.y, exhTemp.loaFac) annotation (Line(points={{-58,30},{-40,30},
              {-40,3},{-12,3}}, color={0,0,127}));
      connect(exhTemp.TAmb, TAmb.y) annotation (Line(points={{-12,-5},{-40,-5},{
              -40,-30},{-58,-30}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end ExhTemp;

    model ExhMas
      extends Modelica.Icons.Example;
      ExhaustMassFlow exhMas(a={0.351,0.139,0.5182,0,0}, mExh_des=28.64)
        annotation (Placement(transformation(extent={{-10,-10},{12,12}})));
      Buildings.Controls.OBC.CDL.Reals.Sources.Ramp LoaFac(
        y(final unit="K", displayUnit="degC"),
        final height=0.4,
        final duration=360,
        final offset=0.6,
        final startTime=600) "Part load ratio"
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAmb(k=15, y(final unit=
              "K", displayUnit="degC")) "Ambient temperature"
        annotation (Placement(transformation(extent={{-80,-42},{-60,-22}})));
    equation
      connect(exhMas.loaFac, LoaFac.y) annotation (Line(points={{-12.2,4.3},{-40,
              4.3},{-40,30},{-58,30}}, color={0,0,127}));
      connect(exhMas.TAmb, TAmb.y) annotation (Line(points={{-12.2,-4.5},{-40,
              -4.5},{-40,-32},{-58,-32}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end ExhMas;

  end Validation;

  block GasTurbineGeneratorEfficiency "Efficiency curve for gas turbine electrical generation efficiency,
   function of two input variables"

    extends Modelica.Blocks.Icons.Block;

    parameter Real a[6] "Polynomial coefficient";
    parameter Real eta_nominal "Nominal gas turbine efficiency";

    Buildings.Controls.OBC.CDL.Interfaces.RealInput loaFac(
      final unit="1") "Load factor in a range of 0 to 1"
       annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
          iconTransformation(extent={{-140,20},{-100,60}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb(
      final unit="degC",
      final quantity = "ThermodynamicTemperature")
      "Ambient temperature in degree Celsius"
       annotation (Placement(transformation(extent={{-140,-60},
              {-100,-20}}), iconTransformation(extent={{-140,-60},{-100,-20}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput eta(
      final unit="1") "Efficiency"
       annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  protected
    Real y(unit="1") "Efficiency";
    constant Real etaSma=0.01 "Small value for eta if y is zero";
    Modelica.Units.NonSI.Temperature_degF TAmb_degF
     "Ambient temperature in degree Fahrenheit";
    Real loaPer
     "Load percentage";
  algorithm
    TAmb_degF := TAmb*(9/5) +32;
    loaPer:= loaFac*100;

  equation
    y = eta_nominal*BaseClasses.Functions.MultivariatePolynomialCurve(
        a=a,
        x1=loaPer,
        x2=TAmb_degF)
      "Efficiency calculated as a function of load factor and ambient temperature";
    eta = max(y,etaSma)
    "Corrected efficiency, ensuring that efficiency is not zero";

  end GasTurbineGeneratorEfficiency;

  block ExhaustTemperature
    "This is a correlation function for exhaust temperature"
    extends Modelica.Blocks.Icons.Block;
    parameter Real a[6] "Polynominal coefficient";
    parameter Modelica.Units.NonSI.Temperature_degC TExh_nominal
     "Nominal exhaust gas temperature";
    Buildings.Controls.OBC.CDL.Interfaces.RealInput loaFac(
      final unit="1") "Load factor"
      annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb(
      final unit="degC",
      final quantity = "ThermodynamicTemperature")
      "Ambient temperature"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput TExh(
      final unit="degC",
      final quantity = "ThermodynamicTemperature")
       "Exhaust gas temperature"
      annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-30},{140,10}})));

  protected
     Modelica.Units.NonSI.Temperature_degF TAmb_degF
     "Ambient temperature in degree Fahrenheit";
     Real loaPer
     "Load percentage";
      Modelica.Units.NonSI.Temperature_degF TExh_nominal_degF
     "Nominal exhaust tempearture in degree Fahrenheit";
      Modelica.Units.NonSI.Temperature_degF TExh_degF
     "Exhaust tempearture in degree Fahrenheit";

  algorithm
    TAmb_degF := TAmb*(9/5) + 32;
    loaPer:= loaFac*100;
    TExh_nominal_degF:=TExh_nominal*(9/5) + 32;
    TExh:= (TExh_degF-32)*(5/9);

  equation
  // Calculate exhaust gas temperature for off-design conditions
  // using the product of the nominal value and the correction factor.
    TExh_degF = TExh_nominal_degF*
      BaseClasses.Functions.MultivariatePolynomialCurve(
        a=a,
        x1=loaPer,
        x2=TAmb_degF);

  end ExhaustTemperature;

  block ExhaustMassFlow
    "This is a correlation function of exhaust mass flow rate"
     extends Modelica.Blocks.Icons.Block;
    parameter Real a[6] "Polynominal coefficient";
    parameter Modelica.Units.SI.MassFlowRate mExh_nominal "Norminal exhaust gas mass flow rate";

    Buildings.Controls.OBC.CDL.Interfaces.RealInput loaFac(
      final unit="1") "Load factor"
      annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb(
      final unit="degC",
      final quantity = "ThermodynamicTemperature")
       "Ambient temperature"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput mExh(
      final unit="kg/s") "Exhaust gas mass flow rate"
      annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-30},{140,10}})));

  protected
     Modelica.Units.NonSI.Temperature_degF TAmb_degF
     "Ambient temperature in degree Fahrenheit";
     Real loaPer
     "Load percentage";

  algorithm
    TAmb_degF := TAmb*(9/5) +32;
    loaPer:= loaFac*100;

  equation
  // Calculate exhaust gas mass flow rate for off-design conditions
  // using the product of the nominal value and the correction factor.
    mExh = mExh_nominal*BaseClasses.Functions.MultivariatePolynomialCurve(
        a=a,
        x1=loaPer,
        x2=TAmb_degF);

  end ExhaustMassFlow;

  function SteamTurbineGeneration
    input Modelica.Units.NonSI.Temperature_degF TExh
      "Exhaust gas temperature";
    input Real a[3]={-4.8765, -4E-06, 0.009}
      "Coefficients";
    output Real y
      "Power generation efficiency range from 0 to 1";

  protected
   Real x = TExh;
   Real xSq = x^2;

  algorithm
    y := a[1] + a[2]*xSq + a[3]*x;

  end SteamTurbineGeneration;

  block SteamTurbine "This is a steam turbine module"
      extends Modelica.Blocks.Icons.Block;
    // Parameters
    parameter Real a_ST[:]={-4.8765, -4E-06, 0.009}
    "Polynominal coefficients for steam turbine power generation 
   efficiency function";
    parameter Modelica.Units.NonSI.Temperature_degC TSta = 87.778
      "Exhaust stack temperature in Celsius";
    Modelica.Blocks.Interfaces.RealInput TExh(
    final quantity="ThermodynamicTemperature",
    final unit = "degC") "Gas turbine exhaust gas temperature"
     annotation (Placement(
          transformation(extent={{-140,20},{-100,60}}), iconTransformation(
            extent={{-140,20},{-100,60}})));
    Modelica.Blocks.Interfaces.RealInput mExh(
    final unit= "kg/s")
    "Gas turbine exhaust gas mass flow rate"
     annotation (Placement(
          transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
            extent={{-140,-60},{-100,-20}})));
    Modelica.Blocks.Interfaces.RealOutput PEle_ST(
    final quantity= "Power",
    final unit = "W")
    "Steam turbine generator power generation"
     annotation (Placement(
          transformation(extent={{100,20},{138,58}}), iconTransformation(
            extent={{100,20},{138,58}})));
    Modelica.Blocks.Interfaces.RealOutput Q_RemSte(
    final quantity= "Power",
    final unit = "W")
      "Remaining steam energy flow after power generation" annotation (Placement(
          transformation(extent={{100,-58},{136,-22}}), iconTransformation(extent={{100,-58},
              {136,-22}})));
    BaseClasses.SteamTurbineGeneration steTur(final a=a_ST)
      annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
    BaseClasses.HRSGEfficiency heaExcEff(final TSta=TSta)
      annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
    BaseClasses.WasteHeatEnthalpy wasEnt(final TSta=TSta)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    Modelica.Blocks.Sources.RealExpression remStemEne(y=supSte.y - P_ST.y)
      annotation (Placement(transformation(extent={{20,-56},{62,-24}})));

    Modelica.Blocks.Interfaces.RealInput TAmb(
    final quantity="ThermodynamicTemperature",
    final unit="degC") "Ambient temperature" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
            extent={{-140,-20},{-100,20}})));
  protected
    Buildings.Controls.OBC.CDL.Reals.Multiply heaRec
      "Heat generation within the engine"
      annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
    Buildings.Controls.OBC.CDL.Reals.Multiply supSte
      "Superheated steam energy "
      annotation (Placement(transformation(extent={{30,0},{50,20}})));
  equation
    connect(heaRec.y, supSte.u2) annotation (Line(points={{12,-20},{20,-20},{
            20,4},{28,4}}, color={0,0,127}));
    connect(remStemEne.y, Q_RemSte)
      annotation (Line(points={{64.1,-40},{118,-40}}, color={0,0,127}));
    connect(steTurEff.TExh, TExh) annotation (Line(points={{-62,80},{-80,80},{-80,
            40},{-120,40}},      color={0,0,127}));
    connect(heaExcEff.TExh, TExh)
      annotation (Line(points={{-62,44},{-80,44},{-80,40},{-120,40}},
                                                    color={0,0,127}));
    connect(wasEnt.TExh, TExh) annotation (Line(points={{-62,4},{-80,4},{-80,40},{
            -120,40}},      color={0,0,127}));
    connect(mExh, heaRec.u2) annotation (Line(points={{-120,-40},{-20,-40},{
            -20,-26},{-12,-26}}, color={0,0,127}));
    connect(heaExcEff.eta_HRSG, supSte.u1) annotation (Line(points={{-38,40},
            {0,40},{0,16},{28,16}}, color={0,0,127}));
    connect(heaExcEff.TAmb, TAmb) annotation (Line(points={{-62,36},{-72,36},{-72,
            0},{-120,0}},   color={0,0,127}));
    connect(wasEnt.TAmb, TAmb) annotation (Line(points={{-62,-4},{-72,-4},{-72,0},
            {-120,0}},  color={0,0,127}));
    connect(heaRec.u1, wasEnt.wasEnt) annotation (Line(points={{-12,-14},{-20,-14},
            {-20,0},{-38,0}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                 Rectangle(
            extent={{-100,100},{100,-100}},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Line(points={{-72,-55},{65,-55}}, color={255,255,255}),
          Line(points={{-58,73},{-58,-66}}, color={255,255,255}),
          Polygon(
            points={{-58,85},{-66,63},{-50,63},{-58,85}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{71,-55},{49,-47},{49,-63},{71,-55}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-58,-12},{-22,-12},{2,20},{24,28},{50,30}},
            color={255,255,255},
            smooth=Smooth.Bezier)}),                               Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end SteamTurbine;

  model degC_to_degF "Unit conversion for temperature"
     extends Modelica.Icons.Example;

    Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TExh(
      y(final unit="C", displayUnit="degC"),
      final height=30,
      final duration=360,
      final offset=1899,
      final startTime=600) "Exhaust gas temperature"
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    .Buildings.Fluid.CHPs.DistrictCHP.Obsolete.degC_to_degF1 Temp_toF
      "Convert the temperature unit"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(Temp_toF.u, TExh.y)
      annotation (Line(points={{-12,0},{-58,0}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end degC_to_degF;

  function ExhaustEnthalpy
    "Correlation function used to calculate the relative enthalpy for waste heat recovery"
    extends Modelica.Icons.Function;

    input Modelica.Units.NonSI.Temperature_degF TExh
      "Exhaust gas temperature in degrees Fahrenheit";
    input Modelica.Units.NonSI.Temperature_degF TSta
      "Exhaust stack temperature in degrees Fahrenheit";
    input Modelica.Units.NonSI.Temperature_degF TAmb
      "Ambient temperature in degrees Fahrenheit";
    output Real hWas
      "Waste heat specific enthalpy (Btu/lb)";

  algorithm
    if abs(TAmb -59) < abs(TAmb-77) then
    // The zero ethalpy reference tempeature is set at 59°F
    hWas:=(0.3003*TExh - 55.576)-(0.2443*TSta- 13.571);
    else
    // The zero ethalpy reference tempeature is set at 77°F
    hWas:=(0.3003*TExh - 59.897)-(0.2443*TSta -17.892);
    end if;

  annotation (Documentation(info="<html>
<p>
This function calculates the waste heat specific enthalpy based on the exhaust and stack temperatures relative to a zero enthalpy reference temperature of either 59°F or 77°F.
</p>

<p>
The specific enthalpy for both the exhaust gas <i>h<sub>exh</sub></i> and exhaust stack 
<i>and h<sub>sta</sub></i> is estimated using a zero enthalpy reference temperature. 
When the reference temperature is set at 59°F, the corresponding correlation functions are:
</p>

<p align=\"center\">
<i>
h<sub>exh</sub> = 0.3003T<sub>exh</sub> - 55.576 [Btu/lb], 
<br/>
h<sub>sta</sub> = 0.2443T<sub>sta</sub> - 13.571 [Btu/lb].
</i>
</p>

<p>
When the reference temperature is set at 77°F, the corresponding correlation functions are:
</p>

<p align=\"center\">
<i>
h<sub>exh</sub> = 0.3003T<sub>exh</sub> - 59.897 [Btu/lb], 
<br/>
h<sub>sta</sub> = 0.2443T<sub>sta</sub> - 17.892 [Btu/lb],
</i>
</p>

<p>
where
<i>T<sub>exh</sub></i> is the exhaust gas temperature (in Fahrenheit) from the gas turbine, 
<i>T<sub>sta</sub></i> is the exhaust stack temperature (in Fahrenheit). 
</p>

<h4>References</h4>
<p>
Gülen, S. (2019). <i> Gas Turbine Combined Cycle Power Plants (1st ed.) </i>. CRC Press.
<a href=\"https://doi.org/10.1201/9780429244360\">[Link]</a>
</p>

<p>
Gülen, S. (2019) <i> Gas Turbines for Electric Power Generation.</i> Cambridge University Press. 
<a href=\"https://doi.org/10.1017/9781108241625\">[Link]</a>
</p>


</html>",
  revisions="<html>
<ul>
<li>
February 16, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
  end ExhaustEnthalpy;

  block degC_to_degF1
    "Block that converts temperature from degree Celsius to Fahrenheit"

    Buildings.Controls.OBC.CDL.Interfaces.RealInput u(
      final unit = "degC",
      final quantity = "ThermodynamicTemperature")
      "Temperature in degree Celsius"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
      final unit = "degF",
      final quantity = "ThermodynamicTemperature")
      "Temperature in degree Fahrenheit"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  protected
    constant Real k = 9./5. "Multiplier";
    constant Real p = 32. "Adder";

    Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
      final k = k) "Gain factor"
      annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));

    Buildings.Controls.OBC.CDL.Reals.AddParameter conv(
      final p = p) "Unit converter"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  equation
    connect(conv.y, y)
      annotation (Line(points={{12,0},{60,0},{60,0},{120,0}},color={0,0,127}));
    connect(u, gai.u)
      annotation (Line(points={{-120,0},{-70,0}}, color={0,0,127}));
    connect(gai.y, conv.u)
      annotation (Line(points={{-46,0},{-12,0}}, color={0,0,127}));

    annotation (
        defaultComponentName = "from_degF",
      Icon(graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{20,58}}, color={28,108,200}),
          Text(
            textColor={0,0,255},
            extent={{-150,110},{150,150}},
            textString="%name"),
          Text(
            extent={{20,-96},{100,-56}},
            textColor={0,0,127},
            textString="F"),
          Polygon(
          points={{90,0},{30,20},{30,-20},{90,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
          Line(points={{-90,0},{30,0}}, color={191,0,0}),
                                           Text(
            extent={{-12,76},{-92,-4}},
            textString="C",
            textColor={0,0,0})}),
          Documentation(info="<html>
<p>
Converts temperature given in degree Fahrenheit [degF] to kelvin [K].
</p>
</html>",   revisions="<html>
<ul>
<li>
November 29, 2021, by Michael Wetter:<br/>
Regenerated files with <code>Text</code> annotation using now the <code>textColor</code> attribute
rather than the deprecated <code>lineColor</code> attribute.
</li>
<li>
July 05, 2018, by Milica Grahovac:<br/>
Generated with <code>Buildings/Resources/src/Controls/OBC/UnitConversions/unit_converters.py</code>.<br/>
First implementation.
</li>
</ul>
</html>"));
  end degC_to_degF1;

  model BottomingCycle_test
    extends Modelica.Icons.Example;
      package MediumSte = Buildings.Media.Steam
      "Steam medium - Medium model for port_b (outlet)";
    package MediumWat =
        Buildings.Media.Specialized.Water.TemperatureDependentDensity
      "Water medium - Medium model for port_a (inlet)";

    // Parameters
    parameter Real a[:]={-0.23380344533,0.220477944738,-0.01476897980}
    "Polynominal coefficients for exhaust exergy efficiency";
    parameter Modelica.Units.NonSI.Temperature_degC TSta = 87.778
      "Exhaust stack temperature in Celsius";

     //parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=28.63 "Nominal mass flow rate";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=56.9972
      "Nominal mass flow rate";

    Buildings.Fluid.CHPs.DistrictCHP.BottomingCycle botCyc(
      final a=a,
      TSta=182.486,
      final m_flow_nominal=m_flow_nominal,
      a_SteMas={0.2150,0,0},
      steBoi(
        allowFlowReversal=false,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        p_start=3000000,
        V=800,
        VWat_start=0.8*botCyc.steBoi.V,
        VWat_flow(start=0.05),
        fixed_p_start=true),
      TSte(y=235),
      conPID(
        controllerType=Modelica.Blocks.Types.SimpleController.PI,
        k=2,
        Ti=300,
        Td=0,
        yMax=1,
        yMin=0,
        Ni=1,
        Nd=1,
        initType=Modelica.Blocks.Types.Init.NoInit,
        reverseActing=true,
        y(start=1, fixed=true)),
      pump(
        p_a_start=30000,
        p_b_start=3000000,
        m_flow_start=55,
        use_T_start=false,
        T_start=504.475,
        h_start=1e5),
      watLevel(y=0.8*botCyc.steBoi.V))
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Constant ambTemp(k=15) "Ambient temperature (deg_C)"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    Buildings.Fluid.Sources.Boundary_pT sou(
      redeclare package Medium = MediumWat,
      use_p_in=false,
      p=30000,
      nPorts=1,
      T=504.475)
      annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
    Modelica.Fluid.Sources.FixedBoundary bou(
      redeclare package Medium = MediumSte,
      p=1000000,
      T=523.15,
      nPorts=1) "Boundary condition"
      annotation (Placement(transformation(extent={{48,-50},{28,-30}})));
    Modelica.Blocks.Sources.Ramp exTem(
      height=-100,
      duration=3000,
      offset=750,
      startTime=0)
      annotation (Placement(transformation(extent={{-2,74},{18,94}})));
    Modelica.Blocks.Sources.Constant exhMass(k=520)
      "Exhaust gas mass flow rate (kg/s)"
      annotation (Placement(transformation(extent={{-80,-42},{-60,-22}})));
    Modelica.Blocks.Sources.Constant exhTep1(k=750) "Exhaust gas temperature (C)"
      annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  equation
    connect(botCyc.TAmb, ambTemp.y) annotation (Line(points={{-11.3,7},{-11.3,6},
            {-40,6},{-40,20},{-59,20}}, color={0,0,127}));
    connect(botCyc.port_a, sou.ports[1]) annotation (Line(points={{-10,1.11111},{
            -20,1.11111},{-20,-40},{-30,-40}},
                                  color={0,127,255}));
    connect(botCyc.port_b, bou.ports[1]) annotation (Line(points={{10,1.11111},{
            20,1.11111},{20,-40},{28,-40}},
                               color={0,127,255}));
    connect(exhMass.y, botCyc.mExh) annotation (Line(points={{-59,-32},{-54,-32},
            {-54,-20},{-40,-20},{-40,2},{-26,2},{-26,3.44444},{-11.3,3.44444}},
                                                                       color={0,0,
            127}));
    connect(botCyc.TExh, exhTep1.y) annotation (Line(points={{-11.3,10.3333},{
            -20,10.3333},{-20,60},{-59,60}},
                                color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end BottomingCycle_test;
end Obsolete;
