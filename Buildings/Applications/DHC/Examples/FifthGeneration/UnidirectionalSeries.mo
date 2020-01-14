within Buildings.Applications.DHC.Examples.FifthGeneration;
package UnidirectionalSeries
  "Model of 5th generation unidirectional series DHC (so-called reservoir network)"
  extends Modelica.Icons.ExamplesPackage;

  package Agents "Package with models for agents"
    model BoreField "Borefield model"
      extends Buildings.Fluid.Geothermal.Borefields.TwoUTubes(
        final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        final tLoaAgg(displayUnit="h") = 3600,
        final nSeg=5,
        TExt0_start=282.55,
        final z0=10,
        final dT_dz=0.02,
        final dynFil=true,
        borFieDat(
          final filDat=Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite(
              kFil=2.0,
              cFil=3040,
              dFil=1450),
          final soiDat=Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone(
              kSoi=2.3,
              cSoi=1000,
              dSoi=2600),
          final conDat=
              Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
              borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
              dp_nominal=35000,
              hBor=250,
              rBor=0.19,
              nBor=350,
              cooBor={dBor*{mod(i - 1, 10),floor((i - 1)/10)} for i in 1:350},
              rTub=0.04,
              kTub=0.4,
              eTub=0.0037,
              xC=0.08)),
        final show_T=true);

      final parameter Integer dBor = 10 "Distance between boreholes";
      Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W") "Heat extracted from soil"
        annotation (Placement(transformation(extent={{100,70},{120,90}})));
    equation
      connect(gaiQ_flow.y, Q_flow) annotation (Line(points={{1,80},{14,80},{14,54},{
              96,54},{96,80},{110,80}}, color={0,0,127}));
    end BoreField;

    model EnergyTransferStation
      "Model of a substation for heating hot water and chilled water production"
      replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium
        "Medium model for water"
        annotation (choicesAllMatching = true);
      outer
        Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Examples.DesignDataDHC
        datDes "DHC systenm design data";
      // SYSTEM GENERAL
      parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
        min=Modelica.Constants.eps)
        "Design cooling thermal power (always positive)"
        annotation (Dialog(group="Nominal conditions"));
      parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
        min=Modelica.Constants.eps)
        "Design heating thermal power (always positive)"
        annotation (Dialog(group="Nominal conditions"));
      parameter Modelica.SIunits.TemperatureDifference dT_nominal = 5
        "Water temperature drop/increase accross CHW HX, condenser or evaporator (always positive)"
        annotation (Dialog(group="Nominal conditions"));
      parameter Modelica.SIunits.Temperature TChiWatSup_nominal = 273.15 + 18
        "Chilled water supply temperature"
         annotation (Dialog(group="Nominal conditions"));
      parameter Modelica.SIunits.Temperature TChiWatRet_nominal=
        TChiWatSup_nominal + dT_nominal
        "Chilled water return temperature"
        annotation (Dialog(group="Nominal conditions"));
      parameter Modelica.SIunits.Temperature THeaWatSup_nominal = 273.15 + 40
        "Heating water supply temperature"
        annotation (Dialog(group="Nominal conditions"));
      parameter Modelica.SIunits.Temperature THeaWatRet_nominal=
        THeaWatSup_nominal - dT_nominal
        "Heating water return temperature"
        annotation (Dialog(group="Nominal conditions"));
      parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa") = 50000
        "Pressure difference at nominal flow rate (for each flow leg)"
        annotation(Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal(min=0)=
        abs(QHea_flow_nominal / cp_default / (THeaWatSup_nominal - THeaWatRet_nominal))
        "Heating water mass flow rate"
        annotation(Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal(min=0)=
        abs(QCoo_flow_nominal / cp_default / (TChiWatSup_nominal - TChiWatRet_nominal))
        "Heating water mass flow rate"
        annotation(Dialog(group="Nominal conditions"));
      // HEAT PUMP
      parameter Real COP_nominal(unit="1") = 5
        "Heat pump COP"
        annotation (Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.Temperature TConLvg_nominal = THeaWatSup_nominal
        "Condenser leaving temperature"
         annotation (Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.Temperature TConEnt_nominal = THeaWatRet_nominal
        "Condenser entering temperature"
         annotation (Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.Temperature TEvaLvg_nominal=
        TEvaEnt_nominal - dT_nominal
        "Evaporator leaving temperature"
         annotation (Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.Temperature TEvaEnt_nominal = datDes.TLooMin
        "Evaporator entering temperature"
         annotation (Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal(min=0)=
        abs(QHea_flow_nominal / cp_default / (TConLvg_nominal - TConEnt_nominal))
        "Condenser mass flow rate"
        annotation(Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal(min=0)=
        abs(heaPum.QEva_flow_nominal / cp_default / (TEvaLvg_nominal - TEvaEnt_nominal))
        "Evaporator mass flow rate"
        annotation(Dialog(group="Nominal conditions"));
      // CHW HX
      final parameter Modelica.SIunits.Temperature T1HexChiEnt_nominal=
        datDes.TLooMax
        "CHW HX primary entering temperature"
         annotation (Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.Temperature T2HexChiEnt_nominal=
        TChiWatRet_nominal
        "CHW HX secondary entering temperature"
         annotation (Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.MassFlowRate m1HexChi_flow_nominal(min=0)=
        abs(QCoo_flow_nominal / cp_default / dT_nominal)
        "CHW HX primary mass flow rate"
        annotation(Dialog(group="Nominal conditions"));
      final parameter Modelica.SIunits.MassFlowRate m2HexChi_flow_nominal(min=0)=
        abs(QCoo_flow_nominal / cp_default / (THeaWatSup_nominal - THeaWatRet_nominal))
        "CHW HX secondary mass flow rate"
        annotation(Dialog(group="Nominal conditions"));
      // Diagnostics
       parameter Boolean show_T = true
        "= true, if actual temperature at port is computed"
        annotation(Dialog(tab="Advanced",group="Diagnostics"));
      parameter Modelica.Fluid.Types.Dynamics mixingVolumeEnergyDynamics=
        Modelica.Fluid.Types.Dynamics.FixedInitial
        "Formulation of energy balance for mixing volume at inlet and outlet"
         annotation(Dialog(tab="Dynamics"));
      Modelica.Blocks.Interfaces.RealOutput PCom(final unit="W")
        "Power drawn by compressor"
        annotation (Placement(transformation(extent={{280,360},{320,400}}),
            iconTransformation(extent={{280,240},{320,280}})));
      Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W")
        "Power drawn by pumps motors"
        annotation (Placement(transformation(extent={{280,320},{320,360}}),
            iconTransformation(extent={{280,200},{320,240}})));
      Modelica.Blocks.Interfaces.RealOutput PHea(unit="W")
        "Total power consumed for space heating"
        annotation (Placement(transformation(extent={{280,280},{320,320}}),
            iconTransformation(extent={{280,160},{320,200}})));
      Modelica.Blocks.Interfaces.RealOutput PCoo(unit="W")
        "Total power consumed for space cooling"
        annotation (Placement(transformation(extent={{280,240},{320,280}}),
            iconTransformation(extent={{280,120},{320,160}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_a(
        redeclare final package Medium = Medium,
        h_outflow(start=Medium.h_default)) "Fluid connector a"
        annotation (Placement(transformation(extent={{-290,-10},{-270,10}}),
            iconTransformation(extent={{-300,-20},{-260,20}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_b(
        redeclare final package Medium = Medium,
        h_outflow(start=Medium.h_default)) "Fluid connector b"
        annotation (Placement(transformation(extent={{290,-10},{270,10}}),
            iconTransformation(extent={{298,-20},{258,20}})));
      Buildings.Fluid.Delays.DelayFirstOrder volMix_a(
        redeclare final package Medium = Medium,
        nPorts=3,
        final m_flow_nominal=(mEva_flow_nominal + m1HexChi_flow_nominal)/2,
        final allowFlowReversal=true,
        tau=600,
        final energyDynamics=mixingVolumeEnergyDynamics)
        "Mixing volume to break algebraic loops and to emulate the delay of the substation"
        annotation (Placement(transformation(extent={{-270,0},{-250,20}})));
      Buildings.Fluid.Delays.DelayFirstOrder volMix_b(
        redeclare final package Medium = Medium,
        nPorts=3,
        final m_flow_nominal=(mEva_flow_nominal + m1HexChi_flow_nominal)/2,
        final allowFlowReversal=true,
        tau=600,
        final energyDynamics=mixingVolumeEnergyDynamics)
        "Mixing volume to break algebraic loops and to emulate the delay of the substation"
        annotation (Placement(transformation(extent={{250,0},{270,20}})));
      // Components
      Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
        redeclare final package Medium1 = Medium,
        redeclare final package Medium2 = Medium,
        final m1_flow_nominal=mCon_flow_nominal,
        final m2_flow_nominal=mEva_flow_nominal,
        final dTEva_nominal=TEvaLvg_nominal - TEvaEnt_nominal,
        final dTCon_nominal=TConLvg_nominal - TConEnt_nominal,
        final allowFlowReversal1=false,
        final allowFlowReversal2=allowFlowReversal,
        final use_eta_Carnot_nominal=false,
        final COP_nominal=COP_nominal,
        final QCon_flow_nominal=QHea_flow_nominal,
        final dp1_nominal=dp_nominal,
        final dp2_nominal=dp_nominal)
        "Heat pump (index 1 for condenser side)"
        annotation (Placement(transformation(extent={{0,116},{-20,136}})));
      Examples.BaseClasses.Pump_m_flow pumEva(
        redeclare final package Medium = Medium,
        final m_flow_nominal=mEva_flow_nominal) "Evaporator pump"
        annotation (Placement(transformation(extent={{-110,110},{-90,130}})));
      Examples.BaseClasses.Pump_m_flow pum1HexChi(
        redeclare final package Medium = Medium,
        final m_flow_nominal=m1HexChi_flow_nominal)
        "Chilled water HX primary pump"
        annotation (Placement(transformation(extent={{-110,-330},{-90,-310}})));
      Modelica.Blocks.Interfaces.RealOutput mHea_flow
        "Mass flow rate used for heating (heat pump evaporator)" annotation (
          Placement(transformation(extent={{280,200},{320,240}}),
            iconTransformation(extent={{280,80},{320,120}})));
      Modelica.Blocks.Interfaces.RealOutput mCoo_flow
        "Mass flow rate used for cooling (CHW HX primary)"      annotation (
         Placement(transformation(extent={{280,160},{320,200}}),
            iconTransformation(extent={{280,40},{320,80}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
        redeclare package Medium = Medium,
        h_outflow(start=Medium.h_default))
        "Fluid connector a"
        annotation (Placement(transformation(extent={{-290,410},{-270,430}}),
            iconTransformation(extent={{-300,-140},{-260,-100}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
        redeclare final package Medium = Medium,
        h_outflow(start=Medium.h_default))
        "Fluid connector b"
        annotation (Placement(transformation(extent={{290,410},{270,430}}),
            iconTransformation(extent={{300,-140},{260,-100}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_aChi(
        redeclare final package Medium = Medium,
        h_outflow(start=Medium.h_default))
        "Fluid connector a"
        annotation (Placement(transformation(extent={{-290,-430},{-270,-410}}),
            iconTransformation(extent={{-300,-260},{-260,-220}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_bChi(
        redeclare final package Medium = Medium,
        h_outflow(start=Medium.h_default))
        "Fluid connector b"
        annotation (Placement(transformation(extent={{290,-430},{270,-410}}),
            iconTransformation(extent={{300,-262},{260,-222}})));
      Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexChi(
        redeclare final package Medium1 = Medium,
        redeclare final package Medium2 = Medium,
        final m1_flow_nominal=m1HexChi_flow_nominal,
        final m2_flow_nominal=m2HexChi_flow_nominal,
        final dp1_nominal=dp_nominal/2,
        final dp2_nominal=dp_nominal/2,
        configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
        final Q_flow_nominal=QCoo_flow_nominal,
        final T_a1_nominal=T1HexChiEnt_nominal,
        final T_a2_nominal=T2HexChiEnt_nominal,
        final allowFlowReversal1=allowFlowReversal,
        final allowFlowReversal2=allowFlowReversal) "Chilled water HX"
        annotation (Placement(transformation(extent={{-20,-344},{0,-324}})));
      Modelica.Blocks.Interfaces.RealInput TSetHeaWat
        "Heating water set point"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-300,200}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-300,240})));
      Modelica.Blocks.Interfaces.RealInput TSetChiWat
        "Chilled water set point"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-300,-180}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-300,160})));
      Buildings.Fluid.Delays.DelayFirstOrder volHeaWat(
        redeclare final package Medium = Medium,
        nPorts=5,
        final m_flow_nominal=mCon_flow_nominal,
        final allowFlowReversal=true,
        tau=600,
        final energyDynamics=mixingVolumeEnergyDynamics)
        "Mixing volume representing the decoupler of the HHW distribution system"
        annotation (Placement(transformation(extent={{-10,420},{10,440}})));
      Examples.BaseClasses.Pump_m_flow pumCon(
        redeclare package Medium = Medium,
        final m_flow_nominal=mCon_flow_nominal)
        "Condenser pump"
        annotation (Placement(transformation(extent={{70,130},{50,150}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort senT2HexChiLvg(
        redeclare package Medium = Medium,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=m2HexChi_flow_nominal)
        "Chilled water supply temperature (sensed)"
        annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={-160,-340})));
      Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysWitHol(
        uLow=1E-4*mHeaWat_flow_nominal,
        uHigh=0.01*mHeaWat_flow_nominal,
        trueHoldDuration=0,
        falseHoldDuration=30)
        annotation (Placement(transformation(extent={{-220,270},{-200,290}})));
      Buildings.Fluid.Sensors.MassFlowRate senMasFloHeaWat(
        redeclare final package Medium = Medium,
        allowFlowReversal=allowFlowReversal)
        "Heating water mass flow rate (sensed)"
        annotation (Placement(transformation(extent={{-250,430},{-230,410}})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=mCon_flow_nominal)
        annotation (Placement(transformation(extent={{-140,270},{-120,290}})));
      Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
        annotation (Placement(transformation(extent={{-190,270},{-170,290}})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=mEva_flow_nominal)
        annotation (Placement(transformation(extent={{-140,210},{-120,230}})));
      Buildings.Fluid.Delays.DelayFirstOrder volChiWat(
        redeclare final package Medium = Medium,
        nPorts=5,
        final m_flow_nominal=m2HexChi_flow_nominal,
        final allowFlowReversal=true,
        tau=600,
        final energyDynamics=mixingVolumeEnergyDynamics)
        "Mixing volume representing the decoupler of the CHW distribution system"
        annotation (Placement(transformation(extent={{-10,-420},{10,-440}})));
      Examples.BaseClasses.Pump_m_flow pum2CooHex(
        redeclare package Medium = Medium,
        final m_flow_nominal=m2HexChi_flow_nominal)
        "Chilled water HX secondary pump"
        annotation (Placement(transformation(extent={{70,-350},{50,-330}})));
      Buildings.Fluid.Sensors.MassFlowRate senMasFloChiWat(
        redeclare package Medium = Medium,
        allowFlowReversal=allowFlowReversal)
        "Chilled water mass flow rate (sensed)"
        annotation (Placement(transformation(extent={{-250,-430},{-230,-410}})));
      Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysWitHol1(
        uLow=1E-4*mChiWat_flow_nominal,
        uHigh=0.01*mChiWat_flow_nominal,
        trueHoldDuration=0,
        falseHoldDuration=30)
        annotation (Placement(transformation(extent={{-220,-230},{-200,-210}})));
      Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
        annotation (Placement(transformation(extent={{-190,-230},{-170,-210}})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gai2(k=m1HexChi_flow_nominal)
        annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort senTConLvg(
        redeclare final package Medium = Medium,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=mCon_flow_nominal)
        "Condenser water leaving temperature (sensed)"
        annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={-44,140})));
      Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat(
        each Ti=120,
        each yMax=1,
        each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
        reverseAction=true,
        each yMin=0) "PI controller for chilled water supply"
        annotation (Placement(transformation(extent={{-170,-190},{-150,-170}})));
      Buildings.Controls.OBC.CDL.Continuous.Product pro
        annotation (Placement(transformation(extent={{-88,-230},{-68,-210}})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gai4(k=1.1)
        annotation (Placement(transformation(extent={{-140,-270},{-120,-250}})));
      Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=1)
        annotation (Placement(transformation(extent={{230,250},{250,270}})));
      Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=2)
        annotation (Placement(transformation(extent={{230,290},{250,310}})));
      Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumHea(nin=2)
        "Total power drawn by pumps motors for space heating (ETS included, building excluded)"
        annotation (Placement(transformation(extent={{170,350},{190,370}})));
      Buildings.Fluid.Sources.Boundary_pT bouHea(
        redeclare final package Medium = Medium,
        nPorts=1)
        "Pressure boundary condition"
        annotation (Placement(transformation(extent={{-40,370},{-20,390}})));
      Buildings.Fluid.Sources.Boundary_pT bouChi(
        redeclare final package Medium = Medium,
        nPorts=1)
        "Pressure boundary condition"
        annotation (Placement(transformation(extent={{-40,-390},{-20,-370}})));
      Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumCoo(nin=2)
        "Total power drawn by pumps motors for space cooling (ETS included, building excluded)"
        annotation (Placement(transformation(extent={{170,310},{190,330}})));
      Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=2)
        annotation (Placement(transformation(extent={{230,330},{250,350}})));
      Medium.ThermodynamicState sta_a=
        Medium.setState_phX(port_a.p,
          noEvent(actualStream(port_a.h_outflow)),
          noEvent(actualStream(port_a.Xi_outflow))) if show_T
        "Medium properties in port_a";
      Medium.ThermodynamicState sta_b=
        Medium.setState_phX(port_b.p,
          noEvent(actualStream(port_b.h_outflow)),
          noEvent(actualStream(port_b.Xi_outflow))) if show_T
        "Medium properties in port_b";
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.specificHeatCapacityCp(Medium.setState_pTX(
          p = Medium.p_default,
          T = Medium.T_default,
          X = Medium.X_default))
        "Specific heat capacity of the fluid";
      final parameter Boolean allowFlowReversal = false
        "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);
    initial equation
      assert(QCoo_flow_nominal > 0,
        "In " + getInstanceName() +
        "Nominal cooling rate must be strictly positive. Obtained QCoo_flow_nominal = " +
        String(QCoo_flow_nominal));
      assert(QHea_flow_nominal > 0,
        "In " + getInstanceName() +
        "Nominal heating rate must be strictly positive. Obtained QHea_flow_nominal = " +
        String(QHea_flow_nominal));
    equation
      connect(volMix_a.ports[1], port_a) annotation (Line(points={{-262.667,0},
              {-280,0}},         color={0,127,255}));
      connect(pumEva.port_a, volMix_a.ports[2])
        annotation (Line(points={{-110,120},{-240,120},{-240,0},{-260,0}},
                                                               color={0,127,255}));
      connect(port_b, volMix_b.ports[1]) annotation (Line(points={{280,0},{
              257.333,0}},
                    color={0,127,255}));
      connect(volHeaWat.ports[1], port_bHeaWat)
        annotation (Line(points={{-3.2,420},{280,420}}, color={0,127,255}));
      connect(volHeaWat.ports[2], pumCon.port_a) annotation (Line(points={{-1.6,
              420},{-1.6,400},{80,400},{80,140},{70,140}},  color={0,127,255}));
      connect(port_aHeaWat, senMasFloHeaWat.port_a)
        annotation (Line(points={{-280,420},{-250,420}}, color={0,127,255}));
      connect(senMasFloHeaWat.port_b, volHeaWat.ports[3])
        annotation (Line(points={{-230,420},{0,420}}, color={0,127,255}));
      connect(senMasFloHeaWat.m_flow, hysWitHol.u) annotation (Line(points={{-240,
              409},{-240,280},{-222,280}},
                                      color={0,0,127}));
      connect(TSetHeaWat, heaPum.TSet) annotation (Line(points={{-300,200},{20,
              200},{20,135},{2,135}},
                                  color={0,0,127}));
      connect(hysWitHol.y, booToRea.u)
        annotation (Line(points={{-198,280},{-192,280}}, color={255,0,255}));
      connect(booToRea.y, gai.u)
        annotation (Line(points={{-168,280},{-142,280}}, color={0,0,127}));
      connect(gai.y, pumCon.m_flow_in) annotation (Line(points={{-118,280},{60,
              280},{60,152}},
                           color={0,0,127}));
      connect(gai1.y, pumEva.m_flow_in)
        annotation (Line(points={{-118,220},{-100,220},{-100,132}},
                                                                 color={0,0,127}));
      connect(booToRea.y, gai1.u) annotation (Line(points={{-168,280},{-160,280},
              {-160,220},{-142,220}},
                              color={0,0,127}));
      connect(volChiWat.ports[1], port_bChi)
        annotation (Line(points={{-3.2,-420},{280,-420}}, color={0,127,255}));
      connect(port_aChi, senMasFloChiWat.port_a)
        annotation (Line(points={{-280,-420},{-250,-420}}, color={0,127,255}));
      connect(senMasFloChiWat.port_b, volChiWat.ports[2])
        annotation (Line(points={{-230,-420},{-1.6,-420}},color={0,127,255}));
      connect(senMasFloChiWat.m_flow, hysWitHol1.u) annotation (Line(points={{-240,
              -409},{-240,-220},{-222,-220}},
                                        color={0,0,127}));
      connect(hysWitHol1.y, booToRea1.u)
        annotation (Line(points={{-198,-220},{-192,-220}}, color={255,0,255}));
      connect(booToRea1.y, gai2.u)
        annotation (Line(points={{-168,-220},{-142,-220}}, color={0,0,127}));
      connect(senT2HexChiLvg.T, conTChiWat.u_m) annotation (Line(points={{-160,
              -329},{-160,-192}},                color={0,0,127}));
      connect(TSetChiWat, conTChiWat.u_s) annotation (Line(points={{-300,-180},
              {-172,-180}},
                      color={0,0,127}));
      connect(gai2.y, pro.u2) annotation (Line(points={{-118,-220},{-100,-220},
              {-100,-226},{-90,-226}},
                                 color={0,0,127}));
      connect(pro.y, pum1HexChi.m_flow_in)
        annotation (Line(points={{-66,-220},{-40,-220},{-40,-280},{-100,-280},{
              -100,-308}},                                      color={0,0,127}));
      connect(conTChiWat.y, pro.u1) annotation (Line(points={{-148,-180},{-100,
              -180},{-100,-214},{-90,-214}},
                                       color={0,0,127}));
      connect(gai4.y, pum2CooHex.m_flow_in) annotation (Line(points={{-118,-260},
              {60,-260},{60,-328}},
                                  color={0,0,127}));
      connect(senMasFloChiWat.m_flow, gai4.u) annotation (Line(points={{-240,
              -409},{-240,-260},{-142,-260}},
                                       color={0,0,127}));
      connect(senTConLvg.port_b, volHeaWat.ports[4]) annotation (Line(points={{-54,140},
              {-60,140},{-60,400},{0,400},{0,420},{1.6,420}},
                                                           color={0,127,255}));
      connect(PPum, PPum)
        annotation (Line(points={{300,340},{300,340}}, color={0,0,127}));
      connect(heaPum.P, PCom) annotation (Line(points={{-21,126},{-28,126},{-28,
              100},{260,100},{260,380},{300,380}},
                     color={0,0,127}));
      connect(gai1.y, mHea_flow) annotation (Line(points={{-118,220},{300,220}},
                                                   color={0,0,127}));
      connect(gai4.y, mCoo_flow) annotation (Line(points={{-118,-260},{240,-260},
              {240,180},{300,180}},
                               color={0,0,127}));
      connect(mulSum.y, PCoo)
        annotation (Line(points={{252,260},{300,260}}, color={0,0,127}));
      connect(mulSum1.y, PHea)
        annotation (Line(points={{252,300},{300,300}}, color={0,0,127}));
      connect(pumCon.P, PPumHea.u[1]) annotation (Line(points={{49,149},{40,149},
              {40,260},{142,260},{142,360},{168,360},{168,361}},
                                             color={0,0,127}));
      connect(pumEva.P, PPumHea.u[2]) annotation (Line(points={{-89,129},{-89,
              128},{-80,128},{-80,160},{120,160},{120,360},{168,360},{168,359}},
                                                  color={0,0,127}));
      connect(bouHea.ports[1], volHeaWat.ports[5]) annotation (Line(points={{-20,380},
              {3.2,380},{3.2,420}}, color={0,127,255}));
      connect(bouChi.ports[1], volChiWat.ports[3]) annotation (Line(points={{-20,
              -380},{0,-380},{0,-420},{0,-420}},
                                             color={0,127,255}));
      connect(pum1HexChi.P, PPumCoo.u[1]) annotation (Line(points={{-89,-311},{
              160,-311},{160,320},{168,320},{168,321}},
                                              color={0,0,127}));
      connect(pum2CooHex.P, PPumCoo.u[2]) annotation (Line(points={{49,-331},{
              24,-331},{24,-332},{20,-332},{20,-220},{160,-220},{160,340},{168,
              340},{168,319}},                                      color={0,0,127}));
      connect(PPumHea.y, mulSum1.u[1]) annotation (Line(points={{192,360},{220,360},
              {220,301},{228,301}}, color={0,0,127}));
      connect(gai1.y, mulSum1.u[2]) annotation (Line(points={{-118,220},{200,
              220},{200,300},{228,300},{228,299}},           color={0,0,127}));
      connect(PPumCoo.y, mulSum.u[1]) annotation (Line(points={{192,320},{210,320},
              {210,260},{228,260}},color={0,0,127}));
      connect(PPumHea.y, mulSum2.u[1]) annotation (Line(points={{192,360},{200,360},
              {200,341},{228,341}}, color={0,0,127}));
      connect(PPumCoo.y, mulSum2.u[2]) annotation (Line(points={{192,320},{200,320},
              {200,340},{214,340},{214,339},{228,339}},
                                    color={0,0,127}));
      connect(mulSum2.y, PPum)
        annotation (Line(points={{252,340},{300,340}}, color={0,0,127}));
      connect(pum1HexChi.port_b, hexChi.port_a1) annotation (Line(points={{-90,
              -320},{-80,-320},{-80,-328},{-20,-328}}, color={0,127,255}));
      connect(hexChi.port_b1, volMix_b.ports[2]) annotation (Line(points={{0,
              -328},{8,-328},{8,-320},{260,-320},{260,0}}, color={0,127,255}));
      connect(pum2CooHex.port_b, hexChi.port_a2)
        annotation (Line(points={{50,-340},{0,-340}}, color={0,127,255}));
      connect(hexChi.port_b2, senT2HexChiLvg.port_a)
        annotation (Line(points={{-20,-340},{-150,-340}}, color={0,127,255}));
      connect(volChiWat.ports[4], pum2CooHex.port_a) annotation (Line(points={{
              1.6,-420},{6,-420},{6,-400},{80,-400},{80,-340},{70,-340}}, color=
             {0,127,255}));
      connect(senT2HexChiLvg.port_b, volChiWat.ports[5]) annotation (Line(
            points={{-170,-340},{-200,-340},{-200,-400},{3.2,-400},{3.2,-420}},
            color={0,127,255}));
      connect(volMix_a.ports[3], pum1HexChi.port_a) annotation (Line(points={{
              -257.333,0},{-260,0},{-260,-320},{-110,-320}}, color={0,127,255}));
      connect(pumEva.port_b, heaPum.port_a2)
        annotation (Line(points={{-90,120},{-20,120}}, color={0,127,255}));
      connect(heaPum.port_b2, volMix_b.ports[3]) annotation (Line(points={{0,120},
              {220,120},{220,0},{262.667,0}},      color={0,127,255}));
      connect(heaPum.port_b1, senTConLvg.port_a) annotation (Line(points={{-20,
              132},{-30,132},{-30,140},{-34,140}}, color={0,127,255}));
      connect(pumCon.port_b, heaPum.port_a1) annotation (Line(points={{50,140},
              {40,140},{40,132},{0,132}}, color={0,127,255}));
      annotation (
      defaultComponentName="ets",
      Documentation(info="<html>
<p>
Heating hot water is produced at low temperature (typically 40°C) with a water-to-water heat pump. 
Chilled water is produced at high temperature (typically 19°C) with a heat exchanger.
</p>
<p>
The time series data are interpolated using
Fritsch-Butland interpolation. This uses
cubic Hermite splines such that y preserves the monotonicity and
der(y) is continuous, also if extrapolated.
</p>
<p>
There is a control volume at each of the two fluid ports
that are exposed by this model. These approximate the dynamics
of the substation, and they also generally avoid nonlinear system
of equations if multiple substations are connected to each other.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 12, 2017, by Michael Wetter:<br/>
Removed call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1097\">issue 1097</a>.
</li>
</ul>
</html>"),
        Icon(coordinateSystem(extent={{-280,-280},{280,280}}, preserveAspectRatio=false),
         graphics={Rectangle(
            extent={{-280,-280},{280,280}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{18,-38},{46,-10}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
            Text(
              extent={{-169,-344},{131,-384}},
              lineColor={0,0,255},
              textString="%name"),
            Rectangle(
              extent={{-282,-234},{280,-250}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-280,-128},{280,-112}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-280,0},{280,8}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-280,0},{282,-8}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(extent={{-280,-460},{280,460}},
              preserveAspectRatio=false), graphics={Text(
              extent={{-106,-236},{-38,-264}},
              lineColor={0,0,127},
              pattern=LinePattern.Dash,
              textString="Add minimum pump flow rate")}));
    end EnergyTransferStation;

    package Controls "Package with controllers"
      block HeatingCurve "Reset of heating supply and return set point temperatures"
        extends Modelica.Blocks.Icons.Block;
        parameter Modelica.SIunits.Temperature THeaSup_nominal
          "Supply temperature space heating system at TOut_nominal"
          annotation (Dialog(group="Nominal conditions"));
        parameter Modelica.SIunits.Temperature THeaRet_nominal
          "Return temperature space heating system at TOut_nominal"
          annotation (Dialog(group="Nominal conditions"));
        parameter Modelica.SIunits.Temperature THeaSupZer
          "Minimum supply and return water temperature at zero load"
          annotation (Dialog(group="Nominal conditions"));
        Buildings.Controls.OBC.CDL.Interfaces.RealInput u(min=0, unit="1")
          "Heating load, normalized with peak load"
          annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
        Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaSup
        "Set point temperature for heating supply"
          annotation (Placement(transformation(extent={{100,40},{140,80}})));
        Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaRet
          "Set point temperature for heating return"
          annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
      initial equation
        assert(THeaSupZer < THeaRet_nominal, "THeaSupZer must be lower than THeaRet_nominal.");
      equation
        THeaSup = THeaSupZer + u * (THeaSup_nominal - THeaSupZer);
        THeaRet = THeaSupZer + u * (THeaRet_nominal - THeaSupZer);
      end HeatingCurve;
    end Controls;
  end Agents;

  package Networks "Package with models for network"
    model DistributionPipe "DHC distribution pipe"
      extends Buildings.Fluid.FixedResistances.PressureDrop(
        final dp_nominal=R*length);

      parameter Real R(unit="Pa/m") "Pressure drop per meter at m_flow_nominal";
      final parameter Modelica.SIunits.Length length = 100 "Length of pipe";

      final parameter Modelica.SIunits.PressureDifference dpStraightPipe_nominal(displayUnit="Pa")=
          Modelica.Fluid.Pipes.BaseClasses.WallFriction.QuadraticTurbulent.pressureLoss_m_flow(
          m_flow=m_flow_nominal,
          rho_a=rho_default,
          rho_b=rho_default,
          mu_a=mu_default,
          mu_b=mu_default,
          length=length,
          diameter=diameter,
          roughness=2.5E-5,
          m_flow_small=m_flow_small)
        "Pressure loss of a straight pipe at m_flow_nominal";

      final parameter Modelica.SIunits.Length diameter(fixed=false, start=0.2, min=0.01) "Pipe diameter";
      final parameter Modelica.SIunits.Velocity v_nominal = m_flow_nominal/(rho_default*ARound)
        "Flow velocity (assuming a round cross section area)";
    protected
      parameter Modelica.SIunits.Area ARound = diameter^2*Modelica.Constants.pi/4
         "Cross sectional area (assuming a round cross section area)";

      parameter Medium.ThermodynamicState state_default=
        Medium.setState_pTX(
          T=Medium.T_default,
          p=Medium.p_default,
          X=Medium.X_default[1:Medium.nXi]) "Default state";

      parameter Modelica.SIunits.Density rho_default = Medium.density(state_default)
        "Density at nominal condition";

      parameter Modelica.SIunits.DynamicViscosity mu_default = Medium.dynamicViscosity(
          state_default)
        "Dynamic viscosity at nominal condition";

    initial equation
      R * length = dpStraightPipe_nominal;
    equation
      when terminal() then
        Modelica.Utilities.Streams.print("Pipe diameter for '" + getInstanceName() + "' is " + String(diameter) + " m.");
      end when;

      annotation (Icon(graphics={
            Rectangle(
              extent={{-100,22},{100,-24}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={0,140,72})}));
    end DistributionPipe;

    model Junction
      extends Buildings.Fluid.FixedResistances.Junction(
      final dp_nominal={0,0,0},
      final tau=5*60);
      annotation (Icon(graphics={Ellipse(
              extent={{-38,36},{40,-40}},
              lineColor={28,108,200},
              fillColor={0,127,0},
              fillPattern=FillPattern.Solid)}));
    end Junction;

    package Controls "Package with controllers"
      block MainPump "Controller for main pump"
        extends Modelica.Blocks.Icons.Block;
        parameter Integer nMix(min=1) "Number of mixing points after the substations";
        parameter Integer nSou(min=1) "Number of heat sources (and heat sinks)";
        parameter Real yPumMin(min=0.01, max=1, final unit="1") = 0.05
          "Minimum pump speed";
        parameter Modelica.SIunits.Temperature TMin(
          displayUnit="degC") = 281.15 "Minimum loop temperature";
        parameter Modelica.SIunits.Temperature TMax(
          displayUnit="degC") = 291.15 "Maximum loop temperature";
        parameter Modelica.SIunits.TemperatureDifference dTSlo(min=1) = 2
          "Temperature difference for slope";
        parameter Boolean use_temperatureShift = true
          "Set to false to disable temperature shift of slopes";
        final parameter Modelica.SIunits.TemperatureDifference delta(min=1)=
          if use_temperatureShift then TMax-TMin-3*dTSlo else 0 "Maximum shift of slopes";
        parameter Modelica.SIunits.TemperatureDifference dTSou_nominal[nSou](
          each min=0) = fill(4, nSou) "Nominal temperature difference over source";
        parameter Real k=0.01
          "Gain of controller that shifts upper and lower temperature setpoints";
        parameter Modelica.SIunits.Time Ti(displayUnit="min") = 300
          "Time constant of integrator block that shifts upper and lower temperature setpoints";
        Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix[nMix](
          each final unit="K",
          each displayUnit="degC")
          "Temperatures at the mixing points"
          annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
        Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouIn[nSou](
          each final unit="K",
          each displayUnit="degC")
          "Temperatures at the inlets of the sources"
          annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
        Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouOut[nSou](
          each final unit="K",
          each displayUnit="degC")
          "Temperatures at the outlets of the sources"
          annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
        Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(min=0, max=1, unit="1")
          "Pump control signal"
          annotation (Placement(transformation(extent={{100,-20},{140,20}})));
        Buildings.Controls.OBC.CDL.Continuous.MultiMin TMixMin(
          final nin=nMix,
          y(final unit="K",
            displayUnit="degC"))
          "Minimum temperature at mixing points"
          annotation (Placement(transformation(extent={{-70,-22},{-50,-2}})));
        Buildings.Controls.OBC.CDL.Continuous.MultiMax TMixMax(
          final nin=nMix,
          y(final unit="K",
            displayUnit="degC"))
          "Maximum temperature at mixing points"
          annotation (Placement(transformation(extent={{-70,8},{-50,28}})));
        Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
          nin=nSou,
          k=fill(1, nSou))
          annotation (Placement(transformation(extent={{-40,-142},{-20,-122}})));
        Buildings.Controls.OBC.CDL.Continuous.Add dTSou[nSou](each final k1=-1)
          "Temperature differences over source"
          annotation (Placement(transformation(extent={{-70,-142},{-50,-122}})));
        Buildings.Controls.OBC.CDL.Continuous.Gain dTSou_nor(k=1/(sum(dTSou_nominal)))
          "Normalization of temperature difference over source"
          annotation (Placement(transformation(extent={{-10,-142},{10,-122}})));
        Buildings.Controls.OBC.CDL.Continuous.LimPID conShi(
          controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
          k=k,
          Ti(displayUnit="min") = Ti,
          final yMax=1,
          final yMin=-1,
          initType=Buildings.Controls.OBC.CDL.Types.Init.InitialOutput)
          "Controller to shift the min/max slopes"
          annotation (Placement(transformation(extent={{20,-112},{40,-92}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0)
          "Set point for source dT"
          annotation (Placement(transformation(extent={{-10,-92},{10,-72}})));
        Buildings.Controls.OBC.CDL.Continuous.Line uppCur "Upper curve"
          annotation (Placement(transformation(extent={{30,8},{50,28}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "Constant 1"
          annotation (Placement(transformation(extent={{-70,68},{-50,88}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yMin(k=yPumMin)
          "Minimum pump speed"
          annotation (Placement(transformation(extent={{-70,38},{-50,58}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TMax_nominal(k=TMax)
          "Maximum temperature"
          annotation (Placement(transformation(extent={{-70,144},{-50,164}})));
        Buildings.Controls.OBC.CDL.Continuous.Add TMax_upper(k2=-delta,
          y(unit="K", displayUnit="degC"))
          "Upper value of upper slope after shifting it"
          annotation (Placement(transformation(extent={{-30,138},{-10,158}})));
        Buildings.Controls.OBC.CDL.Continuous.Max sPos "Positive shift"
          annotation (Placement(transformation(extent={{60,-94},{80,-74}})));
        Buildings.Controls.OBC.CDL.Continuous.Min sNeg "Negative shift"
          annotation (Placement(transformation(extent={{60,-132},{80,-112}})));
        Buildings.Controls.OBC.CDL.Continuous.AddParameter TMax_lower(p=-dTSlo, k=1)
          "Minimum temperatuer value of upper slope after shifting it"
          annotation (Placement(transformation(extent={{10,137},{30,159}})));
        Buildings.Controls.OBC.CDL.Continuous.Line lowCur "Lower curve"
          annotation (Placement(transformation(extent={{30,-22},{50,-2}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TMin_nominal(k=TMin)
          "Minimum temperature"
          annotation (Placement(transformation(extent={{-70,98},{-50,118}})));
        Buildings.Controls.OBC.CDL.Continuous.Add TMin_lower(k2=-delta,
          y(unit="K", displayUnit="degC"))
          "Lower value of lower slope after shifting it"
          annotation (Placement(transformation(extent={{-30,98},{-10,118}})));
        Buildings.Controls.OBC.CDL.Continuous.AddParameter TMin_upper(p=+dTSlo, k=1)
          "Maximum temperatuer value of lower slope after shifting it"
          annotation (Placement(transformation(extent={{10,98},{30,118}})));
        Buildings.Controls.OBC.CDL.Continuous.Max ySetPum "Change in pump signal"
          annotation (Placement(transformation(extent={{60,-10},{80,10}})));
      equation
        connect(TMix, TMixMin.u) annotation (Line(points={{-120,60},{-86,60},{-86,-12},
                {-72,-12}},
                      color={0,0,127}));
        connect(TMix, TMixMax.u) annotation (Line(points={{-120,60},{-86,60},{-86,18},
                {-72,18}},
                      color={0,0,127}));
        connect(dTSou.u1, TSouIn) annotation (Line(points={{-72,-126},{-90,-126},{-90,
                0},{-120,0}}, color={0,0,127}));
        connect(dTSou.u2, TSouOut) annotation (Line(points={{-72,-138},{-94,-138},{-94,
                -60},{-120,-60}}, color={0,0,127}));
        connect(mulSum.u, dTSou.y)
          annotation (Line(points={{-42,-132},{-48,-132}}, color={0,0,127}));
        connect(mulSum.y, dTSou_nor.u)
          annotation (Line(points={{-18,-132},{-12,-132}}, color={0,0,127}));
        connect(dTSou_nor.y, conShi.u_m)
          annotation (Line(points={{12,-132},{30,-132},{30,-114}}, color={0,0,127}));
        connect(conShi.u_s, zer.y) annotation (Line(points={{18,-102},{16,-102},{16,-82},
                {12,-82}},
                       color={0,0,127}));
        connect(uppCur.u, TMixMax.y)
          annotation (Line(points={{28,18},{-48,18}}, color={0,0,127}));
        connect(uppCur.f1, yMin.y) annotation (Line(points={{28,22},{-30,22},{-30,48},
                {-48,48}}, color={0,0,127}));
        connect(uppCur.f2, one.y) annotation (Line(points={{28,10},{-26,10},{-26,78},{
                -48,78}}, color={0,0,127}));
        connect(TMax_nominal.y, TMax_upper.u1)
          annotation (Line(points={{-48,154},{-32,154}}, color={0,0,127}));
        connect(zer.y, sPos.u1) annotation (Line(points={{12,-82},{46,-82},{46,-78},{58,
                -78}}, color={0,0,127}));
        connect(zer.y, sNeg.u1) annotation (Line(points={{12,-82},{46,-82},{46,-116},{
                58,-116}},
                       color={0,0,127}));
        connect(conShi.y, sPos.u2) annotation (Line(points={{42,-102},{50,-102},{50,-90},
                {58,-90}}, color={0,0,127}));
        connect(conShi.y, sNeg.u2) annotation (Line(points={{42,-102},{50,-102},{50,-128},
                {58,-128}},color={0,0,127}));
        connect(TMax_lower.u, TMax_upper.y)
          annotation (Line(points={{8,148},{-8,148}},   color={0,0,127}));
        connect(uppCur.x1, TMax_lower.y) annotation (Line(points={{28,26},{20,26},{20,
                82},{42,82},{42,148},{32,148}}, color={0,0,127}));
        connect(TMax_upper.y, uppCur.x2) annotation (Line(points={{-8,148},{0,148},{0,
                14},{28,14}}, color={0,0,127}));
        connect(TMixMin.y, lowCur.u)
          annotation (Line(points={{-48,-12},{28,-12}}, color={0,0,127}));
        connect(TMin_nominal.y, TMin_lower.u1) annotation (Line(points={{-48,108},{-40,
                108},{-40,114},{-32,114}}, color={0,0,127}));
        connect(TMin_lower.y, TMin_upper.u)
          annotation (Line(points={{-8,108},{8,108}}, color={0,0,127}));
        connect(TMin_upper.y, lowCur.x2) annotation (Line(points={{32,108},{36,108},{36,
                86},{16,86},{16,-16},{28,-16}}, color={0,0,127}));
        connect(TMin_lower.y, lowCur.x1) annotation (Line(points={{-8,108},{-4,108},{-4,
                -4},{28,-4}}, color={0,0,127}));
        connect(lowCur.f1, one.y) annotation (Line(points={{28,-8},{-26,-8},{-26,78},{
                -48,78}}, color={0,0,127}));
        connect(lowCur.f2, yMin.y) annotation (Line(points={{28,-20},{-30,-20},{-30,48},
                {-48,48}}, color={0,0,127}));
        connect(uppCur.y, ySetPum.u1)
          annotation (Line(points={{52,18},{56,18},{56,6},{58,6}}, color={0,0,127}));
        connect(lowCur.y, ySetPum.u2) annotation (Line(points={{52,-12},{56,-12},{56,-6},
                {58,-6}}, color={0,0,127}));
        connect(ySetPum.y, y)
          annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
        connect(sPos.y, TMax_upper.u2) annotation (Line(points={{82,-84},{88,-84},{88,
                134},{-40,134},{-40,142},{-32,142}}, color={0,0,127}));
        connect(sNeg.y, TMin_lower.u2) annotation (Line(points={{82,-122},{94,-122},{
                94,94},{-40,94},{-40,102},{-32,102}}, color={0,0,127}));
        annotation (Diagram(coordinateSystem(extent={{-100,-180},{100,180}})), Icon(
              coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
              Ellipse(
                extent={{-52,52},{54,-52}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-94,68},{-76,54}},
                lineColor={0,0,127},
                textString="TMix"),
              Text(
                extent={{-94,8},{-76,-6}},
                lineColor={0,0,127},
                textString="TSouIn"),
              Text(
                extent={{-94,-52},{-76,-66}},
                lineColor={0,0,127},
                textString="TSouOut"),
              Text(
                extent={{76,8},{94,-6}},
                lineColor={0,0,127},
                textString="y"),
              Ellipse(
                extent={{-50,50},{52,-50}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{0,50},{0,-50},{52,0},{0,50}},
                lineColor={0,0,0},
                lineThickness=1,
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid)}),
          Documentation(revisions="<html>
<ul>
<li>
September 12, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>",       info="<html>
<p>
Controller for the main circulation pump.
</p>
<p>
This controller adjusts the pump speed in order to reduce the speed, unless
the water temperature at the mixing points after the agents in the district is too high
or too low, as measured by the difference to <code>TMin</code> and <code>TMax</code>,
in which case the pump speed is increased to avoid that the loop gets too cold or too warm.
The control is as follows:
Let <code>TMixMin</code> and <code>TMixMax</code> be the
minimum and maximum mixing temperatures.
If <code>TMax-TMixMax</code> or <code>TMixMin-TMin</code> is too small,
the pump speed is increased.
If the difference is larger than <code>dTSlo</code>, then the pump speed
is set to the minimum speed <code>yPumMin</code>.
This calculation is done for both, <code>TMixMin</code> and <code>TMixMax</code>.
The actual pump speed is then the larger of the two pump signals.
Therefore, the pump speeds are calculated as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"Image of the control that adjusts the pump speed\"
src=\"modelica://DHCNetworks/Resources/Images/Controls/MainPump.png\"/>
</p>
<p>
Moreover, the district loop temperature is adjusted by changing the mass
flow rate of the pump to increase the overall efficiency if there is net
cooling or net heating on the loop. Specifically,
if the district heating or cooling loop is in net heating (cooling) mode,
it is favorable to increase (decrease) the loop temperature, which can
be done by increasing the pump speed. Whether the loop
is in heating or cooling mode is determined based on the temperature differences
across the loop sources, which are the inputs <code>TSouIn</code> and <code>TSouOut</code>.
Each heat source or sink needs to be connected to one element of these
vectorized input signals.
This net difference is then used with a PI-controller to determine how much the slopes
should be shifted in order to increase the pump speed.
The shift of these slopes is indicated by the arrows
in the figure.
Note that this controller must be configured to be slow reacting, as it requires the
feedback from the district heating and cooling loop.
</p>
<p>
For a typical usage of this controller, see
<a href=\"modelica://DHCNetworks.Controls.Validation.MainPumpClosedLoop\">
DHCNetworks.Controls.Validation.MainPumpClosedLoop</a>.
</p>
</html>"));
      end MainPump;

      model PumpMode
        "Defines m flow of pums. 0 - \"winter mode\", abs (m_flow_BN) - \"summer mode\""
        extends Modelica.Blocks.Icons.Block;
        Modelica.Blocks.Interfaces.RealInput massFlowInBN "in kg/s"
          annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
        Modelica.Blocks.Interfaces.RealOutput massFlowPumps
          annotation (Placement(transformation(extent={{100,-10},{120,10}})));
        Modelica.Blocks.Logical.Switch switchMode
          annotation (Placement(transformation(extent={{60,-10},{80,10}})));
        Modelica.Blocks.Sources.Constant winterMode(k=0)
          annotation (Placement(transformation(extent={{0,30},{20,50}})));
        Modelica.Blocks.Logical.GreaterEqualThreshold flowDirectionInBN
          annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
        Modelica.Blocks.Math.Abs summerMode
          annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
      equation
        connect(switchMode.y, massFlowPumps)
          annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
        connect(winterMode.y, switchMode.u1) annotation (Line(points={{21,40},{40,
                40},{40,8},{58,8}}, color={0,0,127}));
        connect(flowDirectionInBN.y, switchMode.u2)
          annotation (Line(points={{1,0},{58,0}}, color={255,0,255}));
        connect(massFlowInBN, flowDirectionInBN.u)
          annotation (Line(points={{-120,0},{-22,0}}, color={0,0,127}));
        connect(summerMode.y, switchMode.u3) annotation (Line(points={{21,-40},{
                40,-40},{40,-8},{58,-8}}, color={0,0,127}));
        connect(massFlowInBN, summerMode.u) annotation (Line(points={{-120,0},{-40,0},
                {-40,-40},{-2,-40}},        color={0,0,127}));
      end PumpMode;
    end Controls;

    model UnidirectionalDistributionSeries
      "Partial model for an element for a distribution leg"

      replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium model"
        annotation (__Dymola_choicesAllMatching=true);
      parameter Modelica.SIunits.TemperatureDifference dTHex(min=0)
        "Temperature difference over substation heat exchanger";
      parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
        "Nominal mass flow rate distribution line";
      parameter Modelica.SIunits.MassFlowRate mSub_flow_nominal
        "Nominal mass flow rate substation line";

      parameter Modelica.SIunits.Length lDis
        "Length of the distribution pipe (only counting warm or cold line, but not sum)";
      parameter Modelica.SIunits.Length lSub
        "Length of the pipe to the substation (only counting warm or cold line, but not sum)";
      parameter Modelica.SIunits.PressureDifference dp_nominal=50000
        "Nominal pressure difference";

      Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(unit="W")
        "Electrical power consumed"
        annotation (Placement(transformation(extent={{100,68},{120,88}}),
            iconTransformation(extent={{100,70},{120,90}})));
      Modelica.Fluid.Interfaces.FluidPort_a subSup(
         redeclare final package Medium = Medium) "Substation supply"
        annotation (Placement(transformation(extent={{-30,110},{-10,130}}),
            iconTransformation(extent={{10,90},{30,110}})));
      Modelica.Fluid.Interfaces.FluidPort_b subRet(
        redeclare final package Medium = Medium) "Substation return"
        annotation (Placement(transformation(extent={{10,110},{30,130}}),
            iconTransformation(extent={{50,90},{70,110}})));
      Modelica.Fluid.Interfaces.FluidPort_a disSup_a(
        redeclare final package Medium = Medium) "Distribution supply line"
        annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
            iconTransformation(extent={{-110,-10},{-90,10}})));
      Modelica.Fluid.Interfaces.FluidPort_b disSup_b(
        redeclare final package Medium = Medium) "Distribution return line"
        annotation (Placement(transformation(extent={{90,-10},{110,10}}),
            iconTransformation(extent={{90,-10},{110,10}})));

      Junction junSup(redeclare final package Medium = Medium, m_flow_nominal={
            mDis_flow_nominal,mDis_flow_nominal,mSub_flow_nominal})
        "Junction in supply line"
        annotation (Placement(transformation(extent={{-30,10},{-10,-10}})));

      Junction junRet(redeclare final package Medium = Medium, m_flow_nominal={
            mDis_flow_nominal,mDis_flow_nominal,mSub_flow_nominal})
        "Junction in return line"
        annotation (Placement(transformation(extent={{10,10},{30,-10}})));

      SidewalkQuayside.Distribution.BaseClasses.MainPipe maiPipSup(
        redeclare final package Medium = Medium,
        final m_flow_nominal=mDis_flow_nominal,
        final length=lDis) "Distribution pipe"
        annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
      SidewalkQuayside.Distribution.BaseClasses.PipeToSubstation pipToSub(
        redeclare package Medium = Medium,
        m_flow_nominal=mSub_flow_nominal,
        length=2*lSub,
        dh=dhSub) "Pipe to substation" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-20,30})));
      parameter Modelica.SIunits.Length dhSub
        "Hydraulic diameter of pipe to substation";
      Buildings.Fluid.Movers.FlowControlled_m_flow disPum(
        redeclare package Medium = Medium,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        addPowerToMedium=false,
        nominalValuesDefineDefaultPressureCurve=true,
        riseTime=10,
        m_flow_nominal=mSub_flow_nominal,
        per(pressure(dp={2*dp_nominal,0}, V_flow={0,2*mSub_flow_nominal/1000})),
        use_inputFilter=false)
        "Pump (or valve) that forces the flow rate to be set to the control signal"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90, origin={-20,58})));
      Buildings.Fluid.Sensors.TemperatureTwoPort supTem(
        allowFlowReversal=false,
        redeclare final package Medium = Medium,
        m_flow_nominal=mSub_flow_nominal)
        annotation (Placement(transformation(extent={{10,10},{-10,-10}},
            rotation=-90, origin={-20,84})));
      Buildings.Fluid.Sensors.TemperatureTwoPort retTem(
        allowFlowReversal=false,
        redeclare final package Medium = Medium,
        m_flow_nominal=mSub_flow_nominal)
        annotation (Placement(transformation(extent={{-10,10},{10,-10}},
            rotation=-90, origin={20,100})));
      SidewalkQuayside.Distribution.BaseClasses.SubstationPumpControl con(dT=dTHex,
          m_flow_nominal=mSub_flow_nominal)
        annotation (Placement(transformation(extent={{-80,48},{-60,68}})));

      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput modInd "Mode index"
        annotation (Placement(transformation(extent={{-140,46},{-100,86}}),
            iconTransformation(extent={{-140,60},{-100,100}})));
      Modelica.Blocks.Interfaces.RealOutput m_flow(unit="kg/s") "Mass flow rate"
        annotation (Placement(transformation(extent={{100,34},{120,54}}),
            iconTransformation(extent={{100,-70},{120,-50}})));

    equation
      connect(disSup_a, maiPipSup.port_a)
        annotation (Line(points={{-100,0},{-80,0}},   color={0,127,255}));
      connect(junSup.port_3, pipToSub.port_a)
        annotation (Line(points={{-20,10},{-20,20}},
                                                   color={0,127,255}));
      connect(maiPipSup.port_b, junSup.port_1)
        annotation (Line(points={{-60,0},{-30,0}}, color={0,127,255}));
      connect(junSup.port_2, junRet.port_1)
        annotation (Line(points={{-10,0},{10,0}}, color={0,127,255}));
      connect(junRet.port_2, disSup_b)
        annotation (Line(points={{30,0},{100,0}}, color={0,127,255}));
      connect(disPum.port_a, pipToSub.port_b)
        annotation (Line(points={{-20,48},{-20,40}}, color={0,127,255}));
      connect(subSup, supTem.port_b)
        annotation (Line(points={{-20,120},{-20,94}}, color={0,127,255}));
      connect(supTem.port_a, disPum.port_b)
        annotation (Line(points={{-20,74},{-20,68}}, color={0,127,255}));
      connect(junRet.port_3, retTem.port_b)
        annotation (Line(points={{20,10},{20,90}}, color={0,127,255}));
      connect(retTem.port_a, subRet)
        annotation (Line(points={{20,110},{20,110},{20,120}}, color={0,127,255}));
      connect(con.yPum, disPum.m_flow_in) annotation (Line(points={{-59,58},{-32,58}},
                                  color={0,0,127}));
      connect(supTem.T, con.TSup) annotation (Line(points={{-31,84},{-90,84},{-90,58},
              {-82,58}}, color={0,0,127}));
      connect(retTem.T, con.TRet) annotation (Line(points={{9,100},{-94,100},{-94,50},
              {-82,50}}, color={0,0,127}));
      connect(modInd, con.modInd)
        annotation (Line(points={{-120,66},{-82,66}}, color={255,127,0}));
      connect(disPum.m_flow_actual, m_flow) annotation (Line(points={{-25,69},{-25,
              76},{80,76},{80,44},{110,44}}, color={0,0,127}));
      connect(disPum.P, PPum) annotation (Line(
          points={{-29,69},{-29,78},{110,78}},
          color={0,0,127},
          pattern=LinePattern.Dash));
      annotation (Icon(graphics={   Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-100,2},{90,-2}},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None,
              lineColor={0,0,0}),
            Rectangle(
              extent={{18,2},{22,100}},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None,
              lineColor={0,0,0}),           Text(
            extent={{-150,-92},{150,-132}},
            textString="%name",
            lineColor={0,0,255}),
            Rectangle(
              extent={{-74,12},{-18,-12}},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None,
              lineColor={0,0,0}),
            Rectangle(
              extent={{-25.5,11.5},{25.5,-11.5}},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None,
              lineColor={0,0,0},
              origin={19.5,49.5},
              rotation=90),
            Rectangle(
              extent={{58,2},{62,100}},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None,
              lineColor={0,0,0})}), Diagram(coordinateSystem(extent={{-100,-60},{100,
                120}})));
    end UnidirectionalDistributionSeries;
  end Networks;

  package Examples "Based on Final_steps_2019_10_21"
    extends Modelica.Icons.ExamplesPackage;

    model Reservoir1Constant
      "Reservoir network with simple control and 0.08m pipe diameter"
      extends Modelica.Icons.Example;
      extends
        Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Examples.BaseClasses.RN_BaseModel(
          datDes(
          mDisPip_flow_nominal=95,
          RDisPip=250,
          epsPla=0.935));
      Modelica.Blocks.Sources.Constant massFlowMainPump(
        k(final unit="kg/s")=datDes.mDisPip_flow_nominal)
        "Pump mass flow rate"
        annotation (Placement(transformation(extent={{-44,-390},{-24,-370}})));
    equation
      connect(massFlowMainPump.y, pumpMainRLTN.m_flow_in) annotation (Line(points={{-23,
              -380},{34,-380},{34,-360},{68,-360}},    color={0,0,127}));
      connect(pumpBHS.m_flow_in, massFlowMainPump.y)
        annotation (Line(points={{50,-428},{50,-380},{-23,-380}},
                                                                color={0,0,127}));
      annotation (
      Diagram(
      coordinateSystem(preserveAspectRatio=false, extent={{-480,-480},{420,360}}),
      graphics={Text(
              extent={{-438,-406},{-306,-432}},
              lineColor={28,108,200},
              horizontalAlignment=TextAlignment.Left,
              textString="Simulation requires (and is faster with)
Hidden.AvoidDoubleComputation=true;
Advanced.SparseActivate=true")}),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir1Constant.mos"
      "Simulate and plot"),
      experiment(
        StopTime=172800,
        Tolerance=1e-06,
        __Dymola_Algorithm="Cvode"));
    end Reservoir1Constant;

    model Reservoir2Constant "Reservoir network with simple control and dp=125 Pa/m"
      extends Modelica.Icons.Example;
      extends
        Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Examples.Reservoir1Constant(
          datDes(RDisPip=125));

      annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-480},{380,360}})),
            __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir2Constant.mos"
            "Simulate and plot"),
        experiment(StopTime=31536000,
        Tolerance=1e-06, __Dymola_NumberOfIntervals=8760));
    end Reservoir2Constant;

    record DesignDataDHC "Record with design data for DHC system"
      extends Modelica.Icons.Record;
      parameter Modelica.SIunits.MassFlowRate mDisPip_flow_nominal
        "Distribution pipe flow rate";
      parameter Real RDisPip(unit="Pa/m")
        "Pressure drop per meter at m_flow_nominal";
      final parameter Modelica.SIunits.MassFlowRate mPla_flow_nominal = 11.45
        "Plant mass flow rate";
      parameter Real epsPla
        "Plant efficiency";
      final parameter Modelica.SIunits.MassFlowRate mSto_flow_nominal = 105
        "Storage mass flow rate";
      final parameter Modelica.SIunits.Temperature TLooMin = 273.15 + 6
        "Minimum loop temperature";
      final parameter Modelica.SIunits.Temperature TLooMax = 273.15 + 17
        "Maximum loop temperature";
      annotation (
        defaultComponentPrefix="datDes",
        defaultComponentPrefixes="inner");
    end DesignDataDHC;

    package BaseClasses "Package with base classes that are used by multiple models"
      block ConstraintViolation
        "Block that outputs the fraction of time when a constraint is violated"
        extends Modelica.Blocks.Interfaces.PartialRealMISO(
          final significantDigits = 3);
        parameter Real uMin "Minimum value for input";
        parameter Real uMax "Maximum value for input";

        Modelica.SIunits.Time t(final start=0, final fixed=true) "Integral of violated time";

      protected
        parameter Modelica.SIunits.Time t0(fixed=false)
          "First sample time instant";

        Boolean vioMin "Flag, true if minimum is violated";
        Boolean vioMax "Flag, true if maximum is violated";
        Boolean tesMax[nu] = {u[i] > uMax for i in 1:nu}  "Test for maximum violation";
      initial equation
        t0 = time-1E-15;
      equation

        vioMin = Modelica.Math.BooleanVectors.anyTrue({u[i] < uMin for i in 1:nu});
        vioMax = Modelica.Math.BooleanVectors.anyTrue({u[i] > uMax for i in 1:nu});
        if vioMin or vioMax then
          der(t) = 1;
        else
          der(t) = 0;
        end if;
        y = t/(time-t0);
        annotation (Icon(graphics={Ellipse(
                extent={{-8,74},{12,-30}},
                lineColor={238,46,47},
                fillColor={238,46,47},
                fillPattern=FillPattern.Solid), Ellipse(
                extent={{-8,-48},{16,-74}},
                lineColor={238,46,47},
                fillColor={238,46,47},
                fillPattern=FillPattern.Solid)}));
      end ConstraintViolation;

      block PowerMeter
        "Block that sums input and integrates it from power to energy"
        extends Modelica.Blocks.Interfaces.PartialRealMISO(
         u(each unit="W"),
         y(unit="J"));

        final parameter String insNam = getInstanceName() "Instance name";
        Modelica.Blocks.Math.MultiSum multiSum(final nu=nu)
          annotation (Placement(transformation(extent={{-34,-6},{-22,6}})));
        Modelica.Blocks.Continuous.Integrator integrator(
          final initType=Modelica.Blocks.Types.Init.InitialState)
          annotation (Placement(transformation(extent={{40,-10},{60,10}})));
      equation
        connect(multiSum.u, u)
          annotation (Line(points={{-34,0},{-100,0}}, color={0,0,127}));
        connect(multiSum.y, integrator.u)
          annotation (Line(points={{-20.98,0},{38,0}}, color={0,0,127}));
        connect(y, integrator.y)
          annotation (Line(points={{117,0},{61,0}}, color={0,0,127}));
        annotation (Icon(graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={28,108,200},
                fillColor={0,128,255},
                fillPattern=FillPattern.Solid)}));
      end PowerMeter;

      model Pump_m_flow "Pump with prescribed mass flow rate"
        extends Buildings.Fluid.Movers.FlowControlled_m_flow(
          per(final motorCooledByFluid=false),
          final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
          final allowFlowReversal=false,
          final inputType=Buildings.Fluid.Types.InputType.Continuous,
          final addPowerToMedium=false,
          final nominalValuesDefineDefaultPressureCurve=true,
          final use_inputFilter=false,
          final show_T=true);
        annotation (Icon(graphics={
              Ellipse(
                extent={{-58,58},{58,-58}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Sphere,
                fillColor={0,0,0}),
              Polygon(
                points={{-2,52},{-2,-48},{52,2},{-2,52}},
                lineColor={0,0,0},
                pattern=LinePattern.None,
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={255,255,255})}));
      end Pump_m_flow;

      partial model RN_BaseModel
        package MediumWater = Buildings.Media.Water "Medium model";
        inner parameter DesignDataDHC datDes "Design values"
          annotation (Placement(transformation(extent={{-460,280},{-440,300}})));
        Agents.BoreField borFie(redeclare package Medium = MediumWater)
          annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-2,-440})));
        Buildings.Fluid.Sensors.TemperatureTwoPort Tml1(
          redeclare package Medium = MediumWater,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)
          annotation (Placement(transformation(
              extent={{-6,-6},{6,6}},
              rotation=90,
              origin={-80,-300})));
        Modelica.Blocks.Sources.RealExpression heatFromToBHF(
          y=4184*(Tml1.T - Tml5.T) *massFlowRateInRLTN.m_flow)
          "in W"
          annotation (Placement(transformation(extent={{-46,-358},{-26,-338}})));
        Pump_m_flow pumpMainRLTN(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal)
          "Pump"
          annotation (Placement(transformation(extent={{10,-10},{-10,10}},
              rotation=90,
              origin={80,-360})));
        Networks.Junction splSup3(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={80,-20})));
        Networks.Junction splSup4(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={80,-60})));
        Fluid.Sensors.TemperatureTwoPort tempBeforeProsumer3(
          redeclare package Medium = MediumWater,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)
          annotation (Placement(transformation(
              extent={{6,6},{-6,-6}},
              rotation=180,
              origin={120,-20})));
        Fluid.Sensors.TemperatureTwoPort tempAfterProsumer3(redeclare package
            Medium =       MediumWater,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)
          annotation (Placement(transformation(
              extent={{-6,-6},{6,6}},
              rotation=180,
              origin={120,-60})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer3(
          redeclare package Medium = MediumWater,
          allowFlowReversal=true)
          annotation (Placement(transformation(
              extent={{6,-6},{-6,6}},
              rotation=0,
              origin={100,-60})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateInRLTN(
          redeclare package Medium = MediumWater,
          allowFlowReversal=true)
          annotation (Placement(
              transformation(
              extent={{6,6},{-6,-6}},
              rotation=180,
              origin={40,220})));
        Networks.Junction splSup5(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={80,180})));
        Networks.Junction splSup6(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={80,140})));
        Fluid.Sensors.TemperatureTwoPort tempBeforeProsumer2(
          redeclare package Medium = MediumWater,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)
          annotation (Placement(transformation(
              extent={{6,6},{-6,-6}},
              rotation=180,
              origin={120,180})));
        Fluid.Sensors.TemperatureTwoPort tempAfterProsumer2(
          redeclare package Medium = MediumWater,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)
          annotation (Placement(transformation(
              extent={{-6,-6},{6,6}},
              rotation=180,
              origin={120,140})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer2(
          redeclare package Medium = MediumWater,
          allowFlowReversal=true)
          annotation (Placement(transformation(
              extent={{6,6},{-6,-6}},
              rotation=0,
              origin={100,140})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateBypassSFApartment(
          redeclare package Medium = MediumWater,
          allowFlowReversal=true)
          annotation (Placement(transformation(
              extent={{-6,-6},{6,6}},
              rotation=-90,
              origin={80,160})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateBypassSFRetail(
          redeclare package Medium = MediumWater,
          allowFlowReversal=true)
          annotation (
            Placement(transformation(
              extent={{-6,-6},{6,6}},
              rotation=-90,
              origin={80,-40})));
        Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Agents.EnergyTransferStation
          ets1(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui1.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui1.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{-360,-40},{-320,0}})));
        Networks.Junction splSup7(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-80,0})));
        Networks.Junction splSup8(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-80,-40})));
        Fluid.Sensors.TemperatureTwoPort          tempBeforeProsumer1(redeclare
            package Medium = MediumWater,
          allowFlowReversal=false,        m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)                          annotation (Placement(transformation(
              extent={{-6,6},{6,-6}},
              rotation=180,
              origin={-120,-40})));
        Fluid.Sensors.TemperatureTwoPort          tempAfterProsumer1(redeclare
            package Medium = MediumWater,
          allowFlowReversal=false,        m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)                          annotation (Placement(transformation(
              extent={{6,6},{-6,-6}},
              rotation=180,
              origin={-120,0})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer1(
            redeclare package Medium = MediumWater, allowFlowReversal=true)
          annotation (Placement(transformation(
              extent={{-6,6},{6,-6}},
              rotation=0,
              origin={-100,0})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateBypassSFLargeOfficediv4(
            redeclare package Medium = MediumWater, allowFlowReversal=true)
          annotation (Placement(transformation(
              extent={{6,6},{-6,-6}},
              rotation=-90,
              origin={-80,-20})));
        Fluid.Sensors.TemperatureTwoPort          Tml2(redeclare package Medium =
              MediumWater,
          allowFlowReversal=false,
                           m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)           annotation (Placement(transformation(
              extent={{-6,-6},{6,6}},
              rotation=90,
              origin={-80,-100})));
        Fluid.Sensors.TemperatureTwoPort          Tml4(redeclare package Medium =
              MediumWater,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)           annotation (Placement(transformation(
              extent={{6,6},{-6,-6}},
              rotation=90,
              origin={80,120})));
        Fluid.Sensors.TemperatureTwoPort          Tml5(redeclare package Medium =
              MediumWater,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)           annotation (Placement(transformation(
              extent={{-6,-6},{6,6}},
              rotation=270,
              origin={80,-100})));
        Fluid.Sensors.TemperatureTwoPort          Tml3(redeclare package Medium =
              MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                           annotation (Placement(transformation(
              extent={{6,6},{-6,-6}},
              rotation=180,
              origin={0,220})));
        Networks.Junction splSup1(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-80,-190})));
        Networks.Junction splSup2(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-80,-270})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateBypassPlant(redeclare
            package Medium = MediumWater, allowFlowReversal=true) annotation (
            Placement(transformation(
              extent={{6,6},{-6,-6}},
              rotation=-90,
              origin={-80,-230})));
        Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
          redeclare package Medium1 = MediumWater,
          redeclare package Medium2 = MediumWater,
          allowFlowReversal2=false,
          final m1_flow_nominal=datDes.mPla_flow_nominal,
          final m2_flow_nominal=datDes.mPla_flow_nominal,
          show_T=true,
          final dp1_nominal(displayUnit="bar") = 50000,
          final dp2_nominal(displayUnit="bar") = 50000,
          final eps=datDes.epsPla)                                                 "Heat exchanger" annotation (Placement(
              transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-146,-240})));
        Fluid.Sensors.TemperatureTwoPort          tempBeforePlantPrimSide(
            redeclare package Medium = MediumWater,
          allowFlowReversal=false,                  m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)                                    annotation (Placement(
              transformation(
              extent={{-6,6},{6,-6}},
              rotation=180,
              origin={-120,-270})));
        Fluid.Sensors.TemperatureTwoPort          tempAfterPlantPrimSide(
            redeclare package Medium = MediumWater,
          allowFlowReversal=false,                  m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)                                    annotation (Placement(
              transformation(
              extent={{6,6},{-6,-6}},
              rotation=180,
              origin={-120,-190})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughPrimSidePlant(
            redeclare package Medium = MediumWater, allowFlowReversal=true)
          annotation (Placement(transformation(
              extent={{-6,6},{6,-6}},
              rotation=0,
              origin={-100,-190})));
        Pump_m_flow                                  pumpPrimarySidePlant(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000)       "Pump" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-140,-210})));
        Modelica.Blocks.Sources.Constant mFlowInputPlant(final k=datDes.mPla_flow_nominal)
                                                                  "kg/s"
          annotation (Placement(transformation(extent={{-100,-238},{-116,-222}})));
        Buildings.Fluid.Sources.Boundary_pT sewageSourceAtConstTemp(
          redeclare package Medium = MediumWater,
          T=290.15,
          nPorts=2) "17°C"
          annotation (Placement(transformation(extent={{-200,-250},{-180,-230}})));
        Pump_m_flow                                  pumpSecondarySidePlant(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000)       "Pump" annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-180,-210})));
        Fluid.Sensors.TemperatureTwoPort          tempAfterPlantSecondSide(
            redeclare package Medium = MediumWater,
          allowFlowReversal=false,                  m_flow_nominal=datDes.mDisPip_flow_nominal,
          tau=0)                                    annotation (Placement(
              transformation(
              extent={{-6,6},{6,-6}},
              rotation=180,
              origin={-166,-270})));
        Modelica.Blocks.Sources.RealExpression heatFromToPlantPrimarySide(y=4184*(
              tempAfterPlantPrimSide.T - tempBeforePlantPrimSide.T)*
              massFlowRateThroughPrimSidePlant.m_flow) "in W"
          annotation (Placement(transformation(extent={{-120,-260},{-100,-240}})));
        Networks.DistributionPipe res(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip)
                           annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={80,-310})));
        Networks.DistributionPipe res1(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip)
                           annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-80,-330})));
        Networks.DistributionPipe distributionPipe(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip)
                           annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=270,
              origin={-80,70})));
        Networks.DistributionPipe res4(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip)
                           annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={80,70})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer1AfterSB(
            redeclare package Medium = MediumWater, allowFlowReversal=true)
          annotation (Placement(transformation(
              extent={{6,-6},{-6,6}},
              rotation=0,
              origin={-100,-40})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer2AfterSB(
            redeclare package Medium = MediumWater, allowFlowReversal=true)
          annotation (Placement(transformation(
              extent={{-6,-6},{6,6}},
              rotation=0,
              origin={100,180})));
        Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer3AfterSB(
            redeclare package Medium = MediumWater, allowFlowReversal=true)
          annotation (Placement(transformation(
              extent={{-6,-6},{6,6}},
              rotation=0,
              origin={100,-20})));
        Modelica.Blocks.Continuous.Integrator integrator(k=0.001*(1/3600))
          annotation (Placement(transformation(extent={{-6,-358},{14,-338}})));
        Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
              MediumWater, nPorts=1) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={130,-340})));
        Networks.DistributionPipe res3(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip)
                           annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-80,-130})));
        Networks.DistributionPipe res5(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip)
                           annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={80,-130})));
        Networks.DistributionPipe res2(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip)
                           annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={80,-172})));
        Networks.DistributionPipe res6(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip)
                           annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={80,-210})));
        PowerMeter EPumPla(nu=2) "Plant pump power consumption"
          annotation (Placement(transformation(extent={{-154,-158},{-142,-146}})));
        PowerMeter EPumPro(nu=1)
                           "Prosumer pump power consumption"
          annotation (Placement(transformation(extent={{246,282},{258,294}})));
        PowerMeter EPumDis(nu=2) "Distribution network pump power consumption"
          annotation (Placement(transformation(extent={{222,-386},{234,-374}})));
        PowerMeter EHeaPum(nu=1)
                           "Heat pump power consumption"
          annotation (Placement(transformation(extent={{246,262},{258,274}})));
        PowerMeter EBorFie(nu=1) "Heat from borefield"
          annotation (Placement(transformation(extent={{-38,-466},{-26,-454}})));
        PowerMeter EPlant(nu=1) "Plant power consumption"
          annotation (Placement(transformation(extent={{-66,-256},{-54,-244}})));
        Modelica.Blocks.Sources.RealExpression heatFromToNetwrokProsumer1(y=4184*(
              tempBeforeProsumer1.T - tempAfterProsumer1.T)*
              massFlowRateThroughProsumer1.m_flow) "in W"
          annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
        PowerMeter EProsumer1(nu=1) "Prosumer 1 power consumption"
          annotation (Placement(transformation(extent={{-118,-86},{-106,-74}})));
        PowerMeter EProsumer2(nu=1) "Prosumer 2 power consumption"
          annotation (Placement(transformation(extent={{180,94},{168,106}})));
        Modelica.Blocks.Sources.RealExpression heatFromToNetwrokProsumer2(y=4184*(
              tempBeforeProsumer2.T - tempAfterProsumer2.T)*
              massFlowRateThroughProsumer2.m_flow) "in W"
          annotation (Placement(transformation(extent={{220,90},{200,110}})));
        Modelica.Blocks.Sources.RealExpression heatFromToNetwrokProsumer3(y=4184*(
              tempBeforeProsumer3.T - tempAfterProsumer3.T)*
              massFlowRateThroughProsumer3.m_flow) "in W"
          annotation (Placement(transformation(extent={{240,-110},{220,-90}})));
        PowerMeter EProsumer3(nu=1) "Prosumer 3 power consumption"
          annotation (Placement(transformation(extent={{180,-106},{168,-94}})));
        PowerMeter ESumProsumers(nu=3) "Prosumers power consumption"
          annotation (Placement(transformation(extent={{-6,-6},{6,6}},
              rotation=0,
              origin={226,-160})));
        Modelica.Blocks.Math.MultiSum EEleTot(
          nu=2, y(unit="J", displayUnit="kWh")) "Total electrical energy"
          annotation (Placement(transformation(extent={{284,274},{296,286}})));

        Buildings.Utilities.IO.Files.Printer pri(
          samplePeriod=8760*3600,
          header="Total electricity use [J]",
          configuration=3,
          significantDigits=5)
          annotation (Placement(transformation(extent={{352,270},{372,290}})));
        Pump_m_flow                                  pumpBHS(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mSto_flow_nominal)
                                  "Pump" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=180,
              origin={50,-440})));
        Networks.Junction splSup9(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,10},{-10,-10}},
              rotation=90,
              origin={80,-400})));
        Networks.Junction splSup10(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={-80,-400})));
        ConstraintViolation TVio(
          final uMin=datDes.TLooMin,
          final uMax=datDes.TLooMax,
          nu=5)
          "Outputs the fraction of times when the temperature constraints are violated"
          annotation (Placement(transformation(extent={{324,324},{336,336}})));
        Buildings.Utilities.IO.Files.Printer pri1(
          samplePeriod=8760*3600,
          header="Temperature constraint violation [-]",
          configuration=3,
          significantDigits=5)
          annotation (Placement(transformation(extent={{352,320},{372,340}})));
        Modelica.Blocks.Math.MultiSum EPumTot(nu=3, y(unit="J", displayUnit="kWh"))
          "Total electrical energy for pumps"
          annotation (Placement(transformation(extent={{284,302},{296,314}})));
        Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui1(redeclare
            package Medium1 =
                      MediumWater, nPorts1=2) "Building"
          annotation (Placement(transformation(extent={{-360,40},{-340,60}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(k=ets1.THeaWatSup_nominal)
          "Heating water supply temperature set point"
          annotation (Placement(transformation(extent={{-460,230},{-440,250}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(k=ets1.TChiWatSup_nominal)
          "Chilled water supply temperature set point"
          annotation (Placement(transformation(extent={{-460,200},{-440,220}})));
        Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui2(
          redeclare package Medium1 = MediumWater,
          idfPath=
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94021950/RefBldgSmallOfficeNew2004_Chicago.idf",
          nPorts1=2) "Building"
          annotation (Placement(transformation(extent={{320,180},{340,200}})));

        Agents.EnergyTransferStation ets2(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui2.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui2.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{320,80},{360,120}})));
        Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui3(redeclare
            package Medium1 =
                      MediumWater, nPorts1=2) "Building"
          annotation (Placement(transformation(extent={{320,-20},{340,0}})));
        Agents.EnergyTransferStation
          ets3(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui3.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui3.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{320,-120},{360,-80}})));
      protected
        constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
      equation
        connect(massFlowRateThroughProsumer3.port_a, tempAfterProsumer3.port_b)
          annotation (Line(points={{106,-60},{114,-60}},   color={0,127,255}));
        connect(massFlowRateThroughProsumer3.port_b, splSup4.port_3)
          annotation (Line(points={{94,-60},{90,-60}},    color={0,127,255}));
        connect(massFlowRateThroughProsumer2.port_a, tempAfterProsumer2.port_b)
          annotation (Line(points={{106,140},{114,140}},
                                                       color={0,127,255}));
        connect(massFlowRateThroughProsumer2.port_b, splSup6.port_3)
          annotation (Line(points={{94,140},{90,140}},color={0,127,255}));
        connect(massFlowRateBypassSFApartment.port_a, splSup5.port_2)
          annotation (Line(points={{80,166},{80,170}}, color={0,127,255}));
        connect(massFlowRateBypassSFApartment.port_b, splSup6.port_1)
          annotation (Line(points={{80,154},{80,150}},color={0,127,255}));
        connect(massFlowRateBypassSFRetail.port_a, splSup3.port_2)
          annotation (Line(points={{80,-34},{80,-30}}, color={0,127,255}));
        connect(massFlowRateBypassSFRetail.port_b, splSup4.port_1)
          annotation (Line(points={{80,-46},{80,-50}}, color={0,127,255}));
        connect(splSup8.port_2, massFlowRateBypassSFLargeOfficediv4.port_a)
          annotation (Line(points={{-80,-30},{-80,-26}},color={0,127,255}));
        connect(splSup7.port_1, massFlowRateBypassSFLargeOfficediv4.port_b)
          annotation (Line(points={{-80,-10},{-80,-14}}, color={0,127,255}));
        connect(massFlowRateThroughProsumer1.port_b, splSup7.port_3)
          annotation (Line(points={{-94,0},{-92,0},{-92,6.66134e-16},{-90,
                6.66134e-16}},                            color={0,127,255}));
        connect(massFlowRateThroughProsumer1.port_a, tempAfterProsumer1.port_b)
          annotation (Line(points={{-106,0},{-110,0},{-110,-4.44089e-16},{-114,
                -4.44089e-16}},                            color={0,127,255}));
        connect(Tml2.port_b, splSup8.port_1)
          annotation (Line(points={{-80,-94},{-80,-50}},
                                                       color={0,127,255}));
        connect(Tml4.port_a, splSup6.port_2)
          annotation (Line(points={{80,126},{80,130}},
                                                    color={0,127,255}));
        connect(massFlowRateInRLTN.port_b, splSup5.port_1) annotation (Line(
              points={{46,220},{80,220},{80,190}},color={0,127,255}));
        connect(Tml3.port_b, massFlowRateInRLTN.port_a)
          annotation (Line(points={{6,220},{34,220}},   color={0,127,255}));
        connect(Tml5.port_a, splSup4.port_2)
          annotation (Line(points={{80,-94},{80,-70}},   color={0,127,255}));
        connect(massFlowRateBypassPlant.port_b, splSup1.port_1) annotation (Line(
              points={{-80,-224},{-80,-200}},         color={0,127,255}));
        connect(massFlowRateBypassPlant.port_a, splSup2.port_2)
          annotation (Line(points={{-80,-236},{-80,-260}},
                                                         color={0,127,255}));
        connect(tempBeforePlantPrimSide.port_a, splSup2.port_3)
          annotation (Line(points={{-114,-270},{-90,-270}}, color={0,127,255}));
        connect(massFlowRateThroughPrimSidePlant.port_b, splSup1.port_3)
          annotation (Line(points={{-94,-190},{-90,-190}},
                                                         color={0,127,255}));
        connect(tempAfterPlantPrimSide.port_b, massFlowRateThroughPrimSidePlant.port_a)
          annotation (Line(points={{-114,-190},{-106,-190}},
                                                           color={0,127,255}));
        connect(mFlowInputPlant.y, pumpPrimarySidePlant.m_flow_in) annotation (
            Line(points={{-116.8,-230},{-120,-230},{-120,-210},{-128,-210}},
                                                                         color={0,
                0,127}));
        connect(tempAfterPlantSecondSide.port_a, plant.port_b2) annotation (Line(
              points={{-160,-270},{-152,-270},{-152,-250}},color={0,127,255}));
        connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[1])
          annotation (Line(points={{-172,-270},{-180,-270},{-180,-238}},color={0,
                127,255}));
        connect(mFlowInputPlant.y, pumpSecondarySidePlant.m_flow_in) annotation (
            Line(points={{-116.8,-230},{-122,-230},{-122,-224},{-200,-224},{-200,-210},
                {-192,-210}},color={0,0,127}));
        connect(Tml1.port_b, splSup2.port_1)
          annotation (Line(points={{-80,-294},{-80,-280}}, color={0,127,255}));
        connect(pumpPrimarySidePlant.port_b, tempAfterPlantPrimSide.port_a)
          annotation (Line(points={{-140,-200},{-140,-190},{-126,-190}},
                                                                      color={0,
                127,255}));
        connect(pumpPrimarySidePlant.port_a, plant.port_b1)
          annotation (Line(points={{-140,-220},{-140,-230}},
                                                           color={0,127,255}));
        connect(pumpSecondarySidePlant.port_b, plant.port_a2) annotation (Line(
              points={{-180,-200},{-180,-190},{-152,-190},{-152,-230}},
                                                                    color={0,127,
                255}));
        connect(pumpSecondarySidePlant.port_a, sewageSourceAtConstTemp.ports[2])
          annotation (Line(points={{-180,-220},{-180,-242}},
                                                           color={0,127,255}));
        connect(res.port_b, pumpMainRLTN.port_a)
          annotation (Line(points={{80,-320},{80,-350}}, color={0,127,255}));
        connect(res1.port_b, Tml1.port_a)
          annotation (Line(points={{-80,-320},{-80,-306}}, color={0,127,255}));
        connect(distributionPipe.port_b, Tml3.port_a)
          annotation (Line(points={{-80,80},{-80,220},{-6,220}},
                                                        color={0,127,255}));
        connect(distributionPipe.port_a, splSup7.port_2) annotation (Line(points={{-80,60},
                {-80,10}},                 color={0,127,255}));
        connect(res4.port_a, Tml4.port_b)
          annotation (Line(points={{80,80},{80,114}},
                                                    color={0,127,255}));
        connect(res4.port_b, splSup3.port_1)
          annotation (Line(points={{80,60},{80,-10}},  color={0,127,255}));
        connect(plant.port_a1, tempBeforePlantPrimSide.port_b) annotation (Line(
              points={{-140,-250},{-140,-270},{-126,-270}}, color={0,127,255}));
        connect(heatFromToBHF.y, integrator.u)
          annotation (Line(points={{-25,-348},{-8,-348}}, color={0,0,127}));
        connect(bou.ports[1], pumpMainRLTN.port_a) annotation (Line(points={{120,
                -340},{80,-340},{80,-350}},
                                      color={0,127,255}));
        connect(res3.port_a, splSup1.port_2)
          annotation (Line(points={{-80,-140},{-80,-180}}, color={0,127,255}));
        connect(res5.port_b, Tml5.port_b)
          annotation (Line(points={{80,-120},{80,-106}}, color={0,127,255}));
        connect(res3.port_b, Tml2.port_a)
          annotation (Line(points={{-80,-120},{-80,-106}},color={0,127,255}));
        connect(res2.port_b, res5.port_a)
          annotation (Line(points={{80,-162},{80,-140}}, color={0,127,255}));
        connect(res.port_a, res6.port_a)
          annotation (Line(points={{80,-300},{80,-220}}, color={0,127,255}));
        connect(res6.port_b, res2.port_a)
          annotation (Line(points={{80,-200},{80,-182}}, color={0,127,255}));
        connect(pumpSecondarySidePlant.P, EPumPla.u[1]) annotation (Line(points={{-189,
                -199},{-189,-150},{-186,-150},{-186,-149.9},{-154,-149.9}},
                                                                     color={0,0,127}));
        connect(pumpPrimarySidePlant.P, EPumPla.u[2]) annotation (Line(points={{-131,
                -199},{-131,-174},{-160,-174},{-160,-154.1},{-154,-154.1}},
                                                               color={0,0,127}));
        connect(ets1.PPum, EPumPro.u[1]) annotation (Line(points={{-318.571,
                -4.28571},{-264,-4.28571},{-264,288},{246,288}},
                                                             color={0,0,127}));
        connect(ets1.PCom, EHeaPum.u[1]) annotation (Line(points={{-318.571,
                -1.42857},{-260,-1.42857},{-260,268},{246,268}},
                                                           color={0,0,127}));
        connect(EPumDis.u[1], pumpMainRLTN.P)
          annotation (Line(points={{222,-377.9},{170,-377.9},{170,-386},{72,
                -386},{72,-371},{71,-371}},                        color={0,0,127}));
        connect(EBorFie.u[1], borFie.Q_flow) annotation (Line(points={{-38,-460},{-52,
                -460},{-52,-448},{-13,-448}}, color={0,0,127}));
        connect(heatFromToPlantPrimarySide.y, EPlant.u[1])
          annotation (Line(points={{-99,-250},{-66,-250}}, color={0,0,127}));
        connect(heatFromToNetwrokProsumer1.y, EProsumer1.u[1])
          annotation (Line(points={{-159,-80},{-118,-80}}, color={0,0,127}));
        connect(EProsumer2.u[1], heatFromToNetwrokProsumer2.y) annotation (Line(
              points={{180,100},{190,100},{190,100},{199,100}}, color={0,0,127}));
        connect(EProsumer3.u[1], heatFromToNetwrokProsumer3.y)
          annotation (Line(points={{180,-100},{219,-100}}, color={0,0,127}));
        connect(heatFromToNetwrokProsumer1.y, ESumProsumers.u[1]) annotation (Line(
              points={{-159,-80},{-132,-80},{-132,-110},{220,-110},{220,-157.2}},
              color={0,0,127}));
        connect(heatFromToNetwrokProsumer3.y, ESumProsumers.u[2]) annotation (Line(
              points={{219,-100},{200,-100},{200,-160},{220,-160}},
                                    color={0,0,127}));
        connect(heatFromToNetwrokProsumer2.y, ESumProsumers.u[3]) annotation (Line(
              points={{199,100},{190,100},{190,60},{254,60},{254,-120},{220,-120},{
                220,-162.8}},                                           color={0,0,
                127}));
        connect(EHeaPum.y, EEleTot.u[1]) annotation (Line(points={{259.02,268},{266,
                268},{266,282.1},{284,282.1}},
                                            color={0,0,127}));
        connect(EEleTot.y, pri.x[1])
          annotation (Line(points={{297.02,280},{350,280}}, color={0,0,127}));
        connect(borFie.port_a, pumpBHS.port_b)
          annotation (Line(points={{8,-440},{40,-440}}, color={0,127,255}));
        connect(res1.port_a, splSup10.port_1)
          annotation (Line(points={{-80,-340},{-80,-390}}, color={0,127,255}));
        connect(splSup10.port_2, borFie.port_b) annotation (Line(points={{-80,
                -410},{-80,-440},{-12,-440}},
                                       color={0,127,255}));
        connect(pumpBHS.port_a, splSup9.port_2) annotation (Line(points={{60,-440},
                {80,-440},{80,-410}},color={0,127,255}));
        connect(splSup9.port_1, pumpMainRLTN.port_b)
          annotation (Line(points={{80,-390},{80,-370}}, color={0,127,255}));
        connect(splSup10.port_3, splSup9.port_3)
          annotation (Line(points={{-70,-400},{70,-400}}, color={0,127,255}));
        connect(pumpBHS.P, EPumDis.u[2]) annotation (Line(points={{39,-431},{24,
                -431},{24,-430},{20,-430},{20,-420},{200,-420},{200,-382.1},{
                222,-382.1}},                                    color={0,0,127}));
        connect(Tml1.T, TVio.u[1]) annotation (Line(points={{-86.6,-300},{-292,-300},
                {-292,333.36},{324,333.36}},color={0,0,127}));
        connect(Tml2.T, TVio.u[2]) annotation (Line(points={{-86.6,-100},{-282,
                -100},{-282,331.68},{324,331.68}},
                                       color={0,0,127}));
        connect(Tml3.T, TVio.u[3]) annotation (Line(points={{6.66134e-16,226.6},
                {6.66134e-16,330},{324,330}},
                                 color={0,0,127}));
        connect(Tml4.T, TVio.u[4]) annotation (Line(points={{86.6,120},{220,120},{220,
                328.32},{324,328.32}}, color={0,0,127}));
        connect(Tml5.T, TVio.u[5]) annotation (Line(points={{86.6,-100},{140,-100},{
                140,-80},{260,-80},{260,326.64},{324,326.64}},
                                                             color={0,0,127}));
        connect(TVio.y, pri1.x[1])
          annotation (Line(points={{337.02,330},{350,330}}, color={0,0,127}));
        connect(EPumPro.y, EPumTot.u[1]) annotation (Line(points={{259.02,288},{266,
                288},{266,310.8},{284,310.8}}, color={0,0,127}));
        connect(EPumDis.y, EPumTot.u[2]) annotation (Line(points={{235.02,-380},
                {268,-380},{268,308},{284,308}},
                                            color={0,0,127}));
        connect(EPumPla.y, EPumTot.u[3]) annotation (Line(points={{-140.98,-152},{
                -132,-152},{-132,-88},{-270,-88},{-270,328},{270,328},{270,305.2},{
                284,305.2}}, color={0,0,127}));
        connect(EPumTot.y, EEleTot.u[2]) annotation (Line(points={{297.02,308},{300,
                308},{300,294},{276,294},{276,277.9},{284,277.9}}, color={0,0,127}));
        connect(bui1.ports_b1[1], ets1.port_aHeaWat) annotation (Line(points={{-320,30},
                {-320,32},{-300,32},{-300,8},{-380,8},{-380,-28.5714},{-360,
                -28.5714}}, color={0,127,255}));
        connect(ets1.port_bHeaWat, bui1.ports_a1[1]) annotation (Line(points={{-320,
                -28.5714},{-312,-28.5714},{-312,-28},{-302,-28},{-302,-60},{
                -400,-60},{-400,36},{-380,36},{-380,30}},
                                                color={0,127,255}));
        connect(bui1.ports_b1[2], ets1.port_aChi) annotation (Line(points={{-320,34},
                {-320,28},{-304,28},{-304,12},{-384,12},{-384,-37.1429},{-360,
                -37.1429}}, color={0,127,255}));
        connect(ets1.port_bChi, bui1.ports_a1[2]) annotation (Line(points={{-320,
                -37.2857},{-312,-37.2857},{-312,-36},{-306,-36},{-306,-56},{
                -396,-56},{-396,30},{-380,30},{-380,34}},
                                                color={0,127,255}));
        connect(TSetHeaWatSup.y, ets1.TSetHeaWat) annotation (Line(points={{-438,
                240},{-420,240},{-420,-2.85714},{-361.429,-2.85714}},
                                                                 color={0,0,127}));
        connect(TSetChiWatSup.y, ets1.TSetChiWat) annotation (Line(points={{-438,
                210},{-420,210},{-420,-8.57143},{-361.429,-8.57143}},
                                                                 color={0,0,127}));
        connect(bui2.ports_b1[1], ets2.port_aHeaWat) annotation (Line(points={{360,170},
                {400,170},{400,60},{300,60},{300,92},{320,92},{320,91.4286}},
              color={0,127,255}));
        connect(ets2.port_bHeaWat, bui2.ports_a1[1]) annotation (Line(points={{360,
                91.4286},{382,91.4286},{382,148},{292,148},{292,170},{300,170}},
              color={0,127,255}));
        connect(bui2.ports_b1[2], ets2.port_aChi) annotation (Line(points={{360,174},
                {366,174},{366,168},{394,168},{394,66},{306,66},{306,82.8571},{
                320,82.8571}},
                           color={0,127,255}));
        connect(ets2.port_bChi, bui2.ports_a1[2]) annotation (Line(points={{360,
                82.7143},{370,82.7143},{370,82},{388,82},{388,154},{296,154},{
                296,170},{300,170},{300,174}},
                                      color={0,127,255}));
        connect(TSetHeaWatSup.y, ets2.TSetHeaWat) annotation (Line(points={{-438,
                240},{288,240},{288,117.143},{318.571,117.143}},
                                                            color={0,0,127}));
        connect(TSetChiWatSup.y, ets2.TSetChiWat) annotation (Line(points={{-438,
                210},{284,210},{284,111.429},{318.571,111.429}},
                                                            color={0,0,127}));
        connect(bui3.ports_b1[1], ets3.port_aHeaWat) annotation (Line(points={{360,-30},
                {400,-30},{400,-140},{300,-140},{300,-108.571},{320,-108.571}},
              color={0,127,255}));
        connect(ets3.port_bHeaWat, bui3.ports_a1[1]) annotation (Line(points={{360,
                -108.571},{384,-108.571},{384,-54},{288,-54},{288,-30},{300,-30}},
              color={0,127,255}));
        connect(bui3.ports_b1[2], ets3.port_aChi) annotation (Line(points={{360,-26},
                {360,-34},{394,-34},{394,-134},{306,-134},{306,-117.143},{320,
                -117.143}}, color={0,127,255}));
        connect(ets3.port_bChi, bui3.ports_a1[2]) annotation (Line(points={{360,
                -117.286},{368,-117.286},{368,-118},{388,-118},{388,-50},{292,
                -50},{292,-30},{300,-30},{300,-26}},
                                               color={0,127,255}));
        connect(TSetHeaWatSup.y, ets3.TSetHeaWat) annotation (Line(points={{-438,
                240},{288,240},{288,-82.8571},{318.571,-82.8571}},
                                                              color={0,0,127}));
        connect(TSetChiWatSup.y, ets3.TSetChiWat) annotation (Line(points={{-438,
                210},{284,210},{284,-88},{302,-88},{302,-88.5714},{318.571,
                -88.5714}},
              color={0,0,127}));
        connect(tempBeforeProsumer1.port_a, massFlowRateThroughProsumer1AfterSB.port_b)
          annotation (Line(points={{-114,-40},{-106,-40}}, color={0,127,255}));
        connect(massFlowRateThroughProsumer1AfterSB.port_a, splSup8.port_3)
          annotation (Line(points={{-94,-40},{-90,-40}}, color={0,127,255}));
        connect(splSup3.port_3, massFlowRateThroughProsumer3AfterSB.port_a)
          annotation (Line(points={{90,-20},{94,-20}}, color={0,127,255}));
        connect(tempBeforeProsumer3.port_a, massFlowRateThroughProsumer3AfterSB.port_b)
          annotation (Line(points={{114,-20},{106,-20}}, color={0,127,255}));
        connect(tempBeforeProsumer3.port_b, ets3.port_a) annotation (Line(
              points={{126,-20},{280,-20},{280,-100},{320,-100}}, color={0,127,
                255}));
        connect(ets3.port_b, tempAfterProsumer3.port_a) annotation (Line(points={{359.857,
                -100},{380,-100},{380,-60},{126,-60}},          color={0,127,
                255}));
        connect(splSup5.port_3, massFlowRateThroughProsumer2AfterSB.port_a)
          annotation (Line(points={{90,180},{94,180}}, color={0,127,255}));
        connect(tempBeforeProsumer2.port_a, massFlowRateThroughProsumer2AfterSB.port_b)
          annotation (Line(points={{114,180},{106,180}}, color={0,127,255}));
        connect(tempBeforeProsumer2.port_b, ets2.port_a) annotation (Line(
              points={{126,180},{280,180},{280,100},{320,100}}, color={0,127,
                255}));
        connect(ets2.port_b, tempAfterProsumer2.port_a) annotation (Line(points={{359.857,
                100},{368,100},{368,140},{126,140}},          color={0,127,255}));
        connect(ets1.port_b, tempAfterProsumer1.port_a) annotation (Line(points={{
                -320.143,-20},{-140,-20},{-140,8.88178e-16},{-126,8.88178e-16}},
              color={0,127,255}));
        connect(tempBeforeProsumer1.port_b, ets1.port_a) annotation (Line(
              points={{-126,-40},{-260,-40},{-260,-48},{-370,-48},{-370,-20},{
                -360,-20}}, color={0,127,255}));
        annotation (Diagram(
              coordinateSystem(preserveAspectRatio=false, extent={{-480,-500},{480,
                  500}})),
          experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
          Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
      end RN_BaseModel;
    end BaseClasses;
  end Examples;

  package Validation "Collection of validation models"
    extends Modelica.Icons.ExamplesPackage;

    model BuildingETSConnection
      "Validation of building and ETS connection"
      extends Modelica.Icons.Example;
        package Medium1 = Buildings.Media.Water
        "Source side medium";
      Buildings.Fluid.Sources.Boundary_pT sinCoo(
        redeclare package Medium = Medium1,
        nPorts=1)
        "Sink for district water"
        annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={110,-60})));
      Agents.EnergyTransferStation etsOff(
        redeclare package Medium = Medium1,
        QCoo_flow_nominal=sum(buiOff.terUni.QCoo_flow_nominal),
        QHea_flow_nominal=sum(buiOff.terUni.QHea_flow_nominal))
        "Energy transfer station"
        annotation (Placement(transformation(extent={{0,-80},{40,-40}})));
      Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump buiOff(redeclare
          package Medium1 = Medium1, nPorts1=2) "Building"
        annotation (Placement(transformation(extent={{0,20},{20,40}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(k=etsOff.THeaWatSup_nominal)
        "Heating water supply temperature set point"
        annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(k=etsOff.TChiWatSup_nominal)
        "Chilled water supply temperature set point"
        annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
      inner parameter Examples.DesignDataDHC
                                    datDes(
        mDisPip_flow_nominal=95,
        RDisPip=250,
        epsPla=0.935)                      "Design values"
        annotation (Placement(transformation(extent={{-160,64},{-140,84}})));
      Fluid.Sources.Boundary_pT sou(
        redeclare package Medium = Medium1,
        use_T_in=true,
        nPorts=1) "Source for district water" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-70,-60})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDis(k=273.15 + 15)
        "District water temperature"
        annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
    equation
      connect(TSetHeaWatSup.y,etsOff. TSetHeaWat) annotation (Line(points={{-138,
              -10},{-40,-10},{-40,-42.8571},{-1.42857,-42.8571}},  color={0,0,127}));
      connect(TSetChiWatSup.y,etsOff. TSetChiWat) annotation (Line(points={{-138,
              -40},{-40,-40},{-40,-48.5714},{-1.42857,-48.5714}},  color={0,0,127}));
      connect(etsOff.port_b, sinCoo.ports[1]) annotation (Line(points={{39.8571,
              -60},{100,-60}},             color={0,127,255}));
      connect(etsOff.port_bHeaWat, buiOff.ports_a1[1]) annotation (Line(points={{40,
              -68.5714},{50,-68.5714},{50,-20},{-32,-20},{-32,10},{-20,10}}, color={
              0,127,255}));
      connect(buiOff.ports_b1[1], etsOff.port_aHeaWat) annotation (Line(points={{40,10},
              {60,10},{60,-100},{-20,-100},{-20,-68.5714},{0,-68.5714}},     color={
              0,127,255}));
      connect(etsOff.port_bChi, buiOff.ports_a1[2]) annotation (Line(points={{40,
              -77.2857},{40,-78},{54,-78},{54,-16},{-36,-16},{-36,14},{-20,14}},
                                                                       color={0,127,
              255}));
      connect(buiOff.ports_b1[2], etsOff.port_aChi) annotation (Line(points={{40,14},
              {64,14},{64,-104},{-16,-104},{-16,-77.1429},{0,-77.1429}}, color={0,127,
              255}));
      connect(sou.ports[1],etsOff. port_a)
        annotation (Line(points={{-60,-60},{0,-60}},  color={0,127,255}));
      connect(TDis.y, sou.T_in) annotation (Line(points={{-138,-70},{-100,-70},{-100,
              -56},{-82,-56}}, color={0,0,127}));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{160,
                120}}),
        graphics={Text(
              extent={{-68,100},{64,74}},
              lineColor={28,108,200},
              textString="Simulation requires
Hidden.AvoidDoubleComputation=true")}),
       experiment(
          StopTime=172800,
          Tolerance=1e-06,
          __Dymola_Algorithm="Cvode"),
        __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Examples/FifthGenUniSeries/Validation/BuildingETSConnection.mos"
            "Simulate and plot"));
    end BuildingETSConnection;
  end Validation;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UnidirectionalSeries;
