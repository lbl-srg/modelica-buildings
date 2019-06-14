within Buildings.Fluid.HeatPumps.Examples;
model EquationFitWatertoWater_OneRoomRadiator

  extends Modelica.Icons.Example;

package MediumA = Buildings.Media.Air
      "Medium model for air";

package MediumW = Buildings.Media.Water
       "Medium model for water";

  // Internal Loads

 parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 4000;

  Modelica.Blocks.Sources.CombiTimeTable timTab(
  extrapolation= Modelica.Blocks.Types.Extrapolation.Periodic,
  smoothness= Modelica.Blocks.Types.Smoothness.ConstantSegments,
    table=[-6*3600,0; 8*3600,QRooInt_flow; 18*3600,0])
                          "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-8,78},{4,90}})));

 parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";

  // Heat Pump
  EquationFitWaterToWater                    heaPum(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    per=Data.WatertoWater_HeatPump.Trane_Axiom_EXW240())
    annotation (Placement(transformation(extent={{44,-38},{64,-18}})));

 parameter Modelica.SIunits.Power Q_flow_nominal = 70000
    "Nominal heating power (positive for heating)"
    annotation(Dialog(group="Nominal condition"));
 parameter Modelica.SIunits.Temperature T_a_nomina
    "Water inlet temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
 parameter Modelica.SIunits.Temperature T_b_nominal
    "Water outlet temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
 parameter Modelica.SIunits.Temperature TAir_nomina
    "Air temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
 parameter Modelica.SIunits.Temperature TRadSup_nominal=46+273.15
   "Radiator nominal Supply temperature";
 parameter Modelica.SIunits.Temperature TRadRet_nominal=38+273.15
  "Radiator nominal Return temperature";

 // parameter Modelica.SIunits.MassFlowRate mHeaPum_flow_nominal "Nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal =  per_Trane.mCon_flow_nominal
  "Nominal Condenser flow rate";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal =  per_Trane.mEva_flow_nominal
 "Nominal Evaporator flow rate";

