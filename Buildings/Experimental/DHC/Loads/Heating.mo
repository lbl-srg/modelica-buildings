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
        IdealValve ideValHea(redeclare package Medium = Medium, final m_flow_nominal=
              mDhw_flow_nominal) "Ideal valve" annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=-90,
              origin={0,6})));
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
        connect(ideValHea.port_2, senTemTw.port_a) annotation (Line(points={{9.8,-1.77636e-15},
                {20,-1.77636e-15},{20,0}}, color={0,127,255}));
        connect(conPID.y, ideValHea.y) annotation (Line(points={{19,50},{1.9984e-15,50},
                {1.9984e-15,17}}, color={0,0,127}));
        connect(senTemTw.T, TTw) annotation (Line(points={{30,11},{30,20},{90,20},{90,
                80},{110,80}}, color={0,0,127}));
        connect(ideValHea.port_1, senTemHw.port_b)
          annotation (Line(points={{-9.8,0},{-20,0}}, color={0,127,255}));
        connect(senTemHw.port_a, port_hw) annotation (Line(points={{-40,0},{-54,0},{-54,
                60},{-100,60}}, color={0,127,255}));
        connect(ideValHea.port_3, senTemCw.port_b)
          annotation (Line(points={{0,-4},{0,-60},{-20,-60}}, color={0,127,255}));
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
        Buildings.Fluid.HeatExchangers.Heater_T heaDhw(
          redeclare package Medium = Medium,
          m_flow_nominal=mHw_flow_nominal,
          dp_nominal=0) "Supplemental electric resistance domestic hot water heater"
          annotation (Placement(transformation(extent={{8,-10},{28,10}})));
        Modelica.Blocks.Sources.Constant conTSetHw(k=TSetHw) "Temperature setpoint for domestic hot water supply from heater"
          annotation (Placement(transformation(extent={{-30,32},{-14,48}})));
        Modelica.Fluid.Interfaces.FluidPort_b port_hw(redeclare package Medium =
              Medium) "Hot water supply port"
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));
        Modelica.Blocks.Interfaces.RealOutput PEleAuxHea
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
        Fluid.Sensors.TemperatureTwoPort senTemHXOut(redeclare package Medium
            = Medium, m_flow_nominal=mHw_flow_nominal)
          annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
      equation
        connect(conTSetHw.y, heaDhw.TSet) annotation (Line(points={{-13.2,40},{
                -8,40},{-8,8},{6,8}},
                                  color={0,0,127}));
        connect(senTemAuxHeaOut.port_b, port_hw)
          annotation (Line(points={{70,0},{100,0}}, color={0,127,255}));
        connect(senTemAuxHeaOut.port_a, heaDhw.port_b)
          annotation (Line(points={{50,0},{28,0}}, color={0,127,255}));
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
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)));
      end DirectHeatExchangerWaterHeaterWithAuxHeat;
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
        parameter Real k(min=0) = 2 "Gain of controller";
        parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 15 "Time constant of Integrator block" annotation (Dialog(enable=
                controllerType == Modelica.Blocks.Types.SimpleController.PI or
                controllerType == Modelica.Blocks.Types.SimpleController.PID));
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
          mDH_flow_nominal = mDH_flow_nominal)
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
        Modelica.Blocks.Interfaces.RealOutput PEleAuxHea(displayUnit="W")
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
