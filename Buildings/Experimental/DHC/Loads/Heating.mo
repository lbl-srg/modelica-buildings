within Buildings.Experimental.DHC.Loads;
package Heating "Package of models for district heating loads"
  extends Modelica.Icons.Package;
  package DHW "Package of models for DHW loads served by district heating"
     extends Modelica.Icons.Package;
    package BaseClasses
      "Package with base classes that are used by multiple models"
      extends Modelica.Icons.BasesPackage;

      model DomesticWaterFixture
        "Thermostatic mixing valve and hot water fixture with representative annual load profile"
        replaceable package Medium = Buildings.Media.Water "Medium model for water";
        parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal
          "Design domestic hot water supply flow rate of system";
        parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") "Pressure difference";
        parameter Modelica.Units.SI.Temperature TDhwSet=273.15 + 40
          "Temperature setpoint of tempered doemstic hot water outlet";
        parameter Real k(min=0) = 2 "Gain of controller";
        parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 15 "Time constant of Integrator block" annotation (Dialog(enable=
                controllerType == Modelica.Blocks.Types.SimpleController.PI or
                controllerType == Modelica.Blocks.Types.SimpleController.PID));
        Modelica.Fluid.Interfaces.FluidPort_a port_dhw(redeclare package Medium =
              Medium) "Domestic hot water supply port" annotation (
            Placement(transformation(extent={{-210,30},{-190,50}}),
              iconTransformation(extent={{-210,30},{-190,50}})));
        Buildings.Fluid.Sources.MassFlowSource_T sinDhw(
          redeclare package Medium = Medium,
          use_m_flow_in=true,
          nPorts=1) "Sink for domestic hot water supply"
          annotation (Placement(transformation(extent={{-30,-30},{-50,-10}})));
        Modelica.Blocks.Math.Gain gaiDhw(k=-mDhw_flow_nominal) "Gain for multiplying domestic hot water schedule"
          annotation (Placement(transformation(extent={{72,10},{52,30}})));
        Modelica.Blocks.Sources.CombiTimeTable schDhw(tableOnFile=true,
        table=[0,0.1; 3600*1,1e-5; 3600*2,1e-5; 3600*3,1e-5; 3600*4,1e-5; 3600*5,0.3;
              3600*6,0.9; 3600*7,1; 3600*8,1; 3600*9,0.8; 3600*10,0.8; 3600*11,0.6;
              3600*12,0.5; 3600*13,0.5; 3600*14,0.4; 3600*15,0.5; 3600*16,0.6; 3600*
              17,0.7; 3600*18,0.9; 3600*19,0.8; 3600*20,0.8; 3600*21,0.6; 3600*22,0.5;
              3600*23,0.3; 3600*24,0.1],
          tableName="tab1",
          fileName=Modelica.Utilities.Files.loadResource(
              "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Heating/DHW/DHW_SingleApartment.mos"),
          smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
          extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic) "Domestic hot water fraction schedule"
          annotation (Placement(transformation(extent={{130,10},{110,30}})));
        Modelica.Fluid.Interfaces.FluidPort_a port_dcw(redeclare package Medium =
              Medium) "Domestic cold water supply port" annotation (
            Placement(transformation(extent={{-210,-50},{-190,-30}}),
              iconTransformation(extent={{-210,-50},{-190,-30}})));
        DomesticWaterMixer tmv(
          redeclare package Medium = Medium,
          TSet=TDhwSet,
          mDhw_flow_nominal=mDhw_flow_nominal,
          dpValve_nominal=dpValve_nominal,
          k=k,
          Ti=Ti)                               "Ideal thermostatic mixing valve"
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
        Modelica.Blocks.Continuous.Integrator watCon(k=-1)
                                                     "Integrated hot water consumption"
          annotation (Placement(transformation(extent={{84,-50},{104,-30}})));
        Modelica.Blocks.Interfaces.RealOutput TTw "Temperature of the outlet tempered water"
          annotation (Placement(transformation(extent={{180,20},{220,60}})));
        Modelica.Blocks.Interfaces.RealOutput mDhw "Total hot water consumption"
          annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
              iconTransformation(extent={{180,-60},{220,-20}})));
      equation
        connect(gaiDhw.y, sinDhw.m_flow_in) annotation (Line(points={{51,20},{0,20},{0,
                -12},{-28,-12}},       color={0,0,127}));
        connect(schDhw.y[1], gaiDhw.u)
          annotation (Line(points={{109,20},{74,20}},    color={0,0,127}));
        connect(tmv.port_tw, sinDhw.ports[1])
          annotation (Line(points={{-90,0},{-70,0},{-70,-20},{-50,-20}},
                                                            color={0,127,255}));
        connect(tmv.port_hw, port_dhw) annotation (Line(points={{-110,6},{-150,6},{-150,
                40},{-200,40}},           color={0,127,255}));
        connect(tmv.port_cw, port_dcw) annotation (Line(points={{-110,-6},{-150,-6},{-150,
                -40},{-200,-40}},         color={0,127,255}));
        connect(tmv.TTw, TTw) annotation (Line(points={{-89,8},{-70,8},{-70,40},{200,40}},
              color={0,0,127}));
        connect(watCon.y, mDhw)
          annotation (Line(points={{105,-40},{200,-40}}, color={0,0,127}));
        connect(watCon.u, gaiDhw.y) annotation (Line(points={{82,-40},{0,-40},{
                0,20},{51,20}}, color={0,0,127}));
      annotation (Documentation(info="<html>
<p>
This is a single zone model based on the envelope of the BESTEST Case 600
building, though it has some modifications.  Supply and return air ports are
included for simulation with air-based HVAC systems.  Heating and cooling
setpoints and internal loads are time-varying according to an assumed
occupancy schedule.
</p>
<p>
This zone model utilizes schedules and constructions from
the <code>Schedules</code> and <code>Constructions</code> packages.
</p>
</html>",       revisions="<html>
<ul>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(extent={{-200,-200},{200,200}})),
          Icon(coordinateSystem(extent={{-200,-200},{200,200}})));
      end DomesticWaterFixture;

      model DomesticWaterMixer "A model for a domestic water mixer"
        replaceable package Medium = Buildings.Media.Water "Water media model";
        parameter Modelica.Units.SI.Temperature TSet = 273.15+40 "Temperature setpoint of tempered hot water outlet";
        parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal "Nominal doemstic hot water flow rate";
        parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") "Pressure difference";
        parameter Real k(min=0) = 2 "Gain of controller";
        parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 15 "Time constant of Integrator block" annotation (Dialog(enable=
                controllerType == Modelica.Blocks.Types.SimpleController.PI or
                controllerType == Modelica.Blocks.Types.SimpleController.PID));
        Modelica.Fluid.Interfaces.FluidPort_b port_tw(redeclare package Medium =
              Medium) "Port for tempered water outlet"
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));
        Buildings.Controls.Continuous.LimPID conPID(
          controllerType=Modelica.Blocks.Types.SimpleController.PI,
          k=k,
          Ti=Ti,
          reset=Buildings.Types.Reset.Parameter)
          annotation (Placement(transformation(extent={{40,40},{20,60}})));
        Buildings.Fluid.Sensors.TemperatureTwoPort senTemTw(redeclare package Medium =
              Medium, m_flow_nominal=mDhw_flow_nominal) "Tempered water temperature sensor"
          annotation (Placement(transformation(extent={{20,-10},{40,10}})));
        Modelica.Blocks.Sources.Constant conTSetCon(k=TSet) "Temperature setpoint for domestic tempered water supply to consumer"
          annotation (Placement(transformation(extent={{80,40},{60,60}})));
        Fluid.Actuators.Valves.ThreeWayLinear
                   ideValHea(redeclare package Medium = Medium, final m_flow_nominal=
              mDhw_flow_nominal,
          dpValve_nominal=dpValve_nominal)
                                 "Ideal valve" annotation (Placement(transformation(
              extent={{10,10},{-10,-10}},
              rotation=180,
              origin={0,0})));
        Modelica.Fluid.Interfaces.FluidPort_a port_hw(redeclare package Medium =
              Medium) "Port for hot water supply"
          annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
        Modelica.Fluid.Interfaces.FluidPort_a port_cw(redeclare package Medium =
              Medium) "Port for domestic cold water supply"
          annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
        Modelica.Blocks.Interfaces.RealOutput TTw "Temperature of the outlet tempered water"
          annotation (Placement(transformation(extent={{100,70},{120,90}})));
        Buildings.Fluid.Sensors.TemperatureTwoPort senTemHw(redeclare package Medium =
              Medium, m_flow_nominal=mDhw_flow_nominal) "Hot water temperature sensor"
          annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
        Buildings.Fluid.Sensors.TemperatureTwoPort senTemCw(redeclare package Medium =
              Medium, m_flow_nominal=mDhw_flow_nominal) "Cold water temperature sensor"
          annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
        Buildings.Fluid.Sensors.MassFlowRate senFloDhw(redeclare package Medium =
              Medium) "Mass flow rate of domestic hot water"
          annotation (Placement(transformation(extent={{50,-10},{70,10}})));
        Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
          annotation (Placement(transformation(extent={{54,22},{44,32}})));
      equation
        connect(conTSetCon.y, conPID.u_s)
          annotation (Line(points={{59,50},{42,50}}, color={0,0,127}));
        connect(senTemTw.T, conPID.u_m)
          annotation (Line(points={{30,11},{30,38}}, color={0,0,127}));
        connect(ideValHea.port_2, senTemTw.port_a) annotation (Line(points={{10,-6.66134e-16},
                {20,-6.66134e-16},{20,0}}, color={0,127,255}));
        connect(conPID.y, ideValHea.y) annotation (Line(points={{19,50},{8.88178e-16,50},
                {8.88178e-16,12}},color={0,0,127}));
        connect(senTemTw.T, TTw) annotation (Line(points={{30,11},{30,20},{90,20},{90,
                80},{110,80}}, color={0,0,127}));
        connect(ideValHea.port_1, senTemHw.port_b)
          annotation (Line(points={{-10,1.77636e-15},{-10,0},{-20,0}},
                                                      color={0,127,255}));
        connect(senTemHw.port_a, port_hw) annotation (Line(points={{-40,0},{-54,0},{-54,
                60},{-100,60}}, color={0,127,255}));
        connect(ideValHea.port_3, senTemCw.port_b)
          annotation (Line(points={{-1.77636e-15,-10},{-1.77636e-15,-60},{-20,-60}},
                                                              color={0,127,255}));
        connect(senTemCw.port_a, port_cw)
          annotation (Line(points={{-40,-60},{-100,-60}}, color={0,127,255}));
        connect(senTemTw.port_b, senFloDhw.port_a)
          annotation (Line(points={{40,0},{50,0}}, color={0,127,255}));
        connect(senFloDhw.port_b, port_tw)
          annotation (Line(points={{70,0},{100,0}}, color={0,127,255}));
        connect(greaterThreshold.u, senFloDhw.m_flow)
          annotation (Line(points={{55,27},{60,27},{60,11}}, color={0,0,127}));
        connect(greaterThreshold.y, conPID.trigger)
          annotation (Line(points={{43.5,27},{38,27},{38,38}}, color={255,0,255}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)));
      end DomesticWaterMixer;

      model IdealValve "Ideal three-way valve"
        extends Modelica.Blocks.Icons.Block;
        replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component"
            annotation (choicesAllMatching = true);
        parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
          "Design chilled water supply flow";
        parameter Boolean port_3_fraction = true "True for fraction of port 2 flow, False for fraction of m_flow_nominal";
        Modelica.Fluid.Interfaces.FluidPort_a port_1(redeclare package Medium =
              Medium) annotation (Placement(transformation(extent={{50,88},
                  {70,108}}), iconTransformation(extent={{50,88},{70,108}})));
        Modelica.Fluid.Interfaces.FluidPort_b port_2(redeclare package Medium =
              Medium) annotation (Placement(transformation(extent={{50,-108},
                  {70,-88}}), iconTransformation(extent={{50,-108},{70,-88}})));
        Modelica.Fluid.Interfaces.FluidPort_a port_3(redeclare package Medium =
              Medium) annotation (Placement(transformation(extent={{90,-10},
                  {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
        Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) annotation (Placement(
              transformation(extent={{-120,-10},{-100,10}}),
              iconTransformation(extent={{-120,-10},{-100,10}})));
        Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
              Medium, allowFlowReversal=false) "Mass flow rate sensor" annotation (
            Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={0,-40})));
        Buildings.Fluid.Movers.BaseClasses.IdealSource preMasFlo(
          redeclare package Medium = Medium,
          control_m_flow=true,
          control_dp=false,
          m_flow_small=m_flow_nominal*1E-5,
          show_V_flow=false,
          allowFlowReversal=false) "Prescribed mass flow rate for the bypass"
          annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=180,
              origin={50,0})));
        Modelica.Blocks.Math.Product pro "Product for mass flow rate computation"
          annotation (Placement(transformation(extent={{-28,6},{-8,26}})));
        Modelica.Blocks.Sources.Constant one(final k=1) "Outputs one"
          annotation (Placement(transformation(extent={{-90,12},{-70,32}})));
        Modelica.Blocks.Math.Feedback feedback
          annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
        Modelica.Blocks.Logical.Switch fraSwi
          annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
        Modelica.Blocks.Sources.Constant con(final k=m_flow_nominal) "Constant"
          annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
        Modelica.Blocks.Sources.BooleanConstant fra(k=port_3_fraction)
          annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
      equation
        connect(feedback.u1, one.y)
          annotation (Line(points={{-58,22},{-69,22}},
                                                     color={0,0,127}));
        connect(y, feedback.u2)
          annotation (Line(points={{-110,0},{-50,0},{-50,14}},color={0,0,127}));
        connect(preMasFlo.port_a, port_3)
          annotation (Line(points={{60,-1.33227e-15},{80,-1.33227e-15},{80,0},{100,
                0}},                                   color={0,127,255}));
        connect(feedback.y, pro.u1)
          annotation (Line(points={{-41,22},{-30,22}},
                                                     color={0,0,127}));
        connect(pro.y, preMasFlo.m_flow_in)
          annotation (Line(points={{-7,16},{56,16},{56,8}},    color={0,0,127}));
        connect(port_1, senMasFlo.port_a)
          annotation (Line(points={{60,98},{60,60},{4.44089e-16,60},{4.44089e-16,
                -30}},                                  color={0,127,255}));
        connect(senMasFlo.port_b, port_2)
          annotation (Line(points={{-4.44089e-16,-50},{0,-50},{0,-72},{60,-72},{60,
                -92},{60,-92},{60,-98},{60,-98}},      color={0,127,255}));
        connect(preMasFlo.port_b, senMasFlo.port_a) annotation (Line(points={{40,
                1.33227e-15},{4.44089e-16,1.33227e-15},{4.44089e-16,-30}},
                                        color={0,127,255}));
        connect(senMasFlo.m_flow, fraSwi.u1) annotation (Line(points={{-11,-40},{-60,-40},
                {-60,-12},{-42,-12}}, color={0,0,127}));
        connect(con.y, fraSwi.u3) annotation (Line(points={{-79,-60},{-62,-60},{-62,-28},
                {-42,-28}}, color={0,0,127}));
        connect(fraSwi.y, pro.u2) annotation (Line(points={{-19,-20},{-10,-20},{-10,0},
                {-40,0},{-40,10},{-30,10}}, color={0,0,127}));
        connect(fra.y, fraSwi.u2) annotation (Line(points={{-79,-30},{-70,-30},{-70,-20},
                {-42,-20}}, color={255,0,255}));
        annotation (
          Icon(
            graphics={
              Polygon(
                points={{60,0},{68,14},{52,14},{60,0}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Line(points={{60,100},{60,-100}}, color={28,108,200}),
              Line(points={{102,0},{62,0}}, color={28,108,200}),
              Polygon(
                points={{60,0},{68,-14},{52,-14},{60,0}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{62,0},{-98,0}}, color={0,0,0}),
              Rectangle(
                visible=use_inputFilter,
                extent={{28,-10},{46,10}},
                lineColor={0,0,0},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{72,-8},{72,8},{60,0},{72,-8}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid)}));
      end IdealValve;

      model DirectHeatExchangerWaterHeaterWithAuxHeat
        "A model for domestic water heating served by district heat exchanger and supplemental electric resistance"
        replaceable package Medium = Buildings.Media.Water "Water media model";
        parameter Modelica.Units.SI.Temperature TSetHw = 273.15+60 "Temperature setpoint of hot water supply from heater";
        parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal "Nominal mass flow rate of hot water supply";
        parameter Modelica.Units.SI.MassFlowRate mDH_flow_nominal "Nominal mass flow rate of district heating water";
        parameter Boolean haveER "Flag that specifies whether electric resistance booster is present";
        Buildings.Fluid.HeatExchangers.Heater_T heaDhw(
          redeclare package Medium = Medium,
          m_flow_nominal=mHw_flow_nominal,
          dp_nominal=0) if haveER == true
                        "Supplemental electric resistance domestic hot water heater"
          annotation (Placement(transformation(extent={{8,-10},{28,10}})));
        Modelica.Blocks.Sources.Constant conTSetHw(k=TSetHw) if haveER == true
                                                             "Temperature setpoint for domestic hot water supply from heater"
          annotation (Placement(transformation(extent={{-30,32},{-14,48}})));
        Modelica.Fluid.Interfaces.FluidPort_b port_hw(redeclare package Medium =
              Medium) "Hot water supply port"
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));
        Modelica.Blocks.Interfaces.RealOutput PEleAuxHea if haveER == true
          "Thermal energy added to water with electric resistance"
          annotation (Placement(transformation(extent={{96,30},{116,50}})));
        Buildings.Fluid.Sensors.TemperatureTwoPort senTemAuxHeaOut(redeclare
            package Medium = Medium, m_flow_nominal=mHw_flow_nominal)
          annotation (Placement(transformation(extent={{50,-10},{70,10}})));
        Modelica.Fluid.Interfaces.FluidPort_a port_cw(redeclare package Medium =
              Medium) "Port for domestic cold water inlet"
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
        Fluid.HeatExchangers.ConstantEffectiveness hex(
          redeclare package Medium1 = Medium,
          redeclare package Medium2 = Medium,
          m1_flow_nominal=mHw_flow_nominal,
          m2_flow_nominal=mDH_flow_nominal,
          dp1_nominal=0,
          dp2_nominal=0,
          eps=0.85) "Domestic hot water heater"
          annotation (Placement(transformation(extent={{-70,16},{-50,-4}})));
        Modelica.Fluid.Interfaces.FluidPort_a port_dhs(redeclare package Medium =
              Medium) "Port for district heating supply"
          annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
        Modelica.Fluid.Interfaces.FluidPort_b port_dhr(redeclare package Medium =
              Medium) "Port for district heating return"
          annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
        Fluid.Sensors.TemperatureTwoPort senTemHXOut(redeclare package Medium =
              Medium, m_flow_nominal=mHw_flow_nominal)
          annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
      protected
        Fluid.FixedResistances.LosslessPipe pip(
          redeclare final package Medium = Medium,
          final m_flow_nominal=mHw_flow_nominal,
          final show_T=false) if haveER == false "Pipe without electric resistance"
          annotation (Placement(transformation(extent={{8,-38},{28,-18}})));
      equation
        connect(conTSetHw.y, heaDhw.TSet) annotation (Line(points={{-13.2,40},{
                -8,40},{-8,8},{6,8}},
                                  color={0,0,127}));
        connect(senTemAuxHeaOut.port_b, port_hw)
          annotation (Line(points={{70,0},{100,0}}, color={0,127,255}));
        connect(heaDhw.Q_flow, PEleAuxHea) annotation (Line(points={{29,8},{40,
                8},{40,40},{106,40}}, color={0,0,127}));
        connect(hex.port_a1, port_cw)
          annotation (Line(points={{-70,0},{-100,0}}, color={0,127,255}));
        connect(port_dhs, hex.port_a2) annotation (Line(points={{-40,100},{-40,
                12},{-50,12}},
                           color={0,127,255}));
        connect(hex.port_b2, port_dhr) annotation (Line(points={{-70,12},{-80,
                12},{-80,100}},
                        color={0,127,255}));
        connect(senTemHXOut.port_a, hex.port_b1)
          annotation (Line(points={{-36,0},{-50,0}}, color={0,127,255}));
        connect(senTemHXOut.port_b, heaDhw.port_a)
          annotation (Line(points={{-16,0},{8,0}}, color={0,127,255}));
        connect(senTemHXOut.port_b, pip.port_a) annotation (Line(points={{-16,0},{-4,0},
                {-4,-28},{8,-28}}, color={0,127,255}));
        connect(heaDhw.port_b, senTemAuxHeaOut.port_a)
          annotation (Line(points={{28,0},{50,0}}, color={0,127,255}));
        connect(pip.port_b, senTemAuxHeaOut.port_a) annotation (Line(points={{28,-28},
                {40,-28},{40,0},{50,0}}, color={0,127,255}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)));
      end DirectHeatExchangerWaterHeaterWithAuxHeat;

      model HeatPumpWaterHeaterWithTank
        "A model for domestic water heating served by heat pump water heater and local storage tank"
        replaceable package Medium = Buildings.Media.Water "Water media model";
        parameter Modelica.Units.SI.Temperature TSetHw = 273.15+60 "Temperature setpoint of hot water supply from heater";
        parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal "Nominal mass flow rate of hot water supply";
        parameter Modelica.Units.SI.MassFlowRate mDH_flow_nominal "Nominal mass flow rate of district heating water";
        parameter Modelica.Units.SI.Volume VTan = 0.151416 "Tank volume";
        parameter Modelica.Units.SI.Length hTan = 1.746 "Height of tank (without insulation)";
        parameter Modelica.Units.SI.Length dIns = 0.0762 "Thickness of insulation";
        parameter Modelica.Units.SI.ThermalConductivity kIns=0.04 "Specific heat conductivity of insulation";
        parameter Modelica.Units.SI.PressureDifference dpHex_nominal=2500 "Pressure drop across the heat exchanger at nominal conditions";
        parameter Modelica.Units.SI.MassFlowRate mHex_flow_nominal=0.278 "Mass flow rate of heat exchanger";
        parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal(min=0) = 1230.9 "Nominal heating flow rate";
        Modelica.Blocks.Sources.Constant conTSetHw(k=TSetHw) "Temperature setpoint for domestic hot water supply from heater"
          annotation (Placement(transformation(extent={{-100,24},{-84,40}})));
        Modelica.Fluid.Interfaces.FluidPort_b port_hw(redeclare package Medium =
              Medium) "Hot water supply port"
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));
        Modelica.Blocks.Interfaces.RealOutput PEleHP
          "Thermal energy added to water with heat pump"
          annotation (Placement(transformation(extent={{96,30},{116,50}})));
        Buildings.Fluid.Sensors.TemperatureTwoPort senTemTankOut(redeclare
            package
            Medium = Medium, m_flow_nominal=mHw_flow_nominal)
          annotation (Placement(transformation(extent={{0,-10},{20,10}})));
        Modelica.Fluid.Interfaces.FluidPort_a port_cw(redeclare package Medium =
              Medium) "Port for domestic cold water inlet"
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
        Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
          redeclare package Medium1 = Medium,
          redeclare package Medium2 = Medium,
          m1_flow_nominal=mHw_flow_nominal,
          m2_flow_nominal=mDH_flow_nominal,
          QCon_flow_nominal=QCon_flow_nominal,
          dp1_nominal=0,
          dp2_nominal=0)
                    "Domestic hot water heater"
          annotation (Placement(transformation(extent={{-70,58},{-50,38}})));
        Modelica.Fluid.Interfaces.FluidPort_a port_dhs(redeclare package Medium =
              Medium) "Port for district heating supply"
          annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
        Modelica.Fluid.Interfaces.FluidPort_b port_dhr(redeclare package Medium =
              Medium) "Port for district heating return"
          annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
        Fluid.Storage.StratifiedEnhancedInternalHex tan(
          redeclare package Medium = Medium,
          m_flow_nominal=mHw_flow_nominal,
          VTan=VTan,
          hTan=hTan,
          dIns=dIns,
          kIns=kIns,
          nSeg=5,
          redeclare package MediumHex = Medium,
          CHex=40,
          Q_flow_nominal=0.278*4200*20,
          hHex_a=0.995,
          hHex_b=0.1,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          energyDynamicsHex=Modelica.Fluid.Types.Dynamics.SteadyState,
          allowFlowReversal=false,
          allowFlowReversalHex=false,
          mHex_flow_nominal=mHex_flow_nominal,
          TTan_nominal=293.15,
          THex_nominal=323.15,
          dpHex_nominal=dpHex_nominal)
                                      "Hot water tank with heat exchanger configured as steady state"
          annotation (Placement(transformation(extent={{-50,-10},{-70,10}})));
        Fluid.Sensors.TemperatureTwoPort senTemHPOut(redeclare package Medium =
              Medium, m_flow_nominal=mHw_flow_nominal) annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={-28,20})));
      equation
        connect(senTemTankOut.port_b, port_hw)
          annotation (Line(points={{20,0},{100,0}}, color={0,127,255}));
        connect(port_dhs, heaPum.port_a2)
          annotation (Line(points={{-40,100},{-40,54},{-50,54}}, color={0,127,255}));
        connect(heaPum.port_b2, port_dhr)
          annotation (Line(points={{-70,54},{-80,54},{-80,100}}, color={0,127,255}));
        connect(tan.port_a, senTemTankOut.port_a)
          annotation (Line(points={{-50,0},{0,0}}, color={0,127,255}));
        connect(heaPum.P, PEleHP) annotation (Line(points={{-49,48},{0,48},{0,40},{106,
                40}}, color={0,0,127}));
        connect(conTSetHw.y, heaPum.TSet) annotation (Line(points={{-83.2,32},{-80,32},
                {-80,39},{-72,39}}, color={0,0,127}));
        connect(port_cw, tan.port_b)
          annotation (Line(points={{-100,0},{-70,0}}, color={0,127,255}));
        connect(tan.portHex_b, heaPum.port_a1) annotation (Line(points={{-50,-8},{-40,
                -8},{-40,-20},{-76,-20},{-76,42},{-70,42}}, color={0,127,255}));
        connect(tan.portHex_a, senTemHPOut.port_b) annotation (Line(points={{-50,-3.8},
                {-28,-3.8},{-28,10}}, color={0,127,255}));
        connect(heaPum.port_b1, senTemHPOut.port_a)
          annotation (Line(points={{-50,42},{-28,42},{-28,30}}, color={0,127,255}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)));
      end HeatPumpWaterHeaterWithTank;
    annotation (Documentation(info="<html>
<p>
This package contains base classes that are used to construct the classes in
<a href=\"modelica://Buildings.Experimental.DHC.Loads.Heating.DHW\">
Buildings.Experimental.DHC.Loads.Heating.DHW</a>.
</p>
</html>"));
    end BaseClasses;

    package Examples "Example implementations of district-integrated DHW models"
      extends Modelica.Icons.ExamplesPackage;

      model DistrictHeatExchangeDHWAuxHeat
        "Example implementation of direct district heat exchange and auxiliary line heater for DHW"
        extends Modelica.Icons.Example;
        replaceable package Medium = Buildings.Media.Water "Water media model";
        parameter Modelica.Units.SI.Temperature TSetHw = 273.15+50 "Temperature setpoint of hot water supply from heater";
        parameter Modelica.Units.SI.Temperature TDHw = 273.15+45 "Temperature setpoint of hot water supply from district";
        parameter Modelica.Units.SI.Temperature TSetTw = 273.15+43 "Temperature setpoint of tempered water supply at fixture";
        parameter Modelica.Units.SI.Temperature TDcw = 273.15+10 "Temperature setpoint of domestic cold water supply";
        parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal = 0.1 "Nominal mass flow rate of hot water supply";
        parameter Modelica.Units.SI.MassFlowRate mDH_flow_nominal = 1 "Nominal mass flow rate of district heating water";
        parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal = mHw_flow_nominal "Nominal mass flow rate of tempered water";
        parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") "Pressure difference";
        parameter Real k(min=0) = 2 "Gain of controller";
        parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 15 "Time constant of Integrator block" annotation (Dialog(enable=
                controllerType == Modelica.Blocks.Types.SimpleController.PI or
                controllerType == Modelica.Blocks.Types.SimpleController.PID));
        parameter Boolean haveER = true "Flag that specifies whether electric resistance booster is present";

        Buildings.Fluid.Sources.Boundary_pT souDcw(
          redeclare package Medium = Medium,
          T(displayUnit = "degC") = TDcw,
          nPorts=2) "Source of domestic cold water"
          annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
        Modelica.Blocks.Math.Gain gaiDhw(k=-0.3234)
          "Gain for multiplying domestic hot water schedule"
          annotation (Placement(transformation(extent={{64,24},{52,36}})));
        BaseClasses.DirectHeatExchangerWaterHeaterWithAuxHeat disHXAuxHea(
          redeclare package Medium = Medium,
          TSetHw(displayUnit = "degC") = TSetHw,
          mHw_flow_nominal = mHw_flow_nominal,
          mDH_flow_nominal = mDH_flow_nominal,
          haveER=haveER)
          "Direct district heat exchanger with auxiliary electric heating"
          annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
        Buildings.Fluid.Sources.MassFlowSource_T sinDhw(
          redeclare package Medium = Medium,
          use_m_flow_in=true,
          nPorts=1) "Sink for domestic hot water supply"
          annotation (Placement(transformation(extent={{30,-10},{10,10}})));
        BaseClasses.DomesticWaterMixer tmv(
          redeclare package Medium = Medium,
          TSet(displayUnit = "degC") = TSetTw,
          mDhw_flow_nominal=mDhw_flow_nominal,
          dpValve_nominal=dpValve_nominal,
          k=k,
          Ti=Ti)
                "Ideal thermostatic mixing valve"
          annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
        Modelica.Blocks.Sources.Sine sine(f=0.001,
          offset=1)
          annotation (Placement(transformation(extent={{100,20},{80,40}})));
        Modelica.Blocks.Continuous.Integrator watCon(k=-1)
          "Integrated hot water consumption"
          annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
        Modelica.Blocks.Interfaces.RealOutput PEleAuxHea(displayUnit="W") if haveER ==
          true
          "Thermal energy added to water with electric resistance"
          annotation (Placement(transformation(extent={{96,70},{116,90}})));
        Modelica.Blocks.Interfaces.RealOutput TTw(final unit="K",displayUnit = "degC") "Temperature of the outlet tempered water"
          annotation (Placement(transformation(extent={{96,50},{116,70}})));
        Modelica.Blocks.Interfaces.RealOutput mDhw(displayUnit="kg") "Total hot water consumption"
          annotation (Placement(transformation(extent={{96,-40},{116,-20}}),
              iconTransformation(extent={{76,-60},{116,-20}})));
        Fluid.Sources.Boundary_pT souDHw(
          redeclare package Medium = Medium,
          T(displayUnit = "degC") = TDHw,
          nPorts=1) "Source of district hot water" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={-54,90})));
        Fluid.Sources.MassFlowSource_T sinDHw(
          redeclare package Medium = Medium,
          use_m_flow_in=true,
          nPorts=1) "Sink for district heating water"
          annotation (Placement(transformation(extent={{-82,22},{-62,42}})));
        Modelica.Blocks.Sources.Constant const(k=-1)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={-90,90})));
      equation
        connect(tmv.port_tw, sinDhw.ports[1])
          annotation (Line(points={{0,0},{10,0}}, color={0,127,255}));
        connect(gaiDhw.y, sinDhw.m_flow_in) annotation (Line(points={{51.4,30},{40,30},
                {40,8},{32,8}}, color={0,0,127}));
        connect(sine.y, gaiDhw.u)
          annotation (Line(points={{79,30},{65.2,30}},
                                                     color={0,0,127}));
        connect(watCon.u, sinDhw.m_flow_in) annotation (Line(points={{58,-30},{40,-30},
                {40,8},{32,8}}, color={0,0,127}));
        connect(disHXAuxHea.port_hw, tmv.port_hw) annotation (Line(points={{-40,10},{-30,
                10},{-30,6},{-20,6}}, color={0,127,255}));
        connect(souDcw.ports[1], disHXAuxHea.port_cw) annotation (Line(points={{-80,2},
                {-80,6},{-70,6},{-70,10},{-60,10}}, color={0,127,255}));
        connect(souDcw.ports[2], tmv.port_cw) annotation (Line(points={{-80,-2},{-80,-6},
                {-70,-6},{-70,-10},{-30,-10},{-30,-6},{-20,-6}}, color={0,127,255}));
        connect(disHXAuxHea.PEleAuxHea, PEleAuxHea) annotation (Line(points={{-39.4,14},
                {-20,14},{-20,80},{106,80}}, color={0,0,127}));
        connect(tmv.TTw, TTw)
          annotation (Line(points={{1,8},{10,8},{10,60},{106,60}}, color={0,0,127}));
        connect(watCon.y, mDhw)
          annotation (Line(points={{81,-30},{106,-30}}, color={0,0,127}));
        connect(souDHw.ports[1], disHXAuxHea.port_dhs)
          annotation (Line(points={{-54,80},{-54,20}}, color={0,127,255}));
        connect(sinDHw.ports[1], disHXAuxHea.port_dhr)
          annotation (Line(points={{-62,32},{-58,32},{-58,20}}, color={0,127,255}));
        connect(const.y, sinDHw.m_flow_in)
          annotation (Line(points={{-90,79},{-90,40},{-84,40}}, color={0,0,127}));
        annotation (experiment(StopTime=3600, Interval=1));
      end DistrictHeatExchangeDHWAuxHeat;

      model DistrictETSIntegration
        "Example implementation of connecting district ETS to building DHW model"
        extends Modelica.Icons.Example;
        replaceable package Medium = Buildings.Media.Water "Water media model";
        parameter Modelica.Units.SI.Temperature TSetHw = 273.15+50 "Temperature setpoint of hot water supply from heater";
        parameter Modelica.Units.SI.Temperature TDHw = 273.15+45 "Temperature setpoint of hot water supply from district";
        parameter Modelica.Units.SI.Temperature TSetTw = 273.15+43 "Temperature setpoint of tempered water supply at fixture";
        parameter Modelica.Units.SI.Temperature TDcw = 273.15+10 "Temperature setpoint of domestic cold water supply";
        parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal = 0.1 "Nominal mass flow rate of hot water supply";
        parameter Modelica.Units.SI.MassFlowRate mDH_flow_nominal = 1 "Nominal mass flow rate of district heating water";
        parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal = mHw_flow_nominal "Nominal mass flow rate of tempered water";
        parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") "Pressure difference";
        parameter Real k(min=0) = 2 "Gain of controller";
        parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 15 "Time constant of Integrator block" annotation (Dialog(enable=
                controllerType == Modelica.Blocks.Types.SimpleController.PI or
                controllerType == Modelica.Blocks.Types.SimpleController.PID));
        parameter Boolean haveER = true "Flag that specifies whether electric resistance booster is present";

        Buildings.Fluid.Sources.Boundary_pT souDcw(
          redeclare package Medium = Medium,
          T(displayUnit = "degC") = TDcw,
          nPorts=2) "Source of domestic cold water"
          annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
        Modelica.Blocks.Math.Gain gaiDhw(k=-0.3234)
          "Gain for multiplying domestic hot water schedule"
          annotation (Placement(transformation(extent={{82,74},{70,86}})));
        BaseClasses.DirectHeatExchangerWaterHeaterWithAuxHeat disHXAuxHea(
          redeclare package Medium = Medium,
          TSetHw(displayUnit = "degC") = TSetHw,
          mHw_flow_nominal = mHw_flow_nominal,
          mDH_flow_nominal = mDH_flow_nominal,
          haveER=haveER)
          "Direct district heat exchanger with auxiliary electric heating"
          annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
        Buildings.Fluid.Sources.MassFlowSource_T sinDhw(
          redeclare package Medium = Medium,
          use_m_flow_in=true,
          nPorts=1) "Sink for domestic hot water supply"
          annotation (Placement(transformation(extent={{48,38},{28,58}})));
        BaseClasses.DomesticWaterMixer tmv(
          redeclare package Medium = Medium,
          TSet(displayUnit = "degC") = TSetTw,
          mDhw_flow_nominal=mDhw_flow_nominal,
          dpValve_nominal=dpValve_nominal,
          k=k,
          Ti=Ti)
                "Ideal thermostatic mixing valve"
          annotation (Placement(transformation(extent={{0,40},{20,60}})));
        Modelica.Blocks.Sources.Sine sine(f=0.001,
          offset=1)
          annotation (Placement(transformation(extent={{120,70},{100,90}})));
        Modelica.Blocks.Continuous.Integrator watCon(k=-1)
          "Integrated hot water consumption"
          annotation (Placement(transformation(extent={{80,38},{100,58}})));
        Modelica.Blocks.Interfaces.RealOutput PEleAuxHea(displayUnit="W") if haveER ==
          true
          "Thermal energy added to water with electric resistance"
          annotation (Placement(transformation(extent={{120,110},{140,130}})));
        Modelica.Blocks.Interfaces.RealOutput TTw(final unit="K",displayUnit = "degC") "Temperature of the outlet tempered water"
          annotation (Placement(transformation(extent={{120,90},{140,110}})));
        Modelica.Blocks.Interfaces.RealOutput mDhw(displayUnit="kg") "Total hot water consumption"
          annotation (Placement(transformation(extent={{120,38},{140,58}}),
              iconTransformation(extent={{100,18},{140,58}})));
        Modelica.Blocks.Sources.Constant const(k=1)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-60,150})));
        EnergyTransferStations.Combined.HeatPumpHeatExchanger ets(
          nPorts_aHeaWat=1,
          nPorts_aChiWat=1,
          nPorts_bChiWat=1,
          nPorts_bHeaWat=1)
          annotation (Placement(transformation(extent={{-30,-30},{30,30}})));
        Fluid.Sensors.TemperatureTwoPort           senTHeaWatRet(redeclare
            final package Medium = Medium, m_flow_nominal=datChi.mCon_flow_nominal)
          "Heating water return temperature" annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-106,40})));
        Fluid.Sensors.TemperatureTwoPort           senTChiWatRet(redeclare
            final package Medium = Medium, m_flow_nominal=datChi.mEva_flow_nominal)
          "Chilled water return temperature" annotation (Placement(transformation(
              extent={{10,10},{-10,-10}},
              rotation=0,
              origin={-108,0})));
        Fluid.Sensors.TemperatureTwoPort           senTChiWatSup(redeclare
            package Medium = Medium, m_flow_nominal=datChi.mEva_flow_nominal)
          "Chilled water supply temperature" annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={80,-40})));
        EnergyTransferStations.BaseClasses.Pump_m_flow     pumHeaWat(
          redeclare package Medium = Medium,
          final m_flow_nominal=mHeaWat_flow_nominal,
          dp_nominal=100E3) "Heating water distribution pump"
          annotation (Placement(transformation(extent={{-10,122},{-30,142}})));
        Fluid.Sensors.TemperatureTwoPort           senTHeaWatSup(redeclare
            package Medium = Medium, m_flow_nominal=datChi.mCon_flow_nominal)
          "Heating water supply temperature" annotation (Placement(transformation(
              extent={{10,-10},{-10,10}},
              rotation=90,
              origin={-34,98})));
        Fluid.MixingVolumes.MixingVolume           volChiWat(
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          T_start=7 + 273.15,
          final prescribedHeatFlowRate=true,
          redeclare package Medium = Medium,
          V=10,
          final mSenFac=1,
          final m_flow_nominal=mChiWat_flow_nominal,
          nPorts=2) "Volume for chilled water distribution circuit" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={151,-90})));
        EnergyTransferStations.BaseClasses.Pump_m_flow     pumChiWat(
          redeclare package Medium = Medium,
          final m_flow_nominal=mChiWat_flow_nominal,
          dp_nominal=100E3) "Chilled water distribution pump"
          annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
        Modelica.Blocks.Continuous.Integrator EDisHP(y(unit="J"))
          "District heat pump electricity use"
          annotation (Placement(transformation(extent={{100,-2},{120,18}})));
        Controls.OBC.CDL.Continuous.GreaterThreshold           uHea(final t=
              0.01, final h=0.005)
          "Enable heating"
          annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
        Controls.OBC.CDL.Continuous.GreaterThreshold           uCoo(final t=
              0.01, final h=0.005)
          "Enable cooling"
          annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
        Controls.OBC.CDL.Continuous.Sources.Constant           THeaWatSupSet(k=45 +
              273.15, y(final unit="K", displayUnit="degC"))
          "Heating water supply temperature set point"
          annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
        Controls.OBC.CDL.Continuous.Sources.Constant           TChiWatSupSet(k=7 +
              273.15, y(final unit="K", displayUnit="degC"))
          "Chilled water supply temperature set point"
          annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
        Fluid.Sensors.TemperatureTwoPort           senTDisWatSup(redeclare
            final package Medium = Medium, final m_flow_nominal=ets.hex.m1_flow_nominal)
          "District water supply temperature" annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-40,-60})));
        Fluid.Sensors.TemperatureTwoPort senTDisWatRet(redeclare final package
            Medium = Medium, final m_flow_nominal=ets.hex.m1_flow_nominal)
          "District water return temperature" annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={40,-60})));
        Fluid.Sources.Boundary_pT           disWat(
          redeclare package Medium = Medium,
          use_T_in=true,
          nPorts=2) "District water boundary conditions" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={0,-90})));
        Modelica.Blocks.Sources.CombiTimeTable TDisWatSup(
          table=[0,11; 1,12; 2,13; 3,14; 4,15; 5,16; 6,17; 7,18; 8,20; 9,18; 10,
              16; 11,13; 12,11],
          timeScale=2592000,
          tableName="tab1",
          extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
          offset={273.15},
          columns={2},
          smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
          "District water supply temperature"
          annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
      equation
        connect(tmv.port_tw, sinDhw.ports[1])
          annotation (Line(points={{20,50},{24,50},{24,48},{28,48}},
                                                  color={0,127,255}));
        connect(gaiDhw.y, sinDhw.m_flow_in) annotation (Line(points={{69.4,80},
                {60,80},{60,56},{50,56}},
                                color={0,0,127}));
        connect(sine.y, gaiDhw.u)
          annotation (Line(points={{99,80},{83.2,80}},
                                                     color={0,0,127}));
        connect(watCon.u, sinDhw.m_flow_in) annotation (Line(points={{78,48},{
                60,48},{60,56},{50,56}},
                                color={0,0,127}));
        connect(disHXAuxHea.port_hw, tmv.port_hw) annotation (Line(points={{-20,60},
                {-10,60},{-10,56},{0,56}},
                                      color={0,127,255}));
        connect(souDcw.ports[1], disHXAuxHea.port_cw) annotation (Line(points={{-60,52},
                {-60,60},{-40,60}},                 color={0,127,255}));
        connect(souDcw.ports[2], tmv.port_cw) annotation (Line(points={{-60,48},
                {-60,40},{-10,40},{-10,44},{0,44}},              color={0,127,255}));
        connect(disHXAuxHea.PEleAuxHea, PEleAuxHea) annotation (Line(points={{-19.4,
                64},{0,64},{0,120},{130,120}},
                                             color={0,0,127}));
        connect(tmv.TTw, TTw)
          annotation (Line(points={{21,58},{28,58},{28,100},{130,100}},
                                                                   color={0,0,127}));
        connect(watCon.y, mDhw)
          annotation (Line(points={{101,48},{130,48}},  color={0,0,127}));
        connect(ets.ports_aHeaWat[1], senTHeaWatRet.port_b) annotation (Line(
              points={{-30,26},{-80,26},{-80,40},{-96,40}}, color={0,127,255}));
        connect(senTChiWatRet.port_a, ets.ports_aChiWat[1]) annotation (Line(
              points={{-98,0},{-80,0},{-80,16},{-30,16}}, color={0,127,255}));
        connect(ets.ports_bChiWat[1], senTChiWatSup.port_a) annotation (Line(
              points={{30,16},{60,16},{60,-40},{70,-40}}, color={0,127,255}));
        connect(ets.ports_bHeaWat[1], pumHeaWat.port_a) annotation (Line(points
              ={{30,26},{140,26},{140,132},{-10,132}}, color={0,127,255}));
        connect(senTHeaWatSup.port_a, pumHeaWat.port_b) annotation (Line(points
              ={{-34,108},{-34,132},{-30,132}}, color={0,127,255}));
        connect(senTHeaWatSup.port_b, disHXAuxHea.port_dhs)
          annotation (Line(points={{-34,88},{-34,70}}, color={0,127,255}));
        connect(const.y, pumHeaWat.m_flow_in) annotation (Line(points={{-49,150},
                {-20,150},{-20,144}}, color={0,0,127}));
        connect(senTChiWatSup.port_b, pumChiWat.port_a)
          annotation (Line(points={{90,-40},{100,-40}}, color={0,127,255}));
        connect(pumChiWat.port_b, volChiWat.ports[1]) annotation (Line(points={
                {120,-40},{140,-40},{140,-88},{141,-88}}, color={0,127,255}));
        connect(volChiWat.ports[2], senTChiWatRet.port_b) annotation (Line(
              points={{141,-92},{140,-92},{140,-140},{-140,-140},{-140,0},{-118,
                0}}, color={0,127,255}));
        connect(disHXAuxHea.port_dhr, senTHeaWatRet.port_a) annotation (Line(
              points={{-38,70},{-38,78},{-140,78},{-140,40},{-116,40}}, color={
                0,127,255}));
        connect(ets.PHea, EDisHP.u)
          annotation (Line(points={{34,8},{98,8}}, color={0,0,127}));
        connect(uHea.y, ets.uHea) annotation (Line(points={{-98,-40},{-74,-40},
                {-74,10},{-34,10}}, color={255,0,255}));
        connect(uCoo.y, ets.uCoo) annotation (Line(points={{-98,-70},{-70,-70},
                {-70,6},{-34,6}}, color={255,0,255}));
        connect(THeaWatSupSet.y, ets.THeaWatSupSet) annotation (Line(points={{
                -118,140},{-86,140},{-86,-2},{-34,-2}}, color={0,0,127}));
        connect(TChiWatSupSet.y, ets.TChiWatSupSet) annotation (Line(points={{
                -118,100},{-90,100},{-90,-6},{-34,-6}}, color={0,0,127}));
        connect(senTDisWatSup.port_b, ets.port_aSerAmb) annotation (Line(points
              ={{-40,-50},{-40,-20},{-30,-20}}, color={0,127,255}));
        connect(senTDisWatRet.port_a, ets.port_bSerAmb) annotation (Line(points
              ={{40,-50},{40,-20},{30,-20}}, color={0,127,255}));
        connect(disWat.ports[1], senTDisWatRet.port_b) annotation (Line(points=
                {{-2,-80},{40,-80},{40,-70}}, color={0,127,255}));
        connect(disWat.ports[2], senTDisWatSup.port_a) annotation (Line(points=
                {{2,-80},{-40,-80},{-40,-70}}, color={0,127,255}));
        connect(TDisWatSup.y[1], disWat.T_in) annotation (Line(points={{-99,
                -110},{-4,-110},{-4,-102}}, color={0,0,127}));
        connect(PEleAuxHea, PEleAuxHea)
          annotation (Line(points={{130,120},{130,120}}, color={0,0,127}));
        annotation (experiment(StopTime=3600, Interval=1),
          Diagram(coordinateSystem(extent={{-160,-160},{160,160}})),
          Icon(coordinateSystem(extent={{-160,-160},{160,160}})));
      end DistrictETSIntegration;
      annotation (
        preferredView="info",
        Documentation(
          info="<html>
<p>
This package contains a collection of residential domestic hot water models 
to demonstrate how these models might be used in district heating systems.
</p>
</html>"));
    end Examples;
  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models for building domestic hot water loads served by a district heating network.
</p>
</html>"));
  end DHW;
annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models for building heating loads served by a district network.
</p>
</html>"));
end Heating;
