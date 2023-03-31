within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump;
model PackagedTerminalHeatPumpIBPSA
    extends Buildings.Fluid.ZoneEquipment.BaseClasses.EquipmentInterfaces(
    final cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.eleDX,
    final heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.heaPum,
    oaPorTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaMix,
    redeclare final package MediumHW =Modelica.Media.Interfaces.PartialMedium,
    redeclare final package MediumCHW =Modelica.Media.Interfaces.PartialMedium,
    out(nPorts=3));

  parameter Modelica.Units.SI.HeatFlowRate QSup_flow_nominal
    "Heat flow rate for supplementary heating";
  parameter Modelica.Units.SI.PressureDifference dpAir_nominal
    "Total pressure difference across supply and return ports in airloop"
    annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.PressureDifference dpCooDX_nominal
    "Pressure drop for DX cooling coil at m_flow_nominal";
  parameter Modelica.Units.SI.PressureDifference dpHeaDX_nominal
    "Pressure drop for DX heating coil at m_flow_nominal";
  parameter Modelica.Units.SI.PressureDifference dpSupHea_nominal
    "Pressure drop for supplementary heating coil at m_flow_nominal";
  parameter Real looHys(unit="1")=0.01
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Nominal heat flow rate of the device";
  parameter Modelica.Units.SI.MassFlowRate mOut_flow_nominal "Heat pump nominal mass flow rate";
  replaceable parameter Buildings.Fluid.Movers.Data.Generic fanPer
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{84,100},{104,120}})),
      Dialog(group="Fan parameters"));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCooCoi(nSta=1)
    "DX cooling coil data"
    annotation (Placement(transformation(extent={{2,100},{22,120}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mAir_flow_nominal,
    final per=fanPer,
    final dp_nominal=dpAir_nominal) "Supply fan"
    annotation (Placement(transformation(extent={{106,-10},{126,10}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u SupHeaCoi(
    redeclare final package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    show_T=true,
    dp_nominal=dpSupHea_nominal,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=datCooCoi.sta[1].nomVal.TEvaIn_nominal,
    Q_flow_nominal=QSup_flow_nominal)
    "Supplementary single speed DX heating coil"
    annotation (Placement(transformation(extent={{184,-10},{204,10}})));

  Modelica.Blocks.Math.Gain gai(
    final k=mAir_flow_nominal)
    "Find mass flowrate value by multiplying nominal flowrate by normalized fan speed signal"
    annotation (Placement(transformation(extent={{-22,70},{-2,90}})));

  Modelica.Blocks.Math.Gain gaiFanNor(
    final k=1/mAir_flow_nominal)
    "Find normalized fan signal by dividing actual fan mass flowrate by nominal flowrate"
    annotation (Placement(transformation(extent={{300,100},{320,120}})));

  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{-260,-50},{-240,-30}})));
  Sensors.TemperatureTwoPort TAirCooCoi(redeclare final package Medium =
        MediumA, final m_flow_nominal=mAir_flow_nominal)
    "Cooling coil outlet air temperature sensor"
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  replaceable parameter HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datHeaCoi(nSta=1)
    "DX heating coil data"
    annotation (Placement(transformation(extent={{42,100},{62,120}})));
  Modelica.Blocks.Interfaces.RealInput uSupHea(final unit="1") if has_hea
    "Supplementary heating loop signal" annotation (Placement(transformation(
          extent={{-400,-30},{-360,10}}), iconTransformation(extent={{-240,-160},
            {-200,-120}})));
  IBPSA.Fluid.HeatPumps.ModularReversible
                    modRevHeaPump(
    redeclare package MediumCon = MediumA,
    redeclare package MediumEva = MediumA,
    QUse_flow_nominal=Q_flow_nominal,
    y_nominal=1,
    redeclare model VapourCompressionCycleInertia =
        IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.NoInertia,
    use_internalSafetyControl=false,
    TCon_nominal=(273.15 + 25) + 273.15,
    dTCon_nominal=10,
    mCon_flow_nominal=mAir_flow_nominal,
    dpCon_nominal(displayUnit="Pa") = 2000,
    use_conCap=false,
    CCon=3000,
    GConOut=100,
    GConIns=1000,
    TEva_nominal=(273.15 + 10) + 273.15,
    dTEva_nominal=5,
    mEva_flow_nominal=mOut_flow_nominal,
    dpEva_nominal(displayUnit="Pa") = 2000,
    use_evaCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare model BlackBoxHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.BlackBoxData.ConstantQualityGrade (
        redeclare IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.NoFrosting
          iceFacCal,
        useAirForCon=false,
        useAirForEva=false,
        TAppCon_nominal=0,
        TAppEva_nominal=0),
    redeclare model BlackBoxHeatPumpCooling =
        IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2D (redeclare
          IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.NoFrosting iceFacCal,
          datTab=
            IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2DData.EN14511.Vitocal200AWO201()),
    redeclare
      IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.DefaultSafetyControl
      safCtrlPar(use_antFre=true, TAntFre=275.15))
    "Modular reversible heat pump"
    annotation (Placement(transformation(extent={{-20,6},{-40,-18}})));

  Movers.FlowControlled_m_flow FanODU(
    redeclare final package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mOut_flow_nominal,
    final per=fanPer,
    final dp_nominal=dpAir_nominal) "ODU fan"
    annotation (Placement(transformation(extent={{-38,-52},{-18,-32}})));
  Modelica.Blocks.Sources.RealExpression mOut_flow(y=mOut_flow_nominal)
    annotation (Placement(transformation(extent={{-108,-44},{-88,-24}})));
  IBPSA.Fluid.Sources.Boundary_pT sinOut(
    redeclare package Medium = MediumA,
    T=283.15,
    nPorts=1) "Fluid sink on source side"
    annotation (Placement(transformation(extent={{-72,-22},{-52,-2}})));
  Modelica.Blocks.Sources.RealExpression sinSpe(y=1)
    annotation (Placement(transformation(extent={{-26,6},{-6,26}})));
equation
  connect(gai.y, fan.m_flow_in)
    annotation (Line(points={{-1,80},{116,80},{116,12}},
                                                       color={0,0,127}));
  connect(fan.m_flow_actual, gaiFanNor.u) annotation (Line(points={{127,5},{142,
          5},{142,80},{214,80},{214,110},{298,110}},
                                        color={0,0,127}));
  connect(uFan, gai.u)
    annotation (Line(points={{-380,120},{-202,120},{-202,80},{-24,80}},
                                                  color={0,0,127}));
  connect(gaiFanNor.y, yFan_actual)
    annotation (Line(points={{321,110},{370,110}}, color={0,0,127}));
  connect(fan.port_b, SupHeaCoi.port_a)
    annotation (Line(points={{126,0},{184,0}}, color={0,127,255}));
  connect(SupHeaCoi.port_b, TAirLvg.port_a)
    annotation (Line(points={{204,0},{240,0}}, color={0,127,255}));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-330,30},{-310,30},{-310,-40},{-262,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(uSupHea, SupHeaCoi.u) annotation (Line(points={{-380,-10},{-338,-10},{
          -338,-54},{160,-54},{160,6},{182,6}}, color={0,0,127}));
  connect(TAirCooCoi.port_b, fan.port_a)
    annotation (Line(points={{52,0},{106,0}}, color={0,127,255}));
  connect(vAirMix.port_b, modRevHeaPump.port_a2)
    annotation (Line(points={{-80,0},{-40,0}}, color={0,127,255}));
  connect(modRevHeaPump.port_b2, TAirCooCoi.port_a)
    annotation (Line(points={{-20,0},{32,0}}, color={0,127,255}));
  connect(uHeaEna, modRevHeaPump.revSet) annotation (Line(points={{-380,-160},{
          -62,-160},{-62,-26},{-6,-26},{-6,3},{-18.4,3}},
                                                      color={255,0,255}));
  connect(FanODU.port_b, modRevHeaPump.port_a1) annotation (Line(points={{-18,-42},
          {10,-42},{10,-12},{-20,-12}}, color={0,127,255}));
  connect(out.ports[3], FanODU.port_a) annotation (Line(points={{-280,30},{-270,
          30},{-270,-16},{-214,-16},{-214,-42},{-38,-42}}, color={0,127,255}));
  connect(mOut_flow.y, FanODU.m_flow_in) annotation (Line(points={{-87,-34},{-60,
          -34},{-60,-24},{-28,-24},{-28,-30}}, color={0,0,127}));
  connect(sinOut.ports[1], modRevHeaPump.port_b1) annotation (Line(points={{-52,-12},
          {-40,-12}},                          color={0,127,255}));
  connect(sinSpe.y, modRevHeaPump.ySet) annotation (Line(points={{-5,16},{10,16},
          {10,-8},{-18.4,-8}}, color={0,0,127}));
  annotation (defaultComponentName = "winAC",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}), graphics={Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,200},{100,240}},
          textString="%name",
          textColor={0,0,255})}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end PackagedTerminalHeatPumpIBPSA;
