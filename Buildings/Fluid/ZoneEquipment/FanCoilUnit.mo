within Buildings.Fluid.ZoneEquipment;
package FanCoilUnit "Package with fan coil unit system models"
  model FanCoilUnit "System model for fan coil unit"

    parameter Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.heatingCoil
      heatingCoilType=Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.heatingCoil.heatingHotWater
      "Type of heating coil used in the FCU"
      annotation(Dialog(group="System parameters"));

    parameter Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.capacityControl
      capacityControlMethod "Type of capacity control method"
      annotation(Dialog(group="System parameters"));

    parameter Modelica.Units.SI.HeatFlowRate QHeaCoi_flow_nominal
      "Heat flow rate at u=1, positive for heating"
      annotation(Dialog(enable=not has_heatingCoilHHW, group="Heating coil parameters"));

    parameter Modelica.Units.SI.MassFlowRate mHotWat_flow_nominal
      "Nominal mass flow rate of water"
      annotation(Dialog(enable=has_heatingCoilHHW, group="Heating coil parameters"));

    parameter Modelica.Units.SI.PressureDifference dpAirTot_nominal
      "Total pressure difference across supply and return ports in airloop"
      annotation(Dialog(group="System parameters"));

    parameter Modelica.Units.SI.ThermalConductance UAHeaCoi_nominal
      "Thermal conductance at nominal flow, used to compute heat capacity"
      annotation(Dialog(enable=has_heatingCoilHHW, group="Heating coil parameters"));

    parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal
      "Nominal mass flow rate of water"
      annotation(Dialog(group="Cooling coil parameters"));

    parameter Modelica.Units.SI.ThermalConductance UACooCoi_nominal
      "Thermal conductance at nominal flow, used to compute heat capacity"
      annotation(Dialog(group="Cooling coil parameters"));

    parameter Modelica.Units.SI.MassFlowRate mAirOut_flow_nominal
      "Nominal mass flow rate of outdoor air"
      annotation(Dialog(group="System parameters"));

    parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
      "Nominal mass flow rate, used for regularization near zero flow"
      annotation(Dialog(group="System parameters"));

    parameter Boolean has_heatingCoilHHW=(heatingCoilType == Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.heatingCoil.heatingHotWater)
      "Does the zone equipment have a hot water heating coil?"
      annotation (Dialog(enable=false, group="Non-configurable"));

    replaceable package MediumA = Buildings.Media.Air
      constrainedby Modelica.Media.Interfaces.PartialCondensingGases "Medium model for air";

    replaceable package MediumW = Buildings.Media.Water "Medium model for water";

    Modelica.Fluid.Interfaces.FluidPort_a port_return(redeclare package Medium =
          MediumA) "Return air port from zone" annotation (Placement(
          transformation(extent={{350,30},{370,50}}),  iconTransformation(extent={{90,-10},
              {110,10}})));

    Modelica.Fluid.Interfaces.FluidPort_b port_supply(redeclare package Medium =
          MediumA) "Supply air port to the zone" annotation (Placement(
          transformation(extent={{350,-50},{370,-30}}),
                                                      iconTransformation(extent={{90,-50},
              {110,-30}})));

    Modelica.Fluid.Interfaces.FluidPort_b port_CCW_outlet(redeclare package
        Medium = MediumW) "Chilled water return port"
      annotation (Placement(transformation(extent={{94,-190},{114,-170}}),
          iconTransformation(extent={{10,-110},{30,-90}})));

    Modelica.Fluid.Interfaces.FluidPort_a port_CCW_inlet(redeclare package Medium =
          MediumW) "Chilled water supply port"
      annotation (Placement(transformation(extent={{134,-190},{154,-170}}),
          iconTransformation(extent={{50,-110},{70,-90}})));

    Modelica.Fluid.Interfaces.FluidPort_b port_HHW_outlet(redeclare package
        Medium = MediumW) if has_heatingCoilHHW "Hot water return port"
      annotation (Placement(transformation(extent={{-46,-190},{-26,-170}}),
          iconTransformation(extent={{-70,-110},{-50,-90}})));

    Modelica.Fluid.Interfaces.FluidPort_a port_HHW_inlet(redeclare package Medium =
          MediumW) if has_heatingCoilHHW "Hot water supply port"
      annotation (Placement(transformation(extent={{-6,-190},{14,-170}}),
          iconTransformation(extent={{-30,-110},{-10,-90}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea
      "Heating loop signal" annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          origin={-380,-140}),iconTransformation(
          extent={{-20,-20},{20,20}},
          origin={-120,-60})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo
      "Cooling loop signal" annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          origin={-380,-80}),
                            iconTransformation(
          extent={{-20,-20},{20,20}},
          origin={-120,-20})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput uFan "Fan signal" annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          origin={-380,80}), iconTransformation(
          extent={{-20,-20},{20,20}},
          origin={-120,20})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupAir
      "Supply air temperature"
      annotation (Placement(transformation(extent={{360,100},{400,140}}),
          iconTransformation(extent={{100,60},{140,100}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSupAir_flow "Supply air flowrate"
      annotation (Placement(transformation(extent={{360,60},{400,100}}),
          iconTransformation(extent={{100,20},{140,60}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput uOA
      "Outdoor air signal" annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          origin={-380,120}), iconTransformation(
          extent={{-20,-20},{20,20}},
          origin={-120,60})));

    Fluid.Actuators.Dampers.MixingBox eco(
      redeclare package Medium = MediumA,
      mOut_flow_nominal=mAirOut_flow_nominal,
      dpDamOut_nominal=50,
      mRec_flow_nominal=mAir_flow_nominal,
      dpDamRec_nominal=50,
      mExh_flow_nominal=mAirOut_flow_nominal,
      dpDamExh_nominal=50) "Outdoor air economizer"
      annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));

    Fluid.Sources.Outside           out(
      redeclare package Medium = MediumA,
      nPorts=2)
      "Boundary conditions for outside air"
      annotation (Placement(transformation(extent={{-280,-30},{-260,-10}})));

    BoundaryConditions.WeatherData.Bus           weaBus
      "Weather bus"
      annotation (Placement(
          transformation(extent={{-340,-40},{-300,0}}),   iconTransformation(
            extent={{-90,70},{-70,90}})));

  // protected
    replaceable Fluid.Sensors.VolumeFlowRate VAirOut_flow(redeclare package
        Medium =                                                                     MediumA,
        m_flow_nominal=mAirOut_flow_nominal)
                                          "Outdoor air volume flowrate"
      annotation (Placement(transformation(extent={{-240,-10},{-220,10}})));

    replaceable Fluid.Sensors.TemperatureTwoPort TAirOutSen(redeclare package
        Medium = MediumA, m_flow_nominal=mAirOut_flow_nominal)
      "Outdoor air temperature sensor"
      annotation (Placement(transformation(extent={{-210,-10},{-190,10}})));

    replaceable Fluid.Sensors.TemperatureTwoPort TAirExhSen(redeclare package
        Medium = MediumA, m_flow_nominal=mAirOut_flow_nominal)
      "Return air temperature sensor"
      annotation (Placement(transformation(extent={{-210,-50},{-190,-30}})));

    replaceable Fluid.Sensors.VolumeFlowRate VAirExh_flow(redeclare package
        Medium =                                                                     MediumA,
        m_flow_nominal=mAirOut_flow_nominal) "Exhaust air volume flowrate"
      annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));

    replaceable Fluid.Sensors.TemperatureTwoPort TAirMixSen(redeclare package
        Medium = MediumA, m_flow_nominal=mAir_flow_nominal)
      "Mixed air temperature sensor"
      annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

    replaceable Fluid.Sensors.VolumeFlowRate VAirMix_flow(redeclare package
        Medium =                                                                     MediumA,
        m_flow_nominal=mAir_flow_nominal) "Mixed air volume flowrate"
      annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));

    replaceable Fluid.Sensors.TemperatureTwoPort TAirHeaSen(redeclare package
        Medium = MediumA, m_flow_nominal=mAir_flow_nominal)
      "Heating coil discharge air temperature sensor"
      annotation (Placement(transformation(extent={{30,-20},{50,0}})));

    Fluid.HeatExchangers.DryCoilCounterFlow heaCoiHHW(
      redeclare package Medium1 = MediumW,
      redeclare package Medium2 = MediumA,
      m1_flow_nominal=mHotWat_flow_nominal,
      m2_flow_nominal=mAir_flow_nominal,
      dp1_nominal=0,
      dp2_nominal=0,
      UA_nominal=UAHeaCoi_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) if
      has_heatingCoilHHW                           "Hot water heating coil"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-10,-50})));

    Fluid.Actuators.Valves.TwoWayLinear valHotWat(
      redeclare package Medium = MediumW,
      m_flow_nominal=mHotWat_flow_nominal,
      dpValve_nominal=50) if has_heatingCoilHHW "Hot water flow control valve"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-36,-74})));

    replaceable Fluid.Sensors.VolumeFlowRate VHotWat_flow(redeclare package
        Medium = MediumW, m_flow_nominal=mHotWat_flow_nominal) if
      has_heatingCoilHHW "Hot water volume flowrate sensor"    annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={4,-84})));

    replaceable Fluid.Sensors.TemperatureTwoPort THotWatRetSen(redeclare
        package
        Medium = MediumW, m_flow_nominal=mHotWat_flow_nominal) if
                                                           has_heatingCoilHHW
      "Hot water return temperature sensor" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-36,-104})));

    replaceable Fluid.Sensors.TemperatureTwoPort THotWatSupSen(redeclare
        package
        Medium = MediumW, m_flow_nominal=mHotWat_flow_nominal) if
      has_heatingCoilHHW "Hot water supply temperature sensor" annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={4,-114})));

    Fluid.HeatExchangers.WetCoilCounterFlow cooCoiCHW(
      redeclare package Medium1 = MediumW,
      redeclare package Medium2 = MediumA,
      m1_flow_nominal=mChiWat_flow_nominal,
      m2_flow_nominal=mAir_flow_nominal,
      dp1_nominal=0,
      dp2_nominal=0,
      UA_nominal=UACooCoi_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      "Chilled-water cooling coil"
                             annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={130,-10})));

    Fluid.Actuators.Valves.TwoWayLinear valChiWat(
      redeclare package Medium = MediumW,
      m_flow_nominal=mChiWat_flow_nominal,
      dpValve_nominal=50) "Chilled water flow control valve" annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={104,-34})));

    replaceable Fluid.Sensors.TemperatureTwoPort TChiWatRetSen(redeclare
        package
        Medium = MediumW, m_flow_nominal=mChiWat_flow_nominal)
      "Chilled water return temperature sensor" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={104,-64})));

    replaceable Fluid.Sensors.VolumeFlowRate VChiWat_flow(redeclare package
        Medium = MediumW, m_flow_nominal=mChiWat_flow_nominal) annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={144,-44})));

    replaceable Fluid.Sensors.TemperatureTwoPort TChiWatSupSen(redeclare
        package
        Medium = MediumW, m_flow_nominal=mChiWat_flow_nominal)
      "Chilled water supply temperature sensor" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={144,-74})));

    replaceable Fluid.Sensors.TemperatureTwoPort TAirSupSen(redeclare package
        Medium = MediumA, m_flow_nominal=mAir_flow_nominal)
      "Discharge air temperature sensor"
      annotation (Placement(transformation(extent={{240,-20},{260,0}})));

    Buildings.Fluid.Movers.FlowControlled_m_flow fan(redeclare package Medium = MediumA,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      m_flow_nominal=mAir_flow_nominal,
      per=fanPer,
      dp_nominal=dpAirTot_nominal + 1000) "Supply fan"
      annotation (Placement(transformation(extent={{200,-20},{220,0}})));

    replaceable Fluid.Sensors.VolumeFlowRate VAirSup_flow(redeclare package
        Medium = MediumA, m_flow_nominal=mAir_flow_nominal)
      "Discharge air volume flow rate"
      annotation (Placement(transformation(extent={{280,-20},{300,0}})));

    replaceable parameter Fluid.Movers.Data.Generic fanPer constrainedby
      Buildings.Fluid.Movers.Data.Generic
      "Record with performance data for supply fan"
      annotation (choicesAllMatching=true,
        Placement(transformation(extent={{52,60},{72,80}})));

    Fluid.FixedResistances.PressureDrop           totalRes(
      final m_flow_nominal=mAir_flow_nominal,
      final dp_nominal=dpAirTot_nominal,
      final allowFlowReversal=false,
      redeclare package Medium = MediumA)
      "Total resistance"
      annotation (Placement(transformation(extent={{156,-14},{176,6}})));

    parameter Boolean fanAddPowerToMedium=true
      "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

    replaceable Sensors.TemperatureTwoPort TAirRetSen(redeclare package Medium =
          MediumA, m_flow_nominal=mAir_flow_nominal)
      "Return air temperature sensor"
      annotation (Placement(transformation(extent={{-150,30},{-130,50}})));

    replaceable Sensors.VolumeFlowRate VAirRet_flow(redeclare package Medium =
          MediumA, m_flow_nominal=mAir_flow_nominal) "Return air volume flowrate"
      annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

    HeatExchangers.HeaterCooler_u hea(
      redeclare package Medium = MediumA,
      m_flow_nominal=mAir_flow_nominal,
      dp_nominal=0,
      Q_flow_nominal=QHeaCoi_flow_nominal) if not has_heatingCoilHHW
      "Electric heating coil"
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  equation
    connect(uOA, eco.y) annotation (Line(points={{-380,120},{-170,120},{-170,2}},
                        color={0,0,127}));

    connect(weaBus, out.weaBus) annotation (Line(
        points={{-320,-20},{-300,-20},{-300,-19.8},{-280,-19.8}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(VAirOut_flow.port_b, TAirOutSen.port_a)
      annotation (Line(points={{-220,0},{-210,0}}, color={0,127,255}));

    connect(TAirOutSen.port_b, eco.port_Out)
      annotation (Line(points={{-190,0},{-180,0},{-180,-4}}, color={0,127,255}));

    connect(out.ports[1], VAirOut_flow.port_a) annotation (Line(points={{-260,-18},
            {-252,-18},{-252,0},{-240,0}}, color={0,127,255}));

    connect(VAirExh_flow.port_b, TAirExhSen.port_a)
      annotation (Line(points={{-220,-40},{-210,-40}}, color={0,127,255}));

    connect(TAirExhSen.port_b, eco.port_Exh) annotation (Line(points={{-190,-40},{
            -180,-40},{-180,-16}}, color={0,127,255}));

    connect(VAirExh_flow.port_a, out.ports[2]) annotation (Line(points={{-240,-40},
            {-252,-40},{-252,-22},{-260,-22}}, color={0,127,255}));

    connect(TAirMixSen.port_b, VAirMix_flow.port_a)
      annotation (Line(points={{-120,-10},{-110,-10}}, color={0,127,255}));

    connect(eco.port_Sup, TAirMixSen.port_a) annotation (Line(points={{-160,-4},{-140,
            -4},{-140,-10}}, color={0,127,255}));

    connect(valHotWat.port_b, heaCoiHHW.port_b1) annotation (Line(points={{-36,-64},
            {-36,-56},{-20,-56}}, color={0,127,255}));

    connect(VHotWat_flow.port_b, heaCoiHHW.port_a1)
      annotation (Line(points={{4,-74},{4,-56},{0,-56}}, color={0,127,255}));

    connect(THotWatRetSen.port_a, valHotWat.port_a)
      annotation (Line(points={{-36,-94},{-36,-84}}, color={0,127,255}));

    connect(THotWatSupSen.port_b, VHotWat_flow.port_a)
      annotation (Line(points={{4,-104},{4,-94}}, color={0,127,255}));

    connect(VAirMix_flow.port_b, heaCoiHHW.port_a2) annotation (Line(points={{-90,
            -10},{-40,-10},{-40,-44},{-20,-44}}, color={0,127,255}));

    connect(heaCoiHHW.port_b2, TAirHeaSen.port_a) annotation (Line(points={{0,-44},
            {20,-44},{20,-10},{30,-10}}, color={0,127,255}));

    connect(uHea, valHotWat.y) annotation (Line(points={{-380,-140},{-60,-140},{-60,
            -74},{-48,-74}}, color={0,0,127}));

    connect(port_HHW_inlet, THotWatSupSen.port_a)
      annotation (Line(points={{4,-180},{4,-124}}, color={0,127,255}));

    connect(port_HHW_outlet, THotWatRetSen.port_b)
      annotation (Line(points={{-36,-180},{-36,-114}}, color={0,127,255}));

    connect(TChiWatRetSen.port_a, valChiWat.port_a)
      annotation (Line(points={{104,-54},{104,-44}}, color={0,127,255}));

    connect(valChiWat.port_b, cooCoiCHW.port_b1) annotation (Line(points={{104,-24},
            {104,-16},{120,-16}}, color={0,127,255}));

    connect(VChiWat_flow.port_b, cooCoiCHW.port_a1) annotation (Line(points={{144,
            -34},{144,-16},{140,-16}}, color={0,127,255}));

    connect(TChiWatSupSen.port_b, VChiWat_flow.port_a)
      annotation (Line(points={{144,-64},{144,-54}}, color={0,127,255}));

    connect(TAirHeaSen.port_b, cooCoiCHW.port_a2) annotation (Line(points={{50,-10},
            {80,-10},{80,-4},{120,-4}}, color={0,127,255}));

    connect(port_CCW_outlet, TChiWatRetSen.port_b)
      annotation (Line(points={{104,-180},{104,-74}}, color={0,127,255}));

    connect(TChiWatSupSen.port_a, port_CCW_inlet)
      annotation (Line(points={{144,-84},{144,-180}}, color={0,127,255}));

    connect(fan.port_b, TAirSupSen.port_a)
      annotation (Line(points={{220,-10},{240,-10}}, color={0,127,255}));

    connect(uCoo, valChiWat.y) annotation (Line(points={{-380,-80},{-80,-80},{-80,
            -34},{92,-34}}, color={0,0,127}));

    connect(TAirSupSen.T, TSupAir)
      annotation (Line(points={{250,1},{250,120},{380,120}}, color={0,0,127}));

    connect(TAirSupSen.port_b, VAirSup_flow.port_a)
      annotation (Line(points={{260,-10},{280,-10}}, color={0,127,255}));

    connect(VAirSup_flow.port_b, port_supply) annotation (Line(points={{300,-10},
            {320,-10},{320,-40},{360,-40}},
                                         color={0,127,255}));

    connect(VAirSup_flow.V_flow, VSupAir_flow)
      annotation (Line(points={{290,1},{290,80},{380,80}},   color={0,0,127}));

    connect(cooCoiCHW.port_b2, totalRes.port_a)
      annotation (Line(points={{140,-4},{156,-4}}, color={0,127,255}));

    connect(totalRes.port_b, fan.port_a) annotation (Line(points={{176,-4},{180,-4},
            {180,-10},{200,-10}}, color={0,127,255}));

    connect(TAirRetSen.port_b, VAirRet_flow.port_a)
      annotation (Line(points={{-130,40},{-120,40}}, color={0,127,255}));

    connect(VAirRet_flow.port_b, eco.port_Ret) annotation (Line(points={{-100,40},
            {-88,40},{-88,14},{-150,14},{-150,-16},{-160,-16}}, color={0,127,255}));

    connect(TAirRetSen.port_a, port_return) annotation (Line(points={{-150,40},{-160,
            40},{-160,60},{-60,60},{-60,40},{360,40}}, color={0,127,255}));

    connect(uFan, fan.m_flow_in)
      annotation (Line(points={{-380,80},{210,80},{210,2}}, color={0,0,127}));
    connect(VAirMix_flow.port_b, hea.port_a) annotation (Line(points={{-90,-10},{-40,
            -10},{-40,10},{-20,10}}, color={0,127,255}));
    connect(hea.port_b, TAirHeaSen.port_a) annotation (Line(points={{0,10},{20,10},
            {20,-10},{30,-10}}, color={0,127,255}));
    connect(uHea, hea.u) annotation (Line(points={{-380,-140},{-60,-140},{-60,16},
            {-22,16}}, color={0,0,127}));
    annotation (defaultComponentName = "fanCoiUni",
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,140}},
            textString="%name",
            textColor={0,0,255})}),                                Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-360,-180},{360,
              140}})));
  end FanCoilUnit;

  package Controls "Package with FCU control modules"
    block Controller_VariableFan_ConstantWaterFlowrate

      parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        "Type of controller" annotation (Dialog(group="Cooling mode"));
      parameter Real kCoo=1 "Gain of controller"
        annotation(Dialog(group="Cooling mode"));
      parameter Real TiCoo=0.5 "Time constant of integrator block"
        annotation(Dialog(group="Cooling mode",
          enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
          controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
      parameter Real TdCoo=0.1 "Time constant of derivative block"
        annotation(Dialog(group="Cooling mode",
          enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

      parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        "Type of controller" annotation (Dialog(group="Heating mode"));

      parameter Real kHea=1 "Gain of controller"
        annotation(Dialog(group="Heating mode"));
      parameter Real TiHea=0.5 "Time constant of integrator block"
        annotation(Dialog(group="Heating mode",
          enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
          controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
      parameter Real TdHea=0.1 "Time constant of derivative block"
        annotation(Dialog(group="Heating mode",
          enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

      parameter Real dTHys(
        final unit="K",
        displayUnit="K",
        final quantity="TemperatureDifference") = 0.2
        "Temperature difference used for enabling coooling and heating mode"
        annotation(Dialog(tab="Advanced"));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon "Measured zone temperature"
        annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
            iconTransformation(extent={{-140,20},{-100,60}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet
        "Zone cooling temperature setpoint"
        annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
            iconTransformation(extent={{-140,-20},{-100,20}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet
        "Zone heating temperature setpoint"
        annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
            iconTransformation(extent={{-140,-60},{-100,-20}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo "Cooling signal"
        annotation (Placement(transformation(extent={{100,40},{140,80}}),
            iconTransformation(extent={{100,40},{140,80}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea "Heating signal"
        annotation (Placement(transformation(extent={{100,0},{140,40}}),
            iconTransformation(extent={{100,0},{140,40}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe "Fan speed signal"
                                                               annotation (Placement(
            transformation(extent={{100,-50},{140,-10}}),
                                                        iconTransformation(extent={
                {100,-40},{140,0}})));

      Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan "Fan enable signal"
                                                               annotation (Placement(
            transformation(extent={{100,-100},{140,-60}}),iconTransformation(extent=
               {{100,-80},{140,-40}})));

      Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=-dTHys,
                                                                       uHigh=0)
        "Enable cooling when zone temperature is higher than cooling setpoint"
        annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

      Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
        "Find difference between zone temperature and cooling setpoint"
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

      Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
        "Boolean to Real conversion"
        annotation (Placement(transformation(extent={{0,60},{20,80}})));

      Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
        "Find difference between zone temperature and heating setpoint"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

      Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(uLow=-dTHys,
                                                                       uHigh=0)
        "Enable heating when zone temperature is lower than heating setpoint"
        annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

      Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
        "Boolean to Real conversion"
        annotation (Placement(transformation(extent={{0,10},{20,30}})));

      Buildings.Controls.OBC.CDL.Logical.Or or2
        "Enable fan in heating mode and cooling mode"
        annotation (Placement(transformation(extent={{60,-90},{80,-70}})));

      Buildings.Controls.OBC.CDL.Continuous.PID conPID(
        controllerType=controllerTypeCoo,
        k=kCoo,
        Ti=TiCoo,
        Td=TdCoo,                                      reverseActing=false)
        "PI controller for fan speed in cooling mode"
        annotation (Placement(transformation(extent={{0,-20},{20,0}})));

      Buildings.Controls.OBC.CDL.Continuous.PID conPID1(
        controllerType=controllerTypeHea,
        k=kHea,
        Ti=TiHea,
        Td=TdHea,                                       reverseActing=false)
        "PI controller for fan speed in heating mode"
        annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
        "Constant zero signal"
        annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

      Buildings.Controls.OBC.CDL.Continuous.Add add3
        "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
        annotation (Placement(transformation(extent={{30,-40},{50,-20}})));

    equation
      connect(TZon,sub2. u1) annotation (Line(points={{-120,60},{-94,60},{-94,76},{
              -82,76}}, color={0,0,127}));

      connect(TCooSet,sub2. u2) annotation (Line(points={{-120,20},{-90,20},{-90,64},
              {-82,64}}, color={0,0,127}));

      connect(sub2.y, hys1.u)
        annotation (Line(points={{-58,70},{-42,70}}, color={0,0,127}));

      connect(hys1.y, booToRea.u)
        annotation (Line(points={{-18,70},{-2,70}}, color={255,0,255}));

      connect(booToRea.y, yCoo) annotation (Line(points={{22,70},{60,70},{60,60},{
              120,60}}, color={0,0,127}));

      connect(sub1.y, hys2.u)
        annotation (Line(points={{-58,20},{-42,20}}, color={0,0,127}));

      connect(hys2.y, booToRea1.u)
        annotation (Line(points={{-18,20},{-2,20}}, color={255,0,255}));

      connect(TZon,sub1. u2) annotation (Line(points={{-120,60},{-94,60},{-94,14},{
              -82,14}}, color={0,0,127}));

      connect(THeaSet,sub1. u1) annotation (Line(points={{-120,-20},{-88,-20},{-88,
              26},{-82,26}}, color={0,0,127}));

      connect(booToRea1.y, yHea)
        annotation (Line(points={{22,20},{120,20}}, color={0,0,127}));

      connect(hys1.y, or2.u1) annotation (Line(points={{-18,70},{-10,70},{-10,-80},{
              58,-80}},  color={255,0,255}));

      connect(hys2.y, or2.u2) annotation (Line(points={{-18,20},{-14,20},{-14,-88},{
              58,-88}},  color={255,0,255}));

      connect(or2.y, yFan)
        annotation (Line(points={{82,-80},{120,-80}}, color={255,0,255}));

      connect(sub2.y, conPID.u_m) annotation (Line(points={{-58,70},{-50,70},{-50,
              -26},{10,-26},{10,-22}}, color={0,0,127}));

      connect(sub1.y, conPID1.u_m) annotation (Line(points={{-58,20},{-54,20},{-54,-68},
              {10,-68},{10,-62}},      color={0,0,127}));

      connect(con.y, conPID.u_s) annotation (Line(points={{-58,-80},{-20,-80},{-20,
              -10},{-2,-10}}, color={0,0,127}));

      connect(con.y, conPID1.u_s) annotation (Line(points={{-58,-80},{-20,-80},{-20,
              -50},{-2,-50}}, color={0,0,127}));

      connect(add3.y, yFanSpe)
        annotation (Line(points={{52,-30},{120,-30}}, color={0,0,127}));

      connect(conPID.y, add3.u1) annotation (Line(points={{22,-10},{26,-10},{26,-24},
              {28,-24}}, color={0,0,127}));

      connect(conPID1.y, add3.u2) annotation (Line(points={{22,-50},{26,-50},{26,-36},
              {28,-36}},      color={0,0,127}));

      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
              preserveAspectRatio=false)));
    end Controller_VariableFan_ConstantWaterFlowrate;

    package Validation "Validation models for FCU control modules"

      extends Modelica.Icons.ExamplesPackage;

      block Controller_VariableFan_ConstantWaterFlowrate
        extends Modelica.Icons.Example;
        Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.Controller_VariableFan_ConstantWaterFlowrate
          controller_VariableFan_ConstantWaterFlowrate
          annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=25)
          annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=23)
          annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
          amplitude=2,
          freqHz=1/60,
          offset=24)
          annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

      equation
        connect(con.y, controller_VariableFan_ConstantWaterFlowrate.TCooSet)
          annotation (Line(points={{-38,20},{-30,20},{-30,0},{-10,0}}, color={0,0,
                127}));

        connect(con1.y, controller_VariableFan_ConstantWaterFlowrate.THeaSet)
          annotation (Line(points={{-38,-20},{-30,-20},{-30,-4},{-10,-4}}, color={0,
                0,127}));

        connect(sin.y, controller_VariableFan_ConstantWaterFlowrate.TZon)
          annotation (Line(points={{-58,50},{-20,50},{-20,4},{-10,4}}, color={0,0,
                127}));

        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)),
          experiment(StopTime=60, __Dymola_Algorithm="Dassl"),
          __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUsecase.mos"
            "Simulate and plot"));
      end Controller_VariableFan_ConstantWaterFlowrate;
    end Validation;
    annotation (Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Rectangle(
            lineColor={128,128,128},
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Ellipse(
            origin={10,10},
            fillColor={76,76,76},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            extent={{-80.0,-80.0},{-20.0,-20.0}}),
          Ellipse(
            origin={10,10},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            extent={{0.0,-80.0},{60.0,-20.0}}),
          Ellipse(
            origin={10,10},
            fillColor={128,128,128},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            extent={{0.0,0.0},{60.0,60.0}}),
          Ellipse(
            origin={10,10},
            lineColor={128,128,128},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{-80.0,0.0},{-20.0,60.0}})}));
  end Controls;

  package Types "Package with type definitions"
    extends Modelica.Icons.TypesPackage;

    type heatingCoil = enumeration(
        electric "Electric resistance heating coil",
        heatingHotWater "Hot-water heating coil")
        "Enumeration for the heating coil types" annotation (Documentation(info=
                                 "<html>
<p>
Enumeration for the type of heating coil used in the zone equipment.
The possible values are
</p>
<ol>
<li>
electric
</li>
<li>
heatingHotWater
</li>
</ol>
</html>",   revisions="<html>
<ul>
<li>
April 20, 2022 by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
    type capacityControl = enumeration(
        multispeedCyclingFanConstantWater "Multi-speed cycling fan with constant water flow rate",
        constantSpeedContinuousFanVariableWater "Constant speed continuous fan with variable water flow rate",
        variableSpeedFanConstantWater "Variable-speed fan with constant water flow rate",
        variableSpeedFanVariableWater "Variable-speed fan with variable water flow rate",
        multispeedFanCyclingSpeedConstantWater "Multi-speed fan with cycling between speeds and constant water flow",
        ASHRAE_90_1 "Fan speed control based on ASHRAE 90.1")
      "Enumeration for the capacity control types"
    annotation (Documentation(info="<html>
<p>
Enumeration for the type of capacity control used in the zone equipment.
The possible values are
</p>
<ol>
<li>
multispeedCyclingFanConstantWater
</li>
<li>
constantSpeedContinuousFanVariableWater
</li>
<li>
variableSpeedFanConstantWater
</li>
<li>
variableSpeedFanVariableWater
</li>
<li>
multispeedFanCyclingSpeedConstantWater
</li>
<li>
ASHRAE_90_1
</li>
</ol>
</html>",
    revisions="<html>
<ul>
<li>
April 20, 2022 by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
  annotation (Documentation(info="<html>
This package contains type definitions.
</html>"));

  end Types;

  package Validation "Validation package for zone equipment"
    extends Modelica.Icons.ExamplesPackage;

    model FanCoilUnit_openLoop

      extends Modelica.Icons.Example;

      replaceable package MediumA = Buildings.Media.Air
        constrainedby Modelica.Media.Interfaces.PartialCondensingGases "Medium model for air";

      replaceable package MediumW = Buildings.Media.Water "Medium model for water";

      Fluid.Sources.Boundary_pT sinCoo(
        redeclare package Medium = MediumW,
        T=279.15,
        nPorts=1) "Sink for chilled water"
                                          annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={40,-80})));

      Fluid.Sources.Boundary_pT sinHea(
        redeclare package Medium = MediumW,
        T=318.15,
        nPorts=1) "Sink for heating hot water"
                                          annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-40,-80})));

      Buildings.Fluid.ZoneEquipment.FanCoilUnit.FanCoilUnit fanCoiUni(
        heatingCoilType=Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.heatingCoil.heatingHotWater,
        capacityControlMethod=Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.capacityControl.multispeedCyclingFanConstantWater,
        dpAirTot_nominal(displayUnit="Pa") = 100,
        mAirOut_flow_nominal=fCUSizing.mAirOut_flow_nominal,
        redeclare package MediumA = MediumA,
        redeclare package MediumW = MediumW,
        mAir_flow_nominal=fCUSizing.mAir_flow_nominal,
        QHeaCoi_flow_nominal=13866,
        mHotWat_flow_nominal=fCUSizing.mHotWat_flow_nominal,
        UAHeaCoi_nominal=fCUSizing.UAHeaCoi_nominal,
        mChiWat_flow_nominal=fCUSizing.mChiWat_flow_nominal,
        UACooCoi_nominal=fCUSizing.UACooCoiTot_nominal,
        redeclare Data.customFCUFan fanPer)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

      Buildings.Fluid.Sources.MassFlowSource_T       souCoo(
        redeclare package Medium = MediumW,
        use_m_flow_in=true,
        use_T_in=true,
        nPorts=1) "Source for chilled water"     annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={70,-80})));

      Buildings.Fluid.Sources.MassFlowSource_T       souHea(
        redeclare package Medium = MediumW,
        use_m_flow_in=true,
        use_T_in=true,
        nPorts=1) "Source for heating hot water"
                                            annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={10,-90})));

      Buildings.Fluid.ZoneEquipment.FanCoilUnit.Validation.Data.FCUSizing
        fCUSizing "Sizing parameters for fan coil unit"
        annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

      Modelica.Blocks.Sources.CombiTimeTable datRea(
        tableOnFile=true,
        fileName=ModelicaServices.ExternalReferences.loadResource(
            "./Buildings/Resources/Data/Fluid/ZoneEquipment/FanCoilAutoSize_ConstantFlowVariableFan.dat"),
        columns=2:19,
        tableName="EnergyPlus",
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
        "Reader for \"IndirectAbsorptionChiller.idf\" EnergyPlus example results"
        annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

      Sources.Boundary_pT souAir(
        redeclare package Medium = MediumA,
        use_Xi_in=true,
        use_T_in=true,
        T=279.15,
        nPorts=1) "Source for zone air"
        annotation (Placement(transformation(extent={{0,20},{20,40}})));

      Sources.Boundary_pT sinAir(
        redeclare package Medium = MediumA,
        T=279.15,
        nPorts=1) "Sink for zone air"
        annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0.2)
        "Constant real signal of 0.2 for the outdoor air economizer"
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

      Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar[3](p=fill(273.15, 3))
        "Add 273.15 to temperature values from EPlus to convert it to Kelvin from Celsius"
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

      BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
            ModelicaServices.ExternalReferences.loadResource(
            "./Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
        "Outdoor weather data"
        annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

      Modelica.Blocks.Sources.RealExpression TSupAir(y=datRea.y[4])
        "Supply air temperature"
        annotation (Placement(transformation(extent={{20,120},{40,140}})));
      Modelica.Blocks.Sources.RealExpression mSupAir_flow(y=datRea.y[11])
        "Supply air mass flowrate"
        annotation (Placement(transformation(extent={{60,120},{80,140}})));
      Modelica.Blocks.Sources.RealExpression TRetAir(y=datRea.y[5])
        "Return air temperature"
        annotation (Placement(transformation(extent={{20,90},{40,110}})));
      Modelica.Blocks.Sources.RealExpression mRetAir_flow(y=datRea.y[6])
        "Return air mass flowrate"
        annotation (Placement(transformation(extent={{60,90},{80,110}})));
      Modelica.Blocks.Sources.RealExpression uFan(y=datRea.y[6]/fCUSizing.mAir_flow_nominal)
        "Fan control signal"
        annotation (Placement(transformation(extent={{20,60},{40,80}})));
      Modelica.Blocks.Sources.RealExpression uCoo(y=datRea.y[8]/fCUSizing.mChiWat_flow_nominal)
        "Cooling control signal"
        annotation (Placement(transformation(extent={{60,60},{80,80}})));
      Modelica.Blocks.Sources.RealExpression uHea(y=datRea.y[10]/fCUSizing.mHotWat_flow_nominal)
        "Heating control signal"
        annotation (Placement(transformation(extent={{100,60},{120,80}})));

      parameter Real ATot = 37.16
        "Area of zone";

      Results res(
        final A=ATot,
        PFan=fanCoiUni.fan.P + 0,
        PHea=fanCoiUni.heaCoiHHW.Q2_flow,
        PCooSen=fanCoiUni.cooCoiCHW.QSen2_flow,
        PCooLat=fanCoiUni.cooCoiCHW.QLat2_flow) "Results of the simulation";

      Results res_EPlus(
        final A=ATot,
        PFan=PFan.y,
        PHea=PHea.y,
        PCooSen=-PCoo.y,
        PCooLat=0);

      model Results "Model to store the results of the simulation"
        parameter Modelica.Units.SI.Area A "Floor area";
        input Modelica.Units.SI.Power PFan "Fan energy";
        input Modelica.Units.SI.Power PHea "Heating energy";
        input Modelica.Units.SI.Power PCooSen "Sensible cooling energy";
        input Modelica.Units.SI.Power PCooLat "Latent cooling energy";

        Real EFan(
          unit="J/m2",
          start=0,
          nominal=1E5,
          fixed=true) "Fan energy";
        Real EHea(
          unit="J/m2",
          start=0,
          nominal=1E5,
          fixed=true) "Heating energy";
        Real ECooSen(
          unit="J/m2",
          start=0,
          nominal=1E5,
          fixed=true) "Sensible cooling energy";
        Real ECooLat(
          unit="J/m2",
          start=0,
          nominal=1E5,
          fixed=true) "Latent cooling energy";
        Real ECoo(unit="J/m2") "Total cooling energy";
      equation

        A*der(EFan) = PFan;
        A*der(EHea) = PHea;
        A*der(ECooSen) = -PCooSen;
        A*der(ECooLat) = -PCooLat;
        ECoo = ECooSen + ECooLat;

      end Results;
      Modelica.Blocks.Sources.RealExpression PHea(y=datRea.y[1]) "Heating power"
        annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
      Modelica.Blocks.Sources.RealExpression PCoo(y=datRea.y[2]) "Cooling power"
        annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
      Modelica.Blocks.Sources.RealExpression PFan(y=datRea.y[3]) "Fan power"
        annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
      Modelica.Blocks.Sources.RealExpression PModCoo(y=-fanCoiUni.cooCoiCHW.Q2_flow)
        "Cooling power consumption in Modelica model"
        annotation (Placement(transformation(extent={{80,20},{100,40}})));
      Modelica.Blocks.Sources.RealExpression PModCooSen(y=-fanCoiUni.cooCoiCHW.QSen2_flow)
        "Sensible cooling power consumption in Modelica model"
        annotation (Placement(transformation(extent={{120,20},{140,40}})));
      Modelica.Blocks.Sources.RealExpression PModCooLat(y=-fanCoiUni.cooCoiCHW.QLat2_flow)
        "Latent cooling power consumption in Modelica model"
        annotation (Placement(transformation(extent={{80,-10},{100,10}})));
      Modelica.Blocks.Sources.RealExpression PModCooCal(y=-1000*4200*fanCoiUni.VChiWat_flow.V_flow
            *(fanCoiUni.TChiWatSupSen.T - fanCoiUni.TChiWatRetSen.T))
        "Calculated cooling power consumption in Modelica model"
        annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
      Modelica.Blocks.Sources.RealExpression PCooSen(y=datRea.y[15])
        "Sensible cooling power"
        annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
      .Buildings.Controls.OBC.CDL.Continuous.Divide div
        "Calculate mass fractions of constituents"
        annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
      .Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(p=1)
        "Add 1 to humidity ratio value to find total mass of moist air"
        annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
      .Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=1)
        "Constant real signal of 1 for holding the hot water and chilled water control valves fully open"
        annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
      Modelica.Blocks.Sources.RealExpression dPFanOut(y=datRea.y[18])
        "Measured fan outlet pressure"
        annotation (Placement(transformation(extent={{100,90},{120,110}})));
      Modelica.Blocks.Sources.RealExpression dPFanIn(y=datRea.y[17])
        "Measured fan inlet pressure"
        annotation (Placement(transformation(extent={{100,120},{120,140}})));
    equation

      connect(fanCoiUni.port_CCW_outlet, sinCoo.ports[1])
        annotation (Line(points={{2,-10},{2,-70},{40,-70}}, color={0,127,255}));

      connect(fanCoiUni.port_HHW_outlet, sinHea.ports[1]) annotation (Line(points={
              {-6,-10},{-6,-60},{-40,-60},{-40,-70}}, color={0,127,255}));

      connect(souCoo.ports[1], fanCoiUni.port_CCW_inlet) annotation (Line(points={{
              70,-70},{70,-60},{6,-60},{6,-10}}, color={0,127,255}));

      connect(souHea.ports[1], fanCoiUni.port_HHW_inlet) annotation (Line(points={{
              10,-80},{10,-74},{-2,-74},{-2,-10}}, color={0,127,255}));

      connect(souAir.ports[1], fanCoiUni.port_return) annotation (Line(points={{20,
              30},{50,30},{50,0},{10,0}}, color={0,127,255}));

      connect(sinAir.ports[1], fanCoiUni.port_supply) annotation (Line(points={{40,
              -30},{50,-30},{50,-4},{10,-4}}, color={0,127,255}));

      connect(con.y, fanCoiUni.uOA) annotation (Line(points={{-58,30},{-20,30},{-20,
              6},{-12,6}}, color={0,0,127}));

      connect(addPar[1].y, souAir.T_in) annotation (Line(points={{-58,70},{-16,70},
              {-16,34},{-2,34}}, color={0,0,127}));

      connect(addPar[2].y, souHea.T_in) annotation (Line(points={{-58,70},{-16,70},{
              -16,-120},{6,-120},{6,-102}},
                                   color={0,0,127}));

      connect(addPar[3].y, souCoo.T_in) annotation (Line(points={{-58,70},{-16,70},{
              -16,-120},{66,-120},{66,-92}},  color={0,0,127}));

      connect(weaDat.weaBus, fanCoiUni.weaBus) annotation (Line(
          points={{-60,110},{-8,110},{-8,8}},
          color={255,204,51},
          thickness=0.5));

      connect(datRea.y[5], addPar[1].u) annotation (Line(points={{-119,0},{-110,0},{
              -110,70},{-82,70}}, color={0,0,127}));
      connect(datRea.y[7], addPar[3].u) annotation (Line(points={{-119,0},{-110,0},{
              -110,70},{-82,70}}, color={0,0,127}));
      connect(datRea.y[9], addPar[2].u) annotation (Line(points={{-119,0},{-110,0},{
              -110,70},{-82,70}}, color={0,0,127}));
      connect(datRea.y[6], fanCoiUni.uFan) annotation (Line(points={{-119,0},{
              -40,0},{-40,2},{-12,2}},                color={0,0,127}));
      connect(datRea.y[16], addPar1.u) annotation (Line(points={{-119,0},{-110,0},{-110,
              -120},{-130,-120},{-130,-140},{-122,-140}}, color={0,0,127}));
      connect(datRea.y[16], div.u1) annotation (Line(points={{-119,0},{-110,0},{-110,
              -120},{-100,-120},{-100,-114},{-62,-114}}, color={0,0,127}));
      connect(addPar1.y, div.u2) annotation (Line(points={{-98,-140},{-70,-140},{-70,
              -126},{-62,-126}}, color={0,0,127}));
      connect(div.y, souAir.Xi_in[1]) annotation (Line(points={{-38,-120},{-26,-120},
              {-26,26},{-2,26}}, color={0,0,127}));
      connect(con1.y, fanCoiUni.uCoo) annotation (Line(points={{-58,-20},{-30,
              -20},{-30,-2},{-12,-2}},
                                  color={0,0,127}));
      connect(con1.y, fanCoiUni.uHea) annotation (Line(points={{-58,-20},{-30,
              -20},{-30,-6},{-12,-6}},
                                  color={0,0,127}));
      connect(datRea.y[10], souHea.m_flow_in) annotation (Line(points={{-119,0},{
              -110,0},{-110,-100},{-20,-100},{-20,-112},{2,-112},{2,-102}}, color={
              0,0,127}));
      connect(datRea.y[8], souCoo.m_flow_in) annotation (Line(points={{-119,0},{
              -110,0},{-110,-100},{-20,-100},{-20,-112},{62,-112},{62,-92}}, color=
              {0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                {100,100}})),                                        Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
        experiment(
          StopTime=86400,
          Interval=60,
          __Dymola_Algorithm="Dassl"),
        __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/FanCoilOpenLoop.mos"
          "Simulate and plot"));
    end FanCoilUnit_openLoop;

    package Data

      extends Modelica.Icons.MaterialPropertiesPackage;

      record FCUSizing "FCU sizing calculations for component parameters"

        extends Modelica.Icons.Record;

        parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal = 0.205
          "Nominal chilled water mass flow rate"
          annotation (Dialog(group="Nominal condition"));

        parameter Modelica.Units.SI.MassFlowRate mHotWat_flow_nominal = 0.137
          "Nominal hot water mass flow rate"
          annotation (Dialog(group="Nominal condition"));

        parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal = 1.225 * 0.419361
          "Nominal supply air mass flow rate"
          annotation (Dialog(group="Nominal condition"));

        parameter Modelica.Units.SI.MassFlowRate mAirOut_flow_nominal = 1.225 * 0.02832
          "Nominal outdoor air mass flow rate"
          annotation (Dialog(group="Nominal condition"));

        parameter Modelica.Units.SI.ThermodynamicTemperature TChiWatSup_nominal = 273.15 + 7.22
          "Nominal chilled water supply temperature"
          annotation (Dialog(group="Cooling coil parameters"));

        parameter Modelica.Units.SI.ThermodynamicTemperature THotWatSup_nominal = 273.15 + 82.2
          "Nominal hot water supply temperature"
          annotation (Dialog(group="Nominal condition"));

        parameter Modelica.Units.SI.ThermalConductance UAHeaCoi_nominal = 2.25*146.06
          "Thermal conductance at nominal flow, used to compute heating capacity"
          annotation (Dialog(group="Nominal condition"));

        parameter Modelica.Units.SI.Pressure pAir = 101325
          "Pressure of air";

        parameter Modelica.Units.SI.ThermodynamicTemperature TCooCoiAirIn_nominal = 273.15 + 24.46
          "Nominal cooling coil inlet air temperature"
          annotation (Dialog(group="Cooling coil parameters"));

        parameter Real humRatAirIn_nominal = 0.009379
          "Inlet air humidity ratio"
          annotation (Dialog(group="Cooling coil parameters"));

        parameter Modelica.Units.SI.ThermodynamicTemperature TCooCoiAirOut_nominal = 273.15 + 7.22
          "Nominal cooling coil inlet air temperature"
          annotation (Dialog(group="Cooling coil parameters"));

        parameter Real humRatAirOut_nominal = 0.009
          "Inlet air humidity ratio"
          annotation (Dialog(group="Cooling coil parameters"));

      // protected
        parameter Modelica.Units.SI.SpecificEnthalpy hAirIn_nominal = sum(Modelica.Media.Air.MoistAir.h_pTX(pAir, TCooCoiAirIn_nominal, [humRatAirIn_nominal/(1+humRatAirIn_nominal), 1/(1+humRatAirIn_nominal)]))
          "Specific enthalpy of inlet air";

        parameter Modelica.Units.SI.SpecificEnthalpy hAirOut_nominal = sum(Modelica.Media.Air.MoistAir.h_pTX(pAir, TCooCoiAirOut_nominal, [humRatAirOut_nominal/(1+humRatAirOut_nominal), 1/(1+humRatAirOut_nominal)]))
          "Specific enthalpy of inlet air";

        parameter Modelica.Units.SI.Power qCooCoi_nominal = mAir_flow_nominal * (hAirIn_nominal - hAirOut_nominal)
          "Heat transferred in cooling coil";

        parameter Modelica.Media.Interfaces.PartialSimpleMedium.ThermodynamicState stateChiWatIn_nominal = Modelica.Media.Water.ConstantPropertyLiquidWater.setState_pTX(pAir, TChiWatSup_nominal)
          "Thermodynamic state for chilled water at coil inlet";

        parameter Modelica.Units.SI.SpecificEnthalpy hChiWatIn_nominal = Modelica.Media.Water.ConstantPropertyLiquidWater.specificEnthalpy(stateChiWatIn_nominal)
          "Chilled water inlet specific enthalpy";

        parameter Modelica.Units.SI.SpecificEnthalpy hChiWatOut_nominal = (mChiWat_flow_nominal * hChiWatIn_nominal + qCooCoi_nominal)/mChiWat_flow_nominal
          "Chilled water outlet specific enthalpy";

        parameter Real delH_lmd = -((hAirIn_nominal - hChiWatOut_nominal) - (hAirOut_nominal - hChiWatIn_nominal)/log(((hAirIn_nominal - hChiWatOut_nominal)/(hAirOut_nominal - hChiWatIn_nominal))))
          "Log mean enthalpy difference";

        parameter Modelica.Units.SI.SpecificHeatCapacity cp_air = 1000;

        parameter Modelica.Units.SI.ThermalConductance UACooCoiExt_nominal = cp_air * qCooCoi_nominal/delH_lmd;

        parameter Modelica.Units.SI.ThermalConductance UACooCoiTot_nominal = 2.7*1/(1/UACooCoiExt_nominal + 1/(3.3*UACooCoiExt_nominal));

        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)));

      end FCUSizing;

      record customFCUFan "Fan data for the FCU validation model"
        extends Movers.Data.Generic(
          speed_rpm_nominal=2900,
          use_powerCharacteristic=true,
          power(V_flow={0,0.041936,0.083872,0.125808,0.167744,0.209681,0.251617,
                0.293553,0.335489,0.377425,0.419361}, P={0,3.314,4.313,5.403,6.775,
                8.619,11.125,14.484,18.886,24.521,31.581}),
          pressure(V_flow={0.041936,0.083872,0.125808,0.167744,0.209681,0.251617,
                0.293553,0.335489,0.377425,0.419361}, dp=0.001*{7500,1875,833.33,468.75,300,208.33,153.06,117.1875, 92.59, 75}),
          motorCooledByFluid=true);
        annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="per",
      Documentation(info="<html>
<p>Data from:<a href=\"http://productfinder.wilo.com/com/en/c0000002200012eb000020023/_0000004f0003f94e0001003a/product.html\"> http://productfinder.wilo.com/com/en/c0000002200012eb000020023/_0000004f0003f94e0001003a/product.html</a></p>
<p>See <a href=\"modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6</a>for more information about how the data is derived.</p>
</html>",         revisions="<html>
<ul>
<li>
May 28, 2017, by Iago Cupeiro:
<br/>
Initial version
</li>
</ul>
</html>"));
      end customFCUFan;
    end Data;
  end Validation;
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Ellipse(
          origin={10,10},
          fillColor={76,76,76},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-80.0,-80.0},{-20.0,-20.0}}),
        Ellipse(
          origin={10,10},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,-80.0},{60.0,-20.0}}),
        Ellipse(
          origin={10,10},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={10,10},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80.0,0.0},{-20.0,60.0}})}));
end FanCoilUnit;