//Room description

  HeatTransfer.Sources.PrescribedTemperature Tout "outside Drybulb tempearture"
   annotation (Placement(transformation(extent={{-32,58},{-20,70}})));

  HeatTransfer.Sources.PrescribedHeatFlow preHea
    annotation (Placement(transformation(extent={{16,74},{36,94}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCap(C=1000)
    annotation (Placement(transformation(extent={{48,96},{64,112}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/
        40)
    annotation (Placement(transformation(extent={{30,56},{46,72}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
  energyDynamics= Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{112,42},{130,58}})));

  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*1.2/3600  "Nominal mass flow rate";

  //radiator parameters

  HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
 energyDynamics= Modelica.Fluid.Types.Dynamics.FixedInitial,
   m_flow_nominal = per_Trane.mCon_flow_nominal,
   Q_flow_nominal = Q_flow_nominal,
   T_a_nominal = TRadSup_nominal,
   T_b_nominal = TRadRet_nominal,
   T_start = TRadSup_nominal,
    TAir_nominal=293.15,
    TRad_nominal=293.15)         "Radiator"
   annotation (Placement(transformation(extent={{62,-2},{42,18}})));

Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor rooSen
    annotation (Placement(transformation(extent={{14,40},{4,50}})));

 //-------------------------------------------------------------------------------------------
//Weather Data

BoundaryConditions.WeatherData.ReaderTMY3
weaDat(filNam=ModelicaServices.ExternalReferences.loadResource(
"modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-134,88},{-114,108}})));

Sensors.TemperatureTwoPort temRet(redeclare package Medium = MediumW,
      m_flow_nominal=per_Trane.mCon_flow_nominal) "Heating water return temperature"
    annotation (Placement(transformation(extent={{26,14},{12,30}})));

Sensors.TemperatureTwoPort temSup(redeclare package Medium = MediumW,
      m_flow_nominal=per_Trane.mCon_flow_nominal) " Heating water supply temperature"
    annotation (Placement(transformation(
        extent={{-8,-9},{8,9}},
        rotation=90,
        origin={71,-8})));

 BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(transformation(extent={{-92,50},{-68,
            78}}), iconTransformation(extent={{-190,-58},{-170,-38}})));

//-------------------------------------------------------------------------------------------------------------------------------

//Chilled water source and sink

 Sources.FixedBoundary cHW_Supply(nPorts=1,
   redeclare package Medium = MediumW,
   use_T= true,
   T= 273.15+12)
    annotation (Placement(transformation(extent={{110,-92},{96,-78}})));

  Sources.FixedBoundary cHw_Return(nPorts=1,
     redeclare package Medium =MediumW,
     use_T= true,
     T= 273.15+6)
        annotation (Placement(transformation(extent={{8,-108},{22,-94}})));

  //Condenser Pump- heating water

  Movers.FlowControlled_m_flow ConPum(
 redeclare package Medium = MediumW,
    redeclare Movers.Data.Generic per,
 y_start=1,
 nominalValuesDefineDefaultPressureCurve=true,
    m_flow_start=1,
 m_flow_nominal= per_Trane.mCon_flow_nominal,
 energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
   annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-12,0})));

//Evaporator pump-Chilled water
  Movers.FlowControlled_m_flow EvaPum(
  redeclare package Medium=MediumW,
    redeclare Movers.Data.Generic per,
  y_start=1,
  nominalValuesDefineDefaultPressureCurve=true,
 m_flow_start=0.85 "mass folw rate instilaize value",
 m_flow_nominal= per_Trane.mEva_flow_nominal,
 energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
   annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={24,-70})));

  // Control of the heatig system

  Modelica.Blocks.Logical.Hysteresis hyst_RoomTem(uLow=19 + 273.15, uHigh=21 +
        273.15)
    annotation (Placement(transformation(extent={{-34,38},{-48,52}})));

  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-124,-78},{-110,-64}})));

  Modelica.Blocks.Math.BooleanToReal evaPum_Signal(
    realTrue=1.89,
    realFalse=0,
    y(start=0))
    annotation (Placement(transformation(extent={{-88,-104},{-78,-94}})));

  // Condenser pump control
  Modelica.Blocks.Logical.Hysteresis hyst_ConPum(
    uLow=0.005*mCon_flow_nominal,
    uHigh=0.01*mCon_flow_nominal,
    pre_y_start=false)
    annotation (Placement(transformation(extent={{-52,-52},{-62,-42}})));

  // Evaporator pump control
  Modelica.Blocks.Logical.Hysteresis hyst_EvaPum(uLow=0.005*mEva_flow_nominal,
      uHigh=0.01*mEva_flow_nominal)
    annotation (Placement(transformation(extent={{-52,-82},{-62,-72}})));
  Modelica.Blocks.Logical.And and1 annotation (Placement(transformation(
        extent={{-5,5},{5,-5}},
        rotation=0,
        origin={-67,-25})));

  Modelica.Blocks.Math.BooleanToReal conPum_Signal(
    realTrue=273.15 + 46,
    realFalse=273.15 + 48,
    y(start=1))
    annotation (Placement(transformation(extent={{-88,0},{-78,10}})));

// Heat Pump Nominal Dat

  Sources.FixedBoundary expTan(redeclare package Medium = MediumW,
    T=318.15,                                                      nPorts=1)
    annotation (Placement(transformation(extent={{114,-4},{98,10}})));

