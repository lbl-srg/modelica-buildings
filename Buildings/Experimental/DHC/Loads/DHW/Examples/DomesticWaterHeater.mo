within Buildings.Experimental.DHC.Loads.DHW.Examples;
model DomesticWaterHeater
  "Example implementation of direct district heat exchange and auxiliary line heater for DHW"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.Temperature TSetHw = 273.15+50 "Temperature setpoint of hot water supply from heater";
  parameter Modelica.Units.SI.Temperature TDHw = 273.15+45 "Temperature setpoint of hot water supply from district";
  parameter Modelica.Units.SI.Temperature TDcw = 273.15+10 "Temperature setpoint of domestic cold water supply";
  parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal = 0.1 "Nominal mass flow rate of hot water supply";
  parameter Modelica.Units.SI.MassFlowRate mDH_flow_nominal = 1 "Nominal mass flow rate of district heating water";

  Buildings.Fluid.Sources.Boundary_pT souDcw(
    redeclare package Medium = Medium,
    T(displayUnit = "degC") = TDcw,
    nPorts=1) "Source of domestic cold water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,30})));
  DirectHeatExchangerWaterHeaterWithAuxHeat genDHW(
    redeclare package Medium = Medium,
    mHw_flow_nominal = mHw_flow_nominal,
    mDH_flow_nominal = mDH_flow_nominal)
                                     "Generation of DHW"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sinDhw(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for domestic hot water supply"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=90,
        origin={30,30})));
  Fluid.Sources.Boundary_pT souDHw(
    redeclare package Medium = Medium,
    use_T_in=true,
    T(displayUnit = "degC") = TDHw,
    nPorts=1) "Source of district hot water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-30})));
  Fluid.Sources.MassFlowSource_T sinDHw(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for district heating water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-30})));
  Modelica.Blocks.Sources.Constant const(k=-1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-90})));
  Modelica.Blocks.Sources.Constant conTSetHw(k=TSetHw)
    "Temperature setpoint for domestic hot water supply from heater"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.Sine     TDis(
    amplitude=5,
    f=0.001,
    offset=TDHw) "Signal to represent fluctuating district water temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,-90})));
  Modelica.Blocks.Interfaces.RealOutput PEle
    "Electric power required for generation equipment"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(conTSetHw.y, genDHW.TSetHw)
    annotation (Line(points={{-79,0},{-11,0}}, color={0,0,127}));
  connect(genDHW.port_a2, souDHw.ports[1])
    annotation (Line(points={{10,-6},{30,-6},{30,-20}}, color={0,127,255}));
  connect(genDHW.port_b2, sinDHw.ports[1])
    annotation (Line(points={{-10,-6},{-30,-6},{-30,-20}}, color={0,127,255}));
  connect(souDcw.ports[1], genDHW.port_a1)
    annotation (Line(points={{-30,20},{-30,6},{-10,6}}, color={0,127,255}));
  connect(const.y, sinDHw.m_flow_in) annotation (Line(points={{2.05391e-15,-79},
          {2.05391e-15,-60},{-60,-60},{-60,-42},{-38,-42}}, color={0,0,127}));
  connect(const.y, sinDhw.m_flow_in) annotation (Line(points={{2.05391e-15,-79},
          {2.05391e-15,-60},{60,-60},{60,60},{38,60},{38,42}}, color={0,0,127}));
  connect(genDHW.port_b1, sinDhw.ports[1])
    annotation (Line(points={{10,6},{30,6},{30,20}}, color={0,127,255}));
  connect(TDis.y, souDHw.T_in) annotation (Line(points={{50,-79},{50,-48},{26,-48},
          {26,-42}}, color={0,0,127}));
  connect(genDHW.PHea, PEle)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
This is an example of a domestic water heater.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2022 by Dre Helmns:<br/>
Created example.
</li>
</ul>
</html>"),__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Heating/DHW/Examples/DomesticWaterHeater.mos"
  "Simulate and plot"),experiment(StopTime=3600, Interval=1));
end DomesticWaterHeater;
