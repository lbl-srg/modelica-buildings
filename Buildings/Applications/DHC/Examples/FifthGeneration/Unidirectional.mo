within Buildings.Applications.DHC.Examples.FifthGeneration;
package Unidirectional
  "Package with example models of unidirectional DHC systems"
  extends Modelica.Icons.VariantsPackage;

  package Agents "Package with models for agents"
    extends Modelica.Icons.VariantsPackage;
    model BoreField "Bore field model"
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
      parameter Integer dBor = 10
      "Distance between boreholes";
      Modelica.Blocks.Interfaces.RealOutput Q_flow
        "Heat extracted from soil"
        annotation (Placement(transformation(extent={{100,70},{120,90}})));
    equation
      connect(gaiQ_flow.y, Q_flow) annotation (Line(points={{1,80},{14,80},{14,54},{
              96,54},{96,80},{110,80}}, color={0,0,127}));
    end BoreField;

    model BuildingWithETS "Model of a building with an energy transfer station"
      extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
        final m_flow_nominal=max(
          ets.m1HexChi_flow_nominal, ets.mEva_flow_nominal),
        final m_flow_small=1E-4*m_flow_nominal,
        final show_T=false,
        final allowFlowReversal=false);
      parameter String idfPath=
        "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"
        "Path of the IDF file"
        annotation(Dialog(group="Building model parameters"));
      parameter String weaPath=
        "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
        "Path of the weather file"
        annotation(Dialog(group="Building model parameters"));
      parameter Integer nZon=6
        "Number of thermal zones"
        annotation(Dialog(group="Building model parameters"), Evaluate=true);
      parameter Integer nSup = 2
        "Number of supply lines"
        annotation(Dialog(group="ETS model parameters"), Evaluate=true);
      parameter Modelica.SIunits.TemperatureDifference dT_nominal=5
        "Water temperature drop/increase accross load and source-side HX (always positive)"
        annotation(Dialog(group="ETS model parameters"));
      parameter Modelica.SIunits.Temperature TChiWatSup_nominal=273.15 + 18
        "Chilled water supply temperature"
        annotation(Dialog(group="ETS model parameters"));
      parameter Modelica.SIunits.Temperature TChiWatRet_nominal=
         TChiWatSup_nominal + dT_nominal
         "Chilled water return temperature"
         annotation(Dialog(group="ETS model parameters"));
      parameter Modelica.SIunits.Temperature THeaWatSup_nominal=273.15 + 40
        "Heating water supply temperature"
        annotation(Dialog(group="ETS model parameters"));
      parameter Modelica.SIunits.Temperature THeaWatRet_nominal=
         THeaWatSup_nominal - dT_nominal
         "Heating water return temperature"
         annotation(Dialog(group="ETS model parameters"));
      parameter Modelica.SIunits.Pressure dp_nominal=50000
        "Pressure difference at nominal flow rate (for each flow leg)"
        annotation(Dialog(group="ETS model parameters"));
      parameter Real COP_nominal=5
        "Heat pump COP"
        annotation(Dialog(group="ETS model parameters"));
      // IO CONNECTORS
      Modelica.Blocks.Interfaces.RealInput TSetChiWat
        "Chilled water set point"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-120,40}),
            iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-110,40})));
      Modelica.Blocks.Interfaces.RealInput TSetHeaWat
        "Heating water set point"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-120,70}),
            iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-110,80})));
      // COMPONENTS
      replaceable Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui(
        redeclare package Medium1=Medium,
        nZon=nZon,
        idfPath=idfPath,
        weaPath=weaPath,
        nPorts1=nSup)
        "Building"
        annotation (Placement(transformation(extent={{-10,40},{10,60}})));
      replaceable SimplifiedETS ets(
        redeclare package Medium = Medium,
        nSup=nSup,
        QCoo_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
        QHea_flow_nominal=sum(bui.terUni.QHea_flow_nominal),
        dT_nominal=dT_nominal,
        TChiWatSup_nominal=TChiWatSup_nominal,
        TChiWatRet_nominal=TChiWatRet_nominal,
        THeaWatSup_nominal=THeaWatSup_nominal,
        THeaWatRet_nominal=THeaWatRet_nominal,
        dp_nominal=dp_nominal,
        COP_nominal=COP_nominal) "Energy transfer station"
        annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));
    equation
      connect(port_a, ets.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,-40},
              {-20,-40}}, color={0,127,255}));
      connect(ets.port_b, port_b) annotation (Line(points={{20,-40},{80,-40},{80,0},
              {100,0}},    color={0,127,255}));
      connect(TSetChiWat, ets.TSetChiWat) annotation (Line(points={{-120,40},{-74,
              40},{-74,-28.5714},{-21.4286,-28.5714}},
                                                   color={0,0,127}));
      connect(TSetHeaWat, ets.TSetHeaWat) annotation (Line(points={{-120,70},{-68,
              70},{-68,-22.8571},{-21.4286,-22.8571}},
                                                   color={0,0,127}));
      connect(bui.ports_b1[1:2], ets.ports_a1) annotation (Line(points={{30,32},{60,
              32},{60,0},{-40,0},{-40,-52.8571},{-20,-52.8571}}, color={0,127,255}));
      connect(ets.ports_b1, bui.ports_a1[1:2]) annotation (Line(points={{20,
              -52.8571},{28,-52.8571},{40,-52.8571},{40,-80},{-60,-80},{-60,32},{
              -30,32}},
            color={0,127,255}));
      annotation (
        DefaultComponentName="bui",
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                {100,100}}), graphics={
            Rectangle(
              extent={{-60,-34},{0,-28}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-60,-34},{0,-40}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{0,-40},{60,-34}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{0,-28},{60,-34}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{60,6},{100,0}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-100,0},{-60,-6}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-100,0},{-60,6}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{60,-6},{100,0}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid),
          Polygon(
            points={{0,80},{-40,60},{40,60},{0,80}},
            lineColor={95,95,95},
            smooth=Smooth.None,
            fillPattern=FillPattern.Solid,
            fillColor={95,95,95}),
          Rectangle(
              extent={{-40,60},{40,-40}},
              lineColor={150,150,150},
              fillPattern=FillPattern.Sphere,
              fillColor={255,255,255}),
          Rectangle(
            extent={{-30,30},{-10,50}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{10,30},{30,50}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-30,-10},{-10,10}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{10,-10},{30,10}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
            Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
            Rectangle(
              extent={{-20,-3},{20,3}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid,
              origin={63,-20},
              rotation=90),
            Rectangle(
              extent={{-19,3},{19,-3}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid,
              origin={-63,-21},
              rotation=90),
            Rectangle(
              extent={{-19,-3},{19,3}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid,
              origin={-57,-13},
              rotation=90),
            Rectangle(
              extent={{-19,3},{19,-3}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid,
              origin={57,-13},
              rotation=90)}),                                        Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end BuildingWithETS;

    model SimplifiedETS
      "Model of a simplified substation for heating hot water (heat pump) and chilled water (free-cooling HX) production"
      replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium
        "Medium model for water"
        annotation (choicesAllMatching = true);
      outer
        Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Data.DesignDataDHC
        datDes "DHC systenm design data";
      // SYSTEM GENERAL
      parameter Integer nSup = 2
        "Number of supply lines"
        annotation(Evaluate=true);
      parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
        min=Modelica.Constants.eps)
        "Design cooling thermal power (always positive)"
        annotation (Dialog(group="Nominal conditions"));
      parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
        min=Modelica.Constants.eps)
        "Design heating thermal power (always positive)"
        annotation (Dialog(group="Nominal conditions"));
      parameter Modelica.SIunits.TemperatureDifference dT_nominal = 5
        "Water temperature drop/increase accross load and source-side HX (always positive)"
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
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.specificHeatCapacityCp(Medium.setState_pTX(
          p = Medium.p_default,
          T = Medium.T_default,
          X = Medium.X_default))
        "Specific heat capacity of the fluid";
      final parameter Boolean allowFlowReversal = false
        "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);
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
      // IO CONNECTORS
      Modelica.Fluid.Interfaces.FluidPort_a port_a(
        redeclare final package Medium = Medium,
        m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
        h_outflow(start=Medium.h_default, nominal=Medium.h_default))
        "Fluid connector a"
        annotation (Placement(transformation(extent={{-290,-410},{-270,-390}}),
            iconTransformation(extent={{-300,-20},{-260,20}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_b(
        redeclare final package Medium = Medium,
        m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
        h_outflow(start=Medium.h_default, nominal=Medium.h_default))
        "Fluid connector b"
        annotation (Placement(transformation(extent={{290,-410},{270,-390}}),
            iconTransformation(extent={{300,-20},{260,20}})));
      Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nSup](
        redeclare each final package Medium = Medium,
        each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
        each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
        "Fluid connectors a (positive design flow direction is from port_a to ports_b)"
        annotation (Placement(transformation(extent={{-290,80},{-270,160}}),
          iconTransformation(extent={{-300,-260},{-260,-100}})));
      Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nSup](
        redeclare each final package Medium = Medium,
        each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
        each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
        "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
        annotation (Placement(transformation(extent={{270,80},{290,160}}),
          iconTransformation(extent={{260,-260},{300,-100}})));
      Modelica.Blocks.Interfaces.RealInput TSetHeaWat
        "Heating water set point"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-300,200}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-300,240})));
      Modelica.Blocks.Interfaces.RealInput TSetChiWat "Chilled water set point"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-300,40}),   iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-300,160})));
      Modelica.Blocks.Interfaces.RealOutput mHea_flow
        "District water mass flow rate used for heating service"
        annotation ( Placement(transformation(extent={{280,260},{320,300}}),
            iconTransformation(extent={{280,80},{320,120}})));
      Modelica.Blocks.Interfaces.RealOutput mCoo_flow
        "District water mass flow rate used for cooling service"
        annotation ( Placement(transformation(extent={{280,220},{320,260}}),
            iconTransformation(extent={{280,40},{320,80}})));
      Modelica.Blocks.Interfaces.RealOutput PCom(final unit="W")
        "Power drawn by compressor"
        annotation (Placement(transformation(extent={{280,420},{320,460}}),
            iconTransformation(extent={{280,240},{320,280}})));
      Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W")
        "Power drawn by pumps motors"
        annotation (Placement(transformation(extent={{280,380},{320,420}}),
            iconTransformation(extent={{280,200},{320,240}})));
      Modelica.Blocks.Interfaces.RealOutput PHea(unit="W")
        "Total power consumed for space heating"
        annotation (Placement(transformation(extent={{280,340},{320,380}}),
            iconTransformation(extent={{280,160},{320,200}})));
      Modelica.Blocks.Interfaces.RealOutput PCoo(unit="W")
        "Total power consumed for space cooling"
        annotation (Placement(transformation(extent={{280,300},{320,340}}),
            iconTransformation(extent={{280,120},{320,160}})));
      // COMPONENTS
      Buildings.Fluid.Delays.DelayFirstOrder volMix_a(
        redeclare final package Medium = Medium,
        nPorts=3,
        final m_flow_nominal=(mEva_flow_nominal + m1HexChi_flow_nominal)/2,
        final allowFlowReversal=true,
        tau=600,
        final energyDynamics=mixingVolumeEnergyDynamics)
        "Mixing volume to break algebraic loops and to emulate the delay of the substation"
        annotation (Placement(transformation(extent={{-270,-400},{-250,-420}})));
      Buildings.Fluid.Delays.DelayFirstOrder volMix_b(
        redeclare final package Medium = Medium,
        nPorts=3,
        final m_flow_nominal=(mEva_flow_nominal + m1HexChi_flow_nominal)/2,
        final allowFlowReversal=true,
        tau=600,
        final energyDynamics=mixingVolumeEnergyDynamics)
        "Mixing volume to break algebraic loops and to emulate the delay of the substation"
        annotation (Placement(transformation(extent={{250,-400},{270,-420}})));
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
        annotation (Placement(transformation(extent={{10,116},{-10,136}})));
      Distribution.BaseClasses.Pump_m_flow pumEva(redeclare final package
          Medium =
            Medium, final m_flow_nominal=mEva_flow_nominal) "Evaporator pump"
        annotation (Placement(transformation(extent={{-110,110},{-90,130}})));
      Distribution.BaseClasses.Pump_m_flow pum1HexChi(redeclare final package
          Medium = Medium, final m_flow_nominal=m1HexChi_flow_nominal)
        "Chilled water HX primary pump"
        annotation (Placement(transformation(extent={{-110,-270},{-90,-250}})));
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
        annotation (Placement(transformation(extent={{-10,-244},{10,-264}})));
      Buildings.Fluid.Delays.DelayFirstOrder volHeaWatRet(
        redeclare final package Medium = Medium,
        nPorts=3,
        m_flow_nominal=mCon_flow_nominal,
        allowFlowReversal=allowFlowReversal,
        tau=60,
        energyDynamics=mixingVolumeEnergyDynamics)
        "Mixing volume representing HHW primary"
        annotation (Placement(transformation(extent={{12,220},{32,240}})));
      Distribution.BaseClasses.Pump_m_flow pumCon(redeclare package Medium = Medium,
          final m_flow_nominal=mCon_flow_nominal) "Condenser pump"
        annotation (Placement(transformation(extent={{110,150},{90,170}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort senT2HexChiLvg(
        redeclare final package Medium = Medium,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=m2HexChi_flow_nominal)
        "CHW HX secondary water leaving temperature (sensed)"
        annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={-160,-220})));
      Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysWitHol(
        uLow=1E-4*mHeaWat_flow_nominal,
        uHigh=0.01*mHeaWat_flow_nominal,
        trueHoldDuration=0,
        falseHoldDuration=30)
        annotation (Placement(transformation(extent={{-210,270},{-190,290}})));
      Buildings.Fluid.Sensors.MassFlowRate senMasFloHeaWat(
        redeclare final package Medium = Medium,
        allowFlowReversal=allowFlowReversal)
        "Heating water mass flow rate (sensed)"
        annotation (Placement(transformation(extent={{-230,370},{-210,350}})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=mCon_flow_nominal)
        annotation (Placement(transformation(extent={{-140,270},{-120,290}})));
      Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
        annotation (Placement(transformation(extent={{-180,270},{-160,290}})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=mEva_flow_nominal)
        annotation (Placement(transformation(extent={{-140,230},{-120,250}})));
      Buildings.Fluid.Delays.DelayFirstOrder volChiWat(
        redeclare final package Medium = Medium,
        nPorts=3,
        m_flow_nominal=m1HexChi_flow_nominal,
        allowFlowReversal=allowFlowReversal,
        tau=60,
        energyDynamics=mixingVolumeEnergyDynamics)
        "Mixing volume representing CHW primary"
        annotation (Placement(transformation(extent={{10,-160},{30,-140}})));
      Distribution.BaseClasses.Pump_m_flow pum2CooHex(redeclare package Medium =
            Medium, final m_flow_nominal=m2HexChi_flow_nominal)
        "Chilled water HX secondary pump"
        annotation (Placement(transformation(extent={{110,-230},{90,-210}})));
      Buildings.Fluid.Sensors.MassFlowRate senMasFloChiWat(
        redeclare package Medium = Medium,
        allowFlowReversal=allowFlowReversal)
        "Chilled water mass flow rate (sensed)"
        annotation (Placement(transformation(extent={{-230,-90},{-210,-70}})));
      Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysWitHol1(
        uLow=1E-4*mChiWat_flow_nominal,
        uHigh=0.01*mChiWat_flow_nominal,
        trueHoldDuration=0,
        falseHoldDuration=30)
        annotation (Placement(transformation(extent={{-212,-10},{-192,10}})));
      Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
        annotation (Placement(transformation(extent={{-186,-10},{-166,10}})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gai2(k=m1HexChi_flow_nominal)
        annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort senTConLvg(
        redeclare final package Medium = Medium,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=mCon_flow_nominal)
        "Condenser water leaving temperature (sensed)"
        annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={-160,160})));
      Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat(
        each Ti=120,
        each yMax=1,
        each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
        reverseAction=true,
        each yMin=0) "PI controller for chilled water supply"
        annotation (Placement(transformation(extent={{-170,30},{-150,50}})));
      Buildings.Controls.OBC.CDL.Continuous.Product pro
        annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gai4(k=1.1)
        annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
      Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=1)
        annotation (Placement(transformation(extent={{230,310},{250,330}})));
      Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=1)
        annotation (Placement(transformation(extent={{230,350},{250,370}})));
      Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumHea(nin=2)
        "Total power drawn by pumps motors for space heating (ETS included, building excluded)"
        annotation (Placement(transformation(extent={{170,410},{190,430}})));
      Buildings.Fluid.Sources.Boundary_pT bouHea(
        redeclare final package Medium = Medium, nPorts=1)
        "Pressure boundary condition representing the expansion vessel"
        annotation (Placement(transformation(extent={{60,230},{40,250}})));
      Buildings.Fluid.Sources.Boundary_pT bouChi(
        redeclare final package Medium = Medium, nPorts=1)
                  "Pressure boundary condition representing the expansion vessel"
        annotation (Placement(transformation(extent={{60,-150},{40,-130}})));
      Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumCoo(nin=2)
        "Total power drawn by pumps motors for space cooling (ETS included, building excluded)"
        annotation (Placement(transformation(extent={{170,370},{190,390}})));
      Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=2)
        annotation (Placement(transformation(extent={{230,390},{250,410}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(
        redeclare final package Medium=Medium,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=mHeaWat_flow_nominal)
        "Heating water supply temperature (sensed)" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={40,360})));
      Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatSup(
        redeclare final package Medium=Medium,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=mHeaWat_flow_nominal)
        "Chilled water supply temperature (sensed)" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={40,-80})));
      EnergyTransferStations.BaseClasses.HydraulicHeader decHeaWat(
        redeclare final package Medium=Medium,
        m_flow_nominal=mHeaWat_flow_nominal,
        nPorts_a=2,
        nPorts_b=2) "Primary-secondary decoupler"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={0,350})));
      EnergyTransferStations.BaseClasses.HydraulicHeader decChiWat(
        redeclare final package Medium=Medium,
        m_flow_nominal=mChiWat_flow_nominal,
        nPorts_a=2,
        nPorts_b=2) "Primary-secondary decoupler"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={0,-90})));
      // MISCELLANEOUS VARIABLES
      Medium.ThermodynamicState sta_a=if allowFlowReversal then
        Medium.setState_phX(port_a.p,
          noEvent(actualStream(port_a.h_outflow)),
          noEvent(actualStream(port_a.Xi_outflow))) else
      Medium.setState_phX(port_a.p,
          inStream(port_a.h_outflow),
          inStream(port_a.Xi_outflow)) if show_T
        "Medium properties in port_a";
      Medium.ThermodynamicState sta_b=if allowFlowReversal then
        Medium.setState_phX(port_b.p,
          noEvent(actualStream(port_b.h_outflow)),
          noEvent(actualStream(port_b.Xi_outflow))) else
        Medium.setState_phX(port_b.p,
          port_b.h_outflow,
          port_b.Xi_outflow) if  show_T
        "Medium properties in port_b";
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
      connect(volMix_a.ports[1], port_a) annotation (Line(points={{-262.667,
              -400},{-280,-400}},color={0,127,255}));
      connect(pumEva.port_a, volMix_a.ports[2])
        annotation (Line(points={{-110,120},{-260,120},{-260,-400}},
                                                               color={0,127,255}));
      connect(port_b, volMix_b.ports[1]) annotation (Line(points={{280,-400},{
              257.333,-400}},
                    color={0,127,255}));
      connect(senMasFloHeaWat.m_flow, hysWitHol.u) annotation (Line(points={{-220,349},
              {-220,280},{-212,280}}, color={0,0,127}));
      connect(TSetHeaWat, heaPum.TSet) annotation (Line(points={{-300,200},{20,200},
              {20,135},{12,135}}, color={0,0,127}));
      connect(hysWitHol.y, booToRea.u)
        annotation (Line(points={{-188,280},{-182,280}}, color={255,0,255}));
      connect(booToRea.y, gai.u)
        annotation (Line(points={{-158,280},{-142,280}}, color={0,0,127}));
      connect(gai.y, pumCon.m_flow_in) annotation (Line(points={{-118,280},{100,280},
              {100,172}},  color={0,0,127}));
      connect(gai1.y, pumEva.m_flow_in)
        annotation (Line(points={{-118,240},{-100,240},{-100,132}},
                                                                 color={0,0,127}));
      connect(booToRea.y, gai1.u) annotation (Line(points={{-158,280},{-150,280},{-150,
              240},{-142,240}},
                              color={0,0,127}));
      connect(senMasFloChiWat.m_flow, hysWitHol1.u) annotation (Line(points={{-220,-69},
              {-220,0},{-214,0}},       color={0,0,127}));
      connect(hysWitHol1.y, booToRea1.u)
        annotation (Line(points={{-190,0},{-188,0}},       color={255,0,255}));
      connect(booToRea1.y, gai2.u)
        annotation (Line(points={{-164,0},{-142,0}},       color={0,0,127}));
      connect(senT2HexChiLvg.T, conTChiWat.u_m) annotation (Line(points={{-160,-209},
              {-160,28}},                        color={0,0,127}));
      connect(TSetChiWat, conTChiWat.u_s) annotation (Line(points={{-300,40},{-172,40}},
                      color={0,0,127}));
      connect(gai2.y, pro.u2) annotation (Line(points={{-118,0},{-100,0},{-100,-6},{
              -90,-6}},          color={0,0,127}));
      connect(pro.y, pum1HexChi.m_flow_in)
        annotation (Line(points={{-66,0},{-60,0},{-60,-60},{-100,-60},{-100,-248}},
                                                                color={0,0,127}));
      connect(conTChiWat.y, pro.u1) annotation (Line(points={{-148,40},{-100,40},{-100,
              6},{-90,6}},             color={0,0,127}));
      connect(gai4.y, pum2CooHex.m_flow_in) annotation (Line(points={{-118,-40},{100,
              -40},{100,-208}},   color={0,0,127}));
      connect(senMasFloChiWat.m_flow, gai4.u) annotation (Line(points={{-220,-69},{-220,
              -40},{-142,-40}},        color={0,0,127}));
      connect(PPum, PPum)
        annotation (Line(points={{300,400},{300,400}}, color={0,0,127}));
      connect(heaPum.P, PCom) annotation (Line(points={{-11,126},{-28,126},{-28,100},
              {160,100},{160,440},{300,440}},
                     color={0,0,127}));
      connect(mulSum.y, PCoo)
        annotation (Line(points={{252,320},{300,320}}, color={0,0,127}));
      connect(mulSum1.y, PHea)
        annotation (Line(points={{252,360},{300,360}}, color={0,0,127}));
      connect(pumCon.P, PPumHea.u[1]) annotation (Line(points={{89,169},{40,169},{40,
              200},{168,200},{168,421}},     color={0,0,127}));
      connect(pumEva.P, PPumHea.u[2]) annotation (Line(points={{-89,129},{-89,128},{
              -80,128},{-80,180},{162,180},{162,420},{168,420},{168,419}},
                                                  color={0,0,127}));
      connect(pum1HexChi.P, PPumCoo.u[1]) annotation (Line(points={{-89,-251},{-78,-251},
              {-78,-278},{160,-278},{160,381},{168,381}},
                                              color={0,0,127}));
      connect(pum2CooHex.P, PPumCoo.u[2]) annotation (Line(points={{89,-211},{80,-211},
              {80,2},{162,2},{162,379},{168,379}},                  color={0,0,127}));
      connect(PPumHea.y, mulSum1.u[1]) annotation (Line(points={{192,420},{220,420},
              {220,360},{228,360}}, color={0,0,127}));
      connect(PPumCoo.y, mulSum.u[1]) annotation (Line(points={{192,380},{210,380},{
              210,320},{228,320}}, color={0,0,127}));
      connect(PPumHea.y, mulSum2.u[1]) annotation (Line(points={{192,420},{200,420},
              {200,401},{228,401}}, color={0,0,127}));
      connect(PPumCoo.y, mulSum2.u[2]) annotation (Line(points={{192,380},{200,380},
              {200,340},{214,340},{214,399},{228,399}},
                                    color={0,0,127}));
      connect(mulSum2.y, PPum)
        annotation (Line(points={{252,400},{300,400}}, color={0,0,127}));
      connect(pum1HexChi.port_b, hexChi.port_a1) annotation (Line(points={{-90,-260},
              {-10,-260}},                             color={0,127,255}));
      connect(hexChi.port_b1, volMix_b.ports[2]) annotation (Line(points={{10,-260},
              {260,-260},{260,-400}},                      color={0,127,255}));
      connect(pum2CooHex.port_b, hexChi.port_a2)
        annotation (Line(points={{90,-220},{20,-220},{20,-248},{10,-248}},
                                                      color={0,127,255}));
      connect(hexChi.port_b2, senT2HexChiLvg.port_a)
        annotation (Line(points={{-10,-248},{-20,-248},{-20,-220},{-150,-220}},
                                                          color={0,127,255}));
      connect(volMix_a.ports[3], pum1HexChi.port_a) annotation (Line(points={{
              -257.333,-400},{-260,-400},{-260,-260},{-110,-260}},
                                                             color={0,127,255}));
      connect(pumEva.port_b, heaPum.port_a2)
        annotation (Line(points={{-90,120},{-10,120}}, color={0,127,255}));
      connect(heaPum.port_b2, volMix_b.ports[3]) annotation (Line(points={{10,120},
              {260,120},{260,-398},{262,-398},{262,-400},{262.667,-400}},
                                                   color={0,127,255}));
      connect(heaPum.port_b1, senTConLvg.port_a) annotation (Line(points={{-10,132},
              {-30,132},{-30,160},{-150,160}},     color={0,127,255}));
      connect(pumCon.port_b, heaPum.port_a1) annotation (Line(points={{90,160},{40,160},
              {40,132},{10,132}},         color={0,127,255}));
      connect(ports_a1[1], senMasFloHeaWat.port_a) annotation (Line(points={{-280,100},
              {-240,100},{-240,360},{-230,360}}, color={0,127,255}));
      connect(ports_a1[2], senMasFloChiWat.port_a) annotation (Line(points={{-280,140},
              {-240,140},{-240,-80},{-230,-80}},   color={0,127,255}));
      connect(senTHeaWatSup.port_b, ports_b1[1]) annotation (Line(points={{50,360},
              {180,360},{180,100},{280,100}},color={0,127,255}));
      connect(senTChiWatSup.port_b, ports_b1[2]) annotation (Line(points={{50,-80},
              {240,-80},{240,140},{280,140}},  color={0,127,255}));
      connect(pum1HexChi.m_flow_actual, mCoo_flow) annotation (Line(points={{-89,-255},
              {-80,-255},{-80,-280},{162,-280},{162,240},{300,240}}, color={0,0,127}));
      connect(pumEva.m_flow_actual, mHea_flow) annotation (Line(points={{-89,125},{-78,
              125},{-78,180},{162,180},{162,280},{300,280}}, color={0,0,127}));
      connect(bouHea.ports[1], volHeaWatRet.ports[1]) annotation (Line(points={{40,240},
              {40,220},{19.3333,220}}, color={0,127,255}));
      connect(bouChi.ports[1], volChiWat.ports[1]) annotation (Line(points={{40,-140},
              {40,-160},{17.3333,-160}},
                                      color={0,127,255}));
      connect(volHeaWatRet.ports[2], pumCon.port_a) annotation (Line(points={{22,220},
              {140,220},{140,160},{110,160}},      color={0,127,255}));
      connect(volChiWat.ports[2], pum2CooHex.port_a) annotation (Line(points={{20,-160},
              {140,-160},{140,-220},{110,-220}},       color={0,127,255}));
      connect(senTConLvg.port_b, decHeaWat.ports_a[1]) annotation (Line(points={{
              -170,160},{-200,160},{-200,220},{-20,220},{-20,360},{2,360}}, color={
              0,127,255}));
      connect(decHeaWat.ports_a[2], senTHeaWatSup.port_a) annotation (Line(points={
              {-2,360},{14.85,360},{14.85,360},{30,360}}, color={0,127,255}));
      connect(senMasFloHeaWat.port_b, decHeaWat.ports_b[1]) annotation (Line(points=
             {{-210,360},{-40,360},{-40,340},{-2,340}}, color={0,127,255}));
      connect(decHeaWat.ports_b[2], volHeaWatRet.ports[3]) annotation (Line(points={{2,340},
              {0,340},{0,220},{24.6667,220}},          color={0,127,255}));
      connect(decChiWat.ports_a[1], senTChiWatSup.port_a) annotation (Line(points={
              {2,-80},{14.85,-80},{14.85,-80},{30,-80}}, color={0,127,255}));
      connect(senT2HexChiLvg.port_b, decChiWat.ports_a[2]) annotation (Line(points=
              {{-170,-220},{-220,-220},{-220,-160},{-20,-160},{-20,-80},{-2,-80}},
            color={0,127,255}));
      connect(senMasFloChiWat.port_b, decChiWat.ports_b[1]) annotation (Line(points=
             {{-210,-80},{-40,-80},{-40,-100},{-2,-100}}, color={0,127,255}));
      connect(decChiWat.ports_b[2], volChiWat.ports[3]) annotation (Line(points={{2,-100},
              {0,-100},{0,-160},{22.6667,-160}},       color={0,127,255}));
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
              extent={{-280,0},{280,8}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-280,0},{280,-8}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(extent={{-280,-460},{280,460}},
              preserveAspectRatio=false), graphics={Text(
              extent={{-106,-16},{-38,-44}},
              lineColor={0,0,127},
              pattern=LinePattern.Dash,
              textString="Add minimum pump flow rate")}));
    end SimplifiedETS;

    package Controls "Package with controllers"
      extends Modelica.Icons.VariantsPackage;
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

  package Distribution "Package with models for network"
    extends Modelica.Icons.VariantsPackage;
    model UnidirectionalSeries
      "Distribution system for unidirectional series DHC"
      extends BaseClasses.PartialDistributionSystem(
        final allowFlowReversal=false);
      parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
        "Nominal mass flow rate in the distribution line";
      parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nCon]
        "Nominal mass flow rate in the connection lines";
      parameter Modelica.SIunits.Length lDis[nCon]
        "Length of the distribution pipes (only counting warm or cold line, but not sum)";
      parameter Modelica.SIunits.Length lCon[nCon]
        "Length of the connection pipes (only counting warm or cold line, but not sum)";
      parameter Modelica.SIunits.Length dhDis
        "Hydraulic diameter of distribution pipe";
      parameter Modelica.SIunits.Length dhCon[nCon]
        "Hydraulic diameter of connection pipe";
      BaseClasses.ConnectionSeries con[nCon](
        redeclare package Medium = Medium,
        each mDis_flow_nominal=mDis_flow_nominal,
        mCon_flow_nominal=mCon_flow_nominal,
        lDis=lDis,
        lCon=lCon,
        each dhDis=dhDis,
        dhCon=dhCon,
        each allowFlowReversal=allowFlowReversal) "Connection to agent"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      BaseClasses.PipeDistribution pipDisRet(
        redeclare each package Medium=Medium,
        dh=dhDis,
        length=sum(lDis),
        m_flow_nominal=mDis_flow_nominal,
        allowFlowReversal=allowFlowReversal)
        "Distribution return pipe"
        annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    equation
      connect(port_disInl, con[1].port_disInl)
        annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
      connect(con.port_conSup, ports_b1)
        annotation (Line(points={{0,10},{0,40},{-80,
              40},{-80,100}}, color={0,127,255}));
      connect(ports_a1, con.port_conRet)
        annotation (Line(points={{80,100},{80,40},{
              6,40},{6,10}}, color={0,127,255}));
      // Connecting outlets to inlets for all instances of connection component
      if nCon >= 2 then
        for i in 2:nCon loop
          connect(con[i-1].port_disOut, con[i].port_disInl);
        end for;
      end if;
      connect(con[nCon].port_disOut, pipDisRet.port_a)
        annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
      connect(pipDisRet.port_b, port_disOut)
        annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
      annotation (
        defaultComponentName="dis",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
              extent={{-6,-200},{6,200}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              origin={0,0},
              rotation=90),
            Rectangle(
              extent={{-53,4},{53,-4}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              origin={-120,47},
              rotation=90),
            Rectangle(
              extent={{-53,4},{53,-4}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              origin={120,47},
              rotation=90)}),
        Diagram( coordinateSystem(preserveAspectRatio=false)));
    end UnidirectionalSeries;

    package Controls "Package with controllers"
      extends Modelica.Icons.VariantsPackage;
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

      model SubstationPumpControl
        extends Modelica.Blocks.Icons.Block;
        parameter Modelica.SIunits.MassFlowRate m_flow_nominal
          "Nominal mass flow rate";
        parameter Modelica.SIunits.TemperatureDifference dT = 5
          "Temperature difference in and out";
        parameter Real yMin = 0.01;

        Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
          final unit="K",
          displayUnit="degC") "District supply water temperature"
          annotation (Placement(transformation(extent={{-200,46},{-160,86}}),
              iconTransformation(extent={{-140,-20},{-100,20}})));
        Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
          final unit="K",
          displayUnit="degC") "District return water temperature"
          annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
              iconTransformation(extent={{-140,-100},{-100,-60}})));
        Buildings.Controls.OBC.CDL.Interfaces.IntegerInput modInd "Mode index"
          annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
              iconTransformation(extent={{-140,60},{-100,100}})));
        Modelica.Blocks.Interfaces.RealOutput yPum(unit="kg/s") "Pump mass flow rate"
          annotation (Placement(transformation(extent={{160,80},{180,100}}),
              iconTransformation(extent={{100,-10},{120,10}})));
        Modelica.Blocks.Interfaces.RealOutput pumSpe(unit="1") "Pump speed"
          annotation (Placement(transformation(extent={{160,120},{180,140}}),
              iconTransformation(extent={{100,-70},{120,-50}})));

        Buildings.Controls.OBC.CDL.Continuous.Gain norMas(final k=m_flow_nominal)
          "Normalization of mass flow rate"
          annotation (Placement(transformation(extent={{120,80},{140,100}})));
        Buildings.Controls.OBC.CDL.Continuous.LimPID conPID_dT(
          reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
          controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
          yMax=1,
          k=0.5,
          Ti=240,
          reverseAction=true,
          yMin=yMin,
          y_reset=0)
          annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
        Buildings.Controls.OBC.CDL.Continuous.Add appHea(k1=-1)
          "Approach temperature for heating mode"
          annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
        Buildings.Controls.OBC.CDL.Continuous.Abs abs
          annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temDif(k=dT)
          "Temperature difference setpoint"
          annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
        Buildings.Controls.OBC.CDL.Continuous.LimPID conPID_TMax(
          reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
          controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
          yMax=1,
          k=0.5,
          Ti=240,
          yMin=yMin,
          y_reset=yMin)
          annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
        Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(k=1, p=dT)
          annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
        Buildings.Controls.OBC.CDL.Logical.Not not1
          annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
        Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(k=1, p=(-1)*dT)
          annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
        Buildings.Controls.OBC.CDL.Continuous.LimPID conPID_TMin(
          reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
          controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
          yMax=1,
          k=0.5,
          Ti=240,
          reverseAction=true,
          yMin=yMin,
          y_reset=yMin)
          annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
        Buildings.Controls.OBC.CDL.Logical.Not not2
          annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
        Modelica.Blocks.Sources.BooleanExpression noLoa(y=modInd == 0)
          annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
        Modelica.Blocks.Sources.BooleanExpression cooModFla(y=modInd == -1)
          annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
        Modelica.Blocks.Sources.BooleanExpression heaModFla(y=modInd == 1)
          annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
        Buildings.Controls.OBC.CDL.Continuous.MultiMax cooModCon(nin=2)
          "Control output when in cooling mode"
          annotation (Placement(transformation(extent={{20,-20},{40,0}})));
        Buildings.Controls.OBC.CDL.Continuous.MultiMax heaModCon(nin=2)
          "Control output when in heating mode"
          annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
        Buildings.Controls.OBC.CDL.Logical.Switch pumConWitLoa
          "Pump modulation control when there is load"
          annotation (Placement(transformation(extent={{80,10},{100,30}})));
        Buildings.Controls.OBC.CDL.Logical.Switch pumCon "Pump modulation control"
          annotation (Placement(transformation(extent={{80,80},{100,100}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
          "Constant zero"
          annotation (Placement(transformation(extent={{20,130},{40,150}})));

      equation
        connect(norMas.y, yPum)
          annotation (Line(points={{142,90},{170,90}}, color={0,0,127}));
        connect(appHea.y,abs. u)
          annotation (Line(points={{-98,60},{-82,60}}, color={0,0,127}));
        connect(abs.y,conPID_dT. u_m)
          annotation (Line(points={{-58,60},{-30,60},{-30,128}}, color={0,0,127}));
        connect(temDif.y,conPID_dT. u_s)
          annotation (Line(points={{-118,140},{-42,140}}, color={0,0,127}));
        connect(addPar.y,conPID_TMax. u_s)
          annotation (Line(points={{-98,-10},{-42,-10}},color={0,0,127}));
        connect(not1.y,conPID_TMax. trigger)
          annotation (Line(points={{-58,20},{-50,20},{-50,-32},{-38,-32},{-38,-22}},
            color={255,0,255}));
        connect(addPar1.y,conPID_TMin. u_s)
          annotation (Line(points={{-98,-90},{-42,-90}},color={0,0,127}));
        connect(not2.y,conPID_TMin. trigger)
          annotation (Line(points={{-58,-60},{-50,-60},{-50,-110},{-38,-110},{-38,
                -102}},
            color={255,0,255}));
        connect(noLoa.y,conPID_dT. trigger)
          annotation (Line(points={{-119,110},{-38,110},{-38,128}}, color={255,0,255}));
        connect(cooModFla.y,not1. u)
          annotation (Line(points={{-99,20},{-82,20}}, color={255,0,255}));
        connect(heaModFla.y,not2. u)
          annotation (Line(points={{-99,-60},{-82,-60}}, color={255,0,255}));
        connect(conPID_dT.y,cooModCon. u[1])
          annotation (Line(points={{-18,140},{0,140},{0,-9},{18,-9}}, color={0,0,127}));
        connect(conPID_TMax.y,cooModCon. u[2])
          annotation (Line(points={{-18,-10},{0,-10},{0,-11},{18,-11}}, color={0,0,127}));
        connect(conPID_dT.y,heaModCon. u[1])
          annotation (Line(points={{-18,140},{0,140},{0,-89},{18,-89}},  color={0,0,127}));
        connect(conPID_TMin.y,heaModCon. u[2])
          annotation (Line(points={{-18,-90},{0,-90},{0,-91},{18,-91}},
            color={0,0,127}));
        connect(not1.y, pumConWitLoa.u2)
          annotation (Line(points={{-58,20},{78,20}}, color={255,0,255}));
        connect(cooModCon.y, pumConWitLoa.u3)
          annotation (Line(points={{42,-10},{60,-10},{60,12},{78,12}}, color={0,0,127}));
        connect(heaModCon.y, pumConWitLoa.u1)
          annotation (Line(points={{42,-90},{52,-90},{52,28},{78,28}}, color={0,0,127}));
        connect(TSup, appHea.u1)
          annotation (Line(points={{-180,66},{-122,66}}, color={0,0,127}));
        connect(TRet, appHea.u2)
          annotation (Line(points={{-180,20},{-132,20},{-132,54},{-122,54}}, color={0,0,127}));
        connect(TSup, addPar.u)
          annotation (Line(points={{-180,66},{-140,66},{-140,-10},{-122,-10}},
            color={0,0,127}));
        connect(TRet, conPID_TMax.u_m)
          annotation (Line(points={{-180,20},{-132,20},{-132,-40},{-30,-40},{-30,-22}},
            color={0,0,127}));
        connect(TSup, addPar1.u)
          annotation (Line(points={{-180,66},{-140,66},{-140,-90},{-122,-90}}, color={0,0,127}));
        connect(TRet, conPID_TMin.u_m)
          annotation (Line(points={{-180,20},{-132,20},{-132,-120},{-30,-120},{-30,-102}},
            color={0,0,127}));
        connect(noLoa.y, pumCon.u2)
          annotation (Line(points={{-119,110},{-20,110},{-20,90},{78,90}}, color={255,0,255}));
        connect(con.y, pumCon.u1)
          annotation (Line(points={{42,140},{60,140},{60,98},{78,98}}, color={0,0,127}));
        connect(pumCon.y, norMas.u)
          annotation (Line(points={{102,90},{118,90}}, color={0,0,127}));
        connect(pumCon.y, pumSpe)
          annotation (Line(points={{102,90},{110,90},{110,130},{170,130}},  color={0,0,127}));
        connect(pumConWitLoa.y, pumCon.u3)
          annotation (Line(points={{102,20},{120,20},{120,40},{60,40},{60,82},{78,82}},
            color={0,0,127}));
        annotation (Diagram(
              coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,160}})));
      end SubstationPumpControl;
    end Controls;

    package BaseClasses "Package with base classes that are used by multiple models"
    extends Modelica.Icons.BasesPackage;
      model Junction
        extends Buildings.Fluid.FixedResistances.Junction(
          final dp_nominal = {0, 0, 0},
          final tau = 5*60,
          final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);
        annotation (Icon(graphics={Ellipse(
                extent={{-38,36},{40,-40}},
                lineColor={28,108,200},
                fillColor={0,127,0},
                fillPattern=FillPattern.Solid)}));
      end Junction;

      model ConnectionSeries "Model for connecting an agent to the DHC system"
        replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium model"
          annotation (__Dymola_choicesAllMatching=true);
        parameter Boolean haveBypFloSen = false
          "Set to true to sense the bypass mass flow rate"
          annotation(Evaluate=true);
        parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
          "Nominal mass flow rate in the distribution line";
        parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
          "Nominal mass flow rate in the connection line";
        parameter Modelica.SIunits.Length lDis
          "Length of the distribution pipe (only counting warm or cold line, but not sum)";
        parameter Modelica.SIunits.Length lCon
          "Length of the connection pipe (only counting warm or cold line, but not sum)";
        parameter Modelica.SIunits.Length dhDis
          "Hydraulic diameter of distribution pipe";
        parameter Modelica.SIunits.Length dhCon
          "Hydraulic diameter of connection pipe";
        parameter Boolean allowFlowReversal = false
          "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
          annotation(Dialog(tab="Assumptions"), Evaluate=true);
        final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
          Medium.specificHeatCapacityCp(Medium.setState_pTX(
            p = Medium.p_default,
            T = Medium.T_default,
            X = Medium.X_default))
          "Specific heat capacity of medium at default medium state";
        // IO CONNECTORS
        Modelica.Fluid.Interfaces.FluidPort_a port_disInl(
          redeclare package Medium=Medium)
          "Distribution inlet port"
          annotation (Placement(transformation(
            extent={{-110,-50},{-90,-30}}), iconTransformation(extent={{-110,-10},
              {-90,10}})));
        Modelica.Fluid.Interfaces.FluidPort_b port_disOut(
          redeclare package Medium=Medium)
          "Distribution outlet port"
          annotation (Placement(transformation(
            extent={{90,-50},{110,-30}}), iconTransformation(extent={{90,-10},{110,
              10}})));
        Modelica.Fluid.Interfaces.FluidPort_b port_conSup(
          redeclare package Medium = Medium) "Connection supply port"
          annotation (Placement(transformation(
            extent={{-50,110},{-30,130}}), iconTransformation(extent={{-10,90},{10,110}})));
        Modelica.Fluid.Interfaces.FluidPort_a port_conRet(
          redeclare package Medium = Medium) "Connection return port"
          annotation (Placement(transformation(
            extent={{30,110},{50,130}}),
            iconTransformation(extent={{50,90},{70,110}})));
        Modelica.Blocks.Interfaces.RealOutput mCon_flow
          "Connection supply mass flow rate" annotation (Placement(transformation(
                extent={{100,20},{140,60}}), iconTransformation(extent={{100,50},{120,
                  70}})));
        Modelica.Blocks.Interfaces.RealOutput Q_flow
          "Heat flow rate transferred to the connected load (>=0 for heating)"
          annotation (Placement(transformation(extent={{100,60},{140,100}}),
            iconTransformation(extent={{100,70},{120,90}})));
        // COMPONENTS
        BaseClasses.Junction junConSup(
          redeclare final package Medium = Medium,
          portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
          portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
          portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
          m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,-mCon_flow_nominal})
          "Junction with connection supply"
          annotation (Placement(transformation(extent={{-50,-30},{-30,-50}})));
        BaseClasses.Junction junConRet(
          redeclare final package Medium = Medium,
          portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
          portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
          portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
          m_flow_nominal={mDis_flow_nominal,mDis_flow_nominal,mCon_flow_nominal})
          "Junction with connection return"
          annotation (Placement(transformation(extent={{30,-30},{50,-50}})));
        PipeDistribution pipDis(
          redeclare final package Medium = Medium,
          final m_flow_nominal=mDis_flow_nominal,
          dh=dhDis,
          length=lDis) "Distribution pipe"
          annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
        PipeConnection pipCon(
          redeclare package Medium = Medium,
          m_flow_nominal=mCon_flow_nominal,
          length=2*lCon,
          dh=dhCon) "Connection pipe" annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-40,-10})));
        Buildings.Fluid.Sensors.TemperatureTwoPort senTConSup(
          allowFlowReversal=allowFlowReversal,
          redeclare final package Medium = Medium,
          m_flow_nominal=mCon_flow_nominal) "Connection supply temperature (sensed)"
          annotation (Placement(transformation(
              extent={{10,10},{-10,-10}},
              rotation=-90,
              origin={-40,80})));
        Buildings.Fluid.Sensors.TemperatureTwoPort senTConRet(
          allowFlowReversal=allowFlowReversal,
          redeclare final package Medium = Medium,
          m_flow_nominal=mCon_flow_nominal) "Connection return temperature (sensed)"
          annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=-90,
              origin={40,80})));
        Buildings.Fluid.Sensors.MassFlowRate senMasFloCon(
          redeclare package Medium = Medium,
          allowFlowReversal=allowFlowReversal)
          "Connection supply mass flow rate (sensed)"
          annotation (Placement(
              transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-40,40})));
        Modelica.Blocks.Sources.RealExpression QCal_flow(
          y=(senTConSup.T - senTConRet.T) * cp_default * senMasFloCon.m_flow)
          "Calculation of heat flow rate transferred to the load"
          annotation (Placement(transformation(extent={{60,70},{80,90}})));
        Buildings.Fluid.Sensors.MassFlowRate senMasFloByp(
          redeclare package Medium = Medium,
          allowFlowReversal=allowFlowReversal) if haveBypFloSen
          "Bypass mass flow rate (sensed)"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={0,-40})));
        Modelica.Blocks.Interfaces.RealOutput mByp_flow if haveBypFloSen
          "Bypass mass flow rate"
          annotation (Placement(transformation(extent={{100,-20},{140,20}}),
              iconTransformation(extent={{100,30},{120,50}})));
      equation
        connect(junConSup.port_3, pipCon.port_a)
          annotation (Line(points={{-40,-30},{-40,-20}}, color={0,127,255}));
        connect(pipDis.port_b, junConSup.port_1)
          annotation (Line(points={{-60,-40},{-50,-40}}, color={0,127,255}));
        connect(port_conSup,senTConSup. port_b)
          annotation (Line(points={{-40,120},{-40,90}}, color={0,127,255}));
        connect(junConRet.port_3, senTConRet.port_b)
          annotation (Line(points={{40,-30},{40,70}}, color={0,127,255}));
        connect(senTConRet.port_a, port_conRet)
          annotation (Line(points={{40,90},{40,120}}, color={0,127,255}));
        connect(senMasFloCon.port_b,senTConSup. port_a)
          annotation (Line(points={{-40,50},{-40,70}}, color={0,127,255}));
        connect(senMasFloCon.m_flow, mCon_flow)
          annotation (Line(points={{-29,40},{120,40}}, color={0,0,127}));
        connect(pipCon.port_b, senMasFloCon.port_a)
          annotation (Line(points={{-40,0},{-40,30}}, color={0,127,255}));
        connect(QCal_flow.y, Q_flow)
          annotation (Line(points={{81,80},{120,80}}, color={0,0,127}));
        connect(port_disInl, pipDis.port_a)
          annotation (Line(points={{-100,-40},{-80,-40}}, color={0,127,255}));
        connect(junConRet.port_2, port_disOut)
          annotation (Line(points={{50,-40},{100,-40}}, color={0,127,255}));
        if haveBypFloSen then
          connect(junConSup.port_2, senMasFloByp.port_a)
            annotation (Line(points={{-30,-40},{-10,-40}}, color={0,127,255}));
          connect(senMasFloByp.port_b, junConRet.port_1)
            annotation (Line(points={{10,-40},{30,-40}}, color={0,127,255}));
          connect(senMasFloByp.m_flow, mByp_flow)
            annotation (Line(points={{0,-29},{0,0},{120,0}}, color={0,0,127}));
        else
          connect(junConSup.port_2, junConRet.port_1)
            annotation (Line(points={{-30,-40},{30,-40}}, color={0,127,255}));
        end if;
        annotation (
          defaultComponentName="con",
          Icon(graphics={   Rectangle(
              extent={{-100,-100},{100,100}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-100,2},{100,-2}},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None,
                lineColor={0,0,0}),
              Rectangle(
                extent={{-2,-2},{2,100}},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None,
                lineColor={0,0,0}),           Text(
              extent={{-152,-104},{148,-144}},
              textString="%name",
              lineColor={0,0,255}),
              Rectangle(
                extent={{-76,12},{-20,-12}},
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
                origin={-0.5,45.5},
                rotation=90),
              Rectangle(
                extent={{58,-2},{62,100}},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None,
                lineColor={0,0,0})}), Diagram(coordinateSystem(extent={{-100,-60},{100,
                  120}})));
      end ConnectionSeries;

      model PipeConnection "Building service connection pipe"
        extends Buildings.Fluid.FixedResistances.HydraulicDiameter(
          dp(nominal=1E5),
          dh=0,
          final fac=1.1,
          final ReC=6000,
          allowFlowReversal=false,
          final linearized=false,
          final v_nominal=m_flow_nominal * 4 / (rho_default * dh^2 * Modelica.Constants.pi));
          // Steel straight pipe
          annotation (
          DefaultComponentName="pipCon",
          Icon(graphics={
              Rectangle(
                extent={{-100,22},{100,-24}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={0,140,72})}));
      end PipeConnection;

      model PipeDistribution "DHC distribution pipe"
        extends Buildings.Fluid.FixedResistances.HydraulicDiameter(
          dp(nominal=1E5),
          dh=0,
          final fac=1.1,
          final ReC=6000,
          final roughness=7E-6,
          allowFlowReversal=false,
          final linearized=false,
          final v_nominal=m_flow_nominal * 4 / (rho_default * dh^2 * Modelica.Constants.pi));
          // PE100 straight pipe
      equation
        when terminal() then
          if length > Modelica.Constants.eps then
            Modelica.Utilities.Streams.print(
               "Pipe nominal pressure drop per meter for '" + getInstanceName() + "' is " +
                String(integer( floor( dp_nominal / length + 0.5)))   + " Pa/m.");
          else
            Modelica.Utilities.Streams.print(
               "Zero pipe pressure drop for '" + getInstanceName() +
               "' as the pipe length is set to zero.");
          end if;
        end when;
        annotation (
        DefaultComponentName="pipDis",
        Icon(graphics={
              Rectangle(
                extent={{-100,22},{100,-24}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={0,140,72})}));
      end PipeDistribution;

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

      partial model PartialDistributionSystem
        "Partial model for distribution system"
        replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
          "Medium model"
          annotation (__Dymola_choicesAllMatching=true);
        parameter Integer nCon
          "Number of connections"
          annotation(Evaluate=true);
        parameter Boolean allowFlowReversal = false
          "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
          annotation(Dialog(tab="Assumptions"), Evaluate=true);
        // IO CONNECTORS
        Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nCon](
          redeclare each package Medium=Medium,
          each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
          each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
          "Connection return port"
          annotation (Placement(transformation(extent={{-10,-40},{10,40}},
              rotation=90,
              origin={80,100}),
            iconTransformation(extent={{-20,-80},{20,80}},
              rotation=90,
              origin={120,100})));
        Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nCon](
          redeclare each package Medium=Medium,
          each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
          each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
          "Connection supply port"
          annotation (Placement(transformation(extent={{-10,-40},{10,40}},
              rotation=90,
              origin={-80,100}),
            iconTransformation(extent={{-20,-80},{20,80}},
              rotation=90,
              origin={-120,100})));
        Modelica.Fluid.Interfaces.FluidPort_a port_disInl(
          redeclare package Medium=Medium)
          "Distribution inlet port"
          annotation (Placement(
            transformation(extent={{-110,-10},{-90,10}}),  iconTransformation(
              extent={{-220,-20},{-180,20}})));
        Modelica.Fluid.Interfaces.FluidPort_b port_disOut(
          redeclare final package Medium=Medium)
          "Distribution outlet port"
           annotation (Placement(
            transformation(extent={{90,-10},{110,10}}),  iconTransformation(extent={{180,-20},
                  {220,20}})));
        annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,100}}),
                                                          graphics={
          Text(
            extent={{-149,-104},{151,-144}},
            lineColor={0,0,255},
            textString="%name"),
            Rectangle(extent={{-200,-100},{200,100}},
              lineColor={0,0,0})}),
            Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
      end PartialDistributionSystem;
    end BaseClasses;
  end Distribution;

  package Examples "Based on Final_steps_2019_10_21"
    extends Modelica.Icons.ExamplesPackage;

    model ConstantFlow "Case with constant district water mass flow rate"
      extends Modelica.Icons.Example;
      extends
        Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Examples.BaseClasses.RN_BaseModel(
          datDes(epsPla=0.935));
      Modelica.Blocks.Sources.Constant massFlowMainPump(
        k(final unit="kg/s")=datDes.mDis_flow_nominal)
        "Pump mass flow rate"
        annotation (Placement(transformation(extent={{-380,-70},{-360,-50}})));
    equation
      connect(massFlowMainPump.y, pumpMainRLTN.m_flow_in)
        annotation (Line(points={{-359,-60},{60,-60},{60,-80},{68,-80}},
                                                    color={0,0,127}));
      connect(pumpBHS.m_flow_in, massFlowMainPump.y)
        annotation (Line(points={{-160,-108},{-160,-60},{-359,-60}},
        color={0,0,127}));
      annotation (
      Diagram(
      coordinateSystem(preserveAspectRatio=false, extent={{-480,-440},{480,440}})),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir1Constant.mos"
      "Simulate and plot"),
      experiment(
        StopTime=172800,
        Tolerance=1e-06,
        __Dymola_Algorithm="Cvode"));
    end ConstantFlow;

    package BaseClasses "Package with base classes that are used by multiple models"
      extends Modelica.Icons.BasesPackage;
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

      partial model RN_BaseModel
        package Medium = Buildings.Media.Water "Medium model";
        parameter Integer nBui = 3
          "Number of buildings connected to DHC system"
          annotation (Evaluate=true);
        parameter String idfPath[nBui] = {
          "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf",
          "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94021950/RefBldgSmallOfficeNew2004_Chicago.idf",
          "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"}
          "Paths of the IDF files";
        parameter String weaPath=
          "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
          "Path of the weather file";
        parameter Integer nZon[nBui] = fill(6, nBui)
          "Number of thermal zones"
          annotation(Evaluate=true);
        inner parameter Data.DesignDataDHC datDes(
          mCon_flow_nominal={
            max(bui[i].ets.m1HexChi_flow_nominal, bui[i].ets.mEva_flow_nominal) for i in 1:nBui})
          "Design values"
          annotation (Placement(transformation(extent={{-286,230},{-266,250}})));
        // COMPONENTS
        Agents.BuildingWithETS bui[nBui](
          redeclare each final package Medium = Medium,
          idfPath=idfPath,
          each weaPath=weaPath,
          nZon=nZon)
          annotation (Placement(transformation(extent={{-10,170},{10,190}})));
        Agents.BoreField borFie(redeclare package Medium=Medium)
          annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-190,-80})));
        Distribution.BaseClasses.Pump_m_flow pumpMainRLTN(
          redeclare package Medium=Medium,
          m_flow_nominal=datDes.mDis_flow_nominal) "Pump"
          annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={80,-80})));
        Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
          redeclare package Medium1=Medium,
          redeclare package Medium2=Medium,
          allowFlowReversal2=false,
          final m1_flow_nominal=datDes.mPla_flow_nominal,
          final m2_flow_nominal=datDes.mPla_flow_nominal,
          show_T=true,
          final dp1_nominal(displayUnit="bar") = 50000,
          final dp2_nominal(displayUnit="bar") = 50000,
          final eps=datDes.epsPla)
          "Heat exchanger" annotation (Placement(
              transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-226,-20})));
        Distribution.BaseClasses.Pump_m_flow pumpPrimarySidePlant(
          redeclare package Medium=Medium,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000) "Pump" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-220,10})));
        Modelica.Blocks.Sources.Constant mFlowInputPlant(
          final k=datDes.mPla_flow_nominal)
          "District water flow rate to plant"
          annotation (Placement(transformation(extent={{-158,-18},{-174,-2}})));
        Buildings.Fluid.Sources.Boundary_pT sewageSourceAtConstTemp(
          redeclare package Medium=Medium,
          T=290.15,
          nPorts=2) "17°C"
          annotation (Placement(transformation(extent={{-280,-30},{-260,-10}})));
        Distribution.BaseClasses.Pump_m_flow pumpSecondarySidePlant(
          redeclare package Medium=Medium,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000) "Pump" annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-260,10})));
        Fluid.Sensors.TemperatureTwoPort tempAfterPlantSecondSide(
            redeclare package Medium=Medium,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDis_flow_nominal,
          tau=0) annotation (Placement(
              transformation(
              extent={{-6,6},{6,-6}},
              rotation=180,
              origin={-246,-40})));
        Buildings.Fluid.Sources.Boundary_pT bou(
          redeclare package Medium=Medium,
          nPorts=1)
          "Boundary pressure condition representing the expansion vessel"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={112,-40})));
        Distribution.BaseClasses.Pump_m_flow pumpBHS(
          redeclare package Medium=Medium,
          m_flow_nominal=datDes.mSto_flow_nominal) "Pump"
          annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=180,
              origin={-160,-120})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup[nBui](k=
              bui.THeaWatSup_nominal) "Heating water supply temperature set point"
          annotation (Placement(transformation(extent={{-286,188},{-266,208}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup[nBui](k=
              bui.TChiWatSup_nominal) "Chilled water supply temperature set point"
          annotation (Placement(transformation(extent={{-286,150},{-266,170}})));
        Distribution.BaseClasses.ConnectionSeries conPla(
          redeclare package Medium=Medium,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=datDes.mPla_flow_nominal,
          lDis=0,
          lCon=10,
          dhDis=datDes.dhDis,
          dhCon=0.10) "Connection to the plant"            annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-80,-10})));
        Distribution.UnidirectionalSeries dis(
          redeclare package Medium=Medium,
          nCon=nBui,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=datDes.mCon_flow_nominal,
          lDis=datDes.lDis,
          lCon=datDes.lCon,
          dhDis=datDes.dhDis,
          dhCon=datDes.dhCon)
          annotation (Placement(transformation(extent={{-20,130},{20,150}})));
        Distribution.BaseClasses.ConnectionSeries conSto(
          redeclare package Medium = Medium,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=datDes.mSto_flow_nominal,
          lDis=0,
          lCon=0,
          dhDis=datDes.dhDis,
          dhCon=datDes.dhDis) "Connection to the bore field" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-80,-90})));
      protected
        constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
      equation
        connect(mFlowInputPlant.y, pumpPrimarySidePlant.m_flow_in) annotation (
            Line(points={{-174.8,-10},{-204,-10},{-204,10},{-208,10}},       color={0,
                0,127}));
        connect(tempAfterPlantSecondSide.port_a, plant.port_b2) annotation (Line(
              points={{-240,-40},{-232,-40},{-232,-30}},   color={0,127,255}));
        connect(mFlowInputPlant.y, pumpSecondarySidePlant.m_flow_in) annotation (
            Line(points={{-174.8,-10},{-200,-10},{-200,10},{-272,10}},       color={0,0,127}));
        connect(pumpPrimarySidePlant.port_a, plant.port_b1)
          annotation (Line(points={{-220,0},{-220,-10}},     color={0,127,255}));
        connect(pumpSecondarySidePlant.port_b, plant.port_a2) annotation (Line(
              points={{-260,20},{-260,40},{-232,40},{-232,-10}},        color={0,127,
                255}));
        connect(bou.ports[1], pumpMainRLTN.port_a)
          annotation (Line(points={{102,-40},{80,-40},{80,-70}},
                                            color={0,127,255}));
        connect(borFie.port_a, pumpBHS.port_b)
          annotation (Line(points={{-200,-80},{-260,-80},{-260,-120},{-170,-120}},
                                                        color={0,127,255}));
        connect(conPla.port_conSup, plant.port_a1) annotation (Line(points={{-90,-10},
                {-100,-10},{-100,-40},{-220,-40},{-220,-30}},     color={0,127,255}));
        connect(pumpPrimarySidePlant.port_b, conPla.port_conRet) annotation (Line(
              points={{-220,20},{-220,40},{-100,40},{-100,-4},{-90,-4}},
              color={0,127,255}));
        connect(conPla.port_disOut, dis.port_disInl) annotation (Line(points={{-80,0},
                {-80,140},{-20,140}},   color={0,127,255}));
        connect(dis.port_disOut, pumpMainRLTN.port_a) annotation (Line(points={{20,140},
                {80,140},{80,-70}},   color={0,127,255}));
        connect(dis.ports_b1, bui.port_a) annotation (Line(points={{-12,150},{-14,150},
                {-14,180},{-10,180}}, color={0,127,255}));
        connect(bui.port_b, dis.ports_a1) annotation (Line(points={{10,180},{14,180},
                {14,150},{12,150}},
                                  color={0,127,255}));
        connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[1])
          annotation (Line(points={{-252,-40},{-260,-40},{-260,-18}},    color={0,127,255}));
        connect(sewageSourceAtConstTemp.ports[2], pumpSecondarySidePlant.port_a)
          annotation (Line(points={{-260,-22},{-260,0}},     color={0,127,255}));
        connect(TSetHeaWatSup.y, bui.TSetHeaWat) annotation (Line(points={{-264,
                198},{-52,198},{-52,188},{-11,188}},
                                           color={0,0,127}));
        connect(TSetChiWatSup.y, bui.TSetChiWat) annotation (Line(points={{-264,
                160},{-50,160},{-50,184},{-11,184}},
                                                color={0,0,127}));
        connect(conSto.port_disOut, conPla.port_disInl)
          annotation (Line(points={{-80,-80},{-80,-20}}, color={0,127,255}));
        connect(borFie.port_b, conSto.port_conRet) annotation (Line(points={{-180,-80},
                {-100,-80},{-100,-84},{-90,-84}}, color={0,127,255}));
        connect(pumpBHS.port_a, conSto.port_conSup) annotation (Line(points={{-150,
                -120},{-100,-120},{-100,-90},{-90,-90}}, color={0,127,255}));
        connect(pumpMainRLTN.port_b, conSto.port_disInl) annotation (Line(points={{80,
                -90},{80,-120},{-80,-120},{-80,-100}}, color={0,127,255}));
        annotation (Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-320,-380},{320,
                  380}}),
                      graphics={
              Text(
            extent={{-296,-218},{44,-298}},
            lineColor={28,108,200},
            horizontalAlignment=TextAlignment.Left,
                textString="Simulation requires the first setting and is faster with the  second one

Hidden.AvoidDoubleComputation=true;
Advanced.SparseActivate=true")}),
          experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
          Icon(coordinateSystem(extent={{-320,-380},{320,380}})));
      end RN_BaseModel;

      partial model RN_BaseModel_bck
        package MediumWater = Buildings.Media.Water "Medium model";
        inner parameter Data.DesignDataDHC datDes "Design values"
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
        Distribution.BaseClasses.Pump_m_flow pumpMainRLTN(redeclare package
            Medium =
              MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal) "Pump"
          annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={80,-360})));
        Distribution.BaseClasses.Junction splSup3(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={80,-20})));
        Distribution.BaseClasses.Junction splSup4(
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
        Distribution.BaseClasses.Junction splSup5(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={80,180})));
        Distribution.BaseClasses.Junction splSup6(
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
        Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Agents.SimplifiedETS
          ets1(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui1.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui1.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{-360,-40},{-320,0}})));
        Distribution.BaseClasses.Junction splSup7(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-80,0})));
        Distribution.BaseClasses.Junction splSup8(
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
        Distribution.BaseClasses.Junction splSup1(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-80,-190})));
        Distribution.BaseClasses.Junction splSup2(
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
        Distribution.BaseClasses.Pump_m_flow pumpPrimarySidePlant(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000) "Pump" annotation (Placement(transformation(
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
        Distribution.BaseClasses.Pump_m_flow pumpSecondarySidePlant(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000) "Pump" annotation (Placement(transformation(
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
        Distribution.BaseClasses.PipeDistribution res(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={80,-310})));
        Distribution.BaseClasses.PipeDistribution res1(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-80,-330})));
        Distribution.BaseClasses.PipeDistribution distributionPipe(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip) annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=270,
              origin={-80,70})));
        Distribution.BaseClasses.PipeDistribution res4(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip) annotation (Placement(transformation(
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
        Distribution.BaseClasses.PipeDistribution res3(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-80,-130})));
        Distribution.BaseClasses.PipeDistribution res5(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={80,-130})));
        Distribution.BaseClasses.PipeDistribution res2(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={80,-172})));
        Distribution.BaseClasses.PipeDistribution res6(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mDisPip_flow_nominal,
          final R=datDes.RDisPip) annotation (Placement(transformation(
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
        Distribution.BaseClasses.Pump_m_flow pumpBHS(redeclare package Medium =
              MediumWater, m_flow_nominal=datDes.mSto_flow_nominal) "Pump"
          annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=180,
              origin={50,-440})));
        Distribution.BaseClasses.Junction splSup9(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,10},{-10,-10}},
              rotation=90,
              origin={80,-400})));
        Distribution.BaseClasses.Junction splSup10(
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

        Agents.SimplifiedETS ets2(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui2.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui2.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{320,80},{360,120}})));
        Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui3(redeclare
            package Medium1 =
                      MediumWater, nPorts1=2) "Building"
          annotation (Placement(transformation(extent={{320,-20},{340,0}})));
        Agents.SimplifiedETS ets3(
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
        connect(ets1.PPum, EPumPro.u[1]) annotation (Line(points={{-318.571,-4.28571},
                {-264,-4.28571},{-264,288},{246,288}},       color={0,0,127}));
        connect(ets1.PCom, EHeaPum.u[1]) annotation (Line(points={{-318.571,-1.42857},
                {-260,-1.42857},{-260,268},{246,268}},     color={0,0,127}));
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
                {-320,32},{-300,32},{-300,8},{-380,8},{-380,-28.5714},{-360,-28.5714}},
                            color={0,127,255}));
        connect(ets1.port_bHeaWat, bui1.ports_a1[1]) annotation (Line(points={{-320,
                -28.5714},{-312,-28.5714},{-312,-28},{-302,-28},{-302,-60},{-400,-60},
                {-400,36},{-380,36},{-380,30}}, color={0,127,255}));
        connect(bui1.ports_b1[2], ets1.port_aChi) annotation (Line(points={{-320,34},
                {-320,28},{-304,28},{-304,12},{-384,12},{-384,-37.1429},{-360,
                -37.1429}}, color={0,127,255}));
        connect(ets1.port_bChi, bui1.ports_a1[2]) annotation (Line(points={{-320,
                -37.2857},{-312,-37.2857},{-312,-36},{-306,-36},{-306,-56},{-396,-56},
                {-396,30},{-380,30},{-380,34}}, color={0,127,255}));
        connect(TSetHeaWatSup.y, ets1.TSetHeaWat) annotation (Line(points={{-438,240},
                {-420,240},{-420,-2.85714},{-361.429,-2.85714}}, color={0,0,127}));
        connect(TSetChiWatSup.y, ets1.TSetChiWat) annotation (Line(points={{-438,210},
                {-420,210},{-420,-8.57143},{-361.429,-8.57143}}, color={0,0,127}));
        connect(bui2.ports_b1[1], ets2.port_aHeaWat) annotation (Line(points={{360,170},
                {400,170},{400,60},{300,60},{300,92},{320,92},{320,91.4286}},
              color={0,127,255}));
        connect(ets2.port_bHeaWat, bui2.ports_a1[1]) annotation (Line(points={{360,
                91.4286},{382,91.4286},{382,148},{292,148},{292,170},{300,170}},
              color={0,127,255}));
        connect(bui2.ports_b1[2], ets2.port_aChi) annotation (Line(points={{360,174},
                {366,174},{366,168},{394,168},{394,66},{306,66},{306,82.8571},{320,
                82.8571}}, color={0,127,255}));
        connect(ets2.port_bChi, bui2.ports_a1[2]) annotation (Line(points={{360,
                82.7143},{370,82.7143},{370,82},{388,82},{388,154},{296,154},{296,170},
                {300,170},{300,174}}, color={0,127,255}));
        connect(TSetHeaWatSup.y, ets2.TSetHeaWat) annotation (Line(points={{-438,240},
                {288,240},{288,117.143},{318.571,117.143}}, color={0,0,127}));
        connect(TSetChiWatSup.y, ets2.TSetChiWat) annotation (Line(points={{-438,210},
                {284,210},{284,111.429},{318.571,111.429}}, color={0,0,127}));
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
                -117.286},{368,-117.286},{368,-118},{388,-118},{388,-50},{292,-50},{
                292,-30},{300,-30},{300,-26}}, color={0,127,255}));
        connect(TSetHeaWatSup.y, ets3.TSetHeaWat) annotation (Line(points={{-438,240},
                {288,240},{288,-82.8571},{318.571,-82.8571}}, color={0,0,127}));
        connect(TSetChiWatSup.y, ets3.TSetChiWat) annotation (Line(points={{-438,210},
                {284,210},{284,-88},{302,-88},{302,-88.5714},{318.571,-88.5714}},
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
        connect(ets3.port_b, tempAfterProsumer3.port_a) annotation (Line(points={{360,
                -100},{380,-100},{380,-60},{126,-60}},          color={0,127,
                255}));
        connect(splSup5.port_3, massFlowRateThroughProsumer2AfterSB.port_a)
          annotation (Line(points={{90,180},{94,180}}, color={0,127,255}));
        connect(tempBeforeProsumer2.port_a, massFlowRateThroughProsumer2AfterSB.port_b)
          annotation (Line(points={{114,180},{106,180}}, color={0,127,255}));
        connect(tempBeforeProsumer2.port_b, ets2.port_a) annotation (Line(
              points={{126,180},{280,180},{280,100},{320,100}}, color={0,127,
                255}));
        connect(ets2.port_b, tempAfterProsumer2.port_a) annotation (Line(points={{360,100},
                {368,100},{368,140},{126,140}},               color={0,127,255}));
        connect(ets1.port_b, tempAfterProsumer1.port_a) annotation (Line(points={{-320,
                -20},{-140,-20},{-140,8.88178e-16},{-126,8.88178e-16}},
              color={0,127,255}));
        connect(tempBeforeProsumer1.port_b, ets1.port_a) annotation (Line(
              points={{-126,-40},{-260,-40},{-260,-48},{-370,-48},{-370,-20},{
                -360,-20}}, color={0,127,255}));
        annotation (Diagram(
              coordinateSystem(preserveAspectRatio=false, extent={{-480,-500},{480,
                  500}})),
          experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
          Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
      end RN_BaseModel_bck;

      partial model RN_BaseModel_bck1
        package MediumWater = Buildings.Media.Water "Medium model";
        inner parameter Data.DesignDataDHC datDes "Design values"
          annotation (Placement(transformation(extent={{-460,280},{-440,300}})));
        Agents.BoreField borFie(redeclare package Medium = MediumWater)
          annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-2,-440})));
        Distribution.BaseClasses.Pump_m_flow pumpMainRLTN(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDis_flow_nominal) "Pump"
          annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={80,-360})));
        Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Agents.SimplifiedETS
          ets1(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui1.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui1.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{-360,-40},{-320,0}})));
        Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
          redeclare package Medium1 = MediumWater,
          redeclare package Medium2 = MediumWater,
          allowFlowReversal2=false,
          final m1_flow_nominal=datDes.mPla_flow_nominal,
          final m2_flow_nominal=datDes.mPla_flow_nominal,
          show_T=true,
          final dp1_nominal(displayUnit="bar") = 50000,
          final dp2_nominal(displayUnit="bar") = 50000,
          final eps=datDes.epsPla)
          "Heat exchanger" annotation (Placement(
              transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-226,-240})));
        Distribution.BaseClasses.Pump_m_flow pumpPrimarySidePlant(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000) "Pump" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-220,-210})));
        Modelica.Blocks.Sources.Constant mFlowInputPlant(final k=datDes.mPla_flow_nominal)
                                                                  "kg/s"
          annotation (Placement(transformation(extent={{-158,-238},{-174,-222}})));
        Buildings.Fluid.Sources.Boundary_pT sewageSourceAtConstTemp(
          redeclare package Medium = MediumWater,
          T=290.15,
          nPorts=2) "17°C"
          annotation (Placement(transformation(extent={{-280,-250},{-260,-230}})));
        Distribution.BaseClasses.Pump_m_flow pumpSecondarySidePlant(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000) "Pump" annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-260,-210})));
        Fluid.Sensors.TemperatureTwoPort tempAfterPlantSecondSide(
            redeclare package Medium = MediumWater,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDis_flow_nominal,
          tau=0) annotation (Placement(
              transformation(
              extent={{-6,6},{6,-6}},
              rotation=180,
              origin={-246,-260})));
        Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
              MediumWater, nPorts=1) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={130,-340})));

        Distribution.BaseClasses.Pump_m_flow pumpBHS(redeclare package Medium =
              MediumWater, m_flow_nominal=datDes.mSto_flow_nominal) "Pump"
          annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=180,
              origin={50,-440})));
        Distribution.BaseClasses.Junction splSup9(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDis_flow_nominal*{1,1,1},
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,10},{-10,-10}},
              rotation=90,
              origin={80,-400})));
        Distribution.BaseClasses.Junction splSup10(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDis_flow_nominal*{1,1,1},
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={-80,-400})));
        Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui1(redeclare
            package Medium1 =
                      MediumWater, nPorts1=2) "Building"
          annotation (Placement(transformation(extent={{-360,40},{-340,60}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(k=ets1.THeaWatSup_nominal)
          "Heating water supply temperature set point"
          annotation (Placement(transformation(extent={{-460,230},{-440,250}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(k=ets1.TChiWatSup_nominal)
          "Chilled water supply temperature set point"
          annotation (Placement(transformation(extent={{-460,190},{-440,210}})));
        Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui2(
          redeclare package Medium1 = MediumWater,
          idfPath=
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94021950/RefBldgSmallOfficeNew2004_Chicago.idf",
          nPorts1=2) "Building"
          annotation (Placement(transformation(extent={{320,180},{340,200}})));

        Agents.SimplifiedETS ets2(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui2.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui2.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{320,80},{360,120}})));
        Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui3(redeclare
            package Medium1 =
                      MediumWater, nPorts1=2) "Building"
          annotation (Placement(transformation(extent={{320,-20},{340,0}})));
        Agents.SimplifiedETS ets3(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui3.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui3.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{320,-120},{360,-80}})));
        Distribution.BaseClasses.ConnectionSeries junBui1(
          redeclare package Medium = MediumWater,
          havePum=false,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=max(ets1.m1HexChi_flow_nominal, ets1.mEva_flow_nominal),
          lDis=datDes.lDis[1],
          lCon=datDes.lCon[1],
          dhDis=datDes.dhDis[1],
          dhCon=datDes.dhCon[1]) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-84,-30})));
        Distribution.BaseClasses.ConnectionSeries junBui2(
          redeclare package Medium = MediumWater,
          havePum=false,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=max(ets2.m1HexChi_flow_nominal, ets2.mEva_flow_nominal),
          lDis=datDes.lDis[2],
          lCon=datDes.lCon[2],
          dhDis=datDes.dhDis[2],
          dhCon=datDes.dhCon[2]) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={84,102})));
        Distribution.BaseClasses.ConnectionSeries junBui3(
          redeclare package Medium = MediumWater,
          havePum=false,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=max(ets2.m1HexChi_flow_nominal, ets2.mEva_flow_nominal),
          lDis=datDes.lDis[2],
          lCon=datDes.lCon[2],
          dhDis=datDes.dhDis[2],
          dhCon=datDes.dhCon[2]) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={84,-98})));
        Distribution.BaseClasses.ConnectionSeries junBui4(
          redeclare package Medium = MediumWater,
          havePum=false,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=datDes.mPla_flow_nominal,
          lDis=datDes.lDis[1],
          lCon=datDes.lCon[1],
          dhDis=datDes.dhDis[1],
          dhCon=datDes.dhCon[1]) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-84,-230})));
      protected
        constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
      equation
        connect(mFlowInputPlant.y, pumpPrimarySidePlant.m_flow_in) annotation (
            Line(points={{-174.8,-230},{-204,-230},{-204,-210},{-208,-210}},
                                                                         color={0,
                0,127}));
        connect(tempAfterPlantSecondSide.port_a, plant.port_b2) annotation (Line(
              points={{-240,-260},{-232,-260},{-232,-250}},color={0,127,255}));
        connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[1])
          annotation (Line(points={{-252,-260},{-260,-260},{-260,-238}},color={0,
                127,255}));
        connect(mFlowInputPlant.y, pumpSecondarySidePlant.m_flow_in) annotation (
            Line(points={{-174.8,-230},{-200,-230},{-200,-210},{-272,-210}},
                             color={0,0,127}));
        connect(pumpPrimarySidePlant.port_a, plant.port_b1)
          annotation (Line(points={{-220,-220},{-220,-230}},
                                                           color={0,127,255}));
        connect(pumpSecondarySidePlant.port_b, plant.port_a2) annotation (Line(
              points={{-260,-200},{-260,-180},{-232,-180},{-232,-230}},
                                                                    color={0,127,
                255}));
        connect(pumpSecondarySidePlant.port_a, sewageSourceAtConstTemp.ports[2])
          annotation (Line(points={{-260,-220},{-260,-242}},
                                                           color={0,127,255}));
        connect(bou.ports[1], pumpMainRLTN.port_a) annotation (Line(points={{120,
                -340},{80,-340},{80,-350}},
                                      color={0,127,255}));
        connect(borFie.port_a, pumpBHS.port_b)
          annotation (Line(points={{8,-440},{40,-440}}, color={0,127,255}));
        connect(splSup10.port_2, borFie.port_b) annotation (Line(points={{-80,
                -410},{-80,-440},{-12,-440}},
                                       color={0,127,255}));
        connect(pumpBHS.port_a, splSup9.port_2) annotation (Line(points={{60,-440},
                {80,-440},{80,-410}},color={0,127,255}));
        connect(splSup9.port_1, pumpMainRLTN.port_b)
          annotation (Line(points={{80,-390},{80,-370}}, color={0,127,255}));
        connect(splSup10.port_3, splSup9.port_3)
          annotation (Line(points={{-70,-400},{70,-400}}, color={0,127,255}));
        connect(bui1.ports_b1[1], ets1.port_aHeaWat) annotation (Line(points={{-320,30},
                {-320,32},{-300,32},{-300,8},{-380,8},{-380,-28.5714},{-360,-28.5714}},
                            color={0,127,255}));
        connect(ets1.port_bHeaWat, bui1.ports_a1[1]) annotation (Line(points={{-320,
                -28.5714},{-312,-28.5714},{-312,-28},{-302,-28},{-302,-60},{-400,-60},
                {-400,36},{-380,36},{-380,30}}, color={0,127,255}));
        connect(bui1.ports_b1[2], ets1.port_aChi) annotation (Line(points={{-320,34},
                {-320,28},{-304,28},{-304,12},{-384,12},{-384,-37.1429},{-360,
                -37.1429}}, color={0,127,255}));
        connect(ets1.port_bChi, bui1.ports_a1[2]) annotation (Line(points={{-320,
                -37.2857},{-312,-37.2857},{-312,-36},{-306,-36},{-306,-56},{-396,-56},
                {-396,30},{-380,30},{-380,34}}, color={0,127,255}));
        connect(TSetHeaWatSup.y, ets1.TSetHeaWat) annotation (Line(points={{-438,240},
                {-420,240},{-420,-2.85714},{-361.429,-2.85714}}, color={0,0,127}));
        connect(TSetChiWatSup.y, ets1.TSetChiWat) annotation (Line(points={{-438,200},
                {-420,200},{-420,-8.57143},{-361.429,-8.57143}}, color={0,0,127}));
        connect(bui2.ports_b1[1], ets2.port_aHeaWat) annotation (Line(points={{360,170},
                {400,170},{400,60},{300,60},{300,92},{320,92},{320,91.4286}},
              color={0,127,255}));
        connect(ets2.port_bHeaWat, bui2.ports_a1[1]) annotation (Line(points={{360,
                91.4286},{384,91.4286},{384,148},{292,148},{292,170},{300,170}},
              color={0,127,255}));
        connect(bui2.ports_b1[2], ets2.port_aChi) annotation (Line(points={{360,174},
                {366,174},{366,168},{394,168},{394,66},{306,66},{306,82.8571},{320,
                82.8571}}, color={0,127,255}));
        connect(ets2.port_bChi, bui2.ports_a1[2]) annotation (Line(points={{360,
                82.7143},{370,82.7143},{370,82},{388,82},{388,154},{296,154},{296,170},
                {300,170},{300,174}}, color={0,127,255}));
        connect(TSetHeaWatSup.y, ets2.TSetHeaWat) annotation (Line(points={{-438,240},
                {288,240},{288,117.143},{318.571,117.143}}, color={0,0,127}));
        connect(TSetChiWatSup.y, ets2.TSetChiWat) annotation (Line(points={{-438,200},
                {284,200},{284,111.429},{318.571,111.429}}, color={0,0,127}));
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
                -117.286},{368,-117.286},{368,-118},{388,-118},{388,-50},{292,-50},{
                292,-30},{300,-30},{300,-26}}, color={0,127,255}));
        connect(TSetHeaWatSup.y, ets3.TSetHeaWat) annotation (Line(points={{-438,240},
                {288,240},{288,-82.8571},{318.571,-82.8571}}, color={0,0,127}));
        connect(TSetChiWatSup.y, ets3.TSetChiWat) annotation (Line(points={{-438,200},
                {284,200},{284,-88},{302,-88},{302,-88.5714},{318.571,-88.5714}},
              color={0,0,127}));
        connect(junBui1.port_conSup, ets1.port_a) annotation (Line(points={{-94,-30},
                {-260,-30},{-260,-50},{-370,-50},{-370,-20},{-360,-20}},color={0,127,255}));
        connect(ets1.port_b,junBui1.port_conRet)  annotation (Line(points={{-320,-20},
                {-100,-20},{-100,-22},{-94,-22},{-94,-24}}, color={0,127,255}));
        connect(junBui4.port_conSup, plant.port_a1) annotation (Line(points={{-94,
                -230},{-100,-230},{-100,-260},{-220,-260},{-220,-250}}, color={0,127,
                255}));
        connect(pumpPrimarySidePlant.port_b, junBui4.port_conRet) annotation (Line(
              points={{-220,-200},{-220,-180},{-100,-180},{-100,-224},{-94,-224}},
              color={0,127,255}));
        connect(junBui1.port_disOut, junBui2.port_disInl) annotation (Line(points={{
                -84,-20},{-84,220},{84,220},{84,112}}, color={0,127,255}));
        connect(junBui2.port_disOut, junBui3.port_disInl) annotation (Line(points={{
                84,92},{84,48},{88,48},{88,2},{84,2},{84,-88}}, color={0,127,255}));
        connect(junBui4.port_disOut, junBui1.port_disInl) annotation (Line(points={{
                -84,-220},{-84,-176},{-88,-176},{-88,-130},{-84,-130},{-84,-40}},
              color={0,127,255}));
        connect(junBui3.port_disOut, pumpMainRLTN.port_a) annotation (Line(points={{
                84,-108},{84,-230},{80,-230},{80,-350}}, color={0,127,255}));
        connect(splSup10.port_1, junBui4.port_disInl) annotation (Line(points={{-80,
                -390},{-80,-316},{-80,-240},{-84,-240}}, color={0,127,255}));
        connect(junBui2.port_conSup, ets2.port_a) annotation (Line(points={{94,102},{
                208,102},{208,100},{320,100}}, color={0,127,255}));
        connect(ets2.port_b, junBui2.port_conRet) annotation (Line(points={{360,100},
                {380,100},{380,40},{100,40},{100,96},{94,96}},      color={0,127,255}));
        connect(junBui3.port_conSup, ets3.port_a) annotation (Line(points={{94,-98},{
                208,-98},{208,-100},{320,-100}}, color={0,127,255}));
        connect(ets3.port_b, junBui3.port_conRet) annotation (Line(points={{360,-100},
                {380,-100},{380,-130},{100,-130},{100,-104},{94,-104}},       color={
                0,127,255}));
        annotation (Diagram(
              coordinateSystem(preserveAspectRatio=false, extent={{-480,-500},{480,
                  500}}), graphics={
                  Text(
                extent={{-382,-332},{-250,-358}},
                lineColor={28,108,200},
                horizontalAlignment=TextAlignment.Left,
                textString="Simulation requires (and is faster with)
Hidden.AvoidDoubleComputation=true;
Advanced.SparseActivate=true")}),
          experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
          Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
      end RN_BaseModel_bck1;

      partial model RN_BaseModel_bck2
        package MediumWater = Buildings.Media.Water "Medium model";
        inner parameter Data.DesignDataDHC datDes(
          mCon_flow_nominal={
            max(ets1.m1HexChi_flow_nominal, ets1.mEva_flow_nominal),
            max(ets2.m1HexChi_flow_nominal, ets2.mEva_flow_nominal),
            max(ets3.m1HexChi_flow_nominal, ets3.mEva_flow_nominal)})
          "Design values"
          annotation (Placement(transformation(extent={{-460,280},{-440,300}})));
        Agents.BoreField borFie(redeclare package Medium = MediumWater)
          annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-2,-440})));
        Distribution.BaseClasses.Pump_m_flow pumpMainRLTN(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDis_flow_nominal) "Pump"
          annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={80,-360})));
        Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Agents.SimplifiedETS
          ets1(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui1.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui1.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{100,-100},{140,-60}})));
        Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
          redeclare package Medium1 = MediumWater,
          redeclare package Medium2 = MediumWater,
          allowFlowReversal2=false,
          final m1_flow_nominal=datDes.mPla_flow_nominal,
          final m2_flow_nominal=datDes.mPla_flow_nominal,
          show_T=true,
          final dp1_nominal(displayUnit="bar") = 50000,
          final dp2_nominal(displayUnit="bar") = 50000,
          final eps=datDes.epsPla)
          "Heat exchanger" annotation (Placement(
              transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-226,-300})));
        Distribution.BaseClasses.Pump_m_flow pumpPrimarySidePlant(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000) "Pump" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-220,-270})));
        Modelica.Blocks.Sources.Constant mFlowInputPlant(final k=datDes.mPla_flow_nominal)
                                                                  "kg/s"
          annotation (Placement(transformation(extent={{-158,-298},{-174,-282}})));
        Buildings.Fluid.Sources.Boundary_pT sewageSourceAtConstTemp(
          redeclare package Medium = MediumWater,
          T=290.15,
          nPorts=2) "17°C"
          annotation (Placement(transformation(extent={{-280,-310},{-260,-290}})));
        Distribution.BaseClasses.Pump_m_flow pumpSecondarySidePlant(
          redeclare package Medium = MediumWater,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000) "Pump" annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-260,-270})));
        Fluid.Sensors.TemperatureTwoPort tempAfterPlantSecondSide(
            redeclare package Medium = MediumWater,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDis_flow_nominal,
          tau=0) annotation (Placement(
              transformation(
              extent={{-6,6},{6,-6}},
              rotation=180,
              origin={-246,-320})));
        Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
              MediumWater, nPorts=1)
          "Boundary pressure condition representing the expansion vessel"
                                     annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={132,-320})));

        Distribution.BaseClasses.Pump_m_flow pumpBHS(redeclare package Medium =
              MediumWater, m_flow_nominal=datDes.mSto_flow_nominal) "Pump"
          annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=180,
              origin={50,-440})));
        Distribution.BaseClasses.Junction splSup9(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDis_flow_nominal*{1,1,1},
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,10},{-10,-10}},
              rotation=90,
              origin={80,-400})));
        Distribution.BaseClasses.Junction splSup10(
          redeclare package Medium = MediumWater,
          m_flow_nominal=datDes.mDis_flow_nominal*{1,1,1},
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={-80,-400})));
        Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui1(redeclare
            package Medium1 =
                      MediumWater, nPorts1=2) "Building"
          annotation (Placement(transformation(extent={{120,-20},{140,0}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(k=ets1.THeaWatSup_nominal)
          "Heating water supply temperature set point"
          annotation (Placement(transformation(extent={{-460,230},{-440,250}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(k=ets1.TChiWatSup_nominal)
          "Chilled water supply temperature set point"
          annotation (Placement(transformation(extent={{-460,190},{-440,210}})));
        Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui2(
          redeclare package Medium1 = MediumWater,
          idfPath=
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94021950/RefBldgSmallOfficeNew2004_Chicago.idf",
          nPorts1=2) "Building"
          annotation (Placement(transformation(extent={{120,180},{140,200}})));

        Agents.SimplifiedETS ets2(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui2.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui2.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{100,80},{140,120}})));
        Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui3(redeclare
            package Medium1 =
                      MediumWater, nPorts1=2) "Building"
          annotation (Placement(transformation(extent={{120,360},{140,380}})));
        Agents.SimplifiedETS ets3(
          redeclare package Medium = MediumWater,
          QCoo_flow_nominal=sum(bui3.terUni.QCoo_flow_nominal),
          QHea_flow_nominal=sum(bui3.terUni.QHea_flow_nominal))
          "Energy transfer station"
          annotation (Placement(transformation(extent={{100,260},{140,300}})));
        Distribution.BaseClasses.ConnectionSeries conPla(
          redeclare package Medium = MediumWater,
          havePum=false,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=datDes.mPla_flow_nominal,
          lDis=datDes.lDis[1],
          lCon=datDes.lCon[1],
          dhDis=datDes.dhDis,
          dhCon=datDes.dhCon[1]) "Connection to the plant" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-80,-290})));
        Distribution.UnidirectionalSeries dis(
          redeclare package Medium = MediumWater,
          nCon=3,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=datDes.mCon_flow_nominal,
          lDis=datDes.lDis,
          lCon=datDes.lCon,
          dhDis=datDes.dhDis,
          dhCon=datDes.dhCon)
          annotation (Placement(transformation(extent={{-20,-150},{20,-130}})));
      protected
        constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
      equation
        connect(mFlowInputPlant.y, pumpPrimarySidePlant.m_flow_in) annotation (
            Line(points={{-174.8,-290},{-204,-290},{-204,-270},{-208,-270}}, color={0,
                0,127}));
        connect(tempAfterPlantSecondSide.port_a, plant.port_b2) annotation (Line(
              points={{-240,-320},{-232,-320},{-232,-310}},color={0,127,255}));
        connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[1])
          annotation (Line(points={{-252,-320},{-260,-320},{-260,-298}},color={0,
                127,255}));
        connect(mFlowInputPlant.y, pumpSecondarySidePlant.m_flow_in) annotation (
            Line(points={{-174.8,-290},{-200,-290},{-200,-270},{-272,-270}}, color={0,0,127}));
        connect(pumpPrimarySidePlant.port_a, plant.port_b1)
          annotation (Line(points={{-220,-280},{-220,-290}}, color={0,127,255}));
        connect(pumpSecondarySidePlant.port_b, plant.port_a2) annotation (Line(
              points={{-260,-260},{-260,-240},{-232,-240},{-232,-290}}, color={0,127,
                255}));
        connect(pumpSecondarySidePlant.port_a, sewageSourceAtConstTemp.ports[2])
          annotation (Line(points={{-260,-280},{-260,-302}}, color={0,127,255}));
        connect(bou.ports[1], pumpMainRLTN.port_a)
          annotation (Line(points={{122,-320},{80,-320},{80,-350}},
                                            color={0,127,255}));
        connect(borFie.port_a, pumpBHS.port_b)
          annotation (Line(points={{8,-440},{40,-440}}, color={0,127,255}));
        connect(splSup10.port_2, borFie.port_b)
          annotation (Line(points={{-80,
                -410},{-80,-440},{-12,-440}}, color={0,127,255}));
        connect(pumpBHS.port_a, splSup9.port_2) annotation (Line(points={{60,-440},
                {80,-440},{80,-410}},color={0,127,255}));
        connect(splSup9.port_1, pumpMainRLTN.port_b)
          annotation (Line(points={{80,-390},{80,-370}}, color={0,127,255}));
        connect(splSup10.port_3, splSup9.port_3)
          annotation (Line(points={{-70,-400},{70,-400}}, color={0,127,255}));
        connect(TSetHeaWatSup.y, ets1.TSetHeaWat) annotation (Line(points={{-438,240},
                {60,240},{60,-62.8571},{98.5714,-62.8571}},      color={0,0,127}));
        connect(TSetChiWatSup.y, ets1.TSetChiWat) annotation (Line(points={{-438,200},
                {60,200},{60,-68.5714},{98.5714,-68.5714}},      color={0,0,127}));
        connect(TSetHeaWatSup.y, ets2.TSetHeaWat) annotation (Line(points={{-438,240},
                {88,240},{88,117.143},{98.5714,117.143}},   color={0,0,127}));
        connect(TSetChiWatSup.y, ets2.TSetChiWat) annotation (Line(points={{-438,200},
                {84,200},{84,111.429},{98.5714,111.429}},   color={0,0,127}));
        connect(TSetHeaWatSup.y, ets3.TSetHeaWat) annotation (Line(points={{-438,240},
                {88,240},{88,297.143},{98.5714,297.143}},     color={0,0,127}));
        connect(TSetChiWatSup.y, ets3.TSetChiWat) annotation (Line(points={{-438,200},
                {84,200},{84,294},{102,294},{102,291.429},{98.5714,291.429}},
              color={0,0,127}));
        connect(conPla.port_conSup, plant.port_a1) annotation (Line(points={{-90,-290},
                {-100,-290},{-100,-320},{-220,-320},{-220,-310}}, color={0,127,255}));
        connect(pumpPrimarySidePlant.port_b, conPla.port_conRet) annotation (Line(
              points={{-220,-260},{-220,-240},{-100,-240},{-100,-284},{-90,-284}},
              color={0,127,255}));
        connect(splSup10.port_1, conPla.port_disInl) annotation (Line(points={{-80,
                -390},{-80,-300}},                 color={0,127,255}));
        connect(conPla.port_disOut, dis.port_disInl) annotation (Line(points={{-80,
                -280},{-80,-140},{-20,-140}},
                                        color={0,127,255}));
        connect(dis.port_disOut, pumpMainRLTN.port_a) annotation (Line(points={{20,-140},
                {80,-140},{80,-350}}, color={0,127,255}));
        connect(dis.ports_b1[1], ets1.port_a) annotation (Line(points={{-6.66667,-130},
                {-20,-130},{-20,-80},{100,-80}}, color={0,127,255}));
        connect(ets1.port_b, dis.ports_a1[1]) annotation (Line(points={{140,-80},{160,
                -80},{160,-120},{20,-120},{20,-130},{17.3333,-130}},color={0,127,255}));
        connect(dis.ports_b1[2], ets2.port_a) annotation (Line(points={{-12,-130},{-20,
                -130},{-20,100},{100,100}}, color={0,127,255}));
        connect(ets2.port_b, dis.ports_a1[2]) annotation (Line(points={{140,100},{160,
                100},{160,40},{20,40},{20,-128},{12,-128},{12,-130}},
                                                      color={0,127,255}));
        connect(dis.ports_b1[3], ets3.port_a) annotation (Line(points={{-17.3333,-130},
                {-20,-130},{-20,280},{100,280}}, color={0,127,255}));
        connect(ets3.port_b, dis.ports_a1[3]) annotation (Line(points={{140,280},{160,
                280},{160,234},{20,234},{20,-130},{6.66667,-130}},color={0,127,255}));
        connect(bui3.ports_b1[1:2], ets3.ports_a1) annotation (Line(points={{160,354},
                {180,354},{180,250},{94,250},{94,267.143},{100,267.143}}, color={0,
                127,255}));
        connect(ets3.ports_b1, bui3.ports_a1[1:2]) annotation (Line(points={{140,
                267.143},{154,267.143},{154,320},{80,320},{80,354},{100,354}}, color=
                {0,127,255}));
        connect(bui2.ports_b1[1:2], ets2.ports_a1) annotation (Line(points={{160,174},
                {180,174},{180,60},{80,60},{80,87.1429},{100,87.1429}}, color={0,127,
                255}));
        connect(ets2.ports_b1, bui2.ports_a1[1:2]) annotation (Line(points={{140,
                87.1429},{152,87.1429},{152,140},{92,140},{92,174},{100,174}}, color=
                {0,127,255}));
        connect(bui1.ports_b1[1:2], ets1.ports_a1) annotation (Line(points={{160,-26},
                {180,-26},{180,-114},{80,-114},{80,-92.8571},{100,-92.8571}}, color={
                0,127,255}));
        connect(ets1.ports_b1, bui1.ports_a1[1:2]) annotation (Line(points={{140,
                -92.8571},{150,-92.8571},{150,-52},{80,-52},{80,-26},{100,-26}},
              color={0,127,255}));
        annotation (Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-480,-500},{480,
              500}}), graphics={
              Text(
            extent={{-478,-420},{-138,-500}},
            lineColor={28,108,200},
            horizontalAlignment=TextAlignment.Left,
                textString="Simulation requires the first setting and is faster with the  second one

Hidden.AvoidDoubleComputation=true;
Advanced.SparseActivate=true")}),
          experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
          Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
      end RN_BaseModel_bck2;

      partial model RN_BaseModel_bck3
        package Medium = Buildings.Media.Water "Medium model";
        parameter Integer nBui = 3
          "Number of buildings connected to DHC system"
          annotation (Evaluate=true);
        parameter String idfPath[nBui] = {
          "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf",
          "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94021950/RefBldgSmallOfficeNew2004_Chicago.idf",
          "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"}
          "Paths of the IDF files";
        parameter String weaPath=
          "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
          "Path of the weather file";
        parameter Integer nZon[nBui] = fill(6, nBui)
          "Number of thermal zones"
          annotation(Evaluate=true);
        inner parameter Data.DesignDataDHC datDes(
          mCon_flow_nominal={
            max(bui[i].ets.m1HexChi_flow_nominal, bui[i].ets.mEva_flow_nominal) for i in 1:nBui})
          "Design values"
          annotation (Placement(transformation(extent={{-320,240},{-300,260}})));
        // COMPONENTS
        Agents.BuildingWithETS bui[nBui](
          redeclare each final package Medium = Medium,
          idfPath=idfPath,
          each weaPath=weaPath,
          nZon=nZon)
          annotation (Placement(transformation(extent={{-10,170},{10,190}})));
        Agents.BoreField borFie(redeclare package Medium=Medium)
          annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-2,-160})));
        Distribution.BaseClasses.Pump_m_flow pumpMainRLTN(
          redeclare package Medium=Medium,
          m_flow_nominal=datDes.mDis_flow_nominal) "Pump"
          annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={80,-80})));
        Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
          redeclare package Medium1=Medium,
          redeclare package Medium2=Medium,
          allowFlowReversal2=false,
          final m1_flow_nominal=datDes.mPla_flow_nominal,
          final m2_flow_nominal=datDes.mPla_flow_nominal,
          show_T=true,
          final dp1_nominal(displayUnit="bar") = 50000,
          final dp2_nominal(displayUnit="bar") = 50000,
          final eps=datDes.epsPla)
          "Heat exchanger" annotation (Placement(
              transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-226,-20})));
        Distribution.BaseClasses.Pump_m_flow pumpPrimarySidePlant(
          redeclare package Medium=Medium,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000) "Pump" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-220,10})));
        Modelica.Blocks.Sources.Constant mFlowInputPlant(
          final k=datDes.mPla_flow_nominal)
          "District water flow rate to plant"
          annotation (Placement(transformation(extent={{-158,-18},{-174,-2}})));
        Buildings.Fluid.Sources.Boundary_pT sewageSourceAtConstTemp(
          redeclare package Medium=Medium,
          T=290.15,
          nPorts=2) "17°C"
          annotation (Placement(transformation(extent={{-280,-30},{-260,-10}})));
        Distribution.BaseClasses.Pump_m_flow pumpSecondarySidePlant(
          redeclare package Medium=Medium,
          final m_flow_nominal=datDes.mPla_flow_nominal,
          dp_nominal=50000) "Pump" annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-260,10})));
        Fluid.Sensors.TemperatureTwoPort tempAfterPlantSecondSide(
            redeclare package Medium=Medium,
          allowFlowReversal=false,
          m_flow_nominal=datDes.mDis_flow_nominal,
          tau=0) annotation (Placement(
              transformation(
              extent={{-6,6},{6,-6}},
              rotation=180,
              origin={-246,-40})));
        Buildings.Fluid.Sources.Boundary_pT bou(
          redeclare package Medium=Medium,
          nPorts=1)
          "Boundary pressure condition representing the expansion vessel"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={112,-40})));
        Distribution.BaseClasses.Pump_m_flow pumpBHS(
          redeclare package Medium=Medium,
          m_flow_nominal=datDes.mSto_flow_nominal) "Pump"
          annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=180,
              origin={50,-160})));
        Distribution.BaseClasses.Junction splSup9(
          redeclare package Medium=Medium,
          m_flow_nominal=datDes.mDis_flow_nominal*{1,1,1},
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,10},{-10,-10}},
              rotation=90,
              origin={80,-120})));
        Distribution.BaseClasses.Junction splSup10(
          redeclare package Medium=Medium,
          m_flow_nominal=datDes.mDis_flow_nominal*{1,1,1},
          from_dp=false) "Flow splitter" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={-80,-120})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup[nBui](k=
              bui.THeaWatSup_nominal) "Heating water supply temperature set point"
          annotation (Placement(transformation(extent={{-320,190},{-300,210}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup[nBui](k=
              bui.TChiWatSup_nominal) "Chilled water supply temperature set point"
          annotation (Placement(transformation(extent={{-320,150},{-300,170}})));
        Distribution.BaseClasses.ConnectionSeries conPla(
          redeclare package Medium=Medium,
          havePum=false,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=datDes.mPla_flow_nominal,
          lDis=datDes.lDis[1],
          lCon=datDes.lCon[1],
          dhDis=datDes.dhDis,
          dhCon=datDes.dhCon[1]) "Connection to the plant" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-80,-10})));
        Distribution.UnidirectionalSeries dis(
          redeclare package Medium=Medium,
          nCon=nBui,
          mDis_flow_nominal=datDes.mDis_flow_nominal,
          mCon_flow_nominal=datDes.mCon_flow_nominal,
          lDis=datDes.lDis,
          lCon=datDes.lCon,
          dhDis=datDes.dhDis,
          dhCon=datDes.dhCon)
          annotation (Placement(transformation(extent={{-20,130},{20,150}})));
      protected
        constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
      equation
        connect(mFlowInputPlant.y, pumpPrimarySidePlant.m_flow_in) annotation (
            Line(points={{-174.8,-10},{-204,-10},{-204,10},{-208,10}},       color={0,
                0,127}));
        connect(tempAfterPlantSecondSide.port_a, plant.port_b2) annotation (Line(
              points={{-240,-40},{-232,-40},{-232,-30}},   color={0,127,255}));
        connect(mFlowInputPlant.y, pumpSecondarySidePlant.m_flow_in) annotation (
            Line(points={{-174.8,-10},{-200,-10},{-200,10},{-272,10}},       color={0,0,127}));
        connect(pumpPrimarySidePlant.port_a, plant.port_b1)
          annotation (Line(points={{-220,0},{-220,-10}},     color={0,127,255}));
        connect(pumpSecondarySidePlant.port_b, plant.port_a2) annotation (Line(
              points={{-260,20},{-260,40},{-232,40},{-232,-10}},        color={0,127,
                255}));
        connect(bou.ports[1], pumpMainRLTN.port_a)
          annotation (Line(points={{102,-40},{80,-40},{80,-70}},
                                            color={0,127,255}));
        connect(borFie.port_a, pumpBHS.port_b)
          annotation (Line(points={{8,-160},{40,-160}}, color={0,127,255}));
        connect(splSup10.port_2, borFie.port_b)
          annotation (Line(points={{-80,-130},{-80,-160},{-12,-160}},
                                              color={0,127,255}));
        connect(pumpBHS.port_a, splSup9.port_2) annotation (Line(points={{60,-160},{
                80,-160},{80,-130}}, color={0,127,255}));
        connect(splSup9.port_1, pumpMainRLTN.port_b)
          annotation (Line(points={{80,-110},{80,-90}},  color={0,127,255}));
        connect(splSup10.port_3, splSup9.port_3)
          annotation (Line(points={{-70,-120},{70,-120}}, color={0,127,255}));
        connect(conPla.port_conSup, plant.port_a1) annotation (Line(points={{-90,-10},
                {-100,-10},{-100,-40},{-220,-40},{-220,-30}},     color={0,127,255}));
        connect(pumpPrimarySidePlant.port_b, conPla.port_conRet) annotation (Line(
              points={{-220,20},{-220,40},{-100,40},{-100,-4},{-90,-4}},
              color={0,127,255}));
        connect(splSup10.port_1, conPla.port_disInl) annotation (Line(points={{-80,
                -110},{-80,-20}},                  color={0,127,255}));
        connect(conPla.port_disOut, dis.port_disInl) annotation (Line(points={{-80,0},
                {-80,140},{-20,140}},   color={0,127,255}));
        connect(dis.port_disOut, pumpMainRLTN.port_a) annotation (Line(points={{20,140},
                {80,140},{80,-70}},   color={0,127,255}));
        connect(dis.ports_b1, bui.port_a) annotation (Line(points={{-12,150},{-14,150},
                {-14,180},{-10,180}}, color={0,127,255}));
        connect(bui.port_b, dis.ports_a1) annotation (Line(points={{10,180},{14,180},
                {14,150},{12,150}},
                                  color={0,127,255}));
        connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[1])
          annotation (Line(points={{-252,-40},{-260,-40},{-260,-18}},    color={0,127,255}));
        connect(sewageSourceAtConstTemp.ports[2], pumpSecondarySidePlant.port_a)
          annotation (Line(points={{-260,-22},{-260,0}},     color={0,127,255}));
        connect(TSetHeaWatSup.y, bui.TSetHeaWat) annotation (Line(points={{-298,200},
                {-20,200},{-20,188},{-11,188}},
                                           color={0,0,127}));
        connect(TSetChiWatSup.y, bui.TSetChiWat) annotation (Line(points={{-298,160},
                {-20,160},{-20,184},{-11,184}}, color={0,0,127}));
        annotation (Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-480,-380},{480,380}}),
                      graphics={
              Text(
            extent={{-478,-142},{-138,-222}},
            lineColor={28,108,200},
            horizontalAlignment=TextAlignment.Left,
                textString="Simulation requires the first setting and is faster with the  second one

Hidden.AvoidDoubleComputation=true;
Advanced.SparseActivate=true")}),
          experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
          Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
      end RN_BaseModel_bck3;
    end BaseClasses;
  end Examples;

  package Validation "Collection of validation models"
    extends Modelica.Icons.ExamplesPackage;

    model BuildingETSConnection "Validation of building and ETS connection"
      extends Modelica.Icons.Example;
        package Medium1 = Buildings.Media.Water
        "Source side medium";
      Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium1,
          nPorts=1) "Sink for district water" annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={130,-40})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(k=bui.ets.THeaWatSup_nominal)
        "Heating water supply temperature set point"
        annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(k=bui.ets.TChiWatSup_nominal)
        "Chilled water supply temperature set point"
        annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
      Fluid.Sources.Boundary_pT sou(
        redeclare package Medium = Medium1,
        use_T_in=true,
        nPorts=1) "Source for district water" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-50,-40})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDis(k=273.15 + 15)
        "District water temperature"
        annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
      Agents.BuildingWithETS bui(redeclare package Medium = Medium1)
        "Model of a building with an energy transfer station"
        annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
      inner parameter Data.DesignDataDHC datDes(
        nBui=1,
        mDis_flow_nominal=25,
        mCon_flow_nominal={25},
        epsPla=0.935) "Design values"
        annotation (Placement(transformation(extent={{-160,66},{-140,86}})));
    equation
      connect(TDis.y, sou.T_in) annotation (Line(points={{-118,-60},{-80,-60},{-80,
              -36},{-62,-36}}, color={0,0,127}));
      connect(sou.ports[1], bui.port_a)
        annotation (Line(points={{-40,-40},{20,-40}},color={0,127,255}));
      connect(bui.port_b, sin.ports[1])
        annotation (Line(points={{40,-40},{120,-40}}, color={0,127,255}));
      connect(TSetHeaWatSup.y, bui.TSetHeaWat) annotation (Line(points={{-118,20},{
              0,20},{0,-32},{19,-32}},      color={0,0,127}));
      connect(TSetChiWatSup.y, bui.TSetChiWat) annotation (Line(points={{-118,-20},
              {-20,-20},{-20,-36},{19,-36}},color={0,0,127}));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{
                180,120}}),
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

    model Decoupler "Validation of building and ETS connection"
      extends Modelica.Icons.Example;
        package Medium = Buildings.Media.Water
        "Source side medium";
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
        "Nominal mass flow rate";
      Fluid.Movers.FlowControlled_m_flow sou1(
        redeclare package Medium = Medium,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        T_start=273.15 + 40,
        m_flow_nominal=m_flow_nominal,
        addPowerToMedium=false,
        nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
        annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
      EnergyTransferStations.BaseClasses.HydraulicHeader hydHea(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        nPorts_a=3,
        nPorts_b=3)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={0,-2})));
      Fluid.Movers.FlowControlled_m_flow sou2(
        redeclare package Medium = Medium,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        T_start=273.15 + 30,
        m_flow_nominal=m_flow_nominal,
        addPowerToMedium=false,
        nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
        annotation (Placement(transformation(extent={{170,-30},{150,-10}})));
      Fluid.Sources.Boundary_pT bou1(
        redeclare package Medium = Medium,
        use_T_in=true,
        nPorts=2) "Boundary pressure" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-130,0})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m1(
        height=1.1,
        duration=1000,
        startTime=0)
        "Primary flow"
        annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T1(k=273.15 + 40)
        "Primary supply temperature"
        annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
      Fluid.Sensors.TemperatureTwoPort senT2Sup(redeclare final package Medium =
            Medium, m_flow_nominal=m_flow_nominal)
        "Secondary supply temperature (sensed)" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={40,20})));
      Fluid.Sensors.TemperatureTwoPort senT1Sup(redeclare final package Medium =
            Medium, m_flow_nominal=m_flow_nominal)
        "Primary supply temperature (sensed)" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-40,20})));
      Fluid.Sensors.TemperatureTwoPort senT1Ret(redeclare final package Medium =
            Medium, m_flow_nominal=m_flow_nominal)
        "Primary return temperature (sensed)" annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={-40,-20})));
      Fluid.Sensors.TemperatureTwoPort senT2Ret(redeclare final package Medium =
            Medium, m_flow_nominal=m_flow_nominal)
        "Secondary return temperature (sensed)" annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={40,-20})));
      Fluid.Sensors.MassFlowRate senMasFlo1Sup(redeclare final package Medium =
            Medium) "Primary mass flow rate (sensed)"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Fluid.Sensors.MassFlowRate senMasFlo2Sup(redeclare final package Medium =
            Medium) "Secondary mass flow rate (sensed)"
        annotation (Placement(transformation(extent={{110,10},{130,30}})));
      Fluid.MixingVolumes.MixingVolume vol1(
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        T_start=273.15 + 30,
        final prescribedHeatFlowRate=true,
        redeclare final package Medium = Medium,
        V=1,
        final mSenFac=1,
        final m_flow_nominal=m_flow_nominal,
        nPorts=2) "Volume for fluid stream"
        annotation (Placement(transformation(extent={{189,-20},{209,-40}})));
      Fluid.HeatExchangers.HeaterCooler_u coo(
        redeclare final package Medium = Medium,
        dp_nominal=1,
        m_flow_nominal=m_flow_nominal,
        Q_flow_nominal=-1E5) "Heat exchange with water stream"
        annotation (Placement(transformation(extent={{80,-30},{60,-10}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T3(k=273.15 + 30)
        "Primary supply temperature"
        annotation (Placement(transformation(extent={{40,50},{60,70}})));
      Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat1(
        k=0.1,
        Ti=10,
        each yMax=1,
        each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
        each yMin=0,
        reverseAction=true)
                     "PI controller for chilled water supply"
        annotation (Placement(transformation(extent={{70,50},{90,70}})));
      Fluid.Sensors.MassFlowRate senMasFlo1Ret(redeclare final package Medium =
            Medium) "Primary mass flow rate (sensed)"
        annotation (Placement(transformation(extent={{-60,-30},{-80,-10}})));
      Fluid.Sensors.MassFlowRate senMasFlo2Ret(redeclare final package Medium =
            Medium) "Secondary mass flow rate (sensed)"
        annotation (Placement(transformation(extent={{130,-30},{110,-10}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m3(
        height=0.5,
        duration=1000,
        offset=0.5,
        startTime=2000)
        "Primary flow"
        annotation (Placement(transformation(extent={{200,50},{180,70}})));
      Fluid.Movers.FlowControlled_m_flow sou3(
        redeclare package Medium = Medium,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        T_start=273.15 + 30,
        m_flow_nominal=m_flow_nominal,
        addPowerToMedium=false,
        nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
        annotation (Placement(transformation(extent={{170,-170},{150,-150}})));
      Fluid.Sensors.TemperatureTwoPort senT2Sup1(redeclare final package Medium =
            Medium, m_flow_nominal=m_flow_nominal)
        "Secondary supply temperature (sensed)" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={40,-120})));
      Fluid.Sensors.TemperatureTwoPort senT2Ret1(redeclare final package Medium =
            Medium, m_flow_nominal=m_flow_nominal)
        "Secondary return temperature (sensed)" annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={40,-160})));
      Fluid.Sensors.MassFlowRate senMasFlo2Sup1(redeclare final package Medium =
            Medium) "Secondary mass flow rate (sensed)"
        annotation (Placement(transformation(extent={{110,-130},{130,-110}})));
      Fluid.MixingVolumes.MixingVolume vol2(
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        T_start=273.15 + 30,
        final prescribedHeatFlowRate=true,
        redeclare final package Medium = Medium,
        V=1,
        final mSenFac=1,
        final m_flow_nominal=m_flow_nominal,
        nPorts=2) "Volume for fluid stream"
        annotation (Placement(transformation(extent={{189,-160},{209,-180}})));
      Fluid.HeatExchangers.HeaterCooler_u coo1(
        redeclare final package Medium = Medium,
        dp_nominal=1,
        m_flow_nominal=m_flow_nominal,
        Q_flow_nominal=-1E5) "Heat exchange with water stream"
        annotation (Placement(transformation(extent={{80,-170},{60,-150}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T2(k=273.15 + 35)
        "Primary supply temperature"
        annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
      Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat2(
        k=0.1,
        Ti=10,
        each yMax=1,
        each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
        each yMin=0,
        reverseAction=true)
                     "PI controller for chilled water supply"
        annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
      Fluid.Sensors.MassFlowRate senMasFlo2Ret1(redeclare final package Medium =
            Medium) "Secondary mass flow rate (sensed)"
        annotation (Placement(transformation(extent={{130,-170},{110,-150}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m2(
        height=0,
        duration=1000,
        offset=0.5,
        startTime=3000)
        "Primary flow"
        annotation (Placement(transformation(extent={{200,-90},{180,-70}})));
    equation
      connect(m1.y, sou1.m_flow_in) annotation (Line(points={{-158,60},{-100,60},{
              -100,32}},       color={0,0,127}));
      connect(senMasFlo1Sup.port_b, senT1Sup.port_a)
        annotation (Line(points={{-60,20},{-50,20}}, color={0,127,255}));
      connect(senT2Sup.port_b, senMasFlo2Sup.port_a)
        annotation (Line(points={{50,20},{110,20}}, color={0,127,255}));
      connect(sou1.port_b, senMasFlo1Sup.port_a)
        annotation (Line(points={{-90,20},{-80,20}}, color={0,127,255}));
      connect(coo.port_b, senT2Ret.port_a)
        annotation (Line(points={{60,-20},{50,-20}}, color={0,127,255}));
      connect(T3.y, conTChiWat1.u_s)
        annotation (Line(points={{62,60},{54,60},{54,64},{56,64},{56,60},{68,60}},
                                                   color={0,0,127}));
      connect(conTChiWat1.y, coo.u) annotation (Line(points={{92,60},{100,60},{100,
              -14},{82,-14}}, color={0,0,127}));
      connect(senT2Ret.T, conTChiWat1.u_m)
        annotation (Line(points={{40,-9},{40,0},{80,0},{80,48}}, color={0,0,127}));
      connect(vol1.ports[1], sou2.port_a)
        annotation (Line(points={{197,-20},{170,-20}}, color={0,127,255}));
      connect(senMasFlo2Sup.port_b, vol1.ports[2])
        annotation (Line(points={{130,20},{201,20},{201,-20}}, color={0,127,255}));
      connect(sou2.port_b, senMasFlo2Ret.port_a)
        annotation (Line(points={{150,-20},{130,-20}}, color={0,127,255}));
      connect(senMasFlo2Ret.port_b, coo.port_a)
        annotation (Line(points={{110,-20},{80,-20}}, color={0,127,255}));
      connect(m3.y, sou2.m_flow_in)
        annotation (Line(points={{178,60},{160,60},{160,-8}}, color={0,0,127}));
      connect(bou1.ports[1], sou1.port_a) annotation (Line(points={{-120,2},{-120,
              20},{-110,20}}, color={0,127,255}));
      connect(T1.y, bou1.T_in) annotation (Line(points={{-158,-50},{-152,-50},{-152,
              4},{-142,4}}, color={0,0,127}));
      connect(senT1Ret.port_b, senMasFlo1Ret.port_a)
        annotation (Line(points={{-50,-20},{-60,-20}}, color={0,127,255}));
      connect(senMasFlo1Ret.port_b, bou1.ports[2]) annotation (Line(points={{-80,
              -20},{-120,-20},{-120,-2}}, color={0,127,255}));
      connect(senT1Sup.port_b, hydHea.ports_a[1]) annotation (Line(points={{-30,20},
              {2.66667,20},{2.66667,8}},
                                     color={0,127,255}));
      connect(hydHea.ports_b[1], senT1Ret.port_a) annotation (Line(points={{
              -2.66667,-12},{-2.66667,-20},{-30,-20}},
                                      color={0,127,255}));
      connect(senT2Ret.port_b, hydHea.ports_b[2]) annotation (Line(points={{30,-20},
              {14,-20},{14,-12},{-1.77636e-15,-12}},
                                                 color={0,127,255}));
      connect(hydHea.ports_a[2], senT2Sup.port_a) annotation (Line(points={{
              1.77636e-15,8},{20,8},{20,20},{30,20}},
                                         color={0,127,255}));
      connect(senT2Sup1.port_b, senMasFlo2Sup1.port_a)
        annotation (Line(points={{50,-120},{110,-120}}, color={0,127,255}));
      connect(coo1.port_b, senT2Ret1.port_a)
        annotation (Line(points={{60,-160},{50,-160}}, color={0,127,255}));
      connect(T2.y,conTChiWat2. u_s)
        annotation (Line(points={{62,-80},{58,-80},{58,-76},{60,-76},{60,-80},{68,
              -80}},                               color={0,0,127}));
      connect(conTChiWat2.y, coo1.u) annotation (Line(points={{92,-80},{100,-80},{
              100,-154},{82,-154}}, color={0,0,127}));
      connect(senT2Ret1.T, conTChiWat2.u_m) annotation (Line(points={{40,-149},{40,
              -140},{80,-140},{80,-92}}, color={0,0,127}));
      connect(vol2.ports[1],sou3. port_a)
        annotation (Line(points={{197,-160},{170,-160}},
                                                       color={0,127,255}));
      connect(senMasFlo2Sup1.port_b, vol2.ports[2]) annotation (Line(points={{130,
              -120},{201,-120},{201,-160}}, color={0,127,255}));
      connect(sou3.port_b, senMasFlo2Ret1.port_a)
        annotation (Line(points={{150,-160},{130,-160}}, color={0,127,255}));
      connect(senMasFlo2Ret1.port_b, coo1.port_a)
        annotation (Line(points={{110,-160},{80,-160}}, color={0,127,255}));
      connect(m2.y,sou3. m_flow_in)
        annotation (Line(points={{178,-80},{160,-80},{160,-148}},
                                                              color={0,0,127}));
      connect(hydHea.ports_a[3], senT2Sup1.port_a) annotation (Line(points={{
              -2.66667,8},{20,8},{20,-120},{30,-120}}, color={0,127,255}));
      connect(hydHea.ports_b[3], senT2Ret1.port_b) annotation (Line(points={{
              2.66667,-12},{14,-12},{14,-160},{30,-160}}, color={0,127,255}));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-200},{
                220,120}})),
       experiment(
          StopTime=5000,
          Tolerance=1e-06,
          __Dymola_Algorithm="Cvode"),
        __Dymola_Commands(file=
              "Resources/Scripts/Dymola/Applications/DHC/Examples/FifthGenUniSeries/Validation/Decoupler.mos"
            "Simulate and plot"));
    end Decoupler;
  end Validation;

  package Data "Package for data records"
    extends Modelica.Icons.MaterialPropertiesPackage;

    record DesignDataDHC "Record with design data for DHC system"
      extends Modelica.Icons.Record;
      parameter Integer nBui = 3
        "Number of served buildings"
        annotation(Evaluate=true);
      parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = 95
        "Distribution pipe flow rate";
      parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nBui]
        "Connection pipe flow rate";
      parameter Modelica.SIunits.MassFlowRate mPla_flow_nominal = 11.45
        "Plant mass flow rate";
      parameter Modelica.SIunits.MassFlowRate mSto_flow_nominal = 105
        "Storage mass flow rate";
      parameter Real epsPla
        "Plant efficiency";
      parameter Modelica.SIunits.Temperature TLooMin = 273.15 + 6
        "Minimum loop temperature";
      parameter Modelica.SIunits.Temperature TLooMax = 273.15 + 17
        "Maximum loop temperature";
      parameter Modelica.SIunits.Length dhDis = 0.25
        "Hydraulic diameter of distribution pipe";
      parameter Modelica.SIunits.Length dhCon[nBui] = fill(0.15, nBui)
        "Hydraulic diameter of connection pipe";
      parameter Modelica.SIunits.Length lDis[nBui] = fill(100, nBui)
        "Length of distribution pipe (only counting warm or cold line, but not sum)";
      parameter Modelica.SIunits.Length lCon[nBui] = fill(10, nBui)
        "Length of connection pipe (only counting warm or cold line, but not sum)";
      annotation (
        defaultComponentPrefix="datDes",
        defaultComponentPrefixes="inner");
    end DesignDataDHC;
  end Data;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Unidirectional;