equation

  connect(preHea.port, vol.heatPort)
  annotation (Line(points={{36,84},{112,84},{112,50}},
                                        color={191,0,0}));
  connect(heatCap.port, vol.heatPort)
   annotation (Line(points={{56,96},{112,96},{112,50}},
                                    color={191,0,0}));
  connect(theCon.port_b, vol.heatPort)
  annotation (Line(points={{46,64},{112,64},{112,50}},
                                        color={191,0,0}));
  connect(heaPum.port_a2, cHW_Supply.ports[1])
  annotation (Line(points={{64,-34},{80,-34},{80,-85},{96,-85}},
                                       color={0,127,255}));
  connect(cHw_Return.ports[1],EvaPum. port_a)
    annotation (Line(points={{22,-101},{24,-101},{24,-80}},
                                                          color={0,127,255}));
  connect(EvaPum.port_b, heaPum.port_b2)
    annotation (Line(points={{24,-60},{24,-34},{44,-34}}, color={0,127,255}));
  connect(evaPum_Signal.y, ConPum.m_flow_in)
  annotation (Line(points={{-77.5,-99},{-30,-99},{-30,0},{-24,0}},
                                          color={0,0,127}));
  connect(evaPum_Signal.y, EvaPum.m_flow_in) annotation (Line(points={{-77.5,-99},{-30,-99},{-30,-70},
          {12,-70}},                     color={0,0,127}));

  connect(timTab.y[1], preHea.Q_flow) annotation (Line(points={{4.6,84},{16,84}},
                                   color={0,0,127}));
  connect(heaPum.port_b1, temSup.port_a)
    annotation (Line(points={{64,-22},{71,-22},{71,-16}},
                                                    color={0,127,255}));
  connect(temSup.port_b, rad.port_a)
    annotation (Line(points={{71,0},{71,8},{62,8}},    color={0,127,255}));
  connect(ConPum.port_b, heaPum.port_a1) annotation (Line(points={{-12,-10},{16,-10},{16,-22},{44,-22}},
                          color={0,127,255}));
  connect(temRet.port_b, ConPum.port_a)
    annotation (Line(points={{12,22},{0,22},{0,10},{-12,10}},
                                               color={0,127,255}));
  connect(ConPum.m_flow_actual, hyst_ConPum.u)
    annotation (Line(points={{-17,-11},{-17,-47},{-51,-47}},
                                                        color={0,0,127}));
  connect(EvaPum.m_flow_actual, hyst_EvaPum.u) annotation (Line(points={{19,-59},{19,-50},{-44,-50},
          {-44,-77},{-51,-77}},                    color={0,0,127}));
  connect(temRet.port_a, rad.port_b)
    annotation (Line(points={{26,22},{34,22},{34,8},{42,8}},
                                               color={0,127,255}));
  connect(rad.port_a, expTan.ports[1]) annotation (Line(points={{62,8},{80,8},{80,3},{98,3}},
                             color={0,127,255}));
  connect(hyst_RoomTem.y, not1.u) annotation (Line(points={{-48.7,45},{-134,45},{-134,-71},{-125.4,-71}},
                  color={255,0,255}));
  connect(not1.y, conPum_Signal.u) annotation (Line(points={{-109.3,-71},{-98,-71},{-98,5},{-89,5}},
                 color={255,0,255}));
  connect(not1.y, evaPum_Signal.u) annotation (Line(points={{-109.3,-71},{-98,-71},{-98,-99},{-89,-99}},
                  color={255,0,255}));
  connect(and1.u1, hyst_ConPum.y) annotation (Line(points={{-73,-25},{-78,-25},{-78,-47},{-62.5,-47}},
                 color={255,0,255}));
  connect(and1.u2, hyst_EvaPum.y) annotation (Line(points={{-73,-21},{-82,-21},{-82,-78},{-62.5,-78},
          {-62.5,-77}},         color={255,0,255}));
  connect(rooSen.port, vol.heatPort)
    annotation (Line(points={{14,45},{112,45},{112,50}},color={191,0,0}));
  connect(rad.heatPortRad, vol.heatPort)
    annotation (Line(points={{50,15.2},{50,45},{112,45},{112,50}},  color={191,0,0}));
  connect(rad.heatPortCon, vol.heatPort)
    annotation (Line(points={{54,15.2},{54,45},{112,45},{112,50}},color={191,0,0}));
  connect(rooSen.T, hyst_RoomTem.u)
    annotation (Line(points={{4,45},{-32.6,45}},                     color={0,0,127}));

  connect(weaDat.weaBus, weaBus.TDryBul) annotation (Line(
      points={{-114,98},{-98,98},{-98,64},{-80,64}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, Tout.T) annotation (Line(
      points={{-80,64},{-33.2,64}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(Tout.port, theCon.port_a) annotation (Line(points={{-20,64},{30,64}}, color={191,0,0}));

  annotation (Documentation(info="<html>
<p>
Example that simulates one room equipped with a radiator. Hot water is produced
by a <i>7</i> kW nominal capacity heat pump. The source side water temperature to the
heat pump is constant at <i>12</i>&deg;C.
</p>
<p>
The heat pump is turned on when the room temperature falls below
<i>19</i>&deg;C and turned
off when the room temperature rises above <i>21</i>&deg;C.
</p>
</html>", revisions="<html>
<ul>
<li>
March 3, 2017, by Michael Wetter:<br/>
Changed mass flow test to use a hysteresis as a threshold test
can cause chattering.
</li>
<li>
January 27, 2017, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),  Placement(transformation(extent={{56,-36},{76,-16}})),
             Placement(transformation(extent={{-100,-98},{-80,-78}})),
                Placement(transformation(extent={{-28,72},{-14,86}})),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
       Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})));
end EquationFitWatertoWater_OneRoomRadiator;
